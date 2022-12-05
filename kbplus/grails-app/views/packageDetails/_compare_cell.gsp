<table class="highlight">
	<thead>
		<tr>
			<th>Coverage Start:</th>
			<th>Coverage End:</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				Date: 
				<span>
			  		<g:formatDate format="yyyy-MM-dd" date="${obj.startDate}"/>
			  	</span>
			</td>
			<td>
				Date: 
				<span>
					<g:formatDate format="yyyy-MM-dd" date="${obj.endDate}"/>
				</span>
			</td>
		</tr>
		<tr>
			<td>
				Volume: 
				<span>
					${obj.startVolume ?: 'N/A'}
				</span>
			</td>
			<td>
				Volume: 
				<span>
					${obj.endVolume ?: 'N/A'}
				</span>
			</td>
		</tr>
		<tr>
			<td>
				Issue: 
				<span>
					${obj.startIssue ?: 'N/A'}
				</span>
			</td>
			<td>
				Issue: 
				<span>
					${obj.endIssue ?: 'N/A'}
				</span>
			</td>
		</tr>
	</tbody>
</table>

  			  
<table class="highlight">
	<thead>
		<tr>
			<th>Ancillary:</th>
			<th></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Coverage Depth: <span>${obj?.coverageDepth  ?: 'N/A'}</span></td>
			<td>Embargo: <span>${obj?.embargo  ?: 'N/A'}</span></td>
		</tr>
		<tr>
			<td>Platform Host:
				<span> 
					<g:if test="${obj?.hostPlatformURL}">
						<a href="${obj.hostPlatformURL}" target="_blank">Link</a></span>
					</g:if>
					<g:else>
						N/A
					</g:else>
				</span>
			</td>
			<td>Hybrid OA: <span>${obj?.hybridOA  ?: 'N/A'}</span></td>
		</tr>
	</tbody>
</table>
