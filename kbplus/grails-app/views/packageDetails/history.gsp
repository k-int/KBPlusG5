<div class="container" data-theme="packages">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">${packageInstance.name} - Package history</h1>
			<div class="row">
				<div class="col s12">
					<div class="tab-table z-depth-1  table-responsive-scroll">
						<g:if test="${formattedHistoryLines?.size() > 0}">
	   						<table class="highlight bordered">
	       						<thead>
	       							<tr>
						              	<td>Name</td>
						              	<td class="mw-180">Actor</td>
						           	   	<td class="mw-130">Event name</td>
						          	    <td class="mw-130">Property</td>
						          	    <td class="mw-130">Old</td>
						              	<td>New</td>
						              	<td class"mw-100">Date</td>
	       							</tr>
	       						</thead>
	       						<tbody>
	       							<g:each in="${formattedHistoryLines}" var="hl">
	           							<tr>
	           								<td class="w150"><a href="${hl.link}">${hl.name}</a></td>
							                <td class="w150">
							                  	<g:link controller="userDetails" action="edit" id="${hl.actor?.id}">${hl.actor?.displayName}</g:link>
							                </td>
							                <td class="w150">${hl.eventName}</td>
							                <td class="w150">${hl.propertyName}</td>
							                <td class="w150">${hl.oldValue}</td>
							                <td class="w150">${hl.newValue}</td>
							                <td class="w100"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${hl.lastUpdated}"/></td>
	           							</tr>
	       							</g:each>
	       						</tbody>
	   						</table>
	     				</g:if>
	     			</div>
				</div>
			</div>

    		<div class="pagination" id="historyPaginate">
				<g:paginate action="history" controller="packageDetails" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${historyLinesTotal}" />
			</div>
		</div>
	</div>
</div>

<!-- probably need some javascript here with an intercepting paginate click -->
<script type="text/javascript">
	$('div[id=historyPaginate]').on('click', function(event) {
		var clicked = $(event.target).closest('#historyPaginate a');
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
		var next_pag_obj = $('div[id=historyPaginate] a[class=nextLink]');
		var prev_pag_obj = $('div[id=historyPaginate] a[class=prevLink]');

		if ((next_pag_obj.html() != null) && (next_pag_obj.html() == 'chevron_right')) {
			next_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_right</i>");
		}

		if ((prev_pag_obj.html() != null) && (prev_pag_obj.html() == 'chevron_left')) {
			prev_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_left</i>");
		}
	});
</script>
