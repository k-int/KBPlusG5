<!doctype html>
<html lang="en" class="no-js">
<head>
    <meta name="layout" content="base"/>
    <parameter name="pagetitle" value="Platform Details" />
	<parameter name="actionrow" value="platform-detail" />
	<g:set var="entityName" value="${message(code: 'platform.label', default: 'Platform')}" />
    <title><g:message code="default.show.label" args="[entityName]" /></title>
</head>
<body class="subscriptions">

	<!--page title-->
	<div class="row">
		<div class="col s12 l10">
			<h1 class="page-title">Platform: ${platformInstance.name}</h1>
		</div>
	</div>
	<!--page title end-->

	<!--***tab card section***-->
	<div class="row row-content ">
		<div class="col s12 m6 l6">
			<div class="card-panel caption-wrap">
				<p class="card-title">Primary URL</p>
				<p class="card-caption">${platformInstance?.primaryUrl?:'No URL'}</p>
			</div>
		</div>
		
		<div class="col s12 m6 l3">
			<div class="card-panel">
				<p class="card-title">Service Provider</p>
				<p class="card-caption">${platformInstance?.serviceProvider?:'No Data'}</p>
			</div>
		</div>
		
		<div class="col s12 m6 l3">
			<div class="card-panel">
				<p class="card-title">Software Provider</p>
				<p class="card-caption">${platformInstance?.softwareProvider?:'No Data'}</p>
			</div>
		</div>
	</div>
	<!--***tab card section end***-->
	
	<!--tab section start-->
	<div class="row">
		<div class="col s12">
			<h2>Availability of titles in this platform by package</h2>
		</div>
	</div>
	
	<div class="row">
		<div class="col s12 scroll-container">
			<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
				<g:each in="${packages}" var="pkg">
					<!--accordian item-->
					<li>
						<!--accordian header-->
						<div class="collapsible-header">
							<div class="col s12">
								<i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Click to toggle"></i>
								<ul class="collection">
									<li class="collection-item"><h2 class="first navy-text"><g:link controller="packageDetails" action="show" id="${pkg.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${pkg.name}</g:link></h2></li>
									<li class="collection-item">Identifier: <span>${pkg.identifier}</span></li>
									<li class="collection-item">Content Provider: <span>${pkg.contentProvider?.name}</span></li>
									<li class="collection-item">Titles Avaliable: <span class="inline-badge tooltipped card-tooltip" data-position="right" data-src="pkg${pkg.id}">${pkg.tipps.size()}</span> </li>
									<script type="text/html" id="pkg${pkg.id}">
										<div class="kb-tooltip">
											<div class="tooltip-title">Titles</div>
											<ul class="tooltip-list">
												<g:each in="${pkg.tipps}" var="tipp">
													<li>${tipp.title.title}</li>
												</g:each>
											</ul>
										</div>
									</script>
								</ul>
							</div>
						</div>
						<!-- accordian header end-->
						
						<!-- accordian body-->
						<div class="collapsible-body">
							<div class="row tab-table table-responsive-scroll">
								<table class="highlight bordered">
									<thead>
										<tr>
											<th>Title</th>
											<th>ISSN</th>
											<th>eISSN</th>
											<th>From</th>
											<th>To</th>
											<th>Coverage</th>
											<th>Tipp</th>
										</tr>
									</thead>
									<tbody>
										<g:each in="${pkg.tipps}" var="tipp">
											<tr>
												<td><g:link controller="titleInstance" action="show" id="${tipp.title.id}">${tipp.title.title}</g:link></td>
												<td class="w100">${tipp?.title?.getIdentifierValue('ISSN')}</td>
												<td class="w100">${tipp?.title?.getIdentifierValue('eISSN')}</td>
												<td class="w100">
													<span><g:formatDate format="dd MMM yyyy" date="${tipp.startDate}"/></span>
													<g:if test="${tipp.startVolume}"><span>volume: ${tipp.startVolume}</span></g:if>
													<g:if test="${tipp.startIssue}"><span>issue: ${tipp.startIssue}</span></g:if>
												</td>
												<td class="w100">
													<span><g:formatDate format="dd MMM yyyy" date="${tipp.endDate}"/></span>
													<g:if test="${tipp.endVolume}"><span>volume: ${tipp.endVolume}</span></g:if>
													<g:if test="${tipp.endIssue}"><span>issue: ${tipp.endIssue}</span></g:if>
												</td>
												<td class="w100">${tipp.coverageDepth}</td>
												<td class="w150"><g:link controller="tipp" action="show" id="${tipp.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Full TIPP Details</g:link></td>
											</tr>
										</g:each>
									</tbody>
								</table>
							</div>
						</div>
						<!-- accordian body end-->
					</li>
					<!-- accordian item end-->
				</g:each>
			</ul>
		</div>
	</div>
</body>
</html>
