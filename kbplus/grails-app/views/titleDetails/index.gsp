<!doctype html>
<html lang="en" class="no-js">
<head>
  <parameter name="pagetitle" value="All Titles" />
  <parameter name="pagestyle" value="Titles" />
  <parameter name="actionrow" value="title-all-list" />
  <meta name="layout" content="base"/>
</head>
<body class="titles">

	<div class="row">
		<div class="col s12">
			<ul class="tabs jisc_tabs mt-40m">
				<g:if test="${params.defaultInstShortcode}">
		        	<li class="tab col s2"><g:link target="_self" controller="myInstitutions" action="currentTitles" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Your Titles<i class="material-icons">chevron_right</i></g:link></li>
		        </g:if>
		    	<li class="tab col s2"><g:link controller="titleDetails" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="active">All KB+ Titles<i class="material-icons">chevron_right</i></g:link></li>
		    </ul>
		</div>
	</div>
	<div id="ourTitles" class="tab-content">
	<!-- search-section start-->
	<div class="row">
		<div class="col s12">
			<div class="mobile-collapsible-header" data-collapsible="title-all-collapsible">Search <i class="material-icons">expand_more</i></div>
			<div class="search-section z-depth-1 mobile-collapsible-body" id="title-all-collapsible">
	            <g:form controller="titleDetails" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" method="get">
	            	<input type="hidden" name="offset" value="${params.offset}"/>
	            	<g:if test="${params.sort && params.order}">
	            		<input type="hidden" name="sort" value="${params.sort}:${params.order}"/>
	            	</g:if>
	            	<div class="col s12 mt-10">
						<h3 class="page-title left">Search All Titles ${params.q}</h3>
					</div>
                	<div class="col s12 m12 l7">
                  		<div class="input-field search-main">
                     		<input id="search-ct" name="q" value="${params.q}" type="search">
                     		<label class="label-icon" for="search-ct"><i class="material-icons">search</i></label>
                     		<i class="material-icons close" id="clearSearch" search-id="search-ct">close</i>
                  		</div>
               		</div>
               		<div class="col s12 l3 mt-10">
						<div class="input-field">
							<g:select id="filter"
									  name="filter"
									  from="${[[key:'',value:'All'],[key:'title',value:'Title'],[key:'publisher',value:'Publisher']]}"
									  optionKey="key"
									  optionValue="value"
									  value="${params.filter?:''}"/>
							<label>Search In</label>
						</div>
					</div>
	               	<div class="col s12 m3 l1">
	                  	<input type="submit" class="waves-effect waves-teal btn" value="Search">
	               	</div>
	               	<div class="col s12 m3 l1">
	               		<g:link controller="titleDetails" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
					</div>
	            </g:form>
			</div>
		</div>
	</div>
	<!-- search-section end-->
	
	
                  
	<div class="row">
		<div class="col s12 page-response">
			<h2 class="list-response text-navy">
				<g:if test="${params.int('offset')}">
					Titles showing: <span>${params.int('offset') + 1}</span> to <span>${resultsTotal < (params.int('max') + params.int('offset')) ? resultsTotal : (params.int('max') + params.int('offset'))}</span> of <span>${resultsTotal}</span>
				</g:if>
				<g:elseif test="${resultsTotal && resultsTotal > 0}">
					Titles showing: <span>1</span> to <span>${resultsTotal < params.int('max') ? resultsTotal : params.int('max')}</span> of <span>${resultsTotal}</span>
				</g:elseif>
				<g:else>
					Titles showing: <span>${resultsTotal}</span>
				</g:else>
				
				<g:if test="${params.q}">
					<span>-- Search Text: ${params.q}</span> 
				</g:if>
				<g:if test="${params.filter}">
					<span>-- Search In: ${params.filter}</span>
				</g:if>
			</h2>
		</div>
	</div>

	<!-- list returning/results-->
	<div class="row">
		<div class="col s12">
			<div class="filter-section z-depth-1">
	        	<g:form controller="titleDetails" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" method="get">
					<g:hiddenField name="q" value="${params.q?.encodeAsHTML()}"/>
					<g:hiddenField name="filter" value="${params.filter}"/>
					<g:hiddenField name="max" value="${params.max}"/>
					<g:hiddenField name="offset" value="${params.offset}"/>
					
					<div class="col s12 l6">
						<div class="input-field">
							<g:select name="sort"
									  value="${params.sort}:${params.order}"
									  keys="['_score:DESC','sortTitle.keyword:ASC','sortTitle.keyword:DESC','publisher.keyword:ASC','publisher.keyword:DESC']"
									  from="${['Relevance','Titles A-Z','Titles Z-A','Publisher A-Z','Publisher Z-A']}"
									  onchange="this.form.submit();"/>
							<label>Sort Titles By:</label>
						</div>
					</div>
				</g:form>
			</div>
        </div>
	</div>
	<!-- list returning/results end-->

	<!-- list accordian start-->
	<div class="row">

		<div class="col s12">

			<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
				<g:set var="counter" value="${params.offset+1}" />
				<g:each in="${hits}" var="hit">
				    <!--accordian item-->
				    <li>
				    	<!--accordian header-->
				      	<div class="collapsible-header medium-height">
				      		<div class="col s12">
				      			<div class="icon-collection">
				      				<div class="icon-collection">
				      				<i class="trigger-accordian"></i>
	                  			</div>
	                  			</div>
	
				      			<ul class="collection">
				      				<li class="collection-item"><h2 class="first navy-text">${counter++}. <g:link controller="titleDetails" action="show" id="${hit.getSourceAsMap().dbId}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${raw(hit.getSourceAsMap().title)}</g:link></h2></li>
				      				<li class="collection-item">Publisher: <span>${hit.getSourceAsMap().publisher?:'No Publisher'}</span></li>
				      				<li class="collection-item">
				      					<g:each in="${hit.getSourceAsMap().identifiers}" var="id">
                              				${id.type}:${id.value?:'No Data'}<br/>
                            			</g:each>
				      				</li>
				      			</ul>
				      		</div>
				      	</div>
				      	<!-- accordian header end-->
				    </li>
					<!-- accordian item end-->
				</g:each>
			</ul>
			<div class="pagination">
				<g:if test="${hits}" >
					<g:paginate controller="titleDetails" action="index" params="${params}" next="chevron_right" prev="chevron_left" maxsteps="10" total="${resultsTotal}" /></span>
				</g:if>
			</div>

		</div>
		<!-- list accordian end-->
	</div>

	<!-- end of tabs -->

</body>
</html>
