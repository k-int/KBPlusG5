<%@ page contentType="text/html;charset=UTF-8" %>

<div class="container" data-theme="licences">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">${message(code:'menu.institutions.comp_lic', default:'Compare your licences (KB+ Licence Properties)')}</h1>
			<p class="form-caption flow-text text-grey">You can use this tool to compare up to three licences</p>

			<div class="row">
				<g:form controller="licenceCompare" name="compare" action="compare" method="get" params="${[defaultInstShortcode:institution?.shortcode]}">
					<input type="hidden" name="institution" value="${institution?.id}"/>
					<div class="row">
						<div class="input-field col s12">
							<input type="hidden" name="selectedIdentifier" id="addIdentifierSelect"/>
						</div>
					</div>

					<div class="row">
						<div class="input-field col s12">
							<button type="button" class="waves-effect waves-light btn" id="addToList">Add Licence <i class="material-icons">add_circle_outline</i></button>
						</div>
					</div>

					<div class="row"><!--This is purposely empty to provide a nice break between elements on the page--></div>

					<div class="row">
						<div class="input-field col s12">
							<g:select style="width:100%; height: auto; word-wrap: break-word; display: block;" id="selectedLicences" name="selectedLicences" class="compare-license browser browser-default" from="${[]}" multiple="true" />
							<label class="active" style="transform: translateY(-200%);">Licences selected for comparison:</label>
						</div>
					</div>

					<div class="row">
						<div class="input-field col s12">
							<input id="submitButton" disabled='true' type="submit" value="Compare" name="Compare" class="waves-effect waves-light btn" />
						</div>
					</div>
				</g:form>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$(function() {
		var main = $('#selectedLicences');

		// Now add the onchange.
		main.change(function() {
			var conceptName = main.find(":selected");
			if (conceptName != null) {
				$('#submitButton').removeAttr('disabled');
			}
		});

		$('#addToList').click(function() {
			var option = $("input[name='selectedIdentifier']").val();
			var option_name = option.split("||")[0];
			var option_id = option.split("||")[1];
			var list_option = "<option selected='selected' value='"+option_id+"''>"+option_name+"</option>";
			$("#selectedLicences").append(list_option);
			$('#selectedLicences').trigger( "change" );
		});

		$("#addIdentifierSelect").select2({
			width: '100%',
			minimumInputLength: 1,
			ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
				url: "<g:createLink controller='ajax' action='lookup'/>",
				dataType: 'json',
				data: function (term, page) {
					return {
						q: "%"+term+"%", // search term
						inst:"${institution?.id}",
						roleType:"${licensee_role}",
						isPublic:"${isPublic?.id}",
						page_limit: 10,
						baseClass:'com.k_int.kbplus.License'
					};
				},
				results: function (data, page) {
					return {results: data.values};
				},
			}
		});
	});
</script>
