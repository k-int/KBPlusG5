<!doctype html>
<%@ page import="java.text.SimpleDateFormat"%>
<%
  def dateFormatter = new SimpleDateFormat("yy-MM-dd HH:mm:ss.SSS")
%>
<html lang="en" class="no-js">
<head>
	<meta name="layout" content="base"/>
	<parameter name="pagetitle" value="Search Results" />
</head>
<body class="home">
	<!-- search-section start-->
	<div class="row">
		<div class="col s12">
			<div class="mobile-collapsible-header" data-collapsible="packages-list-collapsible">Search <i class="material-icons">expand_more</i></div>
			<div class="search-section z-depth-1 mobile-collapsible-body" id="packages-list-collapsible">
				<g:form action="search" controller="myInstitutions" params="${[defaultInstShortcode:params.defaultInstShortcode]}" method="get">
					<input type="hidden" name="all" value="yes">
					<div class="col s12 mt-10">
						<h3 class="page-title left">Search</h3>
					</div>
					
					<div class="col s12 l10">
						<div class="input-field search-main">
							<input name="q" value="${params.q}" id="search-all" placeholder="Enter your search term..." type="search" required>
							<label class="label-icon" for="search-all"><i class="material-icons">search</i></label>
							<i class="material-icons close" id="clearSearch" search-id="search-all">close</i>
						</div>
					</div>
					
					<div class="col s12 l1">
						<input type="submit" class="waves-effect waves-teal btn" value="Search">
					</div>
				</g:form>
			</div>
		</div>
	</div>
	<!-- search-section end-->
	
	<!--page title-->
	<div class="row">
		<div class="col s12 l10">
			<h1 class="page-title">Search results: ${resultsTotal} - ${params.q}</h1>
		</div>
	</div>
	<!--page title end-->
	
	<!-- commenting out as not being implemented yet, and if we were to, it would be by facets rather than type
	<div class="row">
		<div class="col s12">
			<div class="search-section z-depth-1 ">
				<div class="col s12">
					<ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
						<li>
							<div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter Results</div>
							<div class="collapsible-body filtercheck">
								<ul class="input-field space">
									<p class="ml-10">Refine your results by selecting specific type of records</p>
									<li class="col s12 m6 l3">
										<input type="checkbox" name="chkbx-1" id="chkbx-1">
										<label for="chkbx-1">Our Subscriptions</label>
									</li>
									<li class="col s12 m6 l3">
										<input type="checkbox" name="chkbx-2" id="chkbx-2">
										<label for="chkbx-2">Our Licences</label>
									</li>
									<li class="col s12 m6 l3">
										<input type="checkbox" name="chkbx-3" id="chkbx-3">
										<label for="chkbx-3">Our Titles</label>
									</li>
									<li class="col s12 m6 l3">
										<input type="checkbox" name="chkbx-4" id="chkbx-4">
										<label for="chkbx-4">Core Titles</label>
									</li>
									<li class="col s12 m6 l3 mt-20">
										<input type="checkbox" name="chkbx-5" id="chkbx-5">
										<label for="chkbx-5">All Subscriptions</label>
									</li>
									<li class="col s12 m6 l3 mt-20">
										<input type="checkbox" name="chkbx-6" id="chkbx-6">
										<label for="chkbx-6">All Licences</label>
									</li>
									<li class="col s12 m6 l3 mt-20">
										<input type="checkbox" name="chkbx-7" id="chkbx-7">
										<label for="chkbx-7">All Packages</label>
									</li>
									<li class="col s12 m6 l3 mt-20">
										<input type="checkbox" name="chkbx-8" id="chkbx-8">
										<label for="chkbx-8">All Titles</label>
									</li>
								</ul>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	-->
	
	<div class="row">
		<div class="col s12">
			<ul class="tabs jisc_tabs" style="margin-top: 0px;">
				<li class="tab"><a href="#subscriptions" class="active">Subscriptions (${subs?.size()?:'0'})<i class="material-icons">chevron_right</i></a></li>
				<li class="tab"><a href="#licences">Licences (${lics?.size()?:'0'})<i class="material-icons">chevron_right</i></a></li>
				<li class="tab"><a href="#titles">Titles (${titles?.size()?:'0'})<i class="material-icons">chevron_right</i></a></li>
				<li class="tab"><a href="#packages">Packages (${pkgs?.size()?:'0'})<i class="material-icons">chevron_right</i></a></li>
				<li class="tab"><a href="#platforms">Platforms (${pfms?.size()?:'0'})<i class="material-icons">chevron_right</i></a></li>
				<li class="tab"><a href="#organisations">Organisations (${orgs?.size()?:'0'})<i class="material-icons">chevron_right</i></a></li>
				<li class="tab"><a href="#actions">Actions (${acts?.size()?:'0'})<i class="material-icons">chevron_right</i></a></li>
			</ul>
		</div>
	</div>
	
	<!--***tab Titles content start***-->
	<div id="subscriptions" class="tab-content search-content">
		<!-- row continer-->
		<div class="row">
			<div class="col s12 l12">
				<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
					<g:each in="${subs}" var="sub">
						<!--accordian item-->
						<li>
							<div class="collapsible-header">
								<div class="col s12">
									<i class="icon icon-subscriptions colour"></i>
									<ul class="collection">
										<li class="collection-item"><h2 class="first navy-text"><g:link controller="subscriptionDetails" action="index" id="${sub.getSourceAsMap().dbId}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${sub.getSourceAsMap().name}</g:link></h2></li>
										<li class="collection-item">From <span>${sub.getSourceAsMap()?.startYearAndMonth ?: 'No start date'}</span></li>
										<li class="collection-item">Packages: 
											<g:if test="${sub.getSourceAsMap()?.packages.size() > 0}">
												<g:each var="p" in="${sub.getSourceAsMap().packages}" status="counter">
													<g:if test="${counter > 0}">
														, 
													</g:if>
													<g:link controller="packageDetails" action="show" id="${p.pkgid}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${p.pkgname}</g:link>
												</g:each>
											</g:if>
											<g:else>
												No Packages
											</g:else>
										</li>
									</ul>
								</div>
							</div>
						</li>
						<!-- accordian item end-->
					</g:each>
				</ul>
			</div>
			<!-- list accordian end-->
		</div>
		<!-- row continer end-->
	</div>
	
	<!--***tab Titles content start***-->
	<div id="licences" class="tab-content search-content">
		<!-- row continer-->
		<div class="row">
			<div class="col s12 l12">
				<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
					<g:each in="${lics}" var="lic">
						<!--accordian item-->
						<li>
							<div class="collapsible-header">
								<div class="col s12">
									<i class="icon icon-licences colour"></i>
									<ul class="collection">
										<li class="collection-item"><h2 class="first navy-text"><g:link controller="licenseDetails" action="index" id="${lic.getSourceAsMap().dbId}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${lic.getSourceAsMap().name}</g:link></h2></li>
										<li class="collection-item">Status: ${lic.getSourceAsMap().status}</li>
									</ul>
								</div>
							</div>
						</li>
						<!-- accordian item end-->
					</g:each>
				</ul>
			</div>
		</div>
		<!-- row continer end-->
	</div>
	
	<!--***tab Titles content start***-->
	<div id="titles" class="tab-content search-content">
		<!-- row continer-->
		<div class="row">
			<div class="col s12 l12">
				<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
					<g:each in="${titles}" var="t">
						<!--accordian item-->
						<li>
							<div class="collapsible-header">
								<div class="col s12">
									<i class="icon icon-titles colour"></i>
									<ul class="collection">
										<li class="collection-item"><h2 class="first navy-text"><g:link controller="titleDetails" action="show" id="${t.getSourceAsMap().dbId}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${t.getSourceAsMap().title}</g:link></h2></li>
										<li class="collection-item">Publisher: <span>${t.getSourceAsMap()?.publisher ?: 'No publisher'}</span></li>
									</ul>
								</div>
							</div>
						</li>
						<!-- accordian item end-->
					</g:each>
				</ul>
			</div>
		</div>
		<!-- row continer end-->
	</div>
	
	<!--***tab Titles content start***-->
	<div id="packages" class="tab-content search-content">
		<!-- row continer-->
		<div class="row">
			<div class="col s12 l12">
				<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
					<g:each in="${pkgs}" var="pkg">
						<!--accordian item-->
						<li>
							<div class="collapsible-header">
								<div class="col s12">
									<i class="icon icon-packages colour"></i>
									<ul class="collection">
										<li class="collection-item"><h2 class="first navy-text"><g:link controller="packageDetails" action="show" id="${pkg.getSourceAsMap().dbId}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${pkg.getSourceAsMap().name}</g:link></h2></li>
										<li class="collection-item">From <span><g:if test="${pkg.getSourceAsMap().startDate}"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${dateFormatter.parse(pkg.getSourceAsMap().startDate)}"/></g:if><g:else>No Start Date</g:else></span> until <span><g:if test="${pkg.getSourceAsMap().endDate}"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${dateFormatter.parse(pkg.getSourceAsMap().endDate)}"/></g:if><g:else>No End Date</g:else></span></li>
										<li class="collection-item">Last Modified: <span><g:if test="${pkg.getSourceAsMap().lastModified}"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${dateFormatter.parse(pkg.getSourceAsMap().lastModified)}"/></g:if><g:else>No Date Last Modified</g:else></span></li>
										<li class="collection-item">Consortium: <span>${pkg.getSourceAsMap()?.consortiaName ?: 'No Consortium'}</span></li>
									</ul>
								</div>
							</div>
						</li>
						<!-- accordian item end-->
					</g:each>
				</ul>
			</div>
		</div>
		<!-- row continer end-->
	</div>
	
	<!--***tab Titles content start***-->
	<div id="platforms" class="tab-content">
		<!-- row continer-->
		<div class="row">
			<div class="col s12 l12">
				<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
					<g:each in="${pfms}" var="pfm">
						<!--accordian item-->
						<li>
							<div class="collapsible-header">
								<div class="col s12">
									<i class="icon icon-platform colour"></i>
									<ul class="collection">
										<li class="collection-item"><h2 class="first navy-text"><g:link controller="platform" action="show" id="${pfm.getSourceAsMap().dbId}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${pfm.getSourceAsMap().name}</g:link></h2></li>
									</ul>
								</div>
							</div>
						</li>
						<!-- accordian item end-->
					</g:each>
				</ul>
			</div>
		</div>
		<!-- row continer end-->
	</div>
	
	<!--***tab Titles content start***-->
	<div id="organisations" class="tab-content">
		<!-- row continer-->
		<div class="row">
			<div class="col s12 l12">
				<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
					<g:each in="${orgs}" var="org">
						<!--accordian item-->
						<li>
							<div class="collapsible-header">
								<div class="col s12">
									<i class="icon icon-institution colour"></i>
									<ul class="collection">
										<li class="collection-item"><h2 class="first navy-text"><g:link controller="organisations" action="show" id="${org.getSourceAsMap().dbId}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${org.getSourceAsMap().name}</g:link></h2></li>
										<li class="collection-item">Sector: ${org.getSourceAsMap()?.sector?:'No Sector Data'}</li>
									</ul>
								</div>
							</div>
						</li>
						<!-- accordian item end-->
					</g:each>
				</ul>
			</div>
		</div>
		<!-- row continer end-->
	</div>
	
	<!--***tab Titles content start***-->
	<div id="actions" class="tab-content">
		<!-- row continer-->
		<div class="row">
			<div class="col s12 l12">
				<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
					<g:each in="${acts}" var="act">
						<!--accordian item-->
						<li>
							<div class="collapsible-header">
								<div class="col s12">
									<i class="icon icon-actions colour"></i>
									<ul class="collection">
										<li class="collection-item"><h2 class="first navy-text"><g:link controller="${act.getSourceAsMap().controller}" action="${act.getSourceAsMap().action}">${act.getSourceAsMap().alias}</g:link></h2></li>
										${act.getSourceAsMap().toString()}
									</ul>
								</div>
							</div>
						</li>
						<!-- accordian item end-->
					</g:each>
				</ul>
			</div>
		</div>
		<!-- row continer end-->
	</div>

</body>
</html>
