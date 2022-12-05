<!doctype html>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="Exports" />
	<parameter name="pagestyle" value="Exports" />
	<parameter name="pageactive" value="export" />
	<meta name="layout" content="public"/>
</head>
<body class="home">
	<section class="region region--1-up">
		<section class="block block-1">
			<h2>${pkg.name}</h2>
			<p class="strapline">Package Start Date : <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${pkg.startDate}"/>, Package End Date: <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${pkg.endDate}"/>, Consortium : ${pkg.consortia?.name ?: 'None'}</p>
			<g:if test="${dateFilter != null}">
				<p class="strapline mgt10">Package date filter set to <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${dateFilter}"/></p>
			</g:if>
			<p class="strapline mgt10">${pkg.getContentProvider()?.name} - Download as</p>
			<div class="region region--1-up mgt10">
				<g:link action="pkg" id="${params.id}" params="${[format:'xml']}" class="btn btn--3d btn--primary btn--large">
					<span>XML</span>
				</g:link>
				<g:link action="pkg" id="${params.id}" params="${[format:'json']}" class="btn btn--3d btn--primary btn--large">
					<span>JSON</span>
				</g:link>
				<g:link action="pkg" id="${params.id}" params="${[format:'xml', transformId:'kbplus']}" class="btn btn--3d btn--primary btn--large">
					<span>KBPlus Import Format</span>
				</g:link>
				<g:link action="pkg" id="${params.id}" params="${[format:'xml', transformId:'kbart2']}" class="btn btn--3d btn--primary btn--large">
					<span>KBART</span>
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
        	<li><g:link target="_self" class="active" controller="publicExport" action="pkg" id="${params.id}">Package Content</g:link></li>
        	<li><g:link target="_self" controller="publicExport" action="pkgHistory" id="${params.id}">Package History</g:link></li>
    	</ul>
    </div>
	
	<section class="region region--1-up mgt10">
		<div class="block block-1">
			<h3>Package Content</h3>
			
			<div>
				<g:if test="${params.int('offset') != null}">
					Showing Titles: ${params.int('offset') + 1} to 
					${num_pkg_rows < (params.int('max') + params.int('offset')) ? num_pkg_rows : (params.int('max') + params.int('offset'))} of ${num_pkg_rows}
				</g:if>
				<g:elseif test="${num_pkg_rows && num_pkg_rows > 0}">
					Showing Titles: 1 to ${num_pkg_rows < params.int('max')?:100 ? num_pkg_rows : params.int('max')?:100} of ${num_pkg_rows}
				</g:elseif>
				<g:else>
					Showing ${resultsTotal} Titles
				</g:else>
			</div>
			
			<table data-rwdtable  class="data-table" id="tech-companies-2">
				<thead>
					<tr>
						<th scope="col" class="persist essential">
							Title
						</th>
						<th scope="col" class="essential ...">
							Start Date (${session.sessionPreferences?.globalDateFormat})
						</th>
						<th scope="col" class="essential ...">
							Start Volume
						</th>
						<th scope="col" class="essential ...">
							Start Issue
						</th>
						<th scope="col" class="essential ...">
							End Date (${session.sessionPreferences?.globalDateFormat})
						</th>
						<th scope="col" class="essential ...">
							End Volume
						</th>
						<th scope="col" class="essential ...">
							End Issue
						</th>
						<th scope="col" class="optional">
							Embargo
						</th>
						<th scope="col" class="optional">
							Coverage Depth
						</th>
						<th scope="col" class="optional">
							Coverage Note
						</th>
						<th scope="col" class="optional">
							Access Status
						</th>
						<th scope="col" class="optional">
							Access Start Date
						</th>
						<th scope="col" class="optional">
							Access End Date
						</th>
					</tr>
				</thead>
				<tbody>
					<g:each in="${titlesList}" var="tipp">
						<tr>
							<th scope="row">${tipp.title.title}</th>
							<td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp.startDate}"/></td>
							<td>${tipp.startVolume}</td>
							<td>${tipp.startIssue}</td>
							<td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp.endDate}"/></td>
							<td>${tipp.endVolume}</td>
							<td>${tipp.endIssue}</td>
							<td>${tipp.embargo}</td>
							<td>${tipp.coverageDepth}</td>
							<td>${tipp.coverageNote}</td>
							<td>${tipp.availabilityStatusAsString}</td>
							<td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp.accessStartDate}" /></td>
							<td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp.accessEndDate}" /></td>
						</tr>
					</g:each>
				</tbody>
			</table>
			
			<div class="pagination pagination--with-pages pagination--with-pages--small-pad pagination--white-bg">
				<g:paginate controller="publicExport" action="pkg" params="${params}" max="${max}" next="Next &gt;" prev="&lt; Previous" total="${num_pkg_rows}"/>
			</div>
		</div>
	</section>
</body>
</html>
