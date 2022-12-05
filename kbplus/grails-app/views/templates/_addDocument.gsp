<div class="container" data-theme="${theme}">
	<div class="row">
	    <div class="col s12">
	    	<h1 class="form-title flow-text navy-text">Add Document</h1>
	    	<div class="row">
			    <g:form class="col s12" name="uploadDocForm" id="upload_new_doc_form" url="[controller:'docWidget',action:'uploadDocument']" method="post" enctype="multipart/form-data">
			        <input type="hidden" name="ownerid" value="${ownobjid}"/>
			        <input type="hidden" name="ownerclass" value="${ownobjclass}"/>
			        <input type="hidden" name="ownertp" value="${owntp}"/>
			        <div class="row">
						<div class="input-field col s12">
			                <input type="text" name="upload_title" id="doc_upload_title">
			                <label for="doc_upload_title">Document Name</label>
			            </div>
					</div>
					<div class="row">

						<div class="file-field input-field col s12">
					      <div class="btn">
					        <span>File</span>
							  <i class="material-icons">add_circle_outline</i>
					        <input type="file" name="upload_file" required>
					      </div>
					      <div class="file-path-wrapper">
					        <input class="file-path validate" type="text" placeholder="Upload a file">
					      </div>
					    </div>
					</div>
					<div class="row">
						<div class="input-field col s12">
			                <select name="doctype">
			                	<option value="" selected disabled>Select one</option>
			                	<option value="License"><g:message code="licence" default="Licence"/></option>
			                    <option value="General">General</option>
			                    <option value="Addendum">Addendum</option>
			                </select>
			                <label>Document Type</label>
						</div>
					</div>
					<div class="row">
						<div class="input-field col s12">
			                <input type="text" name="creator" id="doc_creator">
			                <label for="doc_creator">Creator</label>
			            </div>
					</div>
			        <div class="row">
						<div class="input-field col s12">
			            	<input id="NewDocSaveChangesBtn" type="submit" class="btn btn-primary" name="SaveDoc" value="Save">
			            </div>
			        </div>
			    </g:form>
			</div>
		</div>
	</div>
</div>

<g:render template="/templates/anchorJavascript" model="${['formName': 'uploadDocForm']}"/>

