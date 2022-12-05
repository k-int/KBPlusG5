<div class="container" data-theme="subscriptions">
	<div class="row">
      	<div class="col s12">
			<h1 class="form-title flow-text text-navy">${subscriptionInstance?.name}</h1>
			<p class="form-caption flow-text text-grey">Search and select the titles you want to add to your subscription.</p>
    		
    		<div class="row">
				<div class="col s12">
					<div class="tab-table z-depth-1  table-responsive-scroll">
	          		<form name="searchEntitlements">
			            <input type="hidden" name="sort" value="${params.sort}">
			            <input type="hidden" name="order" value="${params.order}">
			            <input type="hidden" name="shortcode" value="${params.defaultInstShortcode}">
			            <input type="hidden" name="subid" value="${params.id}">
			            
			            <div class="row">
					        <div class="input-field col s12 search-main">
						        <input id="filter_at" placeholder="Enter your search term..." type="search" name="filter_at" value="${params.filter}">
						        <label class="label-icon" for="search"><i class="material-icons">search</i></label>
						        <i class="material-icons close" id="clearSearchAddTitlesModal" search-id="filter_at">close</i>
					        </div>
						</div>
						
						<div class="row">
							<div class="input-field col s12">
								<select id="pkgfilter_at" name="pkgfilter_at">
			                    	<option value="">All</option>
			                    	<g:each in="${subscriptionInstance.packages}" var="sp">
			                    		<option value="${sp.pkg.id}" ${sp.pkg.id.toString()==params.pkgfilter?'selected=true':''}>${sp.pkg.name}</option>
			                    	</g:each>
			                    </select>
			                    <label>Package</label>
							</div>
						</div>
						
						<div class="row">
							<div class="input-field col s6">
								<g:kbplusDatePicker inputid="startsBefore" name="startsBefore" value="${params.startsBefore}"/>
								<label class="active">Starts Before</label>
							</div>
							<div class="input-field col s6">
								<g:kbplusDatePicker inputid="endsAfter" name="endsAfter" value="${params.endsAfter}"/>
								<label class="active">Ends After</label>
							</div>
						</div>
						
						<div class="row">
							<div class="input-field col s12">
			            		<input type="submit" class="waves-effect waves-light btn">
			            	</div>
			            </div>
	          		</form>
	          		</div>
	          	</div>
       		</div>
       		
       		<div class="row">
				<div class="col s12 page-response">
					<h2 class="list-response text-navy">
					Showing Available Titles: 
					<g:if test="${params.int('offset')}">
						<span>${params.int('offset') + 1}</span> to <span>${num_tipp_rows < (params.int('max') + params.int('offset')) ? num_tipp_rows : (params.int('max') + params.int('offset'))}</span> of <span>${num_tipp_rows}</span>
					</g:if>
					<g:elseif test="${num_tipp_rows && num_tipp_rows > 0}">
						<span>1</span> to <span>${num_tipp_rows < params.int('max') ? num_tipp_rows : tipps?.size()}</span> of <span>${num_tipp_rows}</span>
					</g:elseif>
					<g:elseif test="${!num_tipp_rows}">
						0
					</g:elseif>
					<g:else>
						${num_tipp_rows}
					</g:else>
				</h2>
				</div>
			</div>
       		
	      	<div class="row">
				<div class="col s12">
					<div class="tab-table z-depth-1  table-responsive-scroll">
		        	<g:form action="processAddEntitlements">
		            	<input type="hidden" name="siid" value="${subscriptionInstance.id}"/>
		            	
		            	<div class="row">
							<div class="input-field col s12">
								<button class="waves-effect waves-light btn" type="submit" >Add Selected Entitlements <i class="material-icons">add_circle_outline</i></button>
		            		</div>
		            	</div>
		            	
		            	<div class="row">
			            	<div class="col s12">
				                <g:each in="${tipps}" var="tipp">
				                  	<div class="list-section">
								  		<ul class="collection with-header">
											<li class="collection-header">
									  			<input type="checkbox" name="_bulkflag.${tipp.id}" id="_bulkflag.${tipp.id}" class="bulkcheck"/>
			                  		  			<label for="_bulkflag.${tipp.id}">&nbsp;</label>
									  			<g:link controller="tipp" id="${tipp.id}" action="show" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="list-title">${tipp.title.title}</g:link>
									  			&nbsp; &nbsp;
									  			<g:if test="${grailsApplication.config.feature.v61}">
			                            			<a href="${tipp?.getComputedTemplateURL()}" TITLE="${tipp?.getComputedTemplateURL()} (In new window)" target="_blank" class="list-title">( Host Link )</a>
			                          			</g:if>
			                          			<g:else>
			                            			<a href="${tipp?.hostPlatformURL}" TITLE="${tipp?.hostPlatformURL} (In new window)" target="_blank" class="list-title">( Host Link )</a>
			                          			</g:else>
											</li>
											<li class="collection-item">ISSN: <span>${tipp?.title?.getIdentifierValue('ISSN')}</span> <div class="two-in-a-row">eISSN: <span>${tipp?.title?.getIdentifierValue('eISSN')}</span></div></li>
											<li class="collection-item">Start date: <span><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp.startDate}"/></span> <div class="two-in-a-row">End Date: <span><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp.endDate}"/></span></div></li>
											<li class="collection-item">Notes: <span>${tipp.coverageNote ?: ''}</span></li>
								  		</ul>
								  	</div>
				                </g:each>
				            </div>
			            </div>
			            
			            <div class="row">
							<div class="input-field col s12">
								<button class="waves-effect waves-light btn" type="submit">Add Selected Entitlements <i class="material-icons">add_circle_outline</i></button>
			            	</div>
			            </div>
	          		</g:form>
	          		</div>
	          	</div>
	  		</div>
	  		
	  		<div class="pagination" id="addEntitlementsPaginate">
				<g:if test="${tipps}" >
					<g:paginate controller="subscriptionDetails" 
								action="addEntitlements" 
								params="${params}" 
								max="${max}" 
								total="${num_tipp_rows}"
								next="chevron_right"
								prev="chevron_left" />
				</g:if>
			</div>
		</div>
	</div>
