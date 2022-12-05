<div class="container" data-theme="${params.theme}">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">${institution.name} Pending Changes</h1>
			<p class="form-caption flow-text text-grey">
				<g:if test="${params.int('offset')}">
                 	Showing results: <span>${params.int('offset') + 1}</span> to <span>${num_todos < (params.int('max') + params.int('offset')) ? num_todos : (params.int('max') + params.int('offset'))}</span> of <span>${num_todos}</span>
                </g:if>
				<g:elseif test="${resultsTotal && resultsTotal > 0}">
                  	Showing results: <span>1</span> to <span>${num_todos < params.int('max') ? num_todos : params.int('max')}</span> of <span>${num_todos}</span>
                </g:elseif>
                <g:else>
                  	Showing results: <span>${num_todos}</span>
                </g:else>
			</p>
			<div class="row">
				<div class="col s12">
					<div class="tab-table z-depth-1  table-responsive-scroll">
						<table class="highlight bordered">
							<tr>
								<th>Content</th>
	          					<th>Number of Changes</th>
	          					<th>Earliest</th>
	          					<th>Latest</th>
							</tr>
					        <g:each in="${todos}" var="todo">
				            	<tr>
				              		<td>
				              			<g:if test="${todo.item_with_changes instanceof com.k_int.kbplus.Subscription}">
	                        				<a href="${createLink(controller:'subscriptionDetails', action:'index', params:[defaultInstShortcode:institution.shortcode], id:todo.item_with_changes.id)}?#pendingchanges">${message(code:'subscription')}: ${todo.item_with_changes.toString()}</a>
	                      				</g:if>
	                      				<g:elseif test="${todo.item_with_changes instanceof com.k_int.kbplus.License}">
	                        				<a href="${createLink(controller:'licenseDetails', action:'index', params:[defaultInstShortcode:institution.shortcode], id:todo.item_with_changes.id)}?#pendingchanges">${message(code:'licence')}: ${todo.item_with_changes.toString()}</a>
	                      				</g:elseif>
	                      				<g:else>
	                      					${todo.item_with_changes.toString()}
	                      				</g:else>
				              		</td>
				              		<td>${todo.num_changes}</td>
				              		<td><g:formatDate date="${todo.earliest}" format="yyyy-MM-dd hh:mm a"/></td>
				              		<td><g:formatDate date="${todo.latest}" format="yyyy-MM-dd hh:mm a"/></td>
				            	</tr>
							</g:each>
						</table>
					</div>
				</div>
			</div>
    		<div class="pagination" id="todoPaginate">
				<g:paginate action="todoModal" controller="myInstitutions" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${num_todos}" />
			</div>
		</div>
	</div>
</div>

<!-- probably need some javascript here with an intercepting paginate click -->
<script type="text/javascript">
	$('div[id=todoPaginate]').on('click', function(event) {
		var clicked = $(event.target).closest('#todoPaginate a');
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
		var next_pag_obj = $('div[id=todoPaginate] a[class=nextLink]');
		var prev_pag_obj = $('div[id=todoPaginate] a[class=prevLink]');
		
		if ((next_pag_obj.html() != null) && (next_pag_obj.html() == 'chevron_right')) {
			next_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_right</i>");
		}
		
		if ((prev_pag_obj.html() != null) && (prev_pag_obj.html() == 'chevron_left')) {
			prev_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_left</i>");
		}
	});
</script>