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
					<g:if test="${obj.startDate != null}">
			  			<g:formatDate format="yyyy-MM-dd" date="${obj.startDate}"/>
			  		</g:if>
			  		<g:else>
			  			<g:formatDate format="yyyy-MM-dd" date="${obj.tipp.startDate}"/>
			  		</g:else>
			  	</span>
			</td>
			<td>
				Date: 
				<span>
					<g:if test="${obj.endDate != null}">
			  			<g:formatDate format="yyyy-MM-dd" date="${obj.endDate}"/>
			  		</g:if>
			  		<g:else>
			  			<g:formatDate format="yyyy-MM-dd" date="${obj.tipp.endDate}"/>
			  		</g:else>
				</span>
			</td>
		</tr>
		<tr>
			<td>
				Volume: 
				<span>
					<g:if test="${obj.startVolume != null}">
  			  	 		${obj.startVolume}
  			  		</g:if>
  			  		<g:else>
  			  	 		${obj.tipp.startVolume}
  			  		</g:else>
				</span>
			</td>
			<td>
				Volume: 
				<span>
					<g:if test="${obj.endVolume != null}">
  			  			${obj.endVolume}
  			  		</g:if>
  			  		<g:else>
  			  			${obj.tipp.endVolume}
  			  		</g:else>
				</span>
			</td>
		</tr>
		<tr>
			<td>
				Issue: 
				<span>
					<g:if test="${obj.startIssue != null}">
			  			${obj.startIssue}
			  		</g:if>
			  		<g:else>
			  			${obj.tipp.startIssue}
			  		</g:else>
				</span>
			</td>
			<td>
				Issue: 
				<span>
					<g:if test="${obj.endIssue != null}">
			  			${obj.endIssue} 
			  		</g:if>
			  		<g:else>
			  			${obj.tipp.endIssue} 
			  		</g:else>
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
			<td>Coverage Depth: <span>${obj?.coverageDepth}</span></td>
			<td>Embargo: <span>${obj?.embargo}</span></td>
		</tr>
		<tr>
			<td colspan="2">
				Coverage Note: 
				<g:if test="${((obj?.endIssue != null) && (obj?.coverageNote)) || (obj?.tipp?.coverageNote)}">
					<span class="inline-badge tooltipped card-tooltip" data-position="right" data-src="${subCol}-ie${obj.id}-cn"><i class="material-icons">info_outline</i></span></span>
					<script type="text/html" id="${subCol}-ie${obj.id}-cn">
						<div class="kb-tooltip">
							<div class="tooltip-title">Note</div>
							<ul class="tooltip-list">
								<li>
									<g:if test="${obj.endIssue != null}">
				  						${obj.coverageNote}
				  					</g:if>
									<g:else>
				  						${obj.tipp.coverageNote}
				  					</g:else>
								</li>
							</ul>
						</div>
					</script>
				</g:if>
			</td>
		</tr>
	</tbody>
</table>
