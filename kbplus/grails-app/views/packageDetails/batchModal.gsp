<div class="container" data-theme="packages">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Batch Task Selected Titles</h1>
			<p class="form-caption flow-text grey-text">Delete or Edit multiple titles at once</p>
			<!--form-->
			<div class="row">
				<g:form controller="packageDetails" action="packageBatchUpdate" id="${pkg.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="col s12">
					<g:each in="${params}" var="prm">
						<g:if test="${prm.key.startsWith('_bulkflag.') && (prm.value=='on')}">
							<input type="hidden" name="${prm.key}" value="${prm.value}"/>
						</g:if>
					</g:each>
					<input type="hidden" name="BatchSelectedBtn" value="on"/>
					
					<div class="row">
						<div class="input-field col s12">
							<select name="bulkOperation" id="bulkOperationSelect">
								<option value="remove">Delete</option>
								<option value="edit">Edit</option>
							</select>
							<label>Batch Action</label>
						</div>
					</div>
					
					<div id="editFields" style="display: none;">

						<div class="row">
							<div class="input-field col s12 m4">
								<g:kbplusDatePicker inputid="bulk_start_date" name="bulk_start_date" value=""/>
								<label class="active">Start Date</label>
							</div>
							<div class="input-field col s12 m2">
								<input id="clear_start_date" type="checkbox" name="clear_start_date"/>
								<label for="clear_start_date">Clear Start Date</label>
							</div>
							<div class="input-field col s12 m4">
								<g:kbplusDatePicker inputid="bulk_end_date" name="bulk_end_date" value=""/>
								<label class="active">End Date</label>
							</div>
							<div class="input-field col s12 m2">
								<input id="clear_end_date" type="checkbox" name="clear_end_date"/>
								<label for="clear_end_date">Clear End Date</label>
							</div>
						</div>

						<div class="row">
							<div class="input-field col s12 m4">
								<input id="bulk_start_volume" name="bulk_start_volume" type="text"/>
								<label class="active">Start Volume</label>
							</div>
							<div class="input-field col s12 m2">
								<input id="clear_start_volume" type="checkbox" name="clear_start_volume"/>
								<label for="clear_start_volume">Clear Start Volume</label>
							</div>
							<div class="input-field col s12 m4">
								<input id="bulk_end_volume" name="bulk_end_volume" type="text"/>
								<label class="active">End Volume</label>
							</div>
							<div class="input-field col s12 m2">
								<input id="clear_end_volume" type="checkbox" name="clear_end_volume"/>
								<label for="clear_end_volume">Clear End Volume</label>
							</div>
						</div>

						<div class="row">
							<div class="input-field col s12 m4">
								<input id="bulk_start_issue" name="bulk_start_issue" type="text"/>
								<label class="active">Start Issue</label>
							</div>
							<div class="input-field col s12 m2">
								<input id="clear_start_issue" type="checkbox" name="clear_start_issue"/>
								<label for="clear_start_issue">Clear Start Issue</label>
							</div>
							<div class="input-field col s12 m4">
								<input id="bulk_end_issue" name="bulk_end_issue" type="text"/>
								<label class="active">End Issue</label>
							</div>
							<div class="input-field col s12 m2">
								<input id="clear_end_issue" type="checkbox" name="clear_end_issue"/>
								<label for="clear_end_issue">Clear End Issue</label>
							</div>
						</div>
						
						<div class="row">
							<div class="input-field col s12 m4">
								<input id="bulk_coverage_depth" name="bulk_coverage_depth" type="text">
								<label class="active">Coverage Depth</label>
							</div>
							<div class="input-field col s12 m2">
								<input id="clear_coverage_depth" type="checkbox" name="clear_coverage_depth"/>
								<label for="clear_coverage_depth">Clear Coverage Depth</label>
							</div>
							<div class="input-field col s12 m4">
								<select	name="bulk_hybridOA" id="bulk_hybridOA">
									<option value="">Please select an option</option>
									<g:each in="${hybridOA}" var="hoa">
										<option value="${hoa.class.name}:${hoa.id}">${hoa.value}</option>
									</g:each>
									%{--<option value="no">No</option>--}%
									%{--<option value="unknown">Unknown</option>--}%
									%{--<option value="yes">Yes</option>--}%
								</select>
								<label>Hybrid OA</label>
							</div>
							<div class="input-field col s12 m4">
								<input id="bulk_embargo" name="bulk_embargo" type="text">
								<label class="active">Embargo</label>
							</div>
							<div class="input-field col s12 m2">
								<input id="clear_embargo" type="checkbox" name="clear_embargo"/>
								<label for="clear_embargo">Clear Embargo</label>
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
					
					<div class="row">
						<div class="input-field col s12">
							<input type="submit" class="waves-effect waves-light btn" value="Batch Action Selected Titles">
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
    	if (op == 'edit') {
    		edit_div.removeAttr("style");
    	}
    	else {
    		edit_div.css({"display": "none"});
    		$('input[name=bulk_start_date]').val('');
    		$('input[name=bulk_end_date]').val('');
    	}
    });
</script>

