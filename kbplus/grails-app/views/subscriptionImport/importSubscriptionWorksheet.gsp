<!doctype html>
<html lang="en" class="no-js">
	<head>
	  <parameter name="pagetitle" value="Import Subscriptions Worksheet" />
	  <parameter name="pagestyle" value="subscriptions" />
	  <parameter name="actionrow" value="sub-worksheet-menu" />
	  <meta name="layout" content="base"/>
	  <title>KB+ :: Import Subscriptions Worksheet</title>
	</head>
	<body class="subscriptions">
		<g:if test="${(errors && (errors.size() > 0))}">
	      	<div class="row">
		        <ul>
		          <g:each in="${errors}" var="e">
		            <li>${e}</li>
		          </g:each>
		        </ul>
	      	</div>
    	</g:if>
		
		<g:if test="${flash.message}">
      		<div class="row">
        		${flash.message}
      		</div>
    	</g:if>

    	<g:if test="${flash.error}">
      		<div class="row">
        		${flash.error}
      		</div>
    	</g:if>
    	
    	<g:set var="counter" value="${-1}" />
		
		<g:form action="processSubscriptionImport" method="post" params="${params}" enctype="multipart/form-data" >
			<div class="row">
				<div class="col s12">
					<g:if test="${subOrg!=null}">
          				Import will create a subscription for ${subOrg.name}
          				<input type="hidden" name="orgId" value="${subOrg.id}"/>
        			</g:if>
					
					<div class="tab-table z-depth-1">
						<table class="highlight bordered responsive-table">
					        <thead>
					          <tr>
					              <th>Title</th>
					              <th>From Pkg</th>
					              <th>ISSN</th>
					              <th>eISSN</th>
					              <th>Start Date</th>
					              <th>Start Volume</th>
					              <th>Start Issue</th>
					              <th>End Date</th>
					              <th>End Volume</th>
					              <th>End Issue</th>
					              <th>Core Medium</th>
					          </tr>
					        </thead>
			
					        <tbody>
								<g:each in="${entitlements}" var="e">
	                				<tr>
	                  					<td>
	                  						<input type="hidden" name="entitlements.${++counter}.tipp_id" value="${e.base_entitlement.id}"/>
	                      					<input type="hidden" name="entitlements.${counter}.core_status" value="${e.core_status}"/>
	                      					<input type="hidden" name="entitlements.${counter}.start_date" value="${e.start_date}"/>
	                      					<input type="hidden" name="entitlements.${counter}.end_date" value="${e.end_date}"/>
	                      					<input type="hidden" name="entitlements.${counter}.coverage" value="${e.coverage}"/>
	                      					<input type="hidden" name="entitlements.${counter}.coverage_note" value="${e.coverage_note}"/>
	                      					<input type="hidden" name="entitlements.${counter}.core_start_date" value="${e.core_start_date}"/>
	                      					<input type="hidden" name="entitlements.${counter}.core_end_date" value="${e.core_end_date}"/>
	                      					${e.base_entitlement.title.title}
	                      				</td>
	                  					<td><g:link controller="packageDetails" action="show" id="${e.base_entitlement.pkg.id}">${e.base_entitlement.pkg.name}(${e.base_entitlement.pkg.id})</g:link></td>
	                  					<td>${e.base_entitlement.title.getIdentifierValue('ISSN')}</td>
	                  					<td>${e.base_entitlement.title.getIdentifierValue('eISSN')}</td>
	                  					<td>${e.start_date} (Default:<g:formatDate format="dd MMMM yyyy" date="${e.base_entitlement.startDate}"/>)</td>
	                  					<td>${e.base_entitlement.startVolume}</td>
	                  					<td>${e.base_entitlement.startIssue}</td>
	                  					<td>${e.end_date} (Default:<g:formatDate format="dd MMMM yyyy" date="${e.base_entitlement.endDate}"/>)</td>
	                  					<td>${e.base_entitlement.endVolume}</td>
	                  					<td>${e.base_entitlement.endIssue}</td>
	                  					<td>${e.core_status?:'N'}</td>
	                				</tr>
	              				</g:each>
					        </tbody>
						</table>
						<input type="hidden" name="ecount" value="${counter}"/>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col s12 page-response">
					<button type="submit" class="waves-effect waves-light btn">Accept and Process</button>
				</div>
			</div>
		</g:form>
	</body>
</html>
