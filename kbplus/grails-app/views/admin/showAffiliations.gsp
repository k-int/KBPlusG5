<!doctype html>
<html>
<head>
  <parameter name="pagetitle" value="Show Affiliations" />
  <parameter name="pagestyle" value="Admin" />
  <parameter name="actionrow" value="none" />
  <meta name="layout" content="base"/>
  <g:set var="entityName" value="${message(code: 'org.label', default: 'Org')}" />
</head>
  <body>

    <g:if test="${flash.error}">
       <bootstrap:alert class="alert-info">${flash.error}</bootstrap:alert>
    </g:if>

    <g:if test="${flash.message}">
       <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
    </g:if>

    <div class="container">
        <h2>Affiliations</h2>
        <table class="table table-bordered table-striped">
          <tr>
            <th>Username</th><th>Affiliations</th>
          </tr>
          <g:each in="${users}" var="u">
            <tr>
              <td>${u.displayName} / ${u.username}</td>
              <td>
                <ul>
                  <g:each in="${u.affiliations}" var="ua">
                    <li>${ua.org.shortcode}:${ua.status}:${ua.formalRole?.authority}</li>
                  </g:each>
                </ul>
              </td>
          </g:each>
        </table>
    </div>




  </body>
</html>
