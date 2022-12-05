<!doctype html>
<html lang="en" class="no-js">
<head>
    <!-- Google Tag Manager -->
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-TLP4Z5N');</script> 
    <!-- End Google Tag Manager -->

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>
        <g:layoutTitle default="KB+"/>
    </title>
    <link rel="shortcut icon" href="https://www.jisc.ac.uk/sites/all/themes/jisc_clean/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1"/>


    <script src="https://use.fontawesome.com/28d4108724.js"></script>
    <asset:stylesheet src="public/ux.jisc-1.2.0.style.css"/>
    <asset:stylesheet src="public/style.css"/>
    <asset:javascript src="ux.jisc-2.0.0.script-head.js"/>
    <asset:stylesheet src="public.css"/>

    <g:render template="/templates/fav"/>

    <g:layoutHead/>
</head>
<body>
    <!-- Google Tag Manager (noscript) -->
    <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-TLP4Z5N" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
    <!-- End Google Tag Manager (noscript) -->

<header class="masthead" role="banner" data-mobilemenu="">
    <div class="masthead__top">
        <div class="inner">
            <a id="skiplinks" class="visuallyhidden focusable in-page" href="#main" tabindex="1">
                <span>Skip to main content</span>
            </a>
            <a class="masthead__logo" href="//jisc.ac.uk">
                <img src="${resource(dir: 'images', file: 'logo.png')}" class="pull-right" />
            </a>
            <nav class="masthead__topnav">
                <ul id="nav" class="topnav__list" data-dropdown="">
                    <li class="topnav__item ">
                        <a href="#">Digital Resources</a>
                    </li>
                    <li class="topnav__item  has-popup" data-dropdown-item="">
                        <a href="#">Journals</a>

                    </li>
                </ul>
            </nav></div>
    </div>
    <div class="masthead__main masthead__main--with-content">
        <div class="inner">
            <div class="header-login-btn-container">
            	<g:link controller="home" action="index" class="btn btn--3d btn--primary btn--large" role="button">
                    <span id="LoginBTN">Knowledge Base+ Member Login</span>
                </g:link>
            </div>
            
            <p class="masthead__title masthead__title--short"><a href="/" title="${pageProperty(name: 'page.pagetitle')?:'Set pagetitle'}">${pageProperty(name: 'page.pagetitle')?:'Set pagetitle'}</a></p>
            
            <div class="nav-wrapper">
                <nav class="masthead__nav header__nav--primary" role="navigation" data-dropdown="">
                    <ul>

                        <li class="nav__item ${pageProperty(name:'page.pageactive')=='publichome'?'active':''}" >
                            <a href="${createLink(uri: '/')}">About KB+</a>
                        </li>
                        <li class="nav__item  ${pageProperty(name:'page.pageactive')=='about'?'active':''}">
                            <a href="${createLink(uri: '/about')}">Sign Up</a>
                        </li>
                        <li class="nav__item  ${pageProperty(name:'page.pageactive')=='signup'?'active':''}">
                            <a href="${createLink(uri: '/signup')}">Support</a>
                        </li>
                        <li class="nav__item  ${pageProperty(name:'page.pageactive')=='contact'?'active':''}">
                            <a href="${createLink(uri: '/contactus')}">Engagement</a>
                        </li>
                        <li class="nav__item  ${pageProperty(name:'page.pageactive')=='export'?'active':''}">
                            <g:link controller="publicExport" action="index">Export</g:link>
                        </li>
                    </ul>
                </nav>
                <nav class="masthead__nav masthead__nav--secondary" role="navigation" data-dropdown="">

                </nav>
            </div>

        </div>
    </div>
</header>
<main id="main" role="main" class="main">
    <div class="inner l-pull-left featured">
        <div class="l-centre-offset">
                <g:layoutBody/>
        </div>
    </div>
</main>
<footer role="contentinfo" class="site-footer">
    <!--
      .light here denotes depth of bg tint
     -->
    <div class="inner l-pull-left light l-gutter--top">
        <div class="l-centre-offset row">
            <!--
          Based on the way these elements behave when folded down,
          this is a standard row/col layout
         -->
            <div class="col span-6">
                <div class="linklist">
                    <div class="linklist__title">
                        Contact Details
                    </div>
                    <ul>
                       Contact the KB+ team using <a href="mailto:help@jisc.ac.uk">help@jisc.ac.uk</a>
                    </ul>
                </div>
            </div>
            <!--/ .col.span-3 -->
            <div class="col span-6">
                <div class="linklist linklist--2col l-gutter--right">
                    <div class="linklist__title">
                        Useful links
                    </div>
                    <ul>
