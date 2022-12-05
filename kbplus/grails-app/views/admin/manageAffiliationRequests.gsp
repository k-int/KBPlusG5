<!doctype html>
<html>
<head>
  <meta name="layout" content="base"/>
  <title>KB+ Manage Affiliation Requests</title>
  <r:require module='annotations' />
  <parameter name="pagetitle" value="Manage Affiliation Requests" />
  <parameter name="pagestyle" value="admin" />
</head>

  <body class="admin">
        <!--page title start-->
  <div class="row">
       <div class="col s12 l12">
          <h1 class="page-title left">Manage Pending Membership Requests</h1>
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

    <!--***table***-->
    <div class="row">

      <div class="col s12">
        <div class="tab-table z-depth-1">
      <!--***tab card section***-->
           <div class="row table-responsive-scroll">
                <table class="highlight bordered">
                      <thead>
                        <tr>
                            <th>User</th>
                            <th>Display Name</th>
                            <th>Email</th>
                            <th>Organisation</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Date Requested</th>
                            <th>Actions</th>
                        </tr>
                      </thead>

                      <tbody>
                        <g:each in="${pendingRequests}" var="req" status="ctr">
                            <tr>
                                <td>${req.user.username}</td>
                                <td>${req.user.displayName}</td>
                                <td>${req.user.email}</td>
                                <td>${req.org.name}</td>
                                <td><g:message code="cv.roles.${req.formalRole?.authority}"/></td>
                                <td class="w100"><g:message code="cv.membership.status.${req.status}"/></td>
                                <td class="w150"><g:formatDate format="dd MMMM yyyy" date="${req.dateRequested}"/></td>
                                <td class="w100"><g:link elementId="ApproveBTN_${ctr}" class="btn-floating table-action ApproveBtn" controller="admin" action="actionAffiliationRequest" params="${[req:req.id, act:'approve']}" ><i class="material-icons tooltipped" data-position="right" data-delay="50" data-tooltip="Approve">done</i></g:link>
                                    <g:link elementId="RejectBTN_${ctr}" class="btn-floating table-action RejectBtn" controller="admin" action="actionAffiliationRequest" params="${[req:req.id, act:'deny']}" ><i class="material-icons tooltipped" data-position="right" data-delay="50" data-tooltip="Deny">close</i></g:link></td>
                            </tr>
                        </g:each>
                      </tbody>
                </table>
           </div>

      </div>
      <!--***table end***-->
    </div>
  </div>
</div>


  </body>
</html>
