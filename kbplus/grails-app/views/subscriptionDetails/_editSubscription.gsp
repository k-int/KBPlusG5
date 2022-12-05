<%@ page import="java.text.SimpleDateFormat"%>
<%
	def dateFormatter = new SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
%>

<div class="container" data-theme="subscriptions">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">${subscriptionInstance?.name}</h1>
			<p class="form-caption flow-text grey-text">Edit subscription details</p>
			<!--form-->
			<div class="row">
				<g:form name="editSubscriptionForm" controller="subscriptionDetails" action="processEditSubscription" id="${params.id}" params="params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]" class="col s12">
					<div class="row">
						<div class="input-field col s12">
							<input type="text" name="subscriptionName" id="subscription_name" value="${subscriptionInstance?.name}" required/>
							<label class="active">Subscription Name</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12 m6">
							<g:select name="licence"
									  id="licence"
                      			  	  from="${licences}"
                      			  	  optionKey="id"
                      			  	  optionValue="reference"
                      			  	  value="${subscriptionInstance?.owner?.id}"
                      			  	  noSelection="['':'None']"
                      			  	  />
							<label>Associated Licence</label>
						</div>
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="manualRenewalDate" name="manualRenewalDate" value="${subscriptionInstance.manualRenewalDate ? dateFormatter.format(subscriptionInstance.manualRenewalDate) : null}"/>
							<label class="active">Manual Renewal Date</label>
						</div>
					</div>

					<div class="row">
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="start_date" name="startDate" value="${subscriptionInstance.startDate ? dateFormatter.format(subscriptionInstance.startDate) : null}"/>
							<label class="active">Start Date</label>
						</div>
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="end_date" name="endDate" value="${subscriptionInstance.endDate ? dateFormatter.format(subscriptionInstance.endDate) : null}"/>
							<label class="active">End Date</label>
						</div>
					</div>

					
					<div class="row">
						<div class="input-field col s12 m6">
							<input type="text" name="cancellationAllowances" value="${subscriptionInstance.cancellationAllowances}" maxlength="255">
							<label class="active">Cancellation Allowances</label>
						</div>
						<div class="input-field col s12 m6">
							<g:select name="child"
									  id="child"
                      			  	  from="${childs}"
                      			  	  optionKey="id"
                      			  	  optionValue="value"
                      			  	  value="${subscriptionInstance?.isSlaved?.id}"
                      			  	  noSelection="['':'Select one']"
                      			  	  />
							<label>Relationship</label>
						</div>
					</div>

					<div class="row">
						<div class="input-field col s12">
							<input type="text" name="impId" id="impid" value="${subscriptionInstance?.impId}"/>
							<label class="active">Subscription Reference</label>
						</div>
					</div>
					

					<div class="row section">
						<div class="input-field col s12">
							<input type="submit" value="Save" class="waves-effect waves-light btn">
						</div>
					</div>

				</g:form>


					<div class="row">
						<div class="col s12">
							<h3 class="indicator">Subscription Identifiers:</h3>
						</div>
						<div class="col s12 mt-30">
							<div class="tab-table z-depth-1 table-responsive-scroll">
								<table class="bordered highlight responsive-table modal-table fixed-table">
									<thead>
									<tr>
										<th>Authority</th>
										<th>Identifier</th>
										<th>Actions</th>
									</tr>
									</thead>
									<tbody>
									<g:each in="${subscriptionInstance.ids}" var="io">
										<tr>
											<td>${io.identifier.ns.ns}</td>
											<td>${io.identifier.value}</td>
											<td><a id="deleteSubIdentifier" href="#!" ctxOid="${subscriptionInstance.class.name}:${subscriptionInstance.id}" ctxProp="ids" targetOid="${io.class.name}:${io.id}">Delete Identifier</a></td>
										</tr>
									</g:each>
									</tbody>
								</table>
							</div>
						</div>
					</div>

					<div class="row">
						<form class="col s12" name="add_ident_submit">
							<p class="grey-text">Select an existing identifier using the typedown, or create a new one by entering namespace:value (EG JC:66454) then clicking that value in the dropdown to confirm.</p>
							<input type="hidden" name="__context" value="${subscriptionInstance.class.name}:${subscriptionInstance.id}"/>
							<input type="hidden" name="__newObjectClass" value="com.k_int.kbplus.IdentifierOccurrence"/>
							<input type="hidden" name="__recip" value="sub"/>
							<input type="hidden" name="identifier" id="addIdentifierSelect"/><br/><br/>
							<button class="btn btn-primary btn-small" type="submit" id="addIdentBtn" >Add Identifier <i class="material-icons">add_circle_outline</i></button>

						</form>
					</div>



			</div>
		</div>
	</div>
</div>

<g:render template="/templates/anchorJavascript" model="${[formName: 'editSubscriptionForm']}"/>

<script type="text/javascript">
  	$('form[name=editSubscriptionForm]').submit(function() {
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
      url: "<g:createLink controller='ajax' action='validateIdentifierUniqueness'/>?identifier="+$("input[name='identifier']").val()+"&owner="+"${subscriptionInstance.class.name}:${subscriptionInstance.id}",
      success: function(data) {
        var proceed = false;
        if(data.unique){
          console.log('data unique');
          proceed = true;
          //$("[name='add_ident_submit']").unbind( "submit" )
          //$("[name='add_ident_submit']").submit();
        }else if(data.duplicates){
          console.log('data duplicates');
          var warning = "The following Subscriptions are also associated with this identifier:\n";
          for(var ti of data.duplicates){
              warning+= ti.id +":"+ ti.title+"\n";
          }
          var accept = confirm(warning);
          if(accept){
            proceed = true;
            //$("[name='add_ident_submit']").unbind( "submit" )
            //$("[name='add_ident_submit']").submit();
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
                        	url: "<g:createLink controller='subscriptionDetails' action='editSubscription' params='${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode,id:params.id]:[id:params.id]}'/>"
                        	//url: "/myInstitutions/"+inst_sc+"/subscriptionDetails/editSubscription/"+subId
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

    //if so we do another ajax call here to addToCollection, and on done reload the modal page for editSubscription method

    return false;
  });

  $('a[id=deleteSubIdentifier]').click(function() {
	var ctxOid = $(this).attr('ctxOid');
	var ctxProp = $(this).attr('ctxProp');
	var targetOid = $(this).attr('targetOid');
	console.log('delete through for sub ids clicked');
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
            	url: "<g:createLink controller='subscriptionDetails' action='editSubscription' params='${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode,id:params.id]:[id:params.id]}'/>"
            	//url: "/myInstitutions/"+inst_sc+"/subscriptionDetails/editSubscription/"+subId
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
    width: "100%",
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
