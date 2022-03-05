# knote-java
Simple Spring Boot app to take notes

créez une image docker avec la commmande suivante:(il faut etre dans la racine du projet)
docker build -t progdisbueapplication .

pour connecter les conteneurs on doit créer un reseau docker grace a la commande suivante:
docker network create knote

maintenant on execute mongodb grace a la commande suivante:
docker run --name=mongo --rm --network=progsisbuenetwork mongo
a propos de la commmande:
--name : définit le nom du conteneur — si vous ne spécifiez pas un nom explicitement, alors un nom est généré automatiquement
--rm : nettoie automatiquement le conteneur et supprime le système de fichiers lorsque le conteneur se ferme
--network : représente le réseau Docker dans lequel le conteneur doit s'exécuter — lorsqu'il est omis, le conteneur s'exécute dans le réseau par défaut
mongo : est le nom de l'image Docker que vous souhaitez exécuter
 
pour executer l'application on a la commande suivante:
docker run --name=progdisbueapplication --rm --network=progsisbuenetwork -p 8080:8080 -e MONGO_URL=mongodb://mongo:27017/dev progdisbueapplication

--name: définit le nom du conteneur
--rm: nettoie automatiquement le conteneur et supprime le système de fichiers lorsque le conteneur se ferme
--network: représente le réseau Docker dans lequel le conteneur doit s'exécuter
-p 8080:8080: publie le port 8080 du conteneur sur le port 8080 de votre machine locale. Cela signifie que si vous accédez maintenant au port 8080 sur votre ordinateur, la demande est transmise au port 8080 du conteneur Knote. Vous pouvez utiliser le transfert pour accéder à l'application depuis votre ordinateur local.
-e: définit une variable d'environnement à l'intérieur du conteneur

Charger l'image du conteneur dans un registre de conteneurs
docker login

renommer l'image
docker tag progdisbueapplication ndawyaya/progdisbueapplication:1.0.0

telecharger l'image sur docker hub
docker push ndawyaya/progdisbueapplication:1.0.0

tout le monde peut acceder a l'application grace aux deux commandes suivantes

docker run --name=mongo --rm --network=progsisbuenetwork mongo
docker run --name=progdisbueapplication --rm --network=knote -p 8080:8080 -e MONGO_URL=mongodb://mongo:27017/dev ndawyaya/progdisbueapplication:1.0.0

Créer un cluster Kubernetes local (avec minikube)
installer kubectl
https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/#install-kubectl-binary-with-curl-on-windows
curl -LO "https://dl.k8s.io/release/v1.23.0/bin/windows/amd64/kubectl.exe"

installer minikube
New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing

ajouter le path
$oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
if ($oldPath.Split(';') -inotcontains 'C:\minikube'){ `
  [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath), [EnvironmentVariableTarget]::Machine) `
}

créer un cluster
minikube start

vérifier le cluster avec
kubectl cluster-info

créer un dossier pour le déploiement 
mkdir kube


ajout du fichier knote.yaml pour le déploiement de l'application

Les quatre premières lignes définissent le type de ressource (Déploiement), 
la version de ce type de ressource ( apps/v1), et le nom de cette ressource spécifique ( knote) 
Ensuite, nous disposons du nombre souhaité de réplicas de votre conteneur

la partie 3 associe la ressource de déploiement aux répliques de pod

Le template.metadata.labels champ définit une étiquette pour les pods qui enveloppent votre conteneur Knote ( app: knote).

Le selector.matchLabels champ sélectionne les pods avec une app: knoteétiquette pour appartenir à cette ressource de déploiement.

La dérniére partie du déploiement définit le conteneur réel que vous souhaitez exécuter

Il définit les éléments suivants :

Un nom pour le conteneur ( progdisbueapplication)
Le nom de l'image Docker ( ndawyaya/progdisbueapplication:1.0.0).
Le port sur lequel le conteneur écoute (8080)
Une variable d'environnement ( MONGO_URL) qui sera mise à la disposition du processus dans le conteneur


Définir un service

La première partie est le sélecteur.
Il sélectionne les Pods à exposer en fonction de leurs labels.
Dans ce cas, tous les pods portant l'étiquette app: knote seront exposés par le service.
La prochaine partie est le port
Dans ce cas, le service écoute les requêtes sur le port 80 et les transmet au port 8080 des pods cibles.
La dernière partie est le type de Service
Dans ce cas, le type est LoadBalancer, ce qui rend les pods exposés accessibles depuis l'extérieur du cluste

Définition du niveau de la base de données
dans le fichier mongo.yaml

En principe, un pod MongoDB peut être déployé de la même manière que notre application, c'est-à-dire en définissant une ressource de déploiement et de service.

Cependant, le déploiement de MongoDB nécessite une configuration supplémentaire.



MongoDB nécessite un stockage persistant.
Le déploiement a une structure similaire à l'autre déploiement.

Cependant, il contient un champ supplémentaire que vous n'avez pas encore vu : volumes.

Le volumeschamp définit un volume de stockage nommé storage, qui fait référence à PersistentVolumeClaim.

De plus, le volume est référencé depuis le volumeMountschamp dans la définition du conteneur MongoDB.

Le volumeMountchamp monte le volume référencé sur le chemin spécifié dans le conteneur, qui dans ce cas est /data/db.

Et /data/dbc'est là que MongoDB enregistre ses données.

En d'autres termes, les données de la base de données MongoDB sont stockées 
dans un volume de stockage persistant qui a un cycle de vie indépendant du conteneur MongoDB.


deploiement de l'application 
kubectl apply -f kube

démarrer le pod
ubectl get pods --watch
démarrage du service
minikube service knote --url