<li class="linklist__item"><a href="https://www.jiscmail.ac.uk/cgi-bin/webadmin?SUBED1=KBPLUS-UPDATES&A=1">Sign up to KB+ Updates</a></li>
<li class="linklist__item"><a href="${createLink(uri: '/accessibility')}">Accessibility</a></li>
<li class="linklist__item"><a href="${createLink(uri: '/privacy')}">Privacy</a></li>
<li class="linklist__item"><a href="${createLink(uri: '/cookies')}">Cookies</a></li>
                    </ul>
                </div>
                <!--/ .linklist -->
            </div>
            <!--/ .col.span-3 -->
        </div>
        <!--/ /-centre-offset.row -->
    </div>
    <!--/ .inner.l-pull-left -->
    <!--
      .medium here denotes depth of bg tint
     -->
    <div class="inner l-pull-left medium bottom-section">
        <div class="l-centre-offset row">
            <div class="col span-6">
                <div class="l-gutter--right">
                    <div class="divisional-info">
                        <div class="divisional-info__side">
                            <a href="https://jisc.ac.uk">
                                <img src="${resource(dir: 'images', file: 'jisc-logo.png')}" width="158" height="93" class="pull-right" />
                            </a>
                        </div>
                        <div class="divisional-info__body">
                            <p>Our suite of network and IT services enable close-knit communities
                            of academics, researchers and students to connect and collaborate.</p>
                            <p><a href="#">Find out more at jisc.ac.uk</a></p>
                        </div>
                    </div>
                    <!--/ .divisional-info -->
                </div>
                <!--/ .l-gutter--right -->
            </div>
            <!--/ .col.span-6 -->
            <div class="col span-6">
                <div class="linklist linklist--2col">
                    <div class="linklist__title v-pad-small--mobile">
                        <h3>Network &amp; IT services</h3>
                    </div>
                    <ul>
                        <li class="linklist__item">
                            <a href="#">Security</a>
                        </li>
                        <li class="linklist__item">
                            <a href="#">Cloud</a>
                        </li>
                        <li class="linklist__item">
                            <a href="#">Connectivity</a>
                        </li>
                        <li class="linklist__item">
                            <a href="#">Email</a>
                        </li>
                        <li class="linklist__item">
                            <a href="#">Access and identity <span class="linklist__item__break">management</span></a>
                        </li>
                        <li class="linklist__item">
                            <a href="#">Internet and IP <span class="linklist__item__break">services</span></a>
                        </li>
                        <li class="linklist__item">
                            <a href="#">Procurement</a>
                        </li>
                        <li class="linklist__item">
                            <a href="#">Telecoms</a>
                        </li>
                        <li class="linklist__item">
                            <a href="#">Videoconferencing</a>
                        </li>
                    </ul>
                </div>
                <!--/ .linklist -->
            </div>
            <!--/ .col.span-6 -->
        </div>
        <!--/ .l-centre-offset.row -->
    </div>
    <!--/ .inner.l-pull-left.medium -->
    <!--
      .heavy here denotes depth of bg tint
     -->
    <div class="inner l-pull-left heavy">
        <div class="l-centre-offset row cc-wrap">
            <div class="cc duo">
                <div class="duo__side">
                    <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/2.0/uk/">
                        <img src="${resource(dir: 'images', file: 'cc_BY-NC-SA.png')}" width="140" height="49" class="pull-right" />
                    </a>
                </div>
                <div class="duo__body">
                    <!--
  @CHANGE
  Add the following print version of the copyright notice. Should always display current year
  -->
                    <span class="print-only">©2013 Jisc.</span> This work is licensed under the <a class="cc__link" rel="license" href="http://creativecommons.org/licenses/by-nc-nd/2.0/uk/">CC BY-NC-SA 4.0</a>
                </div>
            </div>
            <!--/ .cc.duo -->
        </div>
        <!--/ .l-centre-offset.row -->
    </div>
    <!--/ .inner.l-pull-left.heavy -->
</footer>


<asset:javascript src="ux.jisc-2.0.0.script-foot.js"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Uniform.js/3.0.0/js/jquery.uniform.standalone.js" type="text/javascript"></script>
<asset:javascript src="public.js"/>


</body>
</html>
