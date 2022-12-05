<%@ page import="com.k_int.kbplus.*" %>
<!doctype html>
<html>
  <head>
    <parameter name="pagetitle" value="User List" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
    <meta name="layout" content="base"/>
  </head>
  <body class="admin">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">User list</h1>
      </div>
    </div>
    <!--page title end-->

    <!--page search start-->
    <div class="row">
      <div class="col s12">
        <div class="search-section z-depth-1">
          <div class="col s12 mt-10">
            <h3 class="page-title left">Search Users</h3>
          </div>

          <g:form controller="userDetails" action="list" method="get">
            <g:if test="${params.defaultInstShortcode}">
              <input type="hidden" name="defaultInstShortcode" value="${params.defaultInstShortcode}">
            </g:if>
            <g:if test="${params.sortOrder}">
              <input type="hidden" name="sortOrder" value="${params.sortOrder}">
            </g:if>
            <div class="input-field col s12 m4 l6">
              <input name="name" id="name_contains" type="text" value="${params.name}">
              <label for="name_contains">Name Contains</label>
            </div>
            <div class="input-field col s12 m4 l4">
              <g:set value="${com.k_int.kbplus.auth.Role.findAll()}" var="auth_values"/>
              <g:select from="${auth_values}" noSelection="${['null':'-Any role-']}" value="${params.authority}" optionKey="id" optionValue="authority" name="authority" />
              <label>Role</label>
            </div>
            <div class="col s12 m2 l1">
              <input type="submit" value="Search" class="btn btn-primary btn-small"/>
            </div>
            <div class="col s12 m2 l1">
              <button class="resetsearch inputreset">Reset</button>
            </div>
          </g:form>
        </div>
      </div>
    </div>
    <!--page search end-->

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

    <div class="row">
      <div class="col s12">
        <div class="filter-section z-depth-1">
          <g:form controller="userDetails" action="list" method="get">
            <g:if test="${params.defaultInstShortcode}">
              <input type="hidden" name="defaultInstShortcode" value="${params.defaultInstShortcode}">
            </g:if>
            <g:hiddenField name="authority" value="${params.authority}"/>
            <g:hiddenField name="name" value="${params.name}"/>
            <g:hiddenField name="max" value="${params.max}"/>
            <g:hiddenField name="offset" value="${params.offset}"/>

            <div class="col s12 l6">
              <div class="input-field">
                <g:select name="sortOrder"
                      value="${params.sortOrder}"
                      keys="['username:asc','username:desc','display:asc','display:desc','instname:asc','instname:desc']"
                      from="${['User Name A-Z','User Name Z-A','Display Name A-Z','Display Name Z-A','Institution A-Z','Institution Z-A']}"
                      onchange="this.form.submit();"/>
                <label>Sort Users By</label>
              </div>
            </div>
          </g:form>
        </div>
      </div>
    </div>

    <!--page results start-->
    <div class="row">
      <div class="col s12">
        <div class="tab-table z-depth-1">
          <table class="table table-striped">
            <thead>
              <tr>
                <th>${message(code: 'user.name.label', default: 'User Name')}</th>
                <th>${message(code: 'user.display.label', default: 'Display Name')}</th>
                <th>${message(code: 'user.instname.label', default: 'Institution')}</th>
                <th>${message(code: 'user.affiliations', default: 'Affiliations')}</th>
              </tr>
            </thead>
            <tbody>
              <g:each in="${users}" var="user">
                <tr>
                  <td><g:link action="edit" id="${user.id}">${user.displayName}</g:link></td>
                  <td>${fieldValue(bean: user, field: "display")}</td>
                  <td>
                    <g:if test="${user.defaultDash != null}">
                      ${user.defaultDash.name}
                    </g:if>
                    <g:else>
                      No default dash set
                    </g:else>
                  </td>
                  <td>
                    <ul>
                      <g:each in="${user.affiliations}" var="aff">
                        <li>${aff.org.name} : ${aff.formalRole.authority} (status=${aff.status})</li>
                      </g:each>
                    </ul>
                  </td>
                </tr>
              </g:each>
            </tbody>
          </table>
        </div>

        <div class="pagination">
          <g:paginate controller="userDetails" action="list" total="${total}" next="chevron_right" prev="chevron_left" maxsteps="10" params="${params}" />
        </div>
      </div>
    </div>
    <!--page results end-->
  </body>
</html>
