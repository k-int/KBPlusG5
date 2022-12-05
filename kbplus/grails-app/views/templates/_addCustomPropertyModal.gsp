<%@ page import="com.k_int.kbplus.RefdataValue" %>
<g:set var="modal_title" value="Add Property"/>
<g:if test="${ownerClass == 'com.k_int.kbplus.License'}">
	<g:set var="modal_title" value="Add Licence Properties"/>
</g:if>
<g:elseif test="${ownerClass == 'com.k_int.kbplus.Org'}">
	<g:set var="modal_title" value="Add Organisation Properties"/>
</g:elseif>
<g:elseif test="${ownerClass == 'com.k_int.kbplus.SystemAdmin'}">
	<g:set var="modal_title" value="Add System Admin Properties"/>
</g:elseif>
<div class="container" data-theme="${theme}">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">${modal_title}</h1>

			<p class="form-caption flow-text text-grey"><g:if test="${descText}">${descText}</g:if></p>

			<!--form-->
			<div class="row">
				<g:form controller="ajax" action="processAddCustomProperty" method="post" name="cust_prop_add_value" class="col s12">
    				<input type="hidden" name="ownerId" value="${ownerId}"/>
    				<input type="hidden" name="editable" value="${editable}"/>
    				<input type="hidden" name="ownerClass" value="${ownerClass}"/>
    				<g:if test="${anchor}">
    					<input type="hidden" name="anchor" value="${anchor}"/>
    				</g:if>
    				<div class="row">
    					<div class="input-field col s12">
    						<g:select name="property"
									  id="property"
                      			  	  from="${propList}"
                      			  	  optionKey="id"
                      			  	  optionValue="text"
                      			  	  value="${propId?:''}"
                      			  	  noSelection="['':'Select one']"
                      			  	  />
                            <label>Property</label>
    					</div>
    				</div>
    				<div class="row">
    					<div class="input-field col s12" id="autoChange">
    						Property Value: <input type="text" name="stringValue" />
    					</div>
    				</div>
    				<div class="row">
    					<div class="input-field col s12">
    						<textarea id="notes_prop" name="notes" class="materialize-textarea"></textarea>
    						<label for="notes_prop">Notes</label>
    					</div>
    				</div>
    				<div class="row">
    					<div class="input-field col s12">
							<button class="btn btn-primary btn-small" type="submit">Add Property <i class="material-icons">add_circle_outline</i></button>
    					</div>
    				</div>
				</g:form>
			</div>
			<!--form end-->
		</div>
	</div>
</div>

<script type="text/javascript">
    var lookupProp = function(){
    	var pid = $('select[name=property]').val();
    	if (pid != "" && pid.length > 0) {
	    	$.ajax({
				type: "GET",
				url: "<g:createLink controller='ajax' action='lookupProperty'/>?propBaseClass=${params.propBaseClass}&propId="+pid,
				error: function(jqXHR, textStatus, errorThrown) {
					console.log('error making ajax call');
					console.log(textStatus);
					console.log(errorThrown);
				}
			}).done(function(data) {
				console.log(data);
				var pt = data.propType;
				var inputContent = "Property Value: ";
				if (pt == "${String.class.name}") {
					console.log("pt is str");
					inputContent += "<input type='text' name='stringValue'/>";
				}
				else if (pt == "${Integer.class.name}") {
					console.log("pt is int");
					inputContent += "<input type='text' name='intValue'/>";
				}
				else if (pt == "${BigDecimal.class.name}") {
					console.log("pt is bd");
					inputContent += "<input type='text' name='decValue'/>";
				}
				else if (pt == "${RefdataValue.class.name}") {
					console.log("pt is rdv");
					inputContent += "<select name='refValue' style='display: block;'>";
					for (var i in data.refdataValues) {
						inputContent += "<option value='"+data.refdataValues[i].id+"'>"+data.refdataValues[i].value+"</option>";
					}
					inputContent += "</select>";
				}
				
				$('#autoChange').html(inputContent);
			});
		}
    };
    
    $(document).ready(lookupProp);
    $('select[name=property]').on('change', lookupProp);
    
    $('form[name=cust_prop_add_value]').submit(function() {
    	var iv = $('input[name=intValue]');
    	var dv = $('input[name=decValue]');
    	var selProp = $('#property option:selected').text();
    	var submitForm = false;
    	
    	console.log('iv:');
    	console.log(iv);
    	console.log(iv.length);
    	
    	if (iv != null && iv.length == 1) {
    		if ((parseFloat(iv.val()) == parseInt(iv.val())) && !isNaN(iv.val())) {
    			submitForm = true;
    		}
    		else {
    			alert('Property value must be an Integer for the selected property: ' + selProp)
    		}
    	}
    	else if (dv != null && dv.length == 1) {
    		if (!isNaN(parseFloat(dv.val())) && isFinite(dv.val())) {
    			submitForm = true;
    		}
    		else {
    			alert('Property value must be a Decimal/Number for the selected property: ' + selProp)
    		}
    	}
    	else {
    		submitForm = true;
    	}
    	
    	return submitForm;
    });
</script>
