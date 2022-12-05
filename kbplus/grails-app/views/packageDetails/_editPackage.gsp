<%@ page import="java.text.SimpleDateFormat"%>
<%
	def dateFormatter = new SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
%>

<div class="container" data-theme="packages">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">${packageInstance?.name}</h1>
			<p class="form-caption flow-text grey-text">Edit package details</p>
			<!--form-->
			<div class="row">
				<g:form name="editPackageForm" controller="packageDetails" action="processEditPackage" id="${params.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="col s12">

					<div class="row">
						<div class="input-field col s12">
							<input type="text" name="packageName" id="package_name" value="${packageInstance?.name}" required/>
							<label class="active">Package Name</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12 m6 l6">
							<g:kbplusDatePicker inputid="start_date" name="startDate" value="${packageInstance.startDate ? dateFormatter.format(packageInstance.startDate) : null}"/>
							<label class="active">Start Date</label>
						</div>
						<div class="input-field col s12 m6 l6">
							<g:kbplusDatePicker inputid="end_date" name="endDate" value="${packageInstance.endDate ? dateFormatter.format(packageInstance.endDate) : null}"/>
							<label class="active">End Date</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12 m6">
							<g:select name="public"
									  id="public"
                      			  	  from="${publicPackage}"
                      			  	  optionKey="id"
                      			  	  optionValue="value"
                      			  	  value="${packageInstance?.isPublic?.id}"
                      			  	  noSelection="['':'']"
                      			  	  />
							<label>Public?</label>
						</div>
						<div class="input-field col s12 m6">
							<input type="text" name="vendorURL" value="${packageInstance.vendorURL}">
							<label class="active">Vendor URL</label>
						</div>
					</div>
					
					<!--<div class="row">
						<div class="input-field col s12">
							<g:select name="licence"
									  id="licence"
                      			  	  from="${licenses}"
                      			  	  optionKey="id"
                      			  	  optionValue="value"
                      			  	  value="${packageInstance?.license?.id}"
                      			  	  noSelection="['':'']"
                      			  	  />
							<label>Licence</label>
						</div>
					</div>-->


					
					<div class="row">
						<div class="input-field col s12 m6">
							<g:select name="packageListStatus"
									  id="packageListStatus"
                      			  	  from="${packageListStatus}"
                      			  	  optionKey="id"
                      			  	  optionValue="value"
                      			  	  value="${packageInstance?.packageListStatus?.id}"
                      			  	  noSelection="['':'']"
                      			  	  />
							<label>Package List Status</label>
						</div>
						<div class="input-field col s12 m6">
							<g:select name="breakable"
									  id="breakable"
                      			  	  from="${breakable}"
                      			  	  optionKey="id"
                      			  	  optionValue="value"
                      			  	  value="${packageInstance?.breakable?.id}"
                      			  	  noSelection="['':'']"
                      			  	  />
							<label>Breakable</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12 m6">
							<g:select name="consistent"
									  id="consistent"
                      			  	  from="${consistent}"
                      			  	  optionKey="id"
                      			  	  optionValue="value"
                      			  	  value="${packageInstance?.consistent?.id}"
                      			  	  noSelection="['':'']"
                      			  	  />
							<label>Consistent</label>
						</div>

						<div class="input-field col s12 m6">
							<g:select name="fixed"
									  id="fixed"
                      			  	  from="${fixed}"
                      			  	  optionKey="id"
                      			  	  optionValue="value"
                      			  	  value="${packageInstance?.fixed?.id}"
                      			  	  noSelection="['':'']"
                      			  	  />
							<label>Fixed</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12 m6">
							<g:select name="licence"
									  id="licence"
                      			  	  from="${licences}"
                      			  	  optionKey="id"
                      			  	  optionValue="reference"
                      			  	  value="${packageInstance?.license?.id}"
                      			  	  noSelection="['':'None']"
                      			  	  />
							<label>Associated Licence</label>
						</div>
						<div class="input-field col s12 m6"> 
							<g:select name="packageScope"
									  id="packageScope"
                      			  	  from="${packageScope}"
                      			  	  optionKey="id"
                      			  	  optionValue="value"
                      			  	  value="${packageInstance?.packageScope?.id}"
                      			  	  noSelection="['':'']"
                      			  	  />
							<label>Package Scope</label>
						</div>
					</div>

					<div class="row">
						<div class="input-field col s12">
							<input type="submit" value="Save Changes" class="waves-effect waves-light btn">
						</div>
					</div>

				</g:form>
			</div>
				
			<div class="row">
				<div class="col s12">
					<div class="tab-table z-depth-1  table-responsive-scroll">
						<h3 class="form-title flow-text navy-text">Package Identifiers:</h3><br><br>
						<table class="highlight bordered">
							<thead>
								<tr>
									<th>Authority</th>
									<th>Identifier</th>
									<th>Actions</th>
								</tr>
							</thead>
							<tbody>
								<g:each in="${packageInstance.ids}" var="io">
									<tr>
										<td>${io.identifier.ns.ns}</td>
										<td>${io.identifier.value}</td>
										<td><a id="deletePkgIdentifier" href="#!" ctxOid="${packageInstance.class.name}:${packageInstance.id}" ctxProp="ids" targetOid="${io.class.name}:${io.id}">Delete Identifier</a></td>
									</tr>
								</g:each>
							</tbody>
						</table>
					</div>
				</div>
			</div>
					
			<div class="row">
				<form class="col s12" name="add_ident_submit">
					Select an existing identifier using the typedown, or create a new one by entering namespace:value (EG JC:66454) then clicking that value in the dropdown to confirm.<br/>
					<input type="hidden" name="__context" value="${packageInstance.class.name}:${packageInstance.id}"/>
					<input type="hidden" name="__newObjectClass" value="com.k_int.kbplus.IdentifierOccurrence"/>
					<input type="hidden" name="__recip" value="pkg"/>
					
					<div class="row">
						<div class="input-field col s12">
							<input type="hidden" name="identifier" id="addIdentifierSelect"/>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12">
							<button class="btn btn-primary btn-small" type="submit" id="addIdentBtn" >Add Identifier <i class="material-icons">add_circle_outline</i></button>
						</div>
					</div>
				</form>
			</div>
		</div>
		<!--form end-->
	</div>
