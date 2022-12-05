<!doctype html>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="Platform List" />
	<parameter name="pagestyle" value="subscriptions" />
	<parameter name="actionrow" value="platform-list" />
	<meta name="layout" content="base"/>
	<g:set var="entityName" value="${message(code: 'platform.label', default: 'Platform')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
</head>
<body class="subscriptions">
	<!--page title-->
	<div class="row">
		<div class="col s12 l10">
			<h1 class="page-title">Platform List</h1>
		</div>
	</div>
	<!--page title end-->
	
	<!-- search-section start-->
	<div class="row">
		<div class="col s12">
			<div class="mobile-collapsible-header" data-collapsible="subscription-platform-collapsible">Search <i class="material-icons">expand_more</i></div>
			<div class="search-section z-depth-1 mobile-collapsible-body" id="subscription-platform-collapsible">
				<g:form controller="platform" action="list" method="get">
					<div class="col s12 mt-10">
						<h3 class="page-title left">Search Platform</h3>
					</div>

					<div class="col s12 m12 l5">
						<div class="input-field search-main">
							<input id="search-platforms" name="q" placeholder="Enter your search term..." value="${params.q?.encodeAsHTML()}" type="search">
							<label class="label-icon" for="search-platforms"><i class="material-icons">search</i></label>
							<i class="material-icons close" id="clearSearch" search-id="search-platforms">close</i>
						</div>
					</div>
					<div class="col s12 m12 l5 mt-10">
						<div class="input-field mar-min">
							<select name="deletedRecordHandling">
								<option value="all" ${params.deletedRecordHandling=='all'?'selected':''}>Include All Records</option>
								<option value="only" ${params.deletedRecordHandling=='only'?'selected':''}>Only Deleted Records</option>
								<option value="exclude" ${params.deletedRecordHandling=='exclude'?'selected':''}>Exclude Deleted Records</option>
							</select>
							<label>Deleted Records</label>
						</div>
					</div>
					<div class="col s6 m3 l1">
						<input type="submit" class="waves-effect waves-teal btn" value="Search" />
					</div>
					<div class="col s6 m3 l1">
						<g:link controller="platform" action="list" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
					</div>
				</g:form>
			</div>
		</div>
	</div>
	<!-- search-section end-->
	
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
									<th>Name</th>
									<th>Status</th>
									<th>Action</th>
								</tr>
							</thead>
							<tbody>
								<g:each in="${platformInstanceList}" var="platformInstance">
									<tr>
										<td>${platformInstance.name}</td>
										<td>${platformInstance.status?.value}</td>
										<td><g:link action="show" id="${platformInstance.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="btn-floating table-action"><i class="material-icons">remove_red_eye</i></g:link></td>
									</tr>
								</g:each>
							</tbody>
						</table>
					</div>
				</div>
				<!--***table end***-->
			</div>
		</div>
		<div class="col s12">
			<div class="pagination">
				<g:paginate action="list" controller="platform" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${platformInstanceTotal}" />
			</div>
		</div>
	</div>
	<!-- platform table end-->
	


</body>
</html>