</div>

<g:set var="addtitles_params_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>	
<script type="text/javascript">
	$('form[name=searchEntitlements]').submit(function() {
		var inst_sc = $('input[name=shortcode]').val();
		var subId = $('input[name=subid]').val();
		var filter = $('input[name=filter_at]').val();
		var sb = $('input[name=startsBefore]').val();
		var ea = $('input[name=endsAfter]').val();
		var pkgfilter = $('select[name=pkgfilter_at] option:selected').val();

		console.log(inst_sc);
		console.log(subId);
		console.log(filter);
		console.log(pkgfilter);
		console.log(sb);
		console.log(ea);
		
		$.ajax({
			type: "GET",
			url: "${createLink(controller:'subscriptionDetails', action:'addEntitlements', params:addtitles_params_sc, id:params.id)}?filter="+ filter +"&pkgfilter="+ pkgfilter +"&startsBefore="+ sb +"&endsAfter="+ ea,
			//url: "/myInstitutions/"+inst_sc+"/subscriptionDetails/addEntitlements/"+subId+"?filter="+ filter +"&pkgfilter="+ pkgfilter +"&startsBefore="+ sb +"&endsAfter="+ ea
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

	$('#clearSearchAddTitlesModal').click(function(){
		console.log('clear search clicked');
		var searchid = $(this).attr('search-id');
		console.log(searchid);
		$('input[id='+searchid+']').val('');
	});
	
	//function selectAll() {
	$('input[name=chkall]').click(function() {
		console.log('firing click function');
		var chkall = $('input[name=chkall]').attr('checked');
		if ((chkall != null) && (chkall == 'checked')) {
			console.log('firing uncheck');
			$('input[name=chkall]').attr('checked', false);
			$('.bulkcheck').attr('checked', false);
		}
		else {
			console.log('firing check');
			$('input[name=chkall]').attr('checked', true);
			$('.bulkcheck').attr('checked', true);
			//$('input[id^="_bulkflag."]').attr('checked', true);
		}
	});

	$('div[id=addEntitlementsPaginate]').on('click', function(event) {
		var clicked = $(event.target).closest('#addEntitlementsPaginate a');
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
  		var next_pag_obj = $('div[id=addEntitlementsPaginate] a[class=nextLink]');
  		var prev_pag_obj = $('div[id=addEntitlementsPaginate] a[class=prevLink]');
  
  		if ((next_pag_obj.html() != null) && (next_pag_obj.html() == 'chevron_right')) {
	  		next_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_right</i>");
  		}
		      
      	if ((prev_pag_obj.html() != null) && (prev_pag_obj.html() == 'chevron_left')) {
	  		prev_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_left</i>");
  		}
  	});
</script>