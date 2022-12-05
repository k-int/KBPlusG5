<!doctype html>
<html lang="en" class="no-js">
<head>
    <!-- Google Tag Manager (noscript) -->
    <script>
      dataLayer = [{
        'Institution': '${params.defaultInstShortcode}',
        'UserDefaultOrg': '${params.defaultInstShortcode}',
        'UserRole': 'ROLE_USER'
      }];
    
      var showLabelEditor = ${session && session.showLocaliseButton == 'Y'}
    </script>
    <!-- Google Tag Manager -->

    <!-- Google Tag Manager -->
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0], j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src= 'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f); })(window,document,'script','dataLayer','GTM-TLP4Z5N');</script>
    <!-- End Google Tag Manager -->

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>
        <g:layoutTitle default="KB+"/>
    </title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700" rel="stylesheet">
    <asset:stylesheet src="thirdparty/select2/select2.css"/>
    <asset:stylesheet src="jstree-themes/default/style.css"/>
    <asset:stylesheet src="application.css"/>

     <g:render template="/templates/fav"/>

    <g:layoutHead/>
</head>
<body class="${pageProperty( name:'body.class' )} ${grailsApplication.config.skin}">

    <!-- Google Tag Manager (noscript) -->
    <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-TLP4Z5N" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
    <!-- End Google Tag Manager (noscript) -->

    <div class="levelbanner ${grailsApplication.config.skin}">
        <h1></h1>
    </div>

    <div id="appCfgElement" data-baseurl="${createLink(uri:'/')}"/>



    <g:render template="/templates/sidebar-nav"/>


    <div class="jisc-frame">

        <g:link controller="home" action="index" class="navbar-logo"></g:link>

        <nav class="navbar-fixed-top jisc-top-header ${pageProperty(name: 'page.pagestyle')?:'subscriptions'}">

            <a href="#" id="trigger-navbar-toggle" class="navbar-toggle">
                <span class="icon-bar">
                    <span></span>
                    <span></span>
                    <span></span>
                </span>
            </a>
            <div class="nav-wrapper">
                <!-- Used <parameter name="pagetitle" value="xxx"/> to set this in the actual gsp -->
                <a href="#" class="section-name">
                    <i class="icon"></i>
                    <div class="group">
                        <span class="section-label">${pageProperty(name: 'page.pagetitle')?:'Set pagetitle'}</span>
                        <g:if test="${institution && !params.dm}">
                        	<span class="section-context">${institution.name?:'No Org Name Set'}</span>
                        </g:if>
                        <g:else>
                            <span class="section-context">${pageProperty(name: 'page.pagesubtitle')?:''}</span>
                        </g:else>
                    </div>
                </a>
                <div class="row hide-on-small-and-down">
                    <div class="col s12">
                        <g:render template="/templates/action-row-${pageProperty(name: 'page.actionrow')?:'none'}"/>
                    </div>
                </div>

            </div>
        </nav>

        <div class="jisc-content">
            <div class="main-content">
                <g:layoutBody/>
                <!-- Modal form -->
				<div id="kbmodal" class="modal bottom-sheet this-modal">
					<div class="fixed-action-btn-top">
      					<a class="z-depth-0 modal-action modal-close btn-floating btn-large waves-effect waves-dark"><i class="material-icons">close</i></a>
   					</div>
					<div class="modal-content">
					</div>
				</div>
				<!-- Modal end -->
            </div>
        </div>


    </div>
    <asset:javascript src="jisc_header.js"/>
    <asset:javascript src="application.js"/>
    
    <button id="support-button" onclick="window.location.href='mailto: help@jisc.ac.uk?subject=Support%20Query';" class="support-button"><i class="material-icons" style="font-size:22px;">help_outline</i> <span style="position:absolute;padding-left:5px">Support</span></button>

</body>
</html>
