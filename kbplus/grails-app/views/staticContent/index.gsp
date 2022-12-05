<!doctype html>
<html>
<head>
    <parameter name="pagetitle" value="Public Home" />
    <parameter name="pagestyle" value="publichome" />
    <parameter name="pageactive" value="publichome" />
    <parameter name="actionrow" value="publichome" />

    <meta name="layout" content="public"/>

    <title>Knowledge Base+</title>
</head>

<body class="public">
    <g:render template="public_navbar" contextPath="/templates" model="['active': 'home']"/>
    <div class="container">
        <div class="row">
            <div class="span8 cms">
                <g:renderMarkdownAsHtml>
                    <g:dbContent key="${params.contentKey}"/>
                </g:renderMarkdownAsHtml>
            </div>
        </div>
    </div>
</body>
</html>