</div>

<script type="text/javascript">
  	$('form[name=editPackageForm]').submit(function() {
		var submitForm = true;
		var start = $('input[name=startDate]').val();
		var end = $('input[name=endDate]').val();
		
		if ((start == null) || (start.length == 0)) {
			submitForm = false;
			alert("Please select a date for Start Date");
		}
		
		if ((end == null) || (end.length == 0)) {
			submitForm = false;
			alert("Please select a date for End Date");
		}
		
		return submitForm;
	});

  $("[name='add_ident_submit']").submit(function() {
    $.ajax({
      url: "<g:createLink controller='ajax' action='validateIdentifierUniqueness'/>?identifier="+$("input[name='identifier']").val()+"&owner="+"${packageInstance.class.name}:${packageInstance.id}",
      success: function(data) {
        var proceed = false;
        if(data.unique){
          console.log('data unique');
          proceed = true;
        }else if(data.duplicates){
          console.log('data duplicates');
          var warning = "The following Packages are also associated with this identifier:\n";
          for(var ti of data.duplicates){
              warning+= ti.id +":"+ ti.title+"\n";
          }
          var accept = confirm(warning);
          if(accept){
            proceed = true;
          }
        }

        if (proceed) {
            console.log('we are proceeding...');
            $.ajax({
                url: "<g:createLink controller='ajax' action='addToCollection'/>?__context="+$("input[name='__context']").val()+"&__newObjectClass="+$("input[name='__newObjectClass']").val()+"&__recip="+$("input[name='__recip']").val()+"&identifier="+$("input[name='identifier']").val()+"&jsonreturn=true",
                success: function(data) {
                    if (data.confirm) {
                        console.log('confirmed from addToCollection, proceeding to reload modal');
                    	$.ajax({
                        	type: "GET",
                        	url: "<g:createLink controller='packageDetails' action='editPackage' id='${params.id}' params='${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}'/>"
                  	  	}).done(function(data) {
							console.log(data);
                  		  	$('.modal-content').html(data);
                  	  	});
                    }
                }    
        	});
      	}
      }
    });

    //if so we do another ajax call here to addToCollection, and on done reload the modal page for editPackage method

    return false;
  });

  $('a[id=deletePkgIdentifier]').click(function() {
	var ctxOid = $(this).attr('ctxOid');
	var ctxProp = $(this).attr('ctxProp');
	var targetOid = $(this).attr('targetOid');
	console.log('delete through for pkg ids clicked');
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
            	url: "<g:createLink controller='packageDetails' action='editPackage' id='${params.id}' params='${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}'/>"
      	  	}).done(function(data) {
				console.log(data);
      		  	$('.modal-content').html(data);
      	  	});
        }
	});
  });
  
  $("#addIdentifierSelect").select2({
    placeholder: "Search for an identifier...",
    minimumInputLength: 1,
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
      url: "<g:createLink controller='ajax' action='lookup'/>",
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
      return {id:'com.k_int.kbplus.Identifier:__new__:'+term,text:"New - "+term};
    }
  });
</script>
