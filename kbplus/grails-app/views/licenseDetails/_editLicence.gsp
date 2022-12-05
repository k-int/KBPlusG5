<%@ page import="java.text.SimpleDateFormat"%>
<%
	def dateFormatter = new SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
%>
<g:set var="editlic_sc_params" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
<div class="container" data-theme="licences">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">${license?.reference?:message(code:'missingLicenseReference', default:'** No Licence Reference Set **')}</h1>
			<p class="form-caption flow-text grey-text"></p>
			<!--form-->
			<div class="row">
				<g:form controller="licenseDetails" action="processEditLicense" id="${params.id}" params="${editlic_sc_params}" name="editLicenceForm" class="col s12">

					<div class="row">
						<div class="input-field col s12">
							<input type="text" name="reference" id="reference" value="${license?.reference}" />
							<label class="active" for="reference">Reference</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12 m6">
							<input type="text" name="contact" id="contact" value="${license.contact}" />
							<label class="active" for="contact">Contact</label>
						</div>

						<div class="input-field col s12 m6">
							<g:select name="status"
									  id="status"
									  from="${status_values}"
									  optionKey="id"
									  optionValue="value"
									  value="${license?.status?.id}"
									  noSelection="['':'']"
							/>
							<label for="status">Status</label>
						</div>
					</div>

					
					<div class="row">
						<div class="input-field col s12 m6">
							<input type="text" name="licUrl" id="licUrl" value="${license.licenseUrl}" />
							<label class="active" for="licUrl">Licence URL</label>
						</div>
						<div class="input-field col s12 m6">
							<input type="text" name="jiscLicenseId" id="jiscLicenseId" value="${license.jiscLicenseId}" />
							<label class="active" for="jiscLicenseId">Jisc License Id</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12 m6">
							<input type="text" name="licensorRef" id="licensorRef" value="${license.licensorRef}" />
							<label class="active" for="licensorRef">Licensor Ref</label>
						</div>
						<div class="input-field col s12 m6">
							<input type="text" name="licenseeRef" id="licenseeRef" value="${license.licenseeRef}" />
							<label class="active" for="licenseeRef">Licensee Ref</label>
						</div>
					</div>

					<div class="row">
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="start_date" name="startDate" value="${license.startDate ? dateFormatter.format(license.startDate) : null}"/>
							<label class="active">Start Date</label>
						</div>
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="end_date" name="endDate" value="${license.endDate ? dateFormatter.format(license.endDate) : null}"/>
							<label class="active">End Date</label>
						</div>
					</div>

					<div class="row">
                        <div class="input-field col s12 m6">
                            <g:select name="ispublic"
                                      id="ispublic"
                                      from="${yn_values}"
                                      optionKey="id"
                                      optionValue="value"
                                      value="${license?.isPublic?.id}"
                                      noSelection="['':'']"
                            />
                            <label>Public?</label>
                        </div>
						<div class="input-field col s12 m6">
							<g:select name="liccat"
									  id="liccat"
                      			  	  from="${liccat_values}"
                      			  	  optionKey="id"
                      			  	  optionValue="value"
                      			  	  value="${license?.licenseCategory?.id}"
                      			  	  noSelection="['':'']"
                      			  	  />
							<label>Licence Category</label>
						</div>
					</div>
					
					<g:each in="${license?.incomingLinks}" var="il">
						<div class="row">
                        	<div class="input-field col s12">
                        		<g:select name="_incominglink.${il.id}"
                        		          id="_incominglink.${il.id}"
                        		          from="${yn_values}"
                        		          optionKey="id"
                        		          optionValue="value"
                        		          value="${il?.isSlaved?.id}"
                        		          noSelection="['':'']"
                            	/>
                            	<label>Incoming Licence Link: ${il.fromLic.reference ?: 'Linked Licence (No reference)'}: Child</label>
                        	</div>
                        </div>
					</g:each>

					<div class="row">
						<div class="input-field col s12">
							<input type="submit" value="Save" class="waves-effect waves-light btn">
						</div>
					</div>

				</g:form>
			</div>
			<!--form end-->

		</div>
	</div>
</div>

<script type="text/javascript">
	function addHiddenAnchorParam(theForm, value) {
    	var input = document.createElement('input');
    	input.type = 'hidden';
    	input.name = 'anchor';
    	input.value = value;
    	theForm.appendChild(input);
	}
	
	var theForm = document.forms['editLicenceForm'];
	var loc = window.location.href;
	if (loc.indexOf("#") !== -1) {
		var anc = loc.substring(loc.indexOf("#"), loc.length);
		addHiddenAnchorParam(theForm, anc);
	}
</script>
