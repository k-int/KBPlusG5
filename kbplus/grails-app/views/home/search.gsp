<!doctype html>
<html lang="en" class="no-js">
  <head>
    <parameter name="pagetitle" value="Search" />
    <parameter name="pagestyle" value="Dashboard" />
    <parameter name="actionrow" value="dashboard" />
    <meta name="layout" content="base"/>
  </head>
  <body class="home">
  
    <g:set var="usaf" value="${user.authorizedOrgs}" />


    hits:${hits}
    resultsTotal:${resultsTotal}
    facets:${facets}
  
  </body>
</html>
