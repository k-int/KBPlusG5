<div class="container" data-theme="subscriptions">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">${platformInstance?.name}</h1>
			<p class="form-caption flow-text grey-text">Edit platform details</p>
			<!--form-->
			<div class="row">
				<g:form name="editPlatform" controller="platform" action="processEditPlatform" params="[id:params.id]" class="col s12">
					<div class="row">
						<div class="input-field col s12">
							<input type="text" name="platformName" id="platform_name" value="${platformInstance?.name}" required/>
							<label class="active">Platform Name</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12">
							<input type="text" name="primaryUrl" id="primaryUrl" value="${platformInstance?.primaryUrl}" required/>
							<label class="active">Primary Url</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12"> 
							<g:select name="serviceProvider"
									  id="serviceProvider"
									  from="${service_values}"
                      			  	  optionKey="id"
                      			  	  optionValue="value"
                      			  	  value="${platformInstance?.serviceProvider}"
                      			  	  noSelection="['':'']"
                      			  	  />
							<label>Service Provider</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12"> 
							<g:select name="softwareProvider"
									  id="softwareProvider"
									  from="${software_values}"
                      			  	  optionKey="id"
                      			  	  optionValue="value"
                      			  	  value="${platformInstance?.softwareProvider}"
                      			  	  noSelection="['':'']"
                      			  	  />
							<label>Software Provider</label>
						</div>
					</div>

					<div class="row">
						<div class="input-field col s12">
							<input type="submit" value="Save Changes" class="waves-effect waves-light btn">
						</div>
					</div>

				</g:form>	
			</div>
		</div>
	</div>
</div>