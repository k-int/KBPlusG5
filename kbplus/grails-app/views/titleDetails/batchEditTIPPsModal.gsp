<div class="container" data-theme="titles">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Batch Edit Selected TIPPs</h1>
			<p class="form-caption flow-text grey-text">Delete or Edit multiple titles at once</p>
			<!--form-->
			<div class="row">
				<g:form controller="titleDetails" action="batchUpdate" id="${params.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="">
					<g:each in="${params}" var="prm">
						<g:if test="${prm.key.startsWith('_bulkflag.') && (prm.value=='on')}">
							<input type="hidden" name="${prm.key}" value="${prm.value}"/>
						</g:if>
					</g:each>

					<div class="row">
						<div class="col s12 l6">
							<div class="input-field col s8">
								<g:kbplusDatePicker inputid="bulk_start_date" name="bulk_start_date" value=""/>
								<label class="active">Start Date</label>
							</div>
							<div class="input-field col s4">
								<input id="clear_start_date" type="checkbox" name="clear_start_date"/>
								<label for="clear_start_date">Clear Start Date</label>
							</div>
						</div>

						<div class="col s12 l6">
							<div class="input-field col s8">
								<g:kbplusDatePicker inputid="bulk_end_date" name="bulk_end_date" value=""/>
								<label class="active">End Date</label>
							</div>
							<div class="input-field col s4">
								<input id="clear_end_date" type="checkbox" name="clear_end_date"/>
								<label for="clear_end_date">Clear End Date</label>
							</div>
						</div>

						<div class="col s12 l6">
							<div class="input-field col s8">
								<input id="bulk_start_volume" name="bulk_start_volume" type="text"/>
								<label class="active">Start Volume</label>
							</div>
							<div class="input-field col s4">
								<input id="clear_start_volume" type="checkbox" name="clear_start_volume"/>
								<label for="clear_start_volume">Clear Start Volume</label>
							</div>
						</div>

						<div class="col s12 l6">
							<div class="input-field col s8">
								<input id="bulk_end_volume" name="bulk_end_volume" type="text"/>
								<label class="active">End Volume</label>
							</div>
							<div class="input-field col s4">
								<input id="clear_end_volume" type="checkbox" name="clear_end_volume"/>
								<label for="clear_end_volume">Clear End Volume</label>
							</div>
						</div>

						<div class="col s12 l6">
							<div class="input-field col s8">
								<input id="bulk_start_issue" name="bulk_start_issue" type="text"/>
								<label class="active">Start Issue</label>
							</div>
							<div class="input-field col s4">
								<input id="clear_start_issue" type="checkbox" name="clear_start_issue"/>
								<label for="clear_start_issue">Clear Start Issue</label>
							</div>
						</div>

						<div class="col s12 l6">
							<div class="input-field col s8">
								<input id="bulk_end_issue" name="bulk_end_issue" type="text"/>
								<label class="active">End Issue</label>
							</div>
							<div class="input-field col s4">
								<input id="clear_end_issue" type="checkbox" name="clear_end_issue"/>
								<label for="clear_end_issue">Clear End Issue</label>
							</div>
						</div>

						<div class="col s12 l6">
							<div class="input-field col s8">
								<input id="bulk_coverage_depth" name="bulk_coverage_depth" type="text">
								<label class="active">Coverage Depth</label>
							</div>
							<div class="input-field col s4">
								<input id="clear_coverage_depth" type="checkbox" name="clear_coverage_depth"/>
								<label for="clear_coverage_depth">Clear Coverage Depth</label>
							</div>
						</div>

						<div class="col s12 l6">
							<div class="input-field col s8">
								<input id="bulk_hostPlatformURL" name="bulk_hostPlatformURL" type="text">
								<label class="active">Host Platform URL</label>
							</div>
							<div class="input-field col s4">
								<input id="clear_hostPlatformURL" type="checkbox" name="clear_hostPlatformURL"/>
								<label for="clear_hostPlatformURL">Clear Host Platform URL</label>
							</div>
						</div>


						<div class="col l12">
							<div class="input-field col s12">
								<textarea id="bulk_coverage_note" name="bulk_coverage_note" class="materialize-textarea"/>
	              				<label class="active">Coverage Note</label>
							</div>
							<div class="col s12">
								<input id="clear_coverage_note" type="checkbox" name="clear_coverage_note"/>
								<label for="clear_coverage_note">Clear Coverage Note</label>
							</div>
						</div>


						<div class="input-field col s12 mt-30">
							<div class="col s12">
								<input type="submit" class="waves-effect waves-light btn" value="Batch Edit Selected TIPPs">
							</div>
						</div>


					</div>


				</g:form>
			</div>
			<!--form end-->
		</div>
	</div>
</div>
