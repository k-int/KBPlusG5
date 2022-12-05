<div class="container" data-theme="titles">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">${ti.title}</h1>
			<p class="form-caption flow-text grey-text">This title appears in the following packages and platforms</p>
			<div class="row">
				<div class="col s12">
					<div class="tab-table z-depth-1  table-responsive-scroll">
						<table class="highlight bordered">
							<thead>
	               				<tr>
	               					<th>Platform</th>
	               					<th>Package</th>
	                 				<th>Start</th>
	                 				<th>End</th>
	                 				<th>Coverage Depth</th>
	                 				<th>Coverage Note</th>
	                 				<th>Host Platform URL</th>
	               				</tr>
	             			</thead>
					        <tbody>
	               				<g:each in="${ti.tipps}" var="t">
	                 				<tr>
	                   					<td><g:link controller="platform" action="show" id="${t.platform.id}">${t.platform.name}</g:link></td>
					                    <td><g:link controller="packageDetails" action="show" id="${t.pkg.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${t.pkg.name}</g:link></td>
					                    <td>Date: <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.startDate}"/><br/>
					                    Volume: ${t.startVolume}<br/>
					                    Issue: ${t.startIssue}</td>
					                    <td>Date: <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.endDate}"/><br/>
					                    Volume: ${t.endVolume}<br/>
					                    Issue: ${t.endIssue}</td>
					                    <td>${t.coverageDepth}</td>
	                   					<td>${t.coverageNote?:'No coverage note'}</td>
	                                   	<td style="word-wrap: break-word;">${t.hostPlatformURL?:'No Host Platform URL'} 
	                                   		<g:if test="${grailsApplication.config.feature.v61}">
	                                     			<br/>New Generated Host Platform URL: ${t.getComputedTemplateURL()}
	                                   		</g:if>
	                                   	</td>
	                 				</tr>
	               				</g:each>
	             			</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>