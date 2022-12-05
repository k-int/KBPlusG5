<!doctype html>
<html>
<head>
  <parameter name="pagetitle" value="Jobs" />
  <parameter name="pagestyle" value="System" />
  <parameter name="actionrow" value="none" />
  <meta name="layout" content="base"/>
</head>

  <body class="system">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">A heading</h1>
      </div>
    </div>
    <!--page title end-->

    <!--page intro and error start-->
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

    <div class="row">
      <div class="col s12 l12">
        <table>
          <thead>
            <tr>
              <th>Key</th>
              <th>Value</th>
              <th>Done?</th>
            </tr>
          </thead>
          <g:each in="${activeFutures}" var="k,v">
            <tr>
              <td>${k}</td>
              <td>${v}</td>
              <td>${v.isDone()}</td>
            </tr>
          </g:each>
        </table>
      </div>
    </div>

  </body>
</html>
