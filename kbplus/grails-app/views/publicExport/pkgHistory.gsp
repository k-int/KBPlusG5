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
        	<li><g:link target="_self" controller="publicExport" action="pkg" id="${params.id}">Package Content</g:link></li>
        	<li><g:link target="_self" class="active" controller="publicExport" action="pkgHistory" id="${params.id}">Package History</g:link></li>
    	</ul>
    </div>
    
	<section class="region region--1-up mgt10">
		<div class="block block-1">
			<h3>Package History</h3>
			<table data-rwdtable  class="data-table" id="tech-companies-2">
				<thead>
					<tr>
						<th scope="col" class="persist essential">
							Date
						</th>
						<th scope="col" class="essential ...">
							Event
						</th>
						<th scope="col" class="essential ...">
							Old
						</th>
						<th scope="col" class="essential ...">
							New
						</th>
						<th scope="col" class="essential ...">
							Link
						</th>
					</tr>
				</thead>
				<tbody>
					<g:each in="${formattedHistoryLines}" var="hl">
						<tr>
							<td><g:formatDate format="yyyy-MM-dd" date="${hl.lastUpdated}"/></td>
							<td>${hl.eventName} ${hl.propertyName}</td>
							<td>${hl.oldValue}</td>
							<td>${hl.newValue}</td>
							<td><a title="${hl.name}" href="${hl.link}">${hl.name}</a></td>
						</tr>
					</g:each>
				</tbody>
			</table>
			
			<g:if test="${historyLines != null}">
				<div class="pagination pagination--with-pages pagination--with-pages--small-pad pagination--white-bg">
					<g:paginate action="pkgHistory" controller="publicExport" params="${params}" next="Next &gt;" prev="&lt; Previous" maxsteps="${max}" total="${num_hl}"/>
				</div>
			</g:if>
		</div>
	</section>
</body>
</html>
