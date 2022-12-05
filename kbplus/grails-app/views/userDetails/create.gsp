<%@ page import="com.k_int.kbplus.*" %>
<!doctype html>
<html>
<head>
  <parameter name="pagetitle" value="Create User" />
  <parameter name="pagestyle" value="Admin" />
  <parameter name="actionrow" value="none" />
  <meta name="layout" content="base"/>
  <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
  <title><g:message code="default.list.label" args="[entityName]" /></title>
</head>

  <body class="admin">
    <!--page title start-->
    <div class="row">
        <div class="col s12 l12">
            <h1 class="page-title left">New User</h1>
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

    <!--page intro and error start-->
    <!--page Affiliations start-->
    <div class="row">
    <div class="col s12">
      <div class="row tab-table z-depth-1">
        <g:form id="createUserForm" action="create" method="post">
          <div class="input-field col s6">
            <input id="username" type="text" class="validate" name="username" value="${params.username}">
            <label for="`Username`">Username</label>
          </div>
          <div class="input-field col s6">
            <input id="dispay" type="text" class="validate" name="display" value="${params.display}">
            <label for="`dispay`">Dispay Name</label>
          </div>
          <div class="input-field col s6">
            <input id="password" type="text" class="validate" name="password" value="${params.password}">
            <label for="`password`">Password</label>
          </div>
          <div class="input-field col s6">
            <input id="email" type="text" class="validate" name="email" value="${params.email}">
            <label for="`email`">Email</label>
          </div>
          <button class="btn waves-effect waves-light" type="submit" name="action" value="Create New User">Create New User</button>

        </g:form>
      </div>
    </div>
    </div>
    <!--page Affiliations end-->

<!--
    <div class="container">

        <div class="page-header">
          <h1>New User</h1>
        </div>

        <g:if test="${flash.message}">
          <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
        </g:if>

        <div class="well">
          <g:form id="createUserForm" action="create" method="post">
             <div class="inline-lists">
               <dl><dt>Username</dt><dd><input type="text" name="username" value="${params.username}"/></dd></dl>
               <dl><dt>Dispay Name</dt><dd><input type="text" name="display" value="${params.display}"/></dd></dl>
               <dl><dt>Password</dt><dd><input type="password" name="password" value="${params.password}"/></dd></dl>
               <dl><dt>eMail</dt><dd><input type="text" name="email" value="${params.email}"/></dd></dl>
               <dl><dt></td><dd><input type="submit" value="GO ->" class="btn btn-primary"/></dd></dl>
            </div>
          </g:form>
        </div>

    </div>

    -->
  </body>
</html>
