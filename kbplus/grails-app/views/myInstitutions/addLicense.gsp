<div class="container" data-theme="licences">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Copy from Template</h1>
			<p class="form-caption flow-text grey-text">
				Choose which licence you’d like to copy from the list below.<br>
				Licence total <span><g:if test="${numLicenses}">${numLicenses}</g:if><g:else>0</g:else></span>
			</p>
			<!--form-->
			<div class="row">
				<form name="searchLicencesCopyTemplate" class="col s12">
					<div class="row modal-search-container z-depth-1">
						<div class="input-field search-main col s10">
							<input type="hidden" name="sort" value="${params.sort}">
							<input type="hidden" name="order" value="${params.order}">
							<input name="filter_liccopytemp" id="searchLicCopyTemp" value="${params.filter}" placeholder="Search Licences" type="search"/>
							<label class="label-icon active" for="searchLicCopyTemp"><i class="material-icons">search</i></label>
							<i class="material-icons input-close-icon close" id="clearLicenceCopyTemplateSearch" search-id="searchLicCopyTemp">close</i>
						</div>
						<div class="input-field col s2">
							<input type="submit" class="waves-effect btn" value="Search">
						</div>
					</div>
				
					<div class="search-results row">
						<g:if test="${licenses?.size() > 0}">
							<g:each in="${licenses}" var="l">
								<div class="row">
									<div class="col s10">
										<h2><g:link action="index" controller="licenseDetails" id="${l.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${l.reference?:"License ${l.id} - No Reference Set"}</g:link></h2>
										<div class="date">
											<div>
												Start date: <span><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${l.startDate}"/></span>
											</div>
											<div>
												End date: <span><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${l.endDate}"/></span>
											</div>
										</div>
										<p>
											<g:if test="${l.pkgs && ( l.pkgs.size() > 0 )}">
	                        					<g:each in="${l.pkgs}" var="pkg">
	                          						<g:link controller="packageDetails" action="show" id="${pkg.id}">${pkg.id} (${pkg.name})</g:link><br/>
												</g:each>
											</g:if>
											<g:else>
												No linked packages.
											</g:else>
										</p>
										<p>${l.licensor?.name ?: 'No Licensor'}</p>
									</div>
									<div class="col s2">
										<g:link controller="myInstitutions" action="actionLicenses" params="${[defaultInstShortcode:params.defaultInstShortcode,baselicense:l.id,'cpy-licence':'Y']}" class="btn-floating btn-flat waves-effect waves-light"><i class="material-icons">content_copy</i></g:link>
									</div>
								</div>
							</g:each>
						</g:if>
					</div>
					
					<div class="pagination" id="copyLicenceTemplatePaginate">
						<g:if test="${licenses}" >
							<g:paginate action="addLicense" controller="myInstitutions" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${numLicenses}" />
						</g:if>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$('form[name=searchLicencesCopyTemplate]').submit(function() {
		var filter = $('input[name=filter_liccopytemp]').val();
		console.log(filter);

		$.ajax({
			type: "GET",
			url: "${createLink(controller:'myInstitutions', action:'addLicense', params:[defaultInstShortcode:params.defaultInstShortcode])}?filter="+ filter,
			error: function(jqXHR, textStatus, errorThrown) {
    		  console.log('error getting search add entitlements');
    		  console.log(textStatus);
    		  console.log(errorThrown);
    		}
		}).done(function(data) {
			console.log(data);
			$('.modal-content').html(data);
		});
		
		return false;
	});

	$('#clearLicenceCopyTemplateSearch').click(function(){
		console.log('clear search clicked');
		var searchid = $(this).attr('search-id');
		console.log(searchid);
		$('input[id='+searchid+']').val('');
	});

	$('div[id=copyLicenceTemplatePaginate]').on('click', function(event) {
		var clicked = $(event.target).closest('#copyLicenceTemplatePaginate a');
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
  		var next_pag_obj = $('div[id=copyLicenceTemplatePaginate] a[class=nextLink]');
   		var prev_pag_obj = $('div[id=copyLicenceTemplatePaginate] a[class=prevLink]');
   		
    	if ((next_pag_obj.html() != null) && (next_pag_obj.html() == 'chevron_right')) {
    	 	next_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_right</i>");
      	}
      	
		if ((prev_pag_obj.html() != null) && (prev_pag_obj.html() == 'chevron_left')) {
			prev_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_left</i>");
		}
	});
</script>
