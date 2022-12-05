<!doctype html>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="Your core titles" />
	<parameter name="pagestyle" value="core" />
    <parameter name="actionrow" value="title-core" />
	<meta name="layout" content="base"/>
	<title>KB+ ${institution.name} - Edit Core Titles</title>
</head>
<body class="titles">
	<div class="row">
		<div class="col s12">
			<div class="row">
				<div class="col s12">
					<ul class="tabs jisc_tabs mt-40m">
						<g:set var="nparams" value="${params.clone()}"/>
						<g:set var="active_filter" value="${nparams.remove('filter')}"/>
						<li class="tab col s2"><g:link target="_self" controller="myInstitutions" action="tipview" params="${nparams + [filter:'core']}" class="${active_filter=='core'?'active':''}">Core<i class="material-icons">chevron_right</i></g:link></li>
						<li class="tab col s2"><g:link target="_self" controller="myInstitutions" action="tipview" params="${nparams + [filter:'not']}" class="${active_filter=='not'?'active':''}">Not Core<i class="material-icons">chevron_right</i></g:link></li>
						<li class="tab col s2"><g:link target="_self" controller="myInstitutions" action="tipview" params="${nparams + [filter:'all']}" class="${active_filter=='all'?'active':''}">All<i class="material-icons">chevron_right</i></g:link></li>
					</ul>
				</div>
			</div>
			
			<!-- tab 1-->
			<div class="row">
				<div class="col s12">
					<div class="mobile-collapsible-header" data-collapsible="core-collapsible">Search <i class="material-icons">expand_more</i></div>
					<div class="search-section z-depth-1 mobile-collapsible-body" id="core-collapsible">
						<g:form action="tipview" method="get" params="${[defaultInstShortcode:params.defaultInstShortcode]}">
							<input type="hidden" name="filter" value="${params.filter}"/>
							<div class="col s12 mt-10">
								<h3 class="page-title left">Search Your Core Titles</h3>
							</div>
							<div class="col s12 l8">
								<div class="input-field search-main">
									<input id="search-core-titles" name="search_str" value="${params.search_str}" type="search">
									<label class="label-icon active" for="search-core-titles"><i class="material-icons">search</i></label>
									<i class="material-icons input-close-icon close" id="clearSearch" search-id="search-core-titles">close</i>
								</div>
							</div>
							
							<div class="col s12 l2 mt-10">
								<div class="input-field">
									<select name="search_for">
										<option ${params.search_for=='title' ? 'selected' : ''} value="title">Title</option>
										<option ${params.search_for=='provider' ? 'selected' : ''} value="provider">Provider</option>
									</select>
									<label>Search for</label>
								</div>
							</div>
							
							<div class="col s6 m3 l1">
								<input type="submit" value="Search" class="waves-effect waves-light btn"/>
							</div>
							
							<div class="col s6 m3 l1">
								<g:link controller="myInstitutions" action="tipview" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
							</div>
							
							<div class="row">
								<div class="col s12 l6 colpadnine">
									<div class="page-response">
										<div class="input-field">
											<g:select name="sort"
									  				  value="${params.sort}"
									  				  keys="['title-title:asc','title-title:desc','provider-name:asc','provider-name:desc']"
									  				  from="${['Title A-Z','Title Z-A','Provider A-Z','Provider Z-A']}"
									  				  onchange="this.form.submit();"/>
											<label>Sort By</label>
										</div>
									</div>
								</div>
							</div>
						</g:form>
					</div>
				</div>
				
				<div class="row">	
					<div class="col s12 page-response">
						<h2 class="list-response text-navy left">
							<g:set var="noOfItems" value="${user?.defaultPageSize?:10}"/>
							<g:if test="${params.max}">
								<g:set var="noOfItems" value="${params.int('max')}"/>
							</g:if>
							<g:if test="${params.int('offset')}">
								Showing results: <span>${params.int('offset') + 1}</span> to <span>${tips.totalCount < (noOfItems + params.int('offset')) ? tips.totalCount : (noOfItems + params.int('offset'))}</span> of <span>${tips.totalCount}</span>
							</g:if>
							<g:elseif test="${tips.totalCount && tips.totalCount > 0}">
								Showing results: <span>1</span> to <span>${tips.totalCount < noOfItems ? tips.totalCount : noOfItems}</span> of <span>${tips.totalCount}</span>
							</g:elseif>
							<g:else>
								Showing results: <span>${tips.totalCount}</span>
							</g:else>
						</h2>
					</div>	
				</div>
				
				<div class="row">
					<div class="col s12">
						<div class="tab-table z-depth-1 table-responsive-scroll">
							<table class="highlight bordered">
								<thead>
									<tr>
										<th>Title in Package</th>
										<th>Title Details</th>
										<th>Provider</th>
										<th class="center-align">Status</th>
									</tr>
								</thead>
								<tbody>
									<g:each in="${tips}" var="tip">
										<tr>
											<td>
												<g:link controller="myInstitutions" action="tip" params="${[defaultInstShortcode:params.defaultInstShortcode]}" id="${tip.id}">${tip?.title?.title} via ${tip?.provider?.name}</g:link>
											</td>
											<td>
												<g:link controller="titleDetails" action="show" id="${tip?.title?.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">See Title Details</g:link>
											</td>
											<td>
												<g:link controller="org" action="show" id="${tip?.provider?.id}">${tip?.provider?.name}</g:link>
											</td>
											<td>
												<g:set var="coreStatus" value="${tip?.coreStatus(null)}"/>
												<g:set var="coreicon" value="${coreStatus?['with-core','Core']:coreStatus==null?['not-core','Not Core']:['was-core','Was/Will Be Core']}"/>
												<i class="btn-floating btn-large waves-effect ${coreicon[0]} centered"><i class="material-icons"></i></i>
												<p class="center-align light mt-10">${coreicon[1]}</p>
												<g:if test="${editable}">
													<p class="center-align light mt-10"><a href="#kbmodal" reload="true" ajax-url="${createLink(controller:'ajax', action:'getTipCoreDates', params:[tipID:tip.id, title:tip?.title?.title, theme:'titles'])}" class="modalButton">Edit core status</a></p>
												</g:if>
											</td>
										</tr>
									</g:each>
								</tbody>
							</table>
						</div>
						
						<div class="pagination">
							<g:paginate controller="myInstitutions" action="tipview" max="${user?.defaultPageSize?:10}" params="${[:]+params}" next="chevron_right" prev="chevron_left" total="${tips.totalCount}" />
						</div>
					</div>
				</div>
			</div>
			<!-- end tab 1-->
		</div>
	</div>
	
</body>
</html>
