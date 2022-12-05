<div class="container" data-theme="licences">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">${license.reference}</h1>
			<p class="form-caption flow-text text-grey">Licence Edit History</p>
			<div class="row">
				<div class="col s12">
					<div class="tab-table z-depth-1  table-responsive-scroll">
						<table class="highlight bordered">
							<tr>
								<th>Event ID</th>
	          					<th>Person</th>
	          					<th>Date</th>
	          					<th>Event</th>
	          					<th>Field</th>
	          					<th>Old Value</th>
	          					<th>New Value</th>
							</tr>
					        <g:if test="${historyLines}">
						    	<g:each in="${historyLines}" var="hl">
					            	<tr>
					              		<td class="w100">${hl.id}</td>
					              		<td class="w150" style="white-space:wrap; word-wrap: break-word;">${hl.actor}</td>
					              		<td class="w100" >${hl.dateCreated}</td>
					              		<td class="w100" >${hl.eventName}</td>
					              		<td class="w150" >${hl.propertyName}</td>
					              		<td>${hl.oldValue}</td>
					              		<td>${hl.newValue}</td>
					            	</tr>
					          	</g:each>
					        </g:if>
						</table>
					</div>
				</div>
			</div>
			
    		<div class="pagination" id="editHistoryPaginate">
				<g:paginate action="edit_history" controller="licenseDetails" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${historyLinesTotal}" />
			</div>
		</div>
	</div>
</div>

<!-- probably need some javascript here with an intercepting paginate click -->
<script type="text/javascript">
	$('div[id=editHistoryPaginate]').on('click', function(event) {
		var clicked = $(event.target).closest('#editHistoryPaginate a');
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
		var next_pag_obj = $('div[id=editHistoryPaginate] a[class=nextLink]');
		var prev_pag_obj = $('div[id=editHistoryPaginate] a[class=prevLink]');
		
		if ((next_pag_obj.html() != null) && (next_pag_obj.html() == 'chevron_right')) {
			next_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_right</i>");
		}
		
		if ((prev_pag_obj.html() != null) && (prev_pag_obj.html() == 'chevron_left')) {
			prev_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_left</i>");
		}
	});
</script>
