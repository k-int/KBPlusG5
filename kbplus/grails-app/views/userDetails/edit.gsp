<%@ page import="com.k_int.kbplus.Org" %>
<!doctype html>
<html>
  <head>
    <parameter name="pagetitle" value="Edit User" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
    <meta name="layout" content="base" />
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
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <g:each in="${ui.affiliations}" var="af">
                <tr>
                  <td>${af.id}</td>
                  <td>${af.org.name}</td>
                  <td>${af.formalRole?.authority}</td>
                  <td>${['Pending','Approved','Rejected','Auto Approved'][af.status]}</td>
                  <td>
                    <g:link controller="ajax" action="deleteThrough" params='${[contextOid:"${ui.class.name}:${ui.id}",contextProperty:"affiliations",targetOid:"${af.class.name}:${af.id}"]}'><i class="material-icons">delete_forever</i></g:link>
                  </td>
                </tr>
              </g:each>
            </tbody>
          </table>

        </div>
      </div>
    </div>
    <!--page Affiliations end-->




    <!-- search-section start-->
    <div class="row">
      <div class="col s12">
        <div class="row tab-table z-depth-1">
        <h3 class="page-title left">Add Role</h3>
        <div class="col s12">
          <g:form controller="ajax" action="addToCollection">
            <div class="col s6 l3 mt-10">
                <input type="hidden" name="__context" value="${ui.class.name}:${ui.id}"/>
                <input type="hidden" name="__newObjectClass" value="com.k_int.kbplus.auth.UserRole"/>
                <input type="hidden" name="__recip" value="user"/>
                <div class="input-field">
                  <g:select name="role"
                            noSelection="${['':'Select One...']}"
                            from="${com.k_int.kbplus.auth.Role.findAllByRoleType('global')}"
                            optionKey="${{'com.k_int.kbplus.auth.Role:'+it.id}}"
                            optionValue="authority" />
                  <label>Role</label>
                </div>
              </div>
              <div class="col s6 m6 l2 mt-20">
                <button type="submit" class="btn">Add Role <i class="material-icons">add_circle_outline</i></button>
              </div>
            </div>
          </g:form>
        </div>
      </div>
      </div>
      <!-- search-section end-->
      <!--page Roles start-->
      <div class="row">
        <div class="col s12">
          <div class="row tab-table z-depth-1">
            <h3>Roles</h3>

            <table class="table table-bordered">
              <thead>
                <tr>
                  <th>Role</td>
                    <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <g:each in="${ui.roles}" var="rl">
                  <tr>
                    <td>${rl.role.authority}</td>
                    <td>
                      <g:link controller="ajax" action="removeUserRole" params='${[user:"${ui.class.name}:${ui.id}",role:"${rl.role.class.name}:${rl.role.id}"]}'><i class="material-icons">delete_forever</i></g:link>
                    </td>
                  </tr>
                </g:each>
              </tbody>
            </table>
        </div>
      </div>

      <g:if test="${grailsApplication.config.localauth}">
      <div class="row">
        <div class="col s12">
          <div class="row tab-table z-depth-1">
            <h3>Local User Credentials</h3>
            <g:form action="updateLocalPassword" autocomplete="off">
               <input type="hidden" name="userId" value="${ui.id}"/>
               New Password: <input type="password" name="newPass" value="" autocomplete="new-password"/>
               <button type="submit">Update user local password</button>
            </g:form>
          </div>
        </div>
      </div>
      </g:if>

    </div>
  </div>

    <!--page roles end-->

<!--
    <div class="container">
      <div class="row">
        <div class="span12">

          <div class="page-header">
             <h1><span id="displayEdit"
                       class="xEditableValue"
                       data-type="textarea"
                       data-pk="${ui.class.name}:${ui.id}"
                       data-name="display"
                       data-url='<g:createLink controller="ajax" action="editableSetValue"/>'
                       data-original-title="${ui.display}">${ui.display}</span></h1>
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
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <g:each in="${ui.affiliations}" var="af">
                <tr>
                  <td>${af.id}</td>
                  <td>${af.org.name}</td>
                  <td>${af.formalRole?.authority}</td>
                  <td>${['Pending','Approved','Rejected','Auto Approved'][af.status]}</td>
                  <td><g:link controller="ajax" action="deleteThrough" params='${[contextOid:"${ui.class.name}:${ui.id}",contextProperty:"affiliations",targetOid:"${af.class.name}:${af.id}"]}'>Delete Affiliation</g:link></td>
                </tr>
              </g:each>
            </tbody>
          </table>

          <h3>Roles</h3>

          <table class="table table-bordered">
            <thead>
              <tr>
                <th>Role</td>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <g:each in="${ui.roles}" var="rl">
                <tr>
                  <td>${rl.role.authority}</td>
                  <td><g:link controller="ajax" action="removeUserRole" params='${[user:"${ui.class.name}:${ui.id}",role:"${rl.role.class.name}:${rl.role.id}"]}'>Delete Role</g:link></td>
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
