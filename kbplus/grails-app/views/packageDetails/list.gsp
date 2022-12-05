<!doctype html>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="Search Packages" />
	<parameter name="pagestyle" value="Packages" />
	<parameter name="actionrow" value="packages-list" />
	<meta name="layout" content="base"/>
	<title>KB+ :: Package List</title>
</head>
<body class="packages">
	<!-- search-section start-->
	<div class="row">
		<div class="col s12">
			<div class="mobile-collapsible-header" data-collapsible="packages-list-collapsible">Search <i class="material-icons">expand_more</i></div>
			<div class="search-section z-depth-1 mobile-collapsible-body" id="packages-list-collapsible">
				<g:form controller="packageDetails" action="list" method="get" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">
					<g:hiddenField name="sort" value="${params.sort}"/>
					<div class="col s12 mt-10">
						<h3 class="page-title left">Search Packages</h3>
					</div>
					<div class="col s12 l10">
			        	<div class="input-field search-main">
							<input id="package-list-search" placeholder="Enter your search term..." name="q" value="${params.q?.encodeAsHTML()}" type="search">
							<label class="label-icon" for="package-list-search"><i class="material-icons">search</i></label>
							<i class="material-icons close" id="clearSearch" search-id="package-list-search">close</i>
						</div>
					</div>
					<div class="col s12 l1">
						<input type="submit" class="waves-effect waves-teal btn" value="Search" />
					</div>
					<div class="col s12 l1">
						<g:link controller="packageDetails" action="list" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
					</div>
					
					<!--search filter -->
					<div class="col s12">
						<ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
							<li>
								<div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter Search</div>
								<div class="collapsible-body">
									<div class="col s12 m12 l3">
										<div class="input-field">
											<g:kbplusDatePicker inputid="update_start_date" name="updateStartDate" value="${params.updateStartDate}"/>
											<label class="active">Updated After</label>
	  									</div>
	  	      						</div>

									<div class="col s12 m12 l3">
										<div class="input-field">
											<g:kbplusDatePicker inputid="update_end_date" name="updateEndDate" value="${params.updateEndDate}"/>
											<label class="active">Updated Before</label>
	  									</div>
	  	      						</div>

		  	      					<div class="col s12 m12 l3">
	  	      							<div class="input-field">
	  	      								<g:kbplusDatePicker inputid="create_start_date" name="createStartDate" value="${params.createStartDate}"/>
											<label class="active">Created After</label>
	  									</div>
	  	      						</div>

		  	      					<div class="col s12 m12 l3">
		  	      						<div class="input-field">
		  	      							<g:kbplusDatePicker inputid="create_end_date" name="createEndDate" value="${params.createEndDate}"/>
											<label class="active">Created Before</label>
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
				<g:if test="${packageInstanceTotal && packageInstanceTotal>0}">
					Showing results: <span>${offset + 1}</span> to <span>${offset + packageInstanceList.size()}</span> of <span>${packageInstanceTotal}</span>
        		</g:if>
        		<g:else>
        			Showing results: <span>0</span>
        		</g:else>
        		<span>
					<g:if test="${params.q}">
						 -- Search Text: ${params.q} 
					</g:if>
					<g:if test="${params.updateStartDate}">
						 -- Updated After: ${params.updateStartDate}
					</g:if>
					<g:if test="${params.updateEndDate}">
						-- Updated Before: ${params.updateEndDate}
					</g:if>
					<g:if test="${params.createStartDate}">
						 -- Created After: ${params.createStartDate}
					</g:if>
					<g:if test="${params.createEndDate}">
						 -- Created Before: ${params.createEndDate}
					</g:if>
				</span>
			</h2>
		</div>
	</div>

	<div class="row">
		<div class="col s12">
			<div class="filter-section z-depth-1">
				<div class="col s12 l6">
					<g:form controller="packageDetails" action="list" method="get" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">
						<g:hiddenField name="q" value="${params.q}"/>
						<g:hiddenField name="updateStartDate" value="${params.updateStartDate}"/>
						<g:hiddenField name="updateEndDate" value="${params.updateEndDate}"/>
						<g:hiddenField name="createStartDate" value="${params.createStartDate}"/>
						<g:hiddenField name="createEndDate" value="${params.createEndDate}"/>
						<g:hiddenField name="offset" value="${params.offset}"/>
						<g:hiddenField name="max" value="${params.max}"/>
						<div class="input-field">
							<g:select name="sort"
									  value="${params.sort}"
							  		  keys="['name:asc','name:desc','identifier:asc','identifier:desc','dateCreated:asc','dateCreated:desc','lastUpdated:asc','lastUpdated:desc']"
							  		  from="${['Name A-Z','Name Z-A','Identifier A-Z','Identifier Z-A','Created Date A-Z','Created Date Z-A','Last Updated A-Z','Last Updated Z-A']}"
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
			    	<g:each in="${packageInstanceList}" var="packageInstance">
						<div class="collapsible-header">
							<div class="col s12">
								<ul class="collection">
									<li class="collection-item"><h2 class="first navy-text"><g:link controller="packageDetails" action="show" id="${packageInstance.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${packageInstance.name}</g:link></h2></li>
									<li class="collection-item">Identifier: <span>${packageInstance.identifier}</span></li>
									<li class="collection-item">Titles: 
									
									<g:if test="${packageInstance.tipps}">
			      						<g:if test="${packageInstance.tipps.size()==1}">
			      							<span>${packageInstance.tipps.getAt(0).title.title}</span>
			      						</g:if>
			      						<g:else>
			      							<span class="inline-badge tooltipped card-tooltip" data-position="right" data-src="pkg${packageInstance.id}">${packageInstance.tipps.size()}</span> </li>
											<script type="text/html" id="pkg${packageInstance.id}">
												<div class="kb-tooltip">
													<div class="tooltip-title">Titles</div>
													<ul class="tooltip-list">
														<g:each in="${packageInstance.tipps}" var="t">
															<li>${t.title.title}</li>
														</g:each>
													</ul>
												</div>
											</script>
			      						</g:else>
			      					</g:if>
			      					<g:else>
			      						<span>No Titles</span>
			      					</g:else>
									
									<li class="collection-item">Date Created: <span>${packageInstance.dateCreated}</span></li>
									<li class="collection-item">Last Updated: <span>${packageInstance.lastUpdated}</span></li>
									<li class="collection-item">Consortium: <span>${packageInstance.consortia?.name?:'No Consortium'}</span></li>
								</ul>
							</div>
						</div>
					</g:each>
					<!-- accordian header end-->
				</li>
				<!-- accordian item end-->
			</ul>
			
			<div class="pagination">
				<g:paginate action="list" controller="packageDetails" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${packageInstanceTotal}" />
			</div>
		</div>
		<!-- list accordian end-->
	</div>
	<!-- list accordian end-->
</body>
</html>
