<%@ page import="com.k_int.kbplus.RefdataValue" %>
<%@ page import="com.k_int.kbplus.RefdataCategory" %>
<!doctype html>
<html>
  <head>
    <parameter name="pagetitle" value="Your profile" />
    <parameter name="pagesubtitle" value="${user.display}" />
    <parameter name="pagestyle" value="profile" />
    <parameter name="actionrow" value="profile" />

    <meta name="layout" content="base"/>
    <title>KB+ User Profile</title>
  </head>

  <body class="profile">

    <g:if test="${flash.error}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel blue lighten-1">
            <span class="white-text">${flash.error}</span>
          </div>
        </div>
      </div>
    </g:if>

    <g:if test="${flash.message}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel blue lighten-1">
            <span class="white-text">${flash.message}</span>
          </div>
        </div>
      </div>
    </g:if>

<!--  <g:if test="${flash.error}">
      <div class="row">
          <div class="col s12 m10 offset-m1" >
              <div class="row">
                  <div class="input-field col s12">
                    <bootstrap:alert class="error-info">${flash.error}</bootstrap:alert>
                  </div>
              </div>
          </div>
      </div>
  </g:if>

    <g:if test="${flash.message}">
        <div class="row">
              <div class="col s12 m10 offset-m1" >
                  <div class="row">
                      <div class="input-field col s12">
                           <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
                      </div>
                  </div>
              </div>
          </div>
    </g:if>

