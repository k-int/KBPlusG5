<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <parameter name="pagetitle" value="IE Transfer" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
    <title>KB+ Admin::IE Transfer</title>
  </head>
  <body class="admin">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">IE Transfer</h1>
      </div>
    </div>
    <!--page title end-->

    <!--page intro and error start-->
    <div class="row">
      <div class="col s12">
        <div class="row strip-table z-depth-1">
          <g:form action="ieTransfer" method="get">
            <p class="title">Add the appropriate ID's below. All IssueEntitlements of source will be removed and transfered to target. Detailed information and confirmation will be presented before proceeding</p>
            <div class="row admin-form">
              <div class="input-field col s6">
                <input type="text" id="sourceTIPP" name="sourceTIPP" value="${params.sourceTIPP}">
                <label for="sourceTIPP">Database ID of IE source TIPP</label>
              </div>
              <div class="input-field col s6">
                <input type="text" id="targetTIPP" name="targetTIPP" value="${params.targetTIPP}">
                <label for="targetTIPP">Database ID of target TIPP</label>
              </div>
            </div>
            
            <g:if test="${sourceTIPPObj && targetTIPPObj}">
              <button onclick="return confirm('All source IEs will be moved to target. Continue?')" class="waves-effect waves-light btn" name="transfer" type="submit" value="Go">Transfer</button>
            </g:if>
            <button type="submit" value="Go" class="waves-effect waves-light btn">Look Up TIPP Info...</button>
          </g:form>
        </div>
      </div>
    </div>   
    
    <g:if test="${sourceTIPPObj && targetTIPPObj}">
      <div class="row">
        <div class="col s12">
          <div class="row tab-table z-depth-1">
            <!--***table***-->
            <div class="tab-content">
              <div class="row table-responsive-scroll">
                <table class="highlight bordered">
                  <thead>
                    <tr>
                      <th></th>
                      <th>(${params.sourceTIPP}) ${sourceTIPPObj.title.title}</th>
                      <th>(${params.targetTIPP}) ${targetTIPPObj.title.title}</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Package</td>
                      <td>${sourceTIPPObj.pkg.name}</td>
                      <td>${targetTIPPObj.pkg.name}</td>
                    </tr>
                    <tr>
                      <td>Start Date</td>
                      <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${sourceTIPPObj.startDate}"/></td>
                      <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${targetTIPPObj.startDate}"/></td>
                    </tr>
                    <tr>
                      <td>End Date</td>
                      <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${sourceTIPPObj.endDate}"/></td>
                      <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${targetTIPPObj.endDate}"/></td>
                    </tr>
                    <tr>
                      <td>Number of IEs</td>
                      <td>${com.k_int.kbplus.IssueEntitlement.countByTipp(sourceTIPPObj)}</td>
                      <td>${com.k_int.kbplus.IssueEntitlement.countByTipp(targetTIPPObj)}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
            <!--***table end***-->
          </div>
        </div>
      </div>  
    </g:if>
    <g:else>
      <g:if test="${params.sourceTIPP && params.targetTIPP}">
        <div class="row">
          <div class="col s12">
            <div class="row strip-table z-depth-1 admin-orgs-merge mergedatareturn">
              <!-- left column -->
              <div class="col s12 l6">
                <div class="admin-table-title-section">
                  <g:if test="${sourceTIPPObj != null}">
                    <h3>TIPP Found: ${sourceTIPPObj.title.title}</h3>
                  </g:if>
                  <g:else>
                    <h3>No TIPP Found with Id: ${params.sourceTIPP}</h3>
                  </g:else>
                </div>
              </div>
              <!-- end left -->
              
              <!-- right column -->
              <div class="col s12 l6">
                <div class="admin-table-title-section">
                  <g:if test="${targetTIPPObj != null}">
                    <h3>TIPP Found: ${targetTIPPObj.title.title}</h3>
                  </g:if>
                  <g:else>
                    <h3>No TIPP Found with Id: ${params.targetTIPP}</h3>
                  </g:else>
                </div>
              </div>
              <!-- end right -->
            </div>
          </div>
        </div>
      </g:if>
    </g:else>
    
    <!--legacy-->
  	<!-- <div class="container">
  	<h1>IE Transfer</h1>

        <g:form action="ieTransfer" method="get">
          <p>Add the appropriate ID's below. All IssueEntitlements of source will be removed and transfered to target. Detailed information and confirmation will be presented before proceeding</p>
          <dl>
            <div class="control-group">
              <dt>Database ID of IE source TIPP</dt>
              <dd>
                <input type="text" name="sourceTIPP" value="${params.sourceTIPP}" />

              </dd>
            </div>

            <div class="control-group">
              <dt>Database ID of target TIPP</dt>
              <dd>
                <input type="text" name="targetTIPP" value="${params.targetTIPP}"/>
              </dd>
            </div>
 			<g:if test="${sourceTIPPObj && targetTIPPObj}">
 			<div class="container">

				  <table class="table table-bordered">
			      <thead>
			        <th></th>
			        <th>(${params.sourceTIPP}) ${sourceTIPPObj.title.title}</th>
			        <th>(${params.targetTIPP}) ${targetTIPPObj.title.title}</th>
			      </thead>
			      <tbody>
			      <tr>
			      	<td><strong>Package</strong></td>
			      	<td>${sourceTIPPObj.pkg.name}</td>
			      	<td>${targetTIPPObj.pkg.name}</td>
			      </tr>
			      <tr>
			      	<td><strong>Start Date</strong> <br/><strong> End Date</strong></td>
			      	<td>
<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${sourceTIPPObj.startDate}"/>
			      	 <br/>
<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${sourceTIPPObj.endDate}"/>
 </td>
  			      	<td>
  <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${targetTIPPObj.startDate}"/>
 <br/>
 <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${targetTIPPObj.endDate}"/>
</td>
			      </tr>
			      <tr>
			      	<td><strong> Number of IEs</strong></td>
			      	<td>${com.k_int.kbplus.IssueEntitlement.countByTipp(sourceTIPPObj)}</td>
			      	<td>${com.k_int.kbplus.IssueEntitlement.countByTipp(targetTIPPObj)}</td>
			      </tr>
			      </tbody>
			      </table>
 			</div>

              <button onclick="return confirm('All source IEs will be moved to target. Continue?')" class="btn-success" name="transfer" type="submit" value="Go">Transfer</button>
  			</g:if>

            <button class="btn-primary" type="submit" value="Go">Look Up TIPP Info...</button>
          </dl>
        </g:form>
      </div>
  	</div> -->
    <!--legacy end-->
    
  </body>
</html>