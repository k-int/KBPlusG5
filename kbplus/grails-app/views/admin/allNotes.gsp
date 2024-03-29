<!doctype html>
<html>
<head>
  <parameter name="pagetitle" value="All Notes" />
  <parameter name="pagestyle" value="Admin" />
  <parameter name="actionrow" value="none" />
  <meta name="layout" content="base"/>
  <title>All notes</title>
</head>

  <body>

   <div class="container">
        <ul class="breadcrumb">
           <li> <g:link controller="home">KBPlus</g:link> <span class="divider">/</span> </li>
           <li>Licences</li>
        </ul>
    </div>

    <div class="container">
      <table class="table table-bordered">
        <tr>
          <th colspan="4">Note attached to</th>
        </tr>
        <tr>
          <th>Date</th>
          <th>Sharing</th>
          <th>Note</th>
          <th>By</th>
        </tr>
        <g:each in="${alerts}" var="ua">
          <tr>
            <td colspan="4">
              <g:if test="${ua.license}">
                <span class="label label-info">License</span>
                <em><g:link action="index"
                        controller="licenseDetails"
                        id="${ua.license.id}">${ua.license.reference}</g:link></em>

              </g:if>
            </td>
          </tr>
          <tr>
            <td><g:formatDate format="dd MMMM yyyy" date="${ua.alert.createTime}" /></td>
            <td>
              <g:if test="${ua.alert.sharingLevel==2}">- Shared with KB+ Community -</g:if>
              <g:elseif test="${ua.alert.sharingLevel==1}">- JC Only -</g:elseif>
              <g:else>- Private -</g:else>
            </td>
            <td>
              ${ua.owner.content}
            </td>
            <td>
              ${ua.alert?.createdBy?.displayName}
            </td>
          </tr>
        </g:each>
      </table>
    </div>
  </body>
</html>
