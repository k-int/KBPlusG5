<%@ page import="com.k_int.kbplus.RefdataValue" %>
<div class="container" data-theme="${theme}">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Edit Property</h1>
			<p class="form-caption flow-text grey-text">Editing Property: ${property.type.name}</p>
			<!--form-->
			<div class="row">
				<g:form controller="ajax" action="processEditCustomProperty" id="${params.id}" method="post" name="cust_prop_edit_value" class="col s12">
    				<input type="hidden" name="propclass" value="${propclass}"/>
    				<input type="hidden" name="editable" value="${editable}"/>
    				<g:if test="${anchor}">
    					<input type="hidden" name="anchor" value="${anchor}"/>
    				</g:if>
    				<div class="row">
    					<div class="input-field col s12">
    						Property Value: 
    						<g:if test="${property.type.type == String.class.name}">
    							<input type="text" name="stringValue" value="${property.stringValue}" />
    						</g:if>
    						<g:elseif test="${property.type.type == Integer.class.name}">
    							<input type="text" name="intValue" value="${property.intValue}" />
    						</g:elseif>
    						<g:elseif test="${property.type.type == BigDecimal.class.name}">
    							<input type="text" name="decValue" value="${property.decValue}" />
    						</g:elseif>
    						<g:elseif test="${property.type.type == RefdataValue.class.name}">
    							<g:select name="refValue"
    									  from="${property?.refValue?.owner ? RefdataValue.findAllByOwner(property.refValue.owner) : RefdataValue.findAllByOwner(com.k_int.kbplus.RefdataCategory.findByDesc(property.type.refdataCategory))}"
    									  optionKey="id"
    									  optionValue="value"
    									  value="${property?.refValue?.id}" />
    						</g:elseif>
    					</div>
    				</div>
    				<div class="row">
    					<div class="input-field col s12">
    						Notes: <textarea name="notes" class="materialize-textarea">${property.note}</textarea>
    					</div>
    				</div>
    				<div class="row">
    					<div class="input-field col s12">
    						<input type="submit" value="Save Changes" class="btn btn-primary btn-small"/>
    					</div>
    				</div>
				</g:form>
			</div>
			<!--form end-->
		</div>
	</div>
</div>

<script type="text/javascript">
    $('form[name=cust_prop_edit_value]').submit(function() {
    	var iv = $('input[name=intValue]');
    	var dv = $('input[name=decValue]');
    	var submitForm = false;
    	
    	console.log('iv:');
    	console.log(iv);
    	console.log(iv.length);
    	
    	if (iv != null && iv.length == 1) {
    		if ((parseFloat(iv.val()) == parseInt(iv.val())) && !isNaN(iv.val())) {
    			submitForm = true;
    		}
    		else {
    			alert('Property value must be an Integer for the this property.')
    		}
    	}
    	else if (dv != null && dv.length == 1) {
    		if (!isNaN(parseFloat(dv.val())) && isFinite(dv.val())) {
    			submitForm = true;
    		}
    		else {
    			alert('Property value must be a Decimal/Number for the this property.')
    		}
    	}
    	else {
    		submitForm = true;
    	}
    	
    	return submitForm;
    });
</script>
