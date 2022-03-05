<!DOCTYPE html>
<html>
<head><title></title>
    <link rel="stylesheet" href="tachyons.min.css">
</head>
<body class="ph3 pt0 pb4 mw7 center sans-serif">
<h1 class="f2 mb0"><span class="gold">Publication de contenu</h1>
<p class="f5 mt1 mb4 lh-copy">Application de publication de contenu</p>
<form action="/note" method="POST" enctype="multipart/form-data">
    <ol class="list pl0">

        <li class="mv3"><label class="f6 b db mb2" for="description">Ecrivez votre contenu</label>
            <textarea class="f4 db border-box hover-black w-100 measure ba b--black-20 pa2 br2 mb2" rows="5"
                      name="description"><#if description??>${description}</#if></textarea>
            <input class="f6 link dim br1 ba bw1 ph3 pv2 mb2 dib black bg-white pointer" type="submit" value="Publier"
                   name="publish">
        </li>
    </ol>
</form>
<ul class="list pl0"><p class="f6 b db mb2">Contenu</p>
    <#if notes??>
        <#list notes as note>
            <li class="mv3 bb bw2 b--light-yellow bg-washed-yellow ph4 pv2"><p class="measure"></p>
                <p>${note}</p>
                <p></p>
            </li>
        <#else>
            <p class="lh-copy f6">Vous n'avez pas de contenu.</p>
        </#list>
    </#if>
</ul>
</body>
</html>