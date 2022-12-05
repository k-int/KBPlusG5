<!doctype html>
<html lang="en" class="no-js">
<head>
    <meta name="layout" content="base"/>
    <parameter name="pagetitle" value="Issue Entitlement" />
	<parameter name="actionrow" value="issue-entitlement-detail" />
	<title>KB+ Issue Entitlement</title>
</head>
<body class="subscriptions">

	<!--page title-->
	<div class="row">
		<div class="col s12 l10">
			<h1 class="page-title">Issue Entitlements: ${issueEntitlementInstance?.tipp.title.title}</h1>
		</div>
	</div>
	<!--page title end-->
	
	<div class="row">
		<div class="col s12">
			<div class="tab-table z-depth-1">
				<h2>Access through subscription : ${issueEntitlementInstance.subscription.name}</h2>
				<!--***table***-->
				<div id="">
					<!--***tab card section***-->
					<div class="row table-responsive-scroll">
						<table class="highlight bordered">
							<thead>
								<tr>
									<th data-field="organisation">From Date</th>
									<th data-field="roles">From Volume</th>
									<th data-field="note">From Issue</th>
									<th data-field="organisation">To Date</th>
									<th data-field="roles">To Volume</th>
									<th data-field="note">To Issue</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>
										<g:if test="${issueEntitlementInstance.startDate}">
											<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${issueEntitlementInstance.startDate}"/>
										</g:if>
										<g:else>
											None
										</g:else>
									</td>
									<td>${issueEntitlementInstance.startVolume?:'None'}</td>
									<td>${issueEntitlementInstance.startIssue?:'None'}</td>
									<td>
										<g:if test="${issueEntitlementInstance.endDate}">
											<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${issueEntitlementInstance.endDate}"/>
										</g:if>
										<g:else>
											None
										</g:else>
									</td>
									<td>${issueEntitlementInstance.endVolume?:'None'}</td>
									<td>${issueEntitlementInstance.endIssue?:'None'}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!--***table end***-->
			</div>
		</div>
	</div>
	
	<!--***tab card section***-->
	<div class="row row-content">
		<div class="col s12 m6 no-padding">
			<div class="row">
				<div class="col s12">
					<div class="row card-panel strip-table-issue-ents-T z-depth-1">
						<div class="col m12 section">
							<div class="col m6 title">
								Subscription
							</div>
							<div class="col m6 result">
								<g:if test="${issueEntitlementInstance?.subscription}">
									<g:link controller="subscriptionDetails" action="index" id="${issueEntitlementInstance?.subscription?.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${issueEntitlementInstance?.subscription?.name.encodeAsHTML()}</g:link>
								</g:if>
								<g:else>
									None
								</g:else>
							</div>
						</div>

						<div class="col m12 section">
							<div class="col m6 title">
								Licence
							</div>
							<div class="col m6 result">
								<g:if test="${issueEntitlementInstance?.subscription.owner}">
									<g:link controller="licenseDetails" action="index" id="${issueEntitlementInstance?.subscription?.owner.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${issueEntitlementInstance?.subscription?.owner.reference.encodeAsHTML()}</g:link>
								</g:if>
								<g:else>
									None
								</g:else>
							</div>
						</div>

						<div class="col m12 section">
							<div class="col m6 title">
								ONIX-PL Licence
							</div>
							<div class="col m6 result">
								<g:if test="${issueEntitlementInstance?.subscription?.owner?.onixplLicense}">
									<g:link controller="onixplLicenseDetails" action="index" id="${issueEntitlementInstance.subscription.owner.onixplLicense.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${issueEntitlementInstance.subscription.owner.onixplLicense.title.encodeAsHTML()}</g:link>
								</g:if>
								<g:else>
									None
								</g:else>
							</div>
						</div>

						<div class="col m12 section">
							<div class="col m6 title">
								Title
							</div>
							<div class="col m6 result">
								<g:if test="${issueEntitlementInstance?.tipp?.title}">
									<g:link controller="titleDetails" action="show" id="${issueEntitlementInstance?.tipp?.title.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${issueEntitlementInstance?.tipp?.title.title.encodeAsHTML()}</g:link>
								</g:if>
								<g:else>
									None
								</g:else>
							</div>
						</div>
						
						<div class="col m12 section">
							<div class="col m6 title">
								Core Medium
							</div>
							<div class="col m6 result">
								<g:if test="${issueEntitlementInstance?.medium}">
									${issueEntitlementInstance.medium}
								</g:if>
								<g:else>
									None
								</g:else>
							</div>
						</div>


            <div class="col m12 section">
              <div class="col m6 title">
                Entitlement Medium
              </div>
              <div class="col m6 result">
                <g:if test="${issueEntitlementInstance?.coreStatus}">
                  ${issueEntitlementInstance.coreStatus}
                </g:if>
                <g:else>
                  None
                </g:else>
              </div>
            </div>


						<div class="col m12 section">
							<div class="col m6 title">
								Core Status
							</div>
							<div class="col m6 result">
								<g:render template="/templates/coreStatus" model="${['issueEntitlement': issueEntitlementInstance, 'theme':'subscriptions', 'center':false, 'editable':editable]}"/>
								<!--<a class="btn-floating btn-large waves-effect with-core tooltipped" data-position="left" data-delay="50" data-tooltip="Since 2017"><i class="material-icons"></i></a> <a href=""><span>view details</span></a>-->
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col s12 m6 no-padding">
			<div class="row">
				<div class="col s12">
					<div class="row card-panel strip-table-issue-ents-T z-depth-1">
						<div class="col m12 section">
							<div class="col m6 title">
								Title Identifiers
							</div>
							<div class="col m6 result">
								<g:if test="${issueEntitlementInstance?.tipp.title?.ids}">
									<g:each in="${issueEntitlementInstance?.tipp.title?.ids}" var="i" status="counter">
										<g:if test="${counter > 0}">, </g:if>
										<span>${i.identifier.ns.ns}:${i.identifier.value}</span>
										<g:if test="${i.identifier.ns.ns.equalsIgnoreCase('issn')}">
											(<a href="https://portal.issn.org/resource/issn/${i.identifier.value}">ISSN Agency</a>)
										</g:if>
										<g:if test="${i.identifier.ns.ns.equalsIgnoreCase('eissn')}">
											(<a href="https://portal.issn.org/resource/issn/${i.identifier.value}">ISSN Agency</a>)
										</g:if>
									</g:each>
								</g:if>
								<g:else>
									None
								</g:else>
							</div>
						</div>
						
						<div class="col m12 section">
							<div class="col m6 title">
								TIPP Delayed OA
							</div>
							<div class="col m6 result">
								<g:if test="${issueEntitlementInstance?.tipp?.delayedOA?.value}">
									${issueEntitlementInstance.tipp.delayedOA.value}
								</g:if>
								<g:else>
									None
								</g:else>
							</div>
						</div>

						<div class="col m12 section">
							<div class="col m6 title">
								TIPP Hybrid OA
							</div>
							<div class="col m6 result">
								<g:if test="${issueEntitlementInstance?.tipp?.hybridOA?.value}">
									${issueEntitlementInstance.tipp.hybridOA.value}
								</g:if>
								<g:else>
									None
								</g:else>
							</div>
						</div>

						<div class="col m12 section">
							<div class="col m6 title">
								Date Title Joined Package
							</div>
							<div class="col m6 result">
								<g:if test="${issueEntitlementInstance?.tipp?.accessStartDate}">
									<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${issueEntitlementInstance.tipp.accessStartDate}"/>
								</g:if>
								<g:else>
									None
								</g:else>
							</div>
						</div>
						
						<div class="col m12 section">
							<div class="col m6 title">
								Title URL
							</div>
							<div class="col m6 result">
								<a href="${issueEntitlementInstance.tipp?.getCombinedPlatformUrl()}" target="_blank" TITLE="${issueEntitlementInstance.tipp?.getCombinedPlatformUrl()}">${issueEntitlementInstance.tipp.platform.name}</a></dd>
							</div>
						</div>
						
						<div class="col m12 section">
							<div class="col m6 title">
								Embargo
							</div>
							<div class="col m6 result">
								<g:if test="${issueEntitlementInstance?.embargo}">
									${issueEntitlementInstance.embargo}
								</g:if>
								<g:else>
									None
								</g:else>
							</div>
						</div>

						<div class="col m12 section">
							<div class="col m6 title">
								Coverage Depth
							</div>
							<div class="col m6 result">
								<g:if test="${issueEntitlementInstance?.coverageDepth}">
									${issueEntitlementInstance.coverageDepth}
								</g:if>
								<g:else>
									None
								</g:else>
							</div>
						</div>

						<div class="col m12 section">
							<div class="col m6 title">
								Coverage Note
							</div>
							<div class="col m6 result">
								<g:if test="${issueEntitlementInstance?.coverageNote}">
									${issueEntitlementInstance.coverageNote}
								</g:if>
								<g:else>
									None
								</g:else>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
    <!--***tab card section end***-->

	<div class row>
		<!-- search-section start-->
		<div class="row">
			<div class="col s12">
				<h2>Occurrences of this title against Packages / Platforms</h2>
				<div class="search-section list-search-ui z-depth-1">
					<g:form controller="issueEntitlement" action="show" params="${params}" method="get">
						<input type="hidden" name="sort" value="${params.sort}">
						<input type="hidden" name="order" value="${params.order}">
                        <div class="col s12 mt-10">
                            <h3 class="page-title left">Search Your Entitlements</h3>
                        </div>
						<div class="col s12 l6">
							<div class="input-field search-main">
								<input id="search-ie-pkg-name" name="filter" value="${params.filter}" type="search">
								<label class="label-icon" for="search-ie-pkg-name"><i class="material-icons">search</i></label>
								<i class="material-icons close" id="clearSearch" search-id="search-ie-pkg-name">close</i>
							</div>
						</div>
						<div class="col s12 l2 mt-10">
							<div class="input-field">
								<g:kbplusDatePicker inputid="startsBefore" name="startsBefore" value="${params.startsBefore}"/>
								<label class="active">Starts Before</label>
							</div>
						</div>
						<div class="col s12 l2 mt-10">
							<div class="input-field">
								<g:kbplusDatePicker inputid="endsAfter" name="endsAfter" value="${params.endsAfter}"/>
								<label class="active">Ends After</label>
							</div>
						</div>
						<div class="col s6 l1">
							<input type="submit" class="waves-effect waves-teal btn right" value="Search"/>
						</div>
                        <div class="col s6 l1">
                            <g:link controller="issueEntitlement" action="show" id="${params.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
                        </div>
					</g:form>
				</div>
			</div>
		</div>
		<!-- search-section end-->
	</div>

	<!-- platform tables-->
	<div class="row">
		<div class="col s12">
			<div class="tab-table z-depth-1">
				<h2>Platforms</h2>
				
				<!--***table***-->
				<div id="licence-properties">
					<!--***tab card section***-->
					<div class="row table-responsive-scroll">
						<table class="highlight bordered">
							<thead>
								<tr>
									<th data-field="cl">From Date</th>
									<th data-field="order-id">From Volume</th>
									<th data-field="date-paid">From Issue</th>
									<th data-field="start-date">To Date</th>
									<th data-field="end-date">To Volume</th>
									<th data-field="ammount">To Issue</th>
									<th data-field="ammount">Coverage Depth</th>
									<th data-field="ammount">Platform</th>
									<th data-field="ammount">Package</th>
									<th data-field="ammount"></th>
								</tr>
							</thead>
							<tbody>
								<g:if test="${tippList}">
									<g:each in="${tippList}" var="t">
										<tr>
											<td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.startDate}"/></td>
											<td>${t.startVolume}</td>
											<td>${t.startIssue}</td>
											<td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.endDate}"/></td>
											<td>${t.endVolume}</td>
											<td>${t.endIssue}</td>
											<td>${t.coverageDepth}</td>
											<td><g:link controller="platform" action="show" id="${t.platform.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${t.platform.name}</g:link></td>
											<td><g:link controller="packageDetails" action="show" id="${t.pkg.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${t.pkg.name}</g:link></td>
											<td><g:link controller="tipp" action="show" id="${t.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">See TIPP</g:link></td>
										</tr>
									</g:each>
								</g:if>
								<g:else>
									<tr><td colspan="10">No Data Currently Added</td></tr>
								</g:else>
							</tbody>
						</table>
					</div>
				</div>
				<!--***table end***-->
			</div>
		</div>
	</div>
	<!-- platform table end-->

	<!--***tabular data***-->
	<div class="row">
		<div class="col s12">
			<div class="tab-table z-depth-1">
				<ul class="tabs jisc_content_tabs">
					<li class="tab"><a href="#defaultspkg">Default Values in Package : ${issueEntitlementInstance.tipp.pkg.name}</a></li>
					<g:if test="${( usage != null ) && ( usage.size() > 0 ) }">
						<li class="tab"><a href="#juspusage">JUSP Usage Statistics</a></li>
					</g:if>
				</ul>
				
				<!--***table***-->
				<div id="defaultspkg" class="tab-content">
					<div class="row table-responsive-scroll">
						<table class="highlight bordered">
							<thead>
								<tr>
									<th data-field="cl">From Date</th>
									<th data-field="order-id">From Volume</th>
									<th data-field="date-paid">From Issue</th>
									<th data-field="start-date">To Date</th>
									<th data-field="end-date">To Volume</th>
									<th data-field="ammount">To Issue</th>
									<th data-field="ammount">Embargo</th>
									<th data-field="ammount">Coverage Depth</th>
									<th data-field="ammount" class="center">Coverage Note</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${issueEntitlementInstance.tipp.startDate}"/></td>
                  					<td>${issueEntitlementInstance.tipp.startVolume}</td>
                  					<td>${issueEntitlementInstance.tipp.startIssue}</td>
                  					<td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${issueEntitlementInstance.tipp.endDate}"/></td>
                  					<td>${issueEntitlementInstance.tipp.endVolume}</td>
                  					<td>${issueEntitlementInstance.tipp.endIssue}</td>
									<td>${issueEntitlementInstance.tipp.embargo}</td>
									<td>${issueEntitlementInstance.tipp.coverageDepth}</td>
									<td class="center">
										<g:if test="${issueEntitlementInstance?.tipp?.coverageNote}">
											<ul class="flex-row">
												<li><i class="material-icons theme-icon tooltipped card-tooltip" data-position="left" data-src="defs-from-pkg-cn">info</i></li>
											</ul>
											<script type="text/html" id="defs-from-pkg-cn">
												<div class="kb-tooltip">
													<div class="tooltip-title">Note</div>
													<ul class="tooltip-list">
														<li>${issueEntitlementInstance.tipp.coverageNote}</li>
													</ul>
												</div>
											</script>
										</g:if>
										<g:else>
											N/A
										</g:else>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!--***table end***-->

				<g:if test="${( usage != null ) && ( usage.size() > 0 ) }">
					<!--***table***-->
					<div id="juspusage" class="tab-content">
						<!--***tab card section***-->
						<div class="row table-responsive-scroll">
							<a href="${jusplink}">[JUSP]</a>
							<table class="highlight bordered">
								<thead>
									<tr>
										<th>Reporting Period</th>
										<g:each in="${x_axis_labels}" var="l">
											<th>${l}</th>
										</g:each>
									</tr>
								</thead>
								<tbody>
									<g:set var="counter" value="${0}" />
									<g:each in="${usage}" var="v">
										<tr>
											<td>${y_axis_labels[counter++]}</td>
											<g:each in="${v}" var="v2">
												<td>${v2}</td>
											</g:each>
										</tr>
									</g:each>
								</tbody>
							</table>
						</div>
					</div>
					<!--***table end***-->
				</g:if>
			</div>
	    	<!--***tabular data end***-->
		</div>
	</div>
	<!--***tab Details content end***-->
</body>
</html>
