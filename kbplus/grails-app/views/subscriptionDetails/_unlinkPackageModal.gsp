<div class="container" data-theme="subscriptions">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Unlink: ${pkg}</h1>
			<p class="form-caption flow-text grey-text">No user actions required for this process.</p>
			<div class="row">
				<div class="col s12">
					<div class="tab-table z-depth-1  table-responsive-scroll">
						<table class="highlight bordered">
							<thead>
							<th>Item</th>
							<th>Details</th>
							<th>Action</th>
							</thead>
							<tbody>
							<g:set var="actions_needed" value="false"/>
							<g:each in="${conflicts_list}" var="conflict_item">
								<tr>
									<td>
										${conflict_item.name}
									</td>
									<td>
										<ul>
											<g:each in="${conflict_item.details}" var="detail_item">
												<li>
													<g:if test="${detail_item.link}">
														<a href="${detail_item.link}">${detail_item.text}</a>
													</g:if>
													<g:else>
														${detail_item.text}
													</g:else>
												</li>
											</g:each>
										</ul>
									</td>
									<td>
									%{-- Add some CSS based on actionRequired to show green/red status --}%
										<g:if test="${conflict_item.action.actionRequired}">
											<i style="color:red" class="fa fa-times-circle"></i>
											<g:set var="actions_needed" value="true"/>
										</g:if>
										<g:else>
											<i style="color:green" class="fa fa-check-circle"></i>
										</g:else>
										${conflict_item.action.text}
									</td>
								</tr>
							</g:each>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col s12">
					<g:form action="unlinkPackage" onsubmit="return confirm('Deletion of IEs and PendingChanges is NOT reversable. Continue?')" method="POST">
						<input type="hidden" name="package" value="${pkg.id}"/>
						<input type="hidden" name="subscription" value="${subscription.id}"/>
						<g:if test="${defaultInstShortcode}">
							<input type="hidden" name="defaultInstShortcode" value="${defaultInstShortcode}"/>
						</g:if>
						<input type="hidden" name="confirmed" value="Y"/>
						<button type="submit"class="btn btn-danger btn-small">Confirm Delete</button>
					</g:form>
				</div>
			</div>
		</div>
	</div>
</div>