-->


  <div class="row row-content">
      <div class="col s12 l12">
          <div class="card jisc_card mlarge white fullheight">
              <div class="card-content text-navy">
                    <g:form action="updateProfile" class="form-inline">
                      <div class="input-field padding col s12 m6">
                          <input id="userDispName" name="userDispName" type="text" class="validate" value="${user.display}">
                          <label for="userDispName">Display Name</label>
                      </div>
                      <div class="input-field padding col s12 m6">
                          <input id="useremail" name="email" type="email" class="validate" value="${user.email}">
                          <label for="useremail">Email Address</label>
                      </div>
                      <div class="input-field padding col s12 m6">
                          <input id="userdefaultPageSize" name="defaultPageSize" type="text" class="validate" value="${user.defaultPageSize}">
                          <label for="userdefaultPageSize">Default Page Size</label>
                      </div>
                      <div class="input-field padding col s12 m6">
                          <select name="defaultDash" value="${user.defaultDash?.id}">
                              <g:each in="${user.authorizedOrgs}" var="o">
                                  <option value="${o.id}" ${user.defaultDash?.id==o.id?'selected':''}>${o.name}</option>
                              </g:each>
                          </select>
                          <label>Default Dashboard</label>
                      </div>

                      <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_KBPLUS_EDITOR">
                      	<p class="card-title pack-detail">Administrator / KB+ Editor Options</p><br/>
                      	<div class="input-field padding col s12 m6">
                    		<g:select name="recAdminEmails"
									  noSelection="${['':'']}"
									  from="${RefdataValue.findAllByOwner(RefdataCategory.findByDesc('YN'))}"
									  optionKey="id"
									  optionValue="value"
									  value="${user.recAdminEmails?.id}"/>
							<label>Housekeeping Emails</label>
						</div>
					  </sec:ifAnyGranted>

                      <div class="col s12 m12 l12">
                          <input type="submit" class="waves-effect waves-teal btn left mar-search" value="Update Profile"/>
                      </div>
                    </g:form>
              </div>
          </div>
      </div>

      <div class="col s12">
          <p class="card-caption">Please note, membership requests may be slow to process if you do not set a meaningful display name and email address. Please ensure
                  these are set correctly before requesting institutional memberships</p>
      </div>


  </div>

  <div class="row row-content">
      <div class="col s12">
          <div class="tab-table z-depth-1">
              <h1 class="table-title">Administrative memberships</h1>
              <div class="title">
                  <div class="row table-responsive-scroll">
                      <table class="highlight bordered">
                          <thead>
                              <tr>
                                  <th data-field="organisation">Organisation</th>
                                  <th data-field="role">Role</th>
                                  <th data-field="status">Status</th>
                                  <th data-field="requested">Date Requested / Actioned</th>
                                  <!-- can no longer do actions in KB+ 6 so commenting out for now -->
                                  <!--<th data-field="actions">Actions</th>-->
                              </tr>
                          </thead>
                          <tbody>
                              <g:each in="${user.affiliations}" var="assoc">
                                  <tr>
                                      <td><g:link controller="organisations" action="show" id="${assoc.org.id}">${assoc.org.name}</g:link></td>
                                      <td><g:message code="cv.roles.${assoc.formalRole?.authority}"/></td>
                                      <td><g:message code="cv.membership.status.${assoc.status}"/></td>
                                      <td><g:formatDate format="dd MMMM yyyy" date="${assoc.dateRequested}"/> / <g:formatDate format="dd MMMM yyyy" date="${assoc.dateActioned}"/></td>
                                      <!-- can no longer do actions in KB+ 6 so commenting out for now -->
                                      <!--
                                      <td>
                                          <a href="" class="btn-floating table-action"><i class="material-icons">create</i></a>
                                          <a href="" class="btn-floating table-action"><i class="material-icons">clear</i></a>
                                      </td>
                                      -->
                                  </tr>
                              </g:each>
                          </tbody>
                      </table>
                  </div>
              </div>
          </div>
      </div>
  </div>

  <div class="row row-content">
      <div class="col s12">
          <div class="card jisc_card small white fullheight">
              <div class="card-content text-navy">
                  <p class="card-title pack-detail">Request new membership</p>
                  <div class="card-detail">
                      <p>Select an organisation and a role below. Requests to join existing
                      organisations will be referred to the administrative users of that organisation. If you feel you should be the administrator of an organisation
                      please contact the KBPlus team for support.</p>
                  </div>
                <div class="card-form">
                    <g:form name="affiliationRequestForm" controller="profile" action="processJoinRequest" class="form-search" method="get">
                        <div class="input-field padding col s12 m6">
                            <g:select name="org"
                            		  noSelection="${['':'Select Organisation...']}"
                                      from="${com.k_int.kbplus.Org.findAllByMembershipOrganisation('Yes',[sort:'name'])}"
                                      optionKey="id"
                                      optionValue="name"
                                      required="true"/>
                            <label>Select Org</label>
                        </div>

                        <div class="input-field padding col s12 m6">
                            <g:select name="formalRole"
                            		  noSelection="${['':'Select Role...']}"
                                      from="${com.k_int.kbplus.auth.Role.findAllByRoleType('user')}"
                                      optionKey="id"
                                      optionValue="${ {role->g.message(code:'cv.roles.'+role.authority) } }"
                                      required="true"/>
                            <label>Select role</label>
                        </div>

                        <div class="input-field col s12">
                            <input id="submitARForm" type="submit" class="waves-effect waves-light btn" value="Request Membership" />
                        </div>

                    </g:form>
                </div>

              </div>
          </div>
      </div>
  </div>

  </body>
</html>

<script type="text/javascript">
    $(document).ready(function () {
        $("#unit").on('change', function (e) {
            var unit = this.options[e.target.selectedIndex].text;
            var val = $(this).next();
            if (unit) {
                switch (unit) {
                    case 'Day':
                        setupUnitAmount(val,7);
                        break;
                    case 'Week':
                        setupUnitAmount(val,4);
                        break;
                    case 'Month':
                        setupUnitAmount(val,12);
                        break;
                    default :
                        console.log('Impossible selection made!');
                        break
                }
            }
        });

        $(".reminderBtn").on('click', function (e) {
            //e.preventDefault();
            var element = $(this);
            var yn = confirm("Are you sure you wish to continue?");
            if(yn)
            {
                $.ajax({
                    method: 'POST',
                    url: "<g:createLink controller='profile' action='updateReminder'/>",
                        data: {
                        op: element.data('op'),
                        id: element.data('id')
                    }
                }).done(function(data) {
                    console.log(data);
                    data.op == 'delete'? element.parents('tr').remove() : element.text(data.active);
                });
            }

            //return false;
        });
    });

    function setupUnitAmount(type, amount) {
        console.log(type);
        type.children().remove();
        for (var i = 1; i <= amount; i++) {
            type.append('<option value="' + i + '">' + i + '</option>');
        }
    }
</script>
