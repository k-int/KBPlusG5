<!doctype html>
<%@ page import="java.text.SimpleDateFormat"%>
<%
  def dateFormatter = new SimpleDateFormat("yy-MM-dd HH:mm:ss.SSS")
%>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="All Packages" />
	<parameter name="pagestyle" value="Packages" />
	<parameter name="actionrow" value="packages-all" />
	<meta name="layout" content="base"/>
	<title>KB+ Packages</title>
</head>
<body class="packages">
	<!-- search-section start-->
	<div class="row">
		<div class="col s12">
			<div class="mobile-collapsible-header" data-collapsible="packages-list-collapsible">Search <i class="material-icons">expand_more</i></div>
			<div class="search-section z-depth-1 mobile-collapsible-body" id="packages-list-collapsible">
				<g:form controller="packageDetails" action="index" method="get" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">
					<g:if test="${params.sort && params.order}">
	            		<input type="hidden" name="sort" value="${params.sort}:${params.order}"/>
	            	</g:if>
					<div class="col s12 mt-10">
						<h3 class="page-title left">Search Packages</h3>
					</div>
					<div class="col s12 l10">
			        	<div class="input-field search-main">
							<input id="package-list-search" placeholder="Use &quot;quotation marks&quot; for exact match" name="q" value="${params.q}" type="search">
							<label class="label-icon" for="package-list-search"><i class="material-icons">search</i></label>
							<i class="material-icons close" id="clearSearch" search-id="package-list-search">close</i>
						</div>
					</div>
					<div class="col s12 l1">
						<input type="submit" class="waves-effect waves-teal btn" value="Search" />
					</div>
					<div class="col s12 l1">
						<g:link controller="packageDetails" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
					</div>
					
					<!--search filter -->
					<!-- set up facets individually for use in filtering below -->
					<g:set var="consortiumFacetKey" value="consortiaName"/>
					<g:set var="consortiumFacetValue" value="${facets?.get(consortiumFacetKey)}"/>
					<g:set var="cpFacetKey" value="cpname"/>
					<g:set var="cpFacetValue" value="${facets?.get(cpFacetKey)}"/>
					<g:set var="startFacetKey" value="startYear"/>
					<g:set var="startFacetValue" value="${facets?.get(startFacetKey)}"/>
					<g:set var="endFacetKey" value="endYear"/>
					<g:set var="endFacetValue" value="${facets?.get(endFacetKey)}"/>
					
					<div class="col s12">
						<ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
							<li>
								<div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter</div>
								<div class="collapsible-body">
									<div class="col s12 m12 l3">
										<div class="input-field">
											<select name="consortiaName" onchange="this.form.submit();">
			  									<option value="" selected>Select one</option>
			  									<g:each in="${consortiumFacetValue?.sort{it.display}}" var="v">
                      								<g:if test="${params.list(consortiumFacetKey).contains(v.term.toString())}">
                      									<option value="${v.term}" selected>${v.display} (${v.count})</option>
                      								</g:if>
                      								<g:else>
                      									<option value="${v.term}">${v.display} (${v.count})</option>
                      								</g:else>
                  								</g:each>
		                      				</select>
		                      				<label>Consortium Name</label>
	  									</div>
	  	      						</div>

									<div class="col s12 m12 l3">
										<div class="input-field">
	  										<select name="cpname" onchange="this.form.submit();">
			  									<option value="" selected>Select one</option>
			  									<g:each in="${cpFacetValue?.sort{it.display}}" var="v">
					                      			<g:if test="${params.list(cpFacetKey).contains(v.term.toString())}">
                      									<option value="${v.term}" selected>${v.display} (${v.count})</option>
                      								</g:if>
                      								<g:else>
                      									<option value="${v.term}">${v.display} (${v.count})</option>
                      								</g:else>
                  								</g:each>
			  								</select>
			  								<label>Content Provider</label>
	  									</div>
	  	      						</div>

		  	      					<div class="col s12 m12 l3">
	  	      							<div class="input-field">
	  										<select name="startYear" onchange="this.form.submit();">
			  									<option value="" selected>YYYY-MM-DD</option>
			  									<g:each in="${startFacetValue?.sort{it.display}}" var="v">
					                      			<g:if test="${params.list(startFacetKey).contains(v.term.toString())}">
                      									<option value="${v.term}" selected>${v.display} (${v.count})</option>
                      								</g:if>
                      								<g:else>
                      									<option value="${v.term}">${v.display} (${v.count})</option>
                      								</g:else>
                  								</g:each>
			  								</select>
			  								<label>Start Year</label>
	  									</div>
	  	      						</div>

		  	      					<div class="col s12 m12 l3">
		  	      						<div class="input-field">
	  										<select name="endYear" onchange="this.form.submit();">
			  									<option value="" selected>YYYY-MM-DD</option>
			  									<g:each in="${endFacetValue?.sort{it.display}}" var="v">
					                      			<g:if test="${params.list(endFacetKey).contains(v.term.toString())}">
                      									<option value="${v.term}" selected>${v.display} (${v.count})</option>
                      								</g:if>
                      								<g:else>
                      									<option value="${v.term}">${v.display} (${v.count})</option>
                      								</g:else>
                  								</g:each>
			  								</select>
			  								<label>End Year</label>
										</div>
									</div>
								</div>
							</li>
						</ul>
					</div>
					<!--search filter end -->
				</g:form>
			</div>
		</div>
	</div>
	<!-- search-section end-->

	<!-- list returning/results-->
	<div class="row">
		<div class="col s12 page-response">
			<h2 class="list-response text-navy">
				Showing results: 
				<g:if test="${params.int('offset')}">
					<span>${params.int('offset') + 1}</span> to <span>${resultsTotal < (params.int('max') + params.int('offset')) ? resultsTotal : (params.int('max') + params.int('offset'))}</span> of <span>${resultsTotal}</span>
				</g:if>
				<g:elseif test="${resultsTotal && resultsTotal > 0}">
					<span>1</span> to <span>${resultsTotal < params.int('max') ? resultsTotal : params.int('max')}</span> of <span>${resultsTotal}</span>
				</g:elseif>
				<g:elseif test="${!resultsTotal}">
					0
				</g:elseif>
				<g:else>
					${resultsTotal}
				</g:else>
        		<span>
					<g:if test="${params.q}">
						 -- Search Text: ${params.q} 
					</g:if>
				</span>
			</h2>
		</div>
	</div>

	<div class="row">
		<div class="col s12">
			<div class="filter-section z-depth-1">
				<div class="col s12 l6">
					<g:form controller="packageDetails" action="index" method="get" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">
						<g:hiddenField name="q" value="${params.q}"/>
						<g:hiddenField name="updateStartDate" value="${params.updateStartDate}"/>
						<g:hiddenField name="updateEndDate" value="${params.updateEndDate}"/>
						<g:hiddenField name="createStartDate" value="${params.createStartDate}"/>
						<g:hiddenField name="createEndDate" value="${params.createEndDate}"/>
						<g:hiddenField name="offset" value="${params.offset}"/>
						<g:hiddenField name="max" value="${params.max}"/>
						<div class="input-field">
							<g:select name="sort"
									  value="${params.sort}:${params.order}"
							  		  keys="['sortname.keyword:ASC','sortname.keyword:DESC','consortiaName:ASC','consortiaName:DESC']"
							  		  from="${['Package Name A-Z','Package Name Z-A','Consortium A-Z','Consortium Z-A']}"
							  		  onchange="this.form.submit();"/>
							<label>Sort Packages By:</label>
						</div>
					</g:form>
				</div>
			</div>
		</div>
	</div>
	<!-- list returning/results end-->

	<!-- list accordian start-->
	<div class="row">
		<div class="col s12 l12">
			<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
				<!--accordian item-->
				<li>
			    	<!--accordian header-->
			    	<g:each in="${hits}" var="hit">
						<div class="collapsible-header">
							<div class="col s12">
								<ul class="collection">
									<li class="collection-item"><h2 class="first navy-text"><g:link controller="packageDetails" action="show" id="${hit.getSourceAsMap().dbId}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${hit.getSourceAsMap().name}</g:link></h2></li>
									<li class="collection-item">
										Titles: 
										<g:if test="${hit.getSourceAsMap().titleCount}">
											<g:if test="${hit.getSourceAsMap().titleCount > 0}">
												<span class="inline-badge">${hit.getSourceAsMap().titleCount}</span>
											</g:if>
											<g:else>
												No Titles
											</g:else>
										</g:if>
										<g:else>
											Unknown Number
										</g:else>
									</li>
									<li class="collection-item">
										From 
										<span>
											<g:if test="${hit.getSourceAsMap().startDate}">
												<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${dateFormatter.parse(hit.getSourceAsMap().startDate)}"/>
											</g:if>
											<g:else>
												No Start Date
											</g:else>
										</span> until <span>
											<g:if test="${hit.getSourceAsMap().endDate}">
												<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${dateFormatter.parse(hit.getSourceAsMap().endDate)}"/>
											</g:if>
											<g:else>
												No End Date
											</g:else>
										</span>
									</li>
			      					<li class="collection-item">Last Modified: <span>${hit.getSourceAsMap().lastModified}</span></li>
			      					<li class="collection-item">Consortium: <span>${hit.getSourceAsMap().consortiaName?:'No Data'}</span></li>
								</ul>
							</div>
						</div>
					</g:each>
					<!-- accordian header end-->
				</li>
				<!-- accordian item end-->
			</ul>
			
			<div class="pagination">
				<g:paginate action="index" controller="packageDetails" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${resultsTotal?:0}" />
			</div>
		</div>
		<!-- list accordian end-->
	</div>
	<!-- list accordian end-->
</body>
</html>
