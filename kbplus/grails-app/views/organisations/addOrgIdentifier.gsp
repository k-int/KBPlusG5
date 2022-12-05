<div class="container" data-theme="organisations">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">${orgInstance.name}</h1>
			<p class="form-caption flow-text grey-text">Edit organisation identifiers</p>
			<div class="tab-table z-depth-1  table-responsive-scroll">
				<table class="highlight bordered">
					<thead>
						<tr>
							<th>Authority</th>
							<th>Identifier</th>
							<th>Actions</th>
						</tr>
					</thead>
					<tbody>
						<g:each in="${orgInstance.ids}" var="io">
							<tr>
								<td>${io.identifier.ns.ns}</td>
								<td>${io.identifier.value}</td>
								<td><a id="deleteOrgIdentifier" href="#!" ctxOid="${orgInstance.class.name}:${orgInstance.id}" ctxProp="ids" targetOid="${io.class.name}:${io.id}">Delete Identifier</a></td>
							</tr>
						</g:each>
					</tbody>
				</table>
			</div>
		</div>
	</div>
			
	<div class="row">
		<div class="col s12">
			<p class="form-caption flow-text text-grey">Select an existing identifier using the typedown, or create a new one by entering namespace:value (EG eISSN:2190-9180) then clicking that value in the dropdown to confirm.</p>
			<!--form-->
			<div class="row">
				<g:form controller="ajax" action="addToCollection" name="add_org_identifier" class="col s12">
    				<input type="hidden" name="__context" value="${orgInstance.class.name}:${orgInstance.id}"/>
					<input type="hidden" name="__newObjectClass" value="com.k_int.kbplus.IdentifierOccurrence"/>
					<input type="hidden" name="__recip" value="org"/>
					<input type="hidden" name="orgIdAjaxLookupURL" value="${createLink(controller:'ajax', action:'lookup')}"/>
    				<g:if test="${anchor}">
    					<input type="hidden" name="anchor" value="${anchor}"/>
    				</g:if>
    				<div class="row">
						<div class="input-field col s12">
							<input type="hidden" name="identifier" id="addOrgIdentifierSelect"/>
						</div>
					</div>
					<div class="row">
    					<div class="input-field col s12">
							<button class="btn btn-primary" type="submit">Add Identifier <i class="material-icons">add_circle_outline</i></button>
    					</div>
    				</div>
				</g:form>
			</div>
			<!--form end-->
		</div>
	</div>
</div>

<script type="text/javascript">
  	$('a[id=deleteOrgIdentifier]').click(function() {
		var ctxOid = $(this).attr('ctxOid');
		var ctxProp = $(this).attr('ctxProp');
		var targetOid = $(this).attr('targetOid');
		console.log('delete through for org ids clicked');
		console.log(ctxOid);
		console.log(ctxProp);
		console.log(targetOid);
	
		$.ajax({
	  		type: "GET",
	  		url: "<g:createLink controller='ajax' action='deleteThrough'/>?contextOid="+ctxOid+"&contextProperty="+ctxProp+"&targetOid="+targetOid+"&jsonreturn=true"
		}).done(function(data) {
			if (data.confirm) {
            	console.log('confirmed from deleteThrough, proceeding to reload modal');
        		$.ajax({
            		type: "GET",
            		url: "<g:createLink controller='organisations' action='addOrgIdentifier' id='${params.id}' params='${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}'/>"
      	  		}).done(function(data) {
					console.log(data);
      		  		$('.modal-content').html(data);
      	  		});
        	}
		});
  	});
  
    $("#addOrgIdentifierSelect").select2({
		width: '100%',
		minimumInputLength: 1,
		ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
			url: $('input[name=orgIdAjaxLookupURL]').val(),
			dataType: 'json',
			data: function (term, page) {
				return {
					q: term, // search term
					page_limit: 10,
					baseClass:'com.k_int.kbplus.Identifier'
				};
			},
			results: function (data, page) {
				return {results: data.values};
			}
    	},
		createSearchChoice:function(term, data) {
			return {id:'com.k_int.kbplus.Identifier:__new__:'+term,text:term};
		}
	});
</script>
