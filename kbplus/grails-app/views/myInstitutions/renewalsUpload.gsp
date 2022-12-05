<!doctype html>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="Import renewals spreadsheet" />
	<parameter name="pagestyle" value="renewals" />
	<parameter name="actionrow" value="renewals-import" />
	<meta name="layout" content="base"/>
	<title>KB+ Renewals Upload</title>
</head>
<body class="subscriptions">
	<g:if test="${(errors && (errors.size() > 0))}">
		<div class="row">
			<div class="col s12">
				<ul>
					<g:each in="${errors}" var="e">
						<li>${e}</li>
					</g:each>
				</ul>
			</div>
		</div>
	</g:if>

	<g:if test="${flash.message}">
		<div class="row">
			<div class="col s12">
				Flash message: ${flash.message}
			</div>
		</div>
	</g:if>

	<g:if test="${flash.error}">
		<div class="row">
			<div class="col s12">
				Flash error: ${flash.error}
			</div>
		</div>
	</g:if>

	<g:set var="counter" value="${-1}" />

	<g:form controller="myInstitutions" action="processRenewal" method="post" enctype="multipart/form-data" params="${params}">
		<input type="hidden" name="subscription.start_date" value="${additionalInfo?.sub_startDate}"/>
		<input type="hidden" name="subscription.end_date" value="${additionalInfo?.sub_endDate}"/>
		<input type="hidden" name="subscription.copy_docs" value="${additionalInfo?.sub_id}"/>

		<div class="row">
			<div class="col s12">
				<div class="tab-table z-depth-1 table-responsive-scroll">
					<table class="highlight bordered">
						<tbody>
							<tr>
								<th>Select</th>
								<th>Subscription Properties</th>
								<th>Value</th>
							</tr>
							<tr>
								<th><g:checkBox name="subscription.copyStart" value="${true}" /><label for="subscription.copyStart" class="four-down-translate" /></th>
								<th>Start Date</th>
								<td>${additionalInfo?.sub_startDate}</td>
							</tr>
							<tr>
								<th><g:checkBox name="subscription.copyEnd" value="${true}" /><label for="subscription.copyEnd"  class="four-down-translate"/></th>
								<th>End Date</th>
								<td>${additionalInfo?.sub_endDate}</td>
							</tr>
							<tr>
								<th><g:checkBox name="subscription.copyDocs" value="${true}" /><label for="subscription.copyDocs"  class="four-down-translate"/></th>
								<th>Copy Documents and Notes from Subscription</th>
								<td>${additionalInfo?.sub_name}</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<div class="row">
			<div class="col s12">
				<div class="tab-table z-depth-1 table-responsive-scroll">
					<table class="highlight bordered">
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
				</div>
			</div>
		</div>

		<div class="row">
			<div class="col s12 page-response">

				<input type="submit" class="waves-effect waves-light btn" value="Accept and Process"/>
			</div>
		</div>
		<input type="hidden" name="ecount" value="${counter}"/>
	</g:form>
</body>
</html>
