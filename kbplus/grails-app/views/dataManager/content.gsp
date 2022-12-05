<%@ page import="java.util.Locale"%>

<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <parameter name="pagetitle" value="Data Manager :: Content management" />
    <parameter name="pagestyle" value="data-manager" />
    <title>KB+ Data Manager :: Content Management</title>
  </head>

  <body class="data-manager">


  <!--page title start-->
  <div class="row">
    <div class="col s12 l12">
        <h1 class="page-title left">Data Manager :: Content</h1>
    </div>
  </div>
  <!--page title end-->

  <g:if test="${flash.message}">
    <div class="row">
      <div class="col s12">
        <div class="card-panel blue lighten-1">
          <span class="white-text"> ${flash.message}</span>
        </div>
      </div>
    </div>
  </g:if>

  <g:if test="${flash.error}">
    <div class="row">
      <div class="col s12">
        <div class="card-panel red lighten-1">
          <span class="white-text"> ${flash.error}</span>
        </div>
      </div>
    </div>
  </g:if>

  <g:link controller="dataManager" action="contentItem" id="mainmenu.dashboard">mainmenu.dashboard</g:link>

   <table>
     <g:each in="${contentItem}" var="ci">
       <tr>
         <td><g:link controller="dataManager" action="contentItem" id="${ci}">${ci}</g:link></td>
       </tr>
     </g:each>
   </table>


  </body>
</html>
