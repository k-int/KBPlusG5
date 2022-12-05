<%@ page import="com.k_int.custprops.PropertyDefinition; com.k_int.kbplus.RefdataCategory" %>
<div class="container" data-theme="${theme}">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Create Custom Property Definition</h1>
			<p class="form-caption flow-text grey-text"></p>
			<!--form-->
			<div class="row">
				<g:form controller="ajax" action="processNewCustomPropertyType" name="add_new_cust_prop" class="col s12">
					<input type="hidden" name="ownerId" value="${ownerId}"/>
    				<input type="hidden" name="editable" value="${editable}"/>
    				<input type="hidden" name="ownerClass" value="${ownerClass}"/>
    				<input type="hidden" name="propBaseClass" value="${propBaseClass}"/>
    				<input type="hidden" name="prop_desc" value="${prop_desc}"/>
    				<input type="hidden" name="theme" value="${theme}"/>
    				<g:if test="${anchor}">
    					<input type="hidden" name="anchor" value="${anchor}"/>
    				</g:if>
					<div class="row">
						<div class="input-field col s12">
							<input placeholder="Enter Custom Property Name Here.." name="cust_prop_name" id="cust_prop_name" type="text" class="validate">
							<label for="name" class="active">Custom Property Name</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12">
							<g:select from="${PropertyDefinition.validTypes.entrySet()}"
									  optionKey="value"
									  optionValue="key"
									  name="cust_prop_type"
									  id="cust_prop_modal_select"
									  />
							<label>Type</label>
						</div>
					</div>
					
					<div class="row" id="autoHide" style="display: none;">
						<div class="input-field col s12">
							<g:select name="refdatacategory"
									  from="${RefdataCategory.list()}"
									  optionKey="id"
									  optionValue="desc"
									  />
							<label>Refdata Category</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12">
							<g:select name="cust_prop_desc"
									  from="${PropertyDefinition.AVAILABLE_DESCR}"
									  value="${ctxType}"
									  />
							<label>Context</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12">
							<input type="checkbox" id="createvalue" name="createvalue"/>
							<label for="createvalue">Create value for this property</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12">
							<button class="waves-effect waves-light btn" type="submit">Add Property <i class="material-icons">add_circle_outline</i></button>
						</div>
					</div>
				</g:form>
			</div>
			<!--form end-->
		</div>
	</div>
</div>

<script type="text/javascript">
	//TODO: check the type option and if refdata need to do ajax call or show a certain field that may or may not be hidden already on the page/modal
	$('select[name=cust_prop_type]').on('change', function(){
    	var pid = $(this).val();
    	var refcat = $('div[id=autoHide]');//document.getElementById('');
    	if (pid == 'com.k_int.kbplus.RefdataValue') {
    		refcat.removeAttr("style");
    	}
    	else {
    		refcat.css({"display": "none"});
    	}
    });
    
    $('form[name=add_new_cust_prop]').submit(function() {
    	var submitForm = false;
    	
    	var cv = $('input[name=createvalue]');
    	
    	var prop_name = $('input[name=cust_prop_name]').val().trim();
    	if (prop_name.length > 0) {
	    	if (cv.prop("checked") == false) {
	    		//submitForm = true;
	    	}
	    	else {
	    		var formaction = $(this).attr('action');
	    		var ownerId = $('input[name=ownerId]').val();
	    		var editable = $('input[name=editable]').val();
	    		var theme = $('input[name=theme]').val();
	    		var ownerClass = $('input[name=ownerClass]').val();
	    		var propBaseClass = $('input[name=propBaseClass]').val();
	    		var prop_desc = $('input[name=prop_desc]').val();
	    		var anchor = $('input[name=anchor]').val();
	    		var cust_prop_type = $('select[name=cust_prop_type]').val();
	    		var refdatacategory = $('select[name=refdatacategory]').val();
	    		var cust_prop_desc = $('select[name=cust_prop_desc]').val();
	    		
	    		formaction += "?cust_prop_name=" + prop_name;
	    		formaction += "&cust_prop_type=" + cust_prop_type;
	    		formaction += "&refdatacategory=" + refdatacategory;
	    		formaction += "&cust_prop_desc=" + cust_prop_desc;
	    		formaction += "&ajax=Y";
	    		
	    		$.ajax({
					type: "GET",
					url: formaction,
					error: function(jqXHR, textStatus, errorThrown) {
	    			  console.log('error processing new custom prop');
	    			  console.log(textStatus);
	    			  console.log(errorThrown);
	    		  	}
				}).done(function(data) {
					console.log('data from adding new custom prop. do we have an id? ' + data);
					$.ajax({
						type: "GET",
						url: "<g:createLink controller='ajax' action='addCustomPropertyModal'/>?prop_desc="+ prop_desc +"&propBaseClass="+ propBaseClass +"&ownerId="+ ownerId +"&ownerClass="+ ownerClass +"&propId="+ data +"&editable=" + editable +"&theme="+ theme +"&anchor="+ encodeURIComponent(anchor),
						error: function(jqXHR, textStatus, errorThrown) {
							console.log('error loading add custom prop modal content');
							console.log(textStatus);
							console.log(errorThrown);
						}
					}).done(function(data) {
						$('.modal-content').html(data);
					});
				});
	    	}
	    }
	    else {
	    	window.alert('Please provide a value for Custom Property Name');
	    }
    	
    	return submitForm;
    });
</script>
