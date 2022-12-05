<div class="container" data-theme="${theme}">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Pending Changes for ${modelType}: ${name}</h1>
			
			<div class="row">
				<div class="col s3 offset-s9 m3 offset-m9 l2 offset-l10">
					<g:if test="${editable && !processingpc && pendingChanges}">
						<div class="actiongroupright">
		      				<g:link controller="pendingChange" action="acceptAll" id="${model.class.name}:${model.id}" class="btn-floating transparent table-action inline"><i class="material-icons tooltipped-modal" data-position="right" data-delay="50" data-tooltip="Approve All">done_all</i></g:link>
		      				<g:link controller="pendingChange" action="rejectAll" id="${model.class.name}:${model.id}" class="btn-floating transparent table-action inline"><i class="material-icons tooltipped-modal" data-position="right" data-delay="50" data-tooltip="Reject All">delete_forever</i></g:link>
						</div>
					</g:if>
		    	</div>
		    </div>
		    
			<div class="row">
				<div class="col s12">
					<div class="tab-table z-depth-1  table-responsive-scroll">
						<table class="highlight bordered">
							<tr>
								<th>Info</th>
	          					<th>Action</th>
							</tr>
							<g:if test="${pendingChanges}">
								<g:each in="${pendingChanges}" var="pc">
									<tr>
										<td>${raw(pc.desc)}</td>
										<td class="w100">
											<g:if test="${editable && !processingpc}">
												<a class="btn-floating transparent table-action ajaxCall" ajax-url="${createLink(controller:'pendingChange', action:'accept', params:[id:pc.id, referer:'no'])}"><i class="material-icons tooltipped-modal" data-position="right" data-delay="50" data-tooltip="Approve">done</i></a>
												<a class="btn-floating transparent table-action ajaxCall" ajax-url="${createLink(controller:'pendingChange', action:'reject', params:[id:pc.id, referer:'no'])}"><i class="material-icons tooltipped-modal" data-position="right" data-delay="50" data-tooltip="Reject">close</i></a>
											</g:if>
										</td>
									</tr>
								</g:each>
							</g:if>
						</table>
					</div>
				</div>
			</div>
    		<div class="pagination" id="pcPaginate">
				<g:paginate action="pendingChanges" controller="${params.controller}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode, id:params.id]:[id:params.id]}" next="chevron_right" prev="chevron_left" offset="${offset ?: 0}" max="${max}" total="${pendingChangesTotal}" />
			</div>
		</div>
	</div>
</div>

<!-- probably need some javascript here with an intercepting paginate click -->
<script type="text/javascript">
	//TODO: ajax call for class ajaxCall!
	$('.ajaxCall').on('click', function(event) {
		var ajax_url = $(this).attr("ajax-url");
		$.ajax({
			type: "GET",
			url: ajax_url,
			error: function(jqXHR, textStatus, errorThrown) {
				console.log('error making ajax call');
				console.log(textStatus);
				console.log(errorThrown);
			}
		}).done(function(data) {
			alert(data);
			var reload_modal_url = "${createLink(controller:params.controller, action:'pendingChanges', params:params)}";
			$.ajax({
				type: "GET",
				url: reload_modal_url,
				error: function(jqXHR, textStatus, errorThrown) {
					console.log('error making ajax call');
					console.log(textStatus);
					console.log(errorThrown);
				}
			}).done(function(data) {
				console.log(data);
				$('.modal-content').html(data);
			});
		});
	});
	
	$('div[id=pcPaginate]').on('click', function(event) {
		var clicked = $(event.target).closest('#pcPaginate a');
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
		var next_pag_obj = $('div[id=pcPaginate] a[class=nextLink]');
		var prev_pag_obj = $('div[id=pcPaginate] a[class=prevLink]');
		
		if ((next_pag_obj.html() != null) && (next_pag_obj.html() == 'chevron_right')) {
			next_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_right</i>");
		}
		
		if ((prev_pag_obj.html() != null) && (prev_pag_obj.html() == 'chevron_left')) {
			prev_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_left</i>");
		}
		
		$('.tooltipped-modal').tooltip();
	});
</script>
