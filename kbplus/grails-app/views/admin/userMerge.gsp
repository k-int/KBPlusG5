<!doctype html>
<html lang="en" class="no-js">
  <head>
    <meta name="layout" content="base"/>
    <parameter name="actionrow" value="titlesdetail" />
    <parameter name="pagetitle" value="User Merge" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
  </head>
  <body class="admin">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">User Merge</h1>
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
    <!--form start -->
    <div class="row row-content">
      <div class="col s12 section">
        <div class="card jisc_card small white fullheight">
          <div class="card-content text-navy">
            <p>Select the user to keep, and the user whose rights will be transferred. When 'Lookup' is clicked, a confirmation box below with 'user to merge' current rights will be displayed.</p>
          </div>
          <div class="card-content text-navy top20">
            <g:form action="userMerge" method="GET">
              <div class="input-field padding col s12 l6 mt-10">
                <label for="userToKeep" style="transform: translateY(-160%);">User to Keep</label>
                <g:select name="userToKeep"
                          from="${usersActive}"
                          optionKey="id"
                          optionValue="${{it.displayName + ' ( ' + it.id +' )'}}"
                          noSelection="${['null':'Choose user to keep']}"
                          class="browser-default"/>
              </div>
              
              <div class="input-field padding col s12 l6 mt-10">
                <label for="userToMerge" style="transform: translateY(-160%);">User to Merge</label>
                <g:select name="userToMerge"
                          from="${usersAll}"
                          optionKey="id"
                          optionValue="${{it.displayName + ' ( ' + it.id +' )'}}"
                          noSelection="${['null':'Choose user to merge']}"
                          class="browser-default"/>
              </div>
              
              <div class="input-field col s12">
                <input type="submit" value="Lookup" class="btn btn-primary"/>
              </div>
            </g:form>
          </div>
        </div>
      </div>
    </div>
    <!--form end -->
    
    <g:if test="${userRoles}">
      <div class="row">
        <div class="col s12">
          <div class="tab-table z-depth-1">
            <h3 class="page-title left">Merge ${userMerge?.displayName} (${userMerge?.id}) into ${userKeep?.displayName} (${userKeep?.id})</h3>
            
            <!--***table***-->
            <div class="tab-content">
              <div class="row table-responsive-scroll">
                <table class="highlight bordered">
                  <thead>
                    <tr>
                      <th colspan="2">Current Roles and Affiliations that will be copied to ${userKeep?.displayName}</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>User Roles</td>
                      <td>
                      	<ul>
                          <g:each in="${userRoles}" var="userRole">
                            <li> ${userRole.authority}</li>
                          </g:each>
                        </ul>
                      </td>
                    </tr>
                    <tr>
                      <td>Affiliations</td>
                      <td>
                        <ul>
                          <g:each in="${userAffiliations}" var="affil">
                            <li> ${affil.org.name} :: ${affil.formalRole.authority}</li>
                          </g:each>
                        </ul>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
            <!--***table end***-->
            
            <g:form action="userMerge" method="POST">
              <input type="hidden" name="userToKeep" value="${params.userToKeep}"/>
              <input type="hidden" name="userToMerge" value="${params.userToMerge}"/>
              <input type="submit" id="mergeUsersBtn" value="Merge" class="btn btn-primary btn-small"/>
            </g:form>
          </div>
        </div>
      </div>
    </g:if>
  </body>
</html>
