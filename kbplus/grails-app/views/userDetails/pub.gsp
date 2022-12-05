<%@ page import="com.k_int.kbplus.Org" %>
<!doctype html>
<html>
<head>
  <parameter name="pagetitle" value="User List" />
  <parameter name="pagestyle" value="Admin" />
  <parameter name="actionrow" value="none" />
  <meta name="layout" content="base"/>
  <title>${ui.display}</title>
</head>

<body class="admin">
  <!--page title start-->
  <div class="row">
      <div class="col s12 l12">
          <h1 class="page-title left">${ui.displayName?:'No username'}</h1>
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
  <!--page intro and error start-->


  <!--page Affiliations start-->
<div class="row">
  <div class="col s12">
    <div class="row tab-table z-depth-1">
      <h3>Affiliations</h3>

      <table class="table table-bordered">
        <thead>
          <tr>
            <th>Id</td>
            <th>Org</td>
            <th>Role</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <g:each in="${ui.affiliations}" var="af">
            <tr>
              <td>${af.id}</td>
              <td>${af.org.name}</td>
              <td>${af.formalRole?.authority}</td>
              <td>${['Pending','Approved','Rejected','Auto Approved'][af.status]}</td>
            </tr>
          </g:each>
        </tbody>
      </table>
    </div>
  </div>
</div>
  <!--page Affiliations end-->

    <!--page Roles start-->
<div class="row">
  <div class="col s12">
    <div class="row tab-table z-depth-1">
      <h3>Roles</h3>

      <table class="table table-bordered">
        <thead>
        </thead>
        <tbody>
          <g:each in="${ui.roles}" var="rl">
            <tr>
              <td>${rl.role.authority}</td>
            </tr>
          </g:each>
        </tbody>
      </table>
    </div>
  </div>
</div>
  <!--page roles end-->
<!--
    <div class="container">
      <div class="row">
        <div class="span12">

          <div class="page-header">
             <h1>${ui.displayName?:'No username'}AAAA</h1>
          </div>

          <g:if test="${flash.message}">
            <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
          </g:if>

          <g:if test="${flash.error}">
            <bootstrap:alert class="alert-info">${flash.error}</bootstrap:alert>
          </g:if>

          <h3>Affiliations</h3>

          <table class="table table-bordered">
            <thead>
              <tr>
                <th>Id</td>
                <th>Org</td>
                <th>Role</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <g:each in="${ui.affiliations}" var="af">
                <tr>
                  <td>${af.id}</td>
                  <td>${af.org.name}</td>
                  <td>${af.formalRole?.authority}</td>
                  <td>${['Pending','Approved','Rejected','Auto Approved'][af.status]}</td>
                </tr>
              </g:each>
            </tbody>
          </table>

          <h3>Roles</h3>

          <table class="table table-bordered">
            <thead>
              <tr>
                <th>Role</td>
              </tr>
            </thead>
            <tbody>
              <g:each in="${ui.roles}" var="rl">
                <tr>
                  <td>${rl.role.authority}</td>
                </tr>
              </g:each>
            </tbody>
          </table>

        </div>
      </div>
    </div>
-->
  </body>
</html>
