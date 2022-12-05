<!doctype html>
<%@ page import="java.text.SimpleDateFormat"%>
<%
  def dateFormater = new SimpleDateFormat("yy-MM-dd HH:mm:ss.SSS")
%>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="Exports" />
	<parameter name="pagestyle" value="Exports" />
	<parameter name="pageactive" value="export" />
	<meta name="layout" content="public"/>
</head>
<body class="home">
	<section class="region region--2-up">
		<section class="block block-1">
			<h2>Copyright notice</h2>
      <div style="width: 88px;" class="tooltipped card-tooltip" data-src="temp-ref-id" ><img src="../assets/88x31.png" align="Public Domain"></div>
      <div>
        <g:link controller="publicExport" action="index" params="${[format:'atom']}"><img src="../assets/feed-icon-28x28.png" align="RSS"/></g:link>
      </div>
      <p>To the extent possible under law, Jisc has waived all copyright and related or neighboring rights to KBPlus Public Export. This work is published from: United Kingdom.</p>

		</section>
		<section class="block block-2 cms">
			<p class="">Cufts style index</p>
			<p class="mgt10">Use the contents of this URI to drive a full crawl of the KB+ subscriptions offered data. Each row gives an identifier that can be used to construct individual subscription requests.</p>
			<div class="region region--1-up mgt10">
				<g:link action="idx" params="${[format:'csv', max:0]}" class="btn btn--3d btn--primary btn--large">
					<span>Simple CSV</span>
				</g:link>
            	<g:link action="idx" params="${[format:'xml', max:0]}" class="btn btn--3d btn--primary btn--large">
					<span>XML</span>
				</g:link>
            	<g:link action="idx" params="${[format:'json', max:0]}" class="btn btn--3d btn--primary btn--large">
					<span>JSON</span>
            	</g:link>
			</div>
		</section>
	</section>
	
	<section class="region region--1-up mgt10">
		<div class="block block-1">
			<hr>
		</div>
	</section>
	
	<div style="margin-top: 10px;">
        <ul class="jisc_tabs">
			<g:set var="active_filter" value="${params.filter}"/>
			<li><g:link action="index" class="${active_filter!='current'?'active':''}">All Packages</g:link></li>
			<li><g:link action="index" class="${active_filter=='current'?'active':''}" params="${[filter:'current']}">Current Packages</g:link></li>
		</ul>
	</div>
	
	<g:form action="index" method="get" params="${params}" class="form">
		<input type="hidden" name="offset" value="${params.offset}"/>
		<g:if test="${params.startYear && params.endYear}">
			<input type="hidden" name="startYear" value="${params.startYear}"/>
			<input type="hidden" name="endYear" value="${params.endYear}"/>
		</g:if>
		<g:if test="${params.filter}">
			<input type="hidden" name="filter" value="${params.filter}"/>
		</g:if>
		
		<div class="region region--2-up mgt30">
			<div class="block block-1 mh32">
				<div class="form-fields__item--text form-fields__item--single">
					<label>
						<span class="form-fields__label-text">Search Term</span>
						<input name="q" placeholder="Add &quot;&quot; for exact match" value="${params.q}" type="text"/>
					</label>
				</div>
			</div>
			<div class="block block-2 mh32">
				<div class="form-fields__item-select form-fields__item-select--large form-fields__item--single">
					<label>
						<span class="form-fields__label-text">Sort</span>
						<select name="sort">
							<option ${params.sort=='sortname.keyword' ? 'selected' : ''} value="sortname.keyword">Package Name</option>
							<option ${params.sort=='_score' ? 'selected' : ''} value="_score">Score</option>
							<option ${params.sort=='lastModified' ? 'selected' : ''} value="lastModified">Last Modified</option>
						</select>
					</label>
				</div>
			</div>
			<div class="block block-3 mgt20">
				<div class="form-fields__item-select form-fields__item-select--large form-fields__item--single">
					<label>
						<span class="form-fields__label-text">Order</span>
						<select name="order" value="${params.order}">
							<option ${params.order=='asc' ? 'selected' : ''} value="ASC">Ascending</option>
							<option ${params.order=='desc' ? 'selected' : ''} value="DESC">Descending</option>
						</select>
					</label>
				</div>
			</div>
			<div class="block block-4 mgt20">
				<div class="form-fields__item-select form-fields__item-select--large form-fields__item--single">
					<label>
						<span class="form-fields__label-text">Modified after   </span>
            			<g:kbplusDatePicker name="lastUpdated" value="${params.lastUpdated}"/>
					</label>
				</div>
			</div>
		</div>
		
		<section class="region region--3-up mgt30">
			<div class="block block-1">
				<button type="submit" name="search" value="yes" class="btn btn--3d btn--primary btn--large">
					<span>Search</span>
				</button>
			</div>
		</section>
	</g:form>
	
	<section class="region region--1-up mgt30">
		<div class="block block-1">
			<hr>
			<h4 class="mgt10">Filter search</h4>
		</div>
	</section>
	
	<g:set var="consortiumFacetKey" value="consortiaName"/>
	<g:set var="consortiumFacetValue" value="${facets?.get(consortiumFacetKey)}"/>
	<g:set var="cpFacetKey" value="cpname"/>
	<g:set var="cpFacetValue" value="${facets?.get(cpFacetKey)}"/>
	<g:set var="startFacetKey" value="startYear"/>
	<g:set var="startFacetValue" value="${facets?.get(startFacetKey)}"/>
	<g:set var="endFacetKey" value="endYear"/>
	<g:set var="endFacetValue" value="${facets?.get(endFacetKey)}"/>
	
	<div class="region region--2-up mgt20">
		<g:form controller="publicExport" action="index" params="${params}" class="form">
			<div class="block block-1">
				<div class="form-fields__item-select form-fields__item-select--large form-fields__item--single">
					<label>
						<span class="form-fields__label-text">Consortia name</span>
						<select name="consortiaName" onchange="this.form.submit();">
							<option value="" selected>Please select an option</option>
							<g:each in="${consortiumFacetValue?.sort{it.display}}" var="v">
								<g:if test="${params.list(consortiumFacetKey).contains(v.term.toString())}">
									<option value="${v.term}" selected>${v.display} (${v.count})</option>
								</g:if>
								<g:else>
									<option value="${v.term}">${v.display} (${v.count})</option>
								</g:else>
							</g:each>
						</select>
					</label>
				</div>
			</div>
			
			<div class="block block-2">
				<div class="form-fields__item-select form-fields__item-select--large form-fields__item--single">
					<label>
						<span class="form-fields__label-text">Content provider</span>
						<select name="cpname" onchange="this.form.submit();">
							<option value="" selected>Please select an option</option>
							<g:each in="${cpFacetValue?.sort{it.display}}" var="v">
								<g:if test="${params.list(cpFacetKey).contains(v.term.toString())}">
									<option value="${v.term}" selected>${v.display} (${v.count})</option>
								</g:if>
								<g:else>
									<option value="${v.term}">${v.display} (${v.count})</option>
								</g:else>
							</g:each>
						</select>
					</label>
				</div>
			</div>
			
			<div class="block block-3 mgt20">
				<div class="form-fields__item-select form-fields__item-select--large form-fields__item--single">
					<label>
						<span class="form-fields__label-text">End Year</span>
						<select name="endYear" onchange="this.form.submit();">
							<option value="" selected>Please select an option</option>
							<g:each in="${endFacetValue?.sort{it.display}}" var="v">
								<g:if test="${params.list(endFacetKey).contains(v.term.toString())}">
									<option value="${v.term}" selected>${v.display} (${v.count})</option>
								</g:if>
								<g:else>
									<option value="${v.term}">${v.display} (${v.count})</option>
								</g:else>
							</g:each>
						</select>
					</label>
				</div>
			</div>
			
			<div class="block block-4 mgt20">
				<div class="form-fields__item-select form-fields__item-select--large form-fields__item--single">
					<label>
						<span class="form-fields__label-text">Start Year</span>
						<select name="startYear" onchange="this.form.submit();">
							<option value="" selected>Please select an option</option>
							<g:each in="${startFacetValue?.sort{it.display}}" var="v">
								<g:if test="${params.list(startFacetKey).contains(v.term.toString())}">
									<option value="${v.term}" selected>${v.display} (${v.count})</option>
								</g:if>
								<g:else>
									<option value="${v.term}">${v.display} (${v.count})</option>
								</g:else>
							</g:each>
						</select>
					</label>
				</div>
			</div>
		</g:form>
	</div>
	
	<section class="region region--1-up mgt20">
		<div class="block block-1">
			<hr>
		</div>
	</section>

	<section class="region region--2-up mgt40">
		<div class="block block-1">
			<h3>
				Showing results: <span>${first_record}</span> to <span>${last_record}</span> of <span>${resultsTotal}</span>
			</h3>
		</div>
		<div class="block block-1">
			<g:form controller="publicExport" action="index" class="form">
				<div class="form-fields__item-select form-fields__item-select--large form-fields__item--single">
					<label>
						<span class="form-fields__label-text">Sort By</span>
						<g:select name="sort"
								  value="${params.sort}:${params.order}"
								  keys="['sortname.keyword:ASC','sortname.keyword:DESC','consortiaName:ASC','consortiaName:DESC','startDate.keyword:ASC','startDate.keyword:DESC','endDate.keyword:ASC','endDate.keyword:DESC','lastModified.keyword:ASC','lastModified.keyword:DESC']"
								  from="${['Package Name A-Z','Package Name Z-A','Consortium A-Z','Consortium Z-A','Start Date A-Z','Start Date Z-A','End Date A-Z','End Date Z-A','Last Modified A-Z','Last Modified Z-A']}"
								  onchange="this.form.submit();"/>
					</label>
				</div>
			</g:form>
		</div>
	</section>
	
	<section class="region region--1-up mgt10 nomgl">
		<g:each in="${hits}" var="hit">
			<!-- This is the search result block -->
			<g:set var="first" value="${true}"/>
			<div class="block block-1 mgt40">
				<div class="region region--1-up nomgl">
					<div class="block nomargin block-1 cms">
						<h4><g:link controller="publicExport" action="pkg" id="${hit.getSourceAsMap().dbId}">${hit.getSourceAsMap().name}</g:link></h4>
						<h6><span>Title Count:</span> ${hit.getSourceAsMap().titleCount?:'Unknown'}</h6>
						<ul>
							<g:each in="${hit.getSourceAsMap().identifiers}" var="ident">
								<li>${ident}</li>
							</g:each>
						</ul>
						<ul>
							<h6><span>Products:</span>
								<g:each in="${hit.getSourceAsMap().products}" var="pkgProd"><g:if test="${first}"><g:set var="first" value="${false}"/></g:if><g:else>, </g:else>${pkgProd}</g:each>
								<g:if test="${first}">None</g:if>
							</h6>
						</ul>
						<h6 class="sideby"><g:formatDate formatName="default.date.format.notime" date="${hit.getSourceAsMap().startDate?dateFormater.parse(hit.getSourceAsMap().startDate):null}"/> until <g:formatDate formatName="default.date.format.notime" date="${hit.getSourceAsMap().endDate?dateFormater.parse(hit.getSourceAsMap().endDate):null}"/></h6>
						<h6 class="sideby">Last Modified: <g:formatDate formatName="default.date.format" date="${hit.getSourceAsMap().lastModified?dateFormater.parse(hit.getSourceAsMap().lastModified):null}"/></h6>
						<h6>Consortium: ${hit.getSourceAsMap().consortiaName}</h6>
						<div class="region region--1-up mgt20">
							<g:link action="pkg" params="${[format:'json',id:hit.getSourceAsMap().dbId]}" class="btn btn--3d btn--primary btn--large nomgl">
								<span>JSON</span>
							</g:link>
							<g:link action="pkg" params="${[format:'xml',id: hit.getSourceAsMap().dbId]}" class="btn btn--3d btn--primary btn--large">
								<span>XML Export</span>
							</g:link>
							<g:each in="${transforms}" var="transkey,transval">
								<g:link action="pkg" params="${[format:'xml',transformId:transkey,mode:params.mode,id:hit.getSourceAsMap().dbId]}" class="btn btn--3d btn--primary btn--large">
									<span>${transval.name}</span>
								</g:link>
							</g:each>
						</div>
						<hr>
					</div>
				</div>
			</div>
			<!-- end of search result block -->
		</g:each>
	</section>
	
	<div class="pagination pagination--with-pages pagination--with-pages--small-pad pagination--white-bg">
		<g:paginate controller="${controller}" action="index" params="${params}" next="Next &gt;" prev="&lt; Previous" total="${resultsTotal?:0}" />
	</div>
	
</body>
</html>
