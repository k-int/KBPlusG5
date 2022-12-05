<!doctype html>
<%
  def addFacet = { params, facet, val ->
    def newparams = [:]
    newparams.putAll(params)
    def current = newparams[facet]
    if ( current == null ) {
      newparams[facet] = val
    }
    else if ( current instanceof String[] ) {
      newparams.remove(current)
      newparams[facet] = current as List
      newparams[facet].add(val);
    }
    else {
      newparams[facet] = [ current, val ]
    }
    newparams
  }

  def removeFacet = { params, facet, val ->
    def newparams = [:]
    newparams.putAll(params)
    def current = newparams[facet]
    if ( current == null ) {
    }
    else if ( current instanceof String[] ) {
      newparams.remove(current)
      newparams[facet] = current as List
      newparams[facet].remove(val);
    }
    else if ( current?.equals(val.toString()) ) {
      newparams.remove(facet)
    }
    newparams
  }

%>
<html lang="en" class="no-js">
	<head>
		<parameter name="pagetitle" value="Subscription: Link Packages" />
		<parameter name="pagestyle" value="subscriptions" />
		<parameter name="actionrow" value="sub-list-menu" />
		<meta name="layout" content="base"/>
		<title>KB+ Subscription :: Link Package</title>
	</head>
	<body class="subscriptions">
		<g:set var="params_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
		
		<!--page title-->
		<div class="row">
			<div class="col s12 l10">
				<h1 class="page-title">${subscriptionInstance.name} : Link Subscription to Packages</h1>
			</div>
		</div>
	  	<!--page title end-->

		<!-- search-section start-->
		<div class="row">
			<div class="col s12">
				<div class="search-section z-depth-1">
					<g:form name="LinkPackageForm" action="linkPackage" method="get" params="${params}">
      					<input type="hidden" name="offset" value="${params.offset}"/>
      					<input type="hidden" name="id" value="${params.id}"/>

						<div class="col s12 mt-10">
							<h3 class="page-title left">Search All Packages</h3>
						</div>

						<div class="col s12 m12 l6">
					        <div class="input-field search-main">
					        	<input id="searchpackages" placeholder="Enter your search term..." name="q" value="${params.q}" type="search"/>
								<label class="label-icon" for="searchpackages"><i class="material-icons">search</i></label>
								<i id="clearSearch" search-id="searchpackages" class="material-icons close">close</i>
					        </div>
						</div>
						<div class="col s6 m6 l2">
							<button type="submit" name="search" value="yes" class="waves-effect waves-teal btn">Search</button>
						</div>

						<!-- TODO: look at styling for below removing of facets when deployed on kbplus test2 instance -->
						<!--<div class="col s12">
							<p>
          						<g:each in="${['type','endYear','startYear','consortiaName','cpname']}" var="facet">
            						<g:each in="${params.list(facet)}" var="fv">
              							<span class="badge alert-info">${facet}:${fv} &nbsp; <g:link controller="${controller}" action="linkPackage" params="${removeFacet(params,facet,fv)}"><i class="material-icons">clear</i></g:link></span>
            						</g:each>
          						</g:each>
      						</p>
						</div>-->

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

						<!-- TODO: need to figure out a way of the onchange select function doing this: addFacet(params,facet.key,v.term) -->
						<!-- perhaps pass a createLink to the function called by onchange -->
						<!-- so <select onchange="functionNameCall(dollar{createLink(controller, action, params: (addFacet...), etc...)})"> -->
						<!-- old linking to add a facet: <g:link controller="dollar{controller}" action="linkPackage" params="dollar{addFacet(params,facet.key,v.term)}">dollar{v.display}</g:link> (dollar{v.count}) -->

						<!--search filter -->
						<div class="col s12">
							<ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
							    <li>
							      	<div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter Search</div>
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

			  	      					<div class="col s12 m12 l2">
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

			  	      					<div class="col s12 m12 l2">
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

			  	      					<div class="col s12 m12 l2">
			  	      						<div class="input-field">
			  									<select name="type" onchange="this.form.submit();">
			  										<option value="" selected>Select one</option>
			  										<g:each in="${typeFacetValue?.sort{it.display}}" var="v">
					                      				<g:if test="${params.list(typeFacetKey).contains(v.term.toString())}">
                      										<option value="${v.term}" selected>${v.display} (${v.count})</option>
                      									</g:if>
                      									<g:else>
                      										<option value="${v.term}">${v.display} (${v.count})</option>
                      									</g:else>
                  									</g:each>
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
					<g:if test="${params.int('offset')}">
                   		Showing results: <span>${params.int('offset') + 1}</span> to <span>${resultsTotal < (params.int('max') + params.int('offset')) ? resultsTotal : (params.int('max') + params.int('offset'))}</span> of <span>${resultsTotal}</span>
                  	</g:if>
					<g:elseif test="${resultsTotal && resultsTotal > 0}">
                    	Showing results: <span>1</span> to <span>${resultsTotal < params.int('max') ? resultsTotal : params.int('max')}</span> of <span>${resultsTotal}</span>
                  	</g:elseif>
                  	<g:else>
                    	Showing results: <span>${resultsTotal}</span>
                  	</g:else>
				</h2>
				<!-- What is this suppose to do? Remove all linked packages from the subscription? commenting out for now -->
				<!--<a href="#" class="waves-effect btn right">Clear Links <i class="material-icons right">link</i></a>-->
			</div>

		</div>
		<!-- list returning/results end-->

		<!-- list accordian start-->
		<div class="row">
			<div class="col s12 l9">
				<div class="tab-table z-depth-1">
					<table class="highlight bordered responsive-table linkPackages">
						<thead>
							<tr>
								<th>Package Name</th>
								<th>Titles</th>
								<th>Consortium</th>
							</tr>
						</thead>
						<tbody>
							<g:each in="${hits}" var="hit">
								<tr>
									<td>
										<p><g:link controller="packageDetails" action="show" id="${hit.getSourceAsMap().dbId}" params="${params_sc}">${hit.getSourceAsMap().name}</g:link></p>
										<p>
											<g:link controller="subscriptionDetails"
													action="linkPackage"
		                                 			id="${params.id}"
		                                 			params="${[addId:hit.getSourceAsMap().dbId,addType:'With']+params_sc}"
		                                 			onClick="return confirm('Are you sure you want to add with entitlements?');"
		                                 			class="waves-effect btn">Link Package (With Entitlements)<i class="material-icons right whiteOver">add_circle_outline</i></g:link>
											<g:link controller="subscriptionDetails"
													action="linkPackage"
		                                 			id="${params.id}"
		                                 			params="${[addId:hit.getSourceAsMap().dbId,addType:'Without']+params_sc}"
		                                 			onClick="return confirm('Are you sure you want to add without entitlements?');"
		                                 			class="waves-effect btn greyBack">Link package (No Entitlements)<i class="material-icons right whiteOver">add_circle_outline</i></g:link>
										</p>
									</td>
									<td><span class="inline-badge" data-position="left" data-src="temp-ref-id">${hit.getSourceAsMap()?.titleCount?:'0'}</span></td>
									<td>${hit.getSourceAsMap().consortiaName}</td>
								</tr>
							</g:each>
						</tbody>
					</table>
				</div>
				<div class="col s12 l9">
					<div class="pagination">
                		<g:if test="${hits}" >
                  			<g:paginate controller="subscriptionDetails" action="linkPackage" params="${params}" next="chevron_right" prev="chevron_left" maxsteps="10" total="${resultsTotal}" />
                		</g:if>
              		</div>
              	</div>
			</div>

			<div class="col s12 l3">
				<div class="card jisc_card mt-0">
					<div class="card-content">
						<span class="card-title">Current List</span>

						<div class="card-detail">
							<p>you have:</p>
							<p class="giga-size">${subscriptionInstance?.packages?.size() ?: '0'}</p>
							<p>Packages added</p>
						</div>
						<g:each in="${subscriptionInstance.packages}" var="sp">
							<div class="card-detail plain-content">
								<ul>
									<li><g:link controller="packageDetails" action="show" id="${sp.pkg.id}" params="${params_sc}">${sp.pkg.name}</g:link></li>
								</ul>
							</div>
							<hr>
						</g:each>
					</div>
				</div>
				<!-- what is this for? is it a link where a user can add/upload a new package to kbplus? commenting out for now -->
	      		<!--<a href="#" class="waves-effect btn right">Add packages<i class="material-icons right">add</i></a>-->
			</div>
		</div>
	</body>
</html>
