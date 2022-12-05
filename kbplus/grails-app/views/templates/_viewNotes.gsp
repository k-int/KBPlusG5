<div class="container" data-theme="${theme}">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Notes</h1>
			<!--form-->
			<div class="row">
				<div class="col s12">
					<div class="tab-table z-depth-1  table-responsive-scroll">
						<table class="highlight bordered">
							<thead>
								<tr>
									<th>Title</th>
									<th>Detail</th>
									<th>Creator</th>
								</tr>
							</thead>
							<tbody>
								<g:each in="${ownerobj.documents}" var="docctx">
            						<g:if test="${docctx.owner.contentType == 0 && (docctx.status == null || docctx.status?.value != 'Deleted')}">
										<tr>
											<td class="w150">${docctx.owner.title}</td>
											<td>${docctx.owner.content}</td>
											<td class="w150">${docctx.owner.creator}</td>
										</tr>
									</g:if>
								</g:each>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
