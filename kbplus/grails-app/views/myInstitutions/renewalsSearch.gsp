<!doctype html>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="Generate renewals spreadsheet" />
	<parameter name="pagestyle" value="subscriptions" />
	<parameter name="actionrow" value="renewals" />
	<meta name="layout" content="base"/>
	<title>KB+ Renewals Generation - Search</title>
</head>
<body class="subscriptions">
	<!-- search-section start-->
	<div class="row">
		<div class="col s12">
			<div class="mobile-collapsible-header" data-collapsible="renew-list-collapsible">Search <i class="material-icons">expand_more</i></div>
			<div class="search-section z-depth-1 mobile-collapsible-body" id="renew-list-collapsible">
				<g:form action="renewalsSearch" method="get" params="${params}">
					<input type="hidden" name="offset" value="${params.offset}"/>
					<div class="col s12 mt-10">
						<h3 class="page-title left">Search Your Renewals</h3>
					</div>
					<div class="col s12 l10">
						<div class="input-field search-main">
							<input id="search-rs" name="pkgname" value="${params.pkgname}" type="search">
							<label class="label-icon" for="search-rs"><i class="material-icons">search</i></label>
							<i id="clearSearch" class="material-icons close" search-id="search-rs">close</i>
				        </div>
					</div>
					<div class="col s12 l1">
						<button type="submit" name="search" value="yes" class="waves-effect waves-teal btn">Search</button>
					</div>
					<div class="col s12 l1">
						<g:link controller="myInstitutions" action="renewalsSearch" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
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
					<g:set var="typeFacetKey" value="type"/>
					<g:set var="typeFacetValue" value="${facets?.get(typeFacetKey)}"/>
					
					<div class="col s12">
						<ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
						    <li>
						      	<div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter Search</div>
						      	<div class="collapsible-body">
	
		  					      	<div class="col s12 m12 l3">
		  	      						<div class="input-field">
		  									<select name="facetConsortium">
			  									<option value="">Select one</option>
			  									<g:if test="${consortiumFacetValue}">
			  										<g:each in="${consortiumFacetValue.sort{it.display}}" var="v">
			  											<g:if test="${(params?.facetConsortium) && (params?.facetConsortium?.equals(v.display))}">
					                      					<option value="${v.display}" selected>${v.display} (${v.count})</option>
					                      				</g:if>
					                      				<g:else>
					                      					<option value="${v.display}">${v.display} (${v.count})</option>
					                      				</g:else>
                  									</g:each>
                  								</g:if>
		                      				</select>
		                      				<label>Consortium Name</label>
		  								</div>
		  	      					</div>
	
		  	      					<div class="col s12 m12 l3">
		  	      						<div class="input-field">
		  	      							<select name="facetContentProvider">
			  									<option value="">Select one</option>
			  									<g:if test="${cpFacetValue}">
			  										<g:each in="${cpFacetValue.sort{it.display}}" var="v">
                        								<g:if test="${(params?.facetContentProvider) && (params?.facetContentProvider?.equals(v.display))}">
					                      					<option value="${v.display}" selected>${v.display} (${v.count})</option>
					                      				</g:if>
					                      				<g:else>
					                      					<option value="${v.display}">${v.display} (${v.count})</option>
					                      				</g:else>
                  									</g:each>
                  								</g:if>
			  								</select>
			  								<label>Content Provider</label>
		  								</div>
		  	      					</div>
	
		  	      					<div class="col s12 m12 l2">
		  	      						<div class="input-field">
		  	      							<select name="facetStartYear">
			  									<option value="">YYYY-MM-DD</option>
			  									<g:if test="${startFacetValue}">
			  										<g:each in="${startFacetValue.sort{it.display}}" var="v">
                        								<g:if test="${(params?.facetStartYear) && (params?.facetStartYear?.equals(v.display))}">
					                      					<option value="${v.display}" selected>${v.display} (${v.count})</option>
					                      				</g:if>
					                      				<g:else>
					                      					<option value="${v.display}">${v.display} (${v.count})</option>
					                      				</g:else>
                  									</g:each>
                  								</g:if>
			  								</select>
			  								<label>Start Year</label>
		  								</div>
		  	      					</div>
	
		  	      					<div class="col s12 m12 l2">
		  	      						<div class="input-field">
		  	      							<select name="facetEndYear">
			  									<option value="">YYYY-MM-DD</option>
			  									<g:if test="${endFacetValue}">
			  										<g:each in="${endFacetValue.sort{it.display}}" var="v">
                        								<g:if test="${(params?.facetEndYear) && (params?.facetEndYear?.equals(v.display))}">
					                      					<option value="${v.display}" selected>${v.display} (${v.count})</option>
					                      				</g:if>
					                      				<g:else>
					                      					<option value="${v.display}">${v.display} (${v.count})</option>
					                      				</g:else>
                  									</g:each>
                  								</g:if>
			  								</select>
			  								<label>End Year</label>
		  								</div>
		  	      					</div>
		  	      					
		  	      					<div class="col s12 m12 l2">
		  	      						<div class="input-field">
		  	      							<select name="facetType">
			  									<option value="">Select one</option>
			  									<g:if test="${typeFacetValue}">
			  										<g:each in="${typeFacetValue.sort{it.display}}" var="v">
                        								<g:if test="${(params?.facetType) && (params?.facetType?.equals(v.display))}">
					                      					<option value="${v.display}" selected>${v.display} (${v.count})</option>
					                      				</g:if>
					                      				<g:else>
					                      					<option value="${v.display}">${v.display} (${v.count})</option>
					                      				</g:else>
                  									</g:each>
                  								</g:if>
			  								</select>
			  								<label>Type</label>
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
			<h2 class="list-response text-navy left">
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
			</h2>
			<g:link controller="myInstitutions" action="renewalsSearch" params="${params+[clearBasket:'yes']}" class="waves-effect btn right">Clear Basket <i class="material-icons right">shopping_basket</i></g:link>
		</div>

	</div>
	<!-- list returning/results end-->
	
	<g:set var="basketIds" value="${[]}"/>
	<g:each in="${basket}" var="b">
		<g:set var="basketIds" value="${basketIds+[b.id]}"/>
	</g:each>
	
	<!-- list accordian start-->
	<div class="row">
		<div class="col s12 l9">
			<div class="tab-table z-depth-1 table-responsive-scroll">
				<table class="highlight bordered">
					<thead>
						<tr>
							<th>Package Name</th>
							<th>Consortium</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody>
						<g:if test="${hits}">
							<g:each in="${hits}" var="hit">
								<g:if test="${(hit.getSourceAsMap().dbId as Long) in basketIds}">
									<tr class="active-basket">
								</g:if>
								<g:else>
									<tr>
								</g:else>
									<td><g:link controller="packageDetails" action="show" id="${hit.getSourceAsMap().dbId}">${hit.getSourceAsMap().name}</g:link></td>
									<td>${hit.getSourceAsMap().consortiaName}</td>
									<td>
										<div class="actions-container">
											<g:link controller="myInstitutions" action="renewalsSearch" params="${params+[addBtn:hit.getSourceAsMap().dbId]}" class="btn-floating btn-flat"><i class="material-icons">shopping_basket</i></g:link>
										</div>
									</td>
								</tr>
							</g:each>
						</g:if>
					</tbody>
				</table>
			</div>
			
			<div class="pagination">
				<g:if test="${hits}" >
					<g:paginate controller="myInstitutions" action="renewalsSearch" params="${params}" next="chevron_right" prev="chevron_left" maxsteps="10" total="${resultsTotal}"/>
				</g:if>
			</div>
		</div>

		<div class="col s12 l3">
			<div class="card jisc_card mt-0">
				<div class="card-content">
					<span class="card-title">Basket Items</span>

					<div class="card-detail">
						<p>you have:</p>
						<p class="giga-size">${basket.size()}</p>
						<p>packages</p>
					</div>
					<g:each in="${basket}" var="itm">
						<div class="card-detail plain-content">
							<ul>
								<li><h2>${itm.name}</h2></li>
							</ul>
						</div>
					</g:each>
				</div>
			</div>

		</div>
	</div>

</body>
</html>
