<div class="container" data-theme="subscriptions">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Batch Action Selected Titles</h1>
			<p class="form-caption flow-text grey-text">Delete or Edit multiple titles at once</p>
			<!--form-->
			<div class="row">
				<g:form controller="subscriptionDetails" action="subscriptionBatchUpdate" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode,id:params.id]:[id:params.id]}" class="col s12">
					<g:each in="${params}" var="prm">
						<g:if test="${prm.key.startsWith('_bulkflag.') && (prm.value=='on')}">
							<input type="hidden" name="${prm.key}" value="${prm.value}"/>
						</g:if>
					</g:each>
					<div class="row">
						<div class="input-field col s12">
							<select name="bulkOperation" id="bulkOperation">
								<option value="remove">Delete</option>
								<option value="edit">Edit</option>
								<option value="core">Make Core</option>
							</select>
							<label>Batch Action</label>
						</div>
					</div>
					
					<div id="editFields" style="display: none;">
						<div class="row">
							<div class="input-field col s12">
								<select name="bulk_medium" id="bulk_medium">
									<option value="">Please select an option</option>
									<g:each in="${iemedium}" var="iem">
										<option value="${iem.class.name}:${iem.id}">${iem.value}</option>
									</g:each>
								</select>
								<label>Entitlement Medium</label>
							</div>
						</div>
						
						<div class="row">
							<div class="input-field col s12 m4">
								<g:kbplusDatePicker inputid="bulk_start_date" name="bulk_start_date" value=""/>
								<label class="active" for="bulk_start_date">Earliest date</label>
							</div>
							<div class="input-field col s12 m2">
								<input id="clear_start_date" type="checkbox" name="clear_start_date"/>
								<label for="clear_start_date">Clear Earliest Date</label>
							</div>
							<div class="input-field col s12 m4">
								<g:kbplusDatePicker inputid="bulk_end_date" name="bulk_end_date" value=""/>
								<label class="active" for="bulk_end_date">Latest date</label>
							</div>
							<div class="input-field col s12 m2">
								<input id="clear_end_date" type="checkbox" name="clear_end_date"/>
								<label for="clear_end_date">Clear Latest Date</label>
							</div>
						</div>
						
						<div class="row">
							<div class="input-field col s12">
								<select name="bulk_coreStatus" id="bulk_coreStatus">
									<option value="">Please select an option</option>
									<g:each in="${corestatus}" var="cs">
										<option value="${cs.class.name}:${cs.id}">${cs.value}</option>
									</g:each>
								</select>
								<label>Core Medium</label>
							</div>
						</div>
					
						<div class="row">
							<div class="input-field col s10">
								<textarea id="bulk_coverage_note" name="bulk_coverage_note" class="materialize-textarea"/>
	              				<label class="active">Coverage Note</label>
							</div>
							<div class="input-field col s2">
								<input id="clear_coverage_note" type="checkbox" name="clear_coverage_note"/>
								<label for="clear_coverage_note">Clear Coverage Note</label>
							</div>
						</div>
					</div>
					
					<div id="coreFields" style="display: none;">
						<div class="row">
							<div class="input-field col s12 m6">
								<g:kbplusDatePicker inputid="core_start_date" name="core_start_date" value=""/>
								<label class="active" for="core_start_date">Core Start</label>
							</div>
							<div class="input-field col s12 m6">
								<g:kbplusDatePicker inputid="core_end_date" name="core_end_date" value=""/>
								<label class="active" for="core_end_date">Core End</label>
							</div>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12">
							<input type="submit" class="waves-effect waves-light btn" value="Apply">
						</div>
					</div>
				</g:form>
			</div>
			<!--form end-->
		</div>
	</div>
</div>

<script type="text/javascript">
	$('select[name=bulkOperation]').on('change', function(){
    	var op = $(this).val();
    	var edit_div = $('div[id=editFields]');
    	var core_div = $('div[id=coreFields]');
    	if (op == 'edit') {
    		edit_div.removeAttr("style");
    		core_div.css({"display": "none"});
    	}
    	else if (op == 'core') {
    		core_div.removeAttr("style");
    		edit_div.css({"display": "none"});
    	}
    	else {
    		edit_div.css({"display": "none"});
    		core_div.css({"display": "none"});
    		$('input[name=bulk_start_date]').val('');
    		$('input[name=bulk_end_date]').val('');
    		$('select[name=bulk_medium] option:selected').removeAttr("selected");
    		$('select[name=bulk_coreStatus] option:selected').removeAttr("selected");
			$('input[name=core_start_date]').val('');
			$('input[name=core_start_date]').val('');
    	}
    });
</script>
