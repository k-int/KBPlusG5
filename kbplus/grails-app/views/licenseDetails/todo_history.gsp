<div class="container" data-theme="licences">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">${license.licensee?.name} ${license.type?.value} Licence : ${license.reference}</h1>
			<p class="form-caption flow-text text-grey">Licence Pending Changes History</p>
			<div class="row">
				<div class="col s12">
					<div class="tab-table z-depth-1  table-responsive-scroll">
						<table class="highlight bordered">
							<tr>
								<th>Pending Change Description</th>
								<th>Outcome</th>
								<th>Date</th>
							</tr>
					        <g:if test="${todoHistoryLines}">
						    	<g:each in="${todoHistoryLines}" var="hl">
					            	<tr>
					              		<td>${raw(hl.desc)}</td>
										<td class="w200">${hl.status?.value?:'Pending'}
											<g:if test="${((hl.status?.value=='Accepted')||(hl.status?.value=='Rejected'))}">
												By ${hl.user?.display?:hl.user?.username} on <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${hl.actionDate}"/>
											</g:if>
										</td>
										<td class="w150"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${hl.ts}"/></td>
					            	</tr>
					          	</g:each>
					        </g:if>
						</table>
					</div>
				</div>
			</div>
			
    		<div class="pagination" id="todoHistoryPaginate">
				<g:paginate action="todo_history" controller="licenseDetails" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${todoHistoryLinesTotal}" />
			</div>
		</div>
	</div>
</div>

<!-- probably need some javascript here with an intercepting paginate click -->
<script type="text/javascript">
	$('div[id=todoHistoryPaginate]').on('click', function(event) {
		var clicked = $(event.target).closest('#todoHistoryPaginate a');
		if (clicked.length > 0) {
			event.preventDefault();
			var loc = clicked.attr('href');

			$.ajax({
				type: "GET",
				url: loc,
				error: function(jqXHR, textStatus, errorThrown) {
					console.log('error making ajax call');
					console.log(textStatus);
					console.log(errorThrown);
				}
			}).done(function(data) {
				console.log(data);
				$('.modal-content').html(data);
			});
		}
	});
	
	$(document).ready(function(){
		var next_pag_obj = $('div[id=todoHistoryPaginate] a[class=nextLink]');
		var prev_pag_obj = $('div[id=todoHistoryPaginate] a[class=prevLink]');
		
		if ((next_pag_obj.html() != null) && (next_pag_obj.html() == 'chevron_right')) {
			next_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_right</i>");
		}
		
		if ((prev_pag_obj.html() != null) && (prev_pag_obj.html() == 'chevron_left')) {
			prev_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_left</i>");
		}
	});
</script>
