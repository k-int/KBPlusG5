<div class="container" data-theme="${theme}">
	<div class="row">
	    <div class="col s12">
	    	<h1 class="form-title flow-text navy-text">Create New Note</h1>
    		<div class="row">
	    		<g:form class="col s12" name="createNoteForm" id="create_note" url="[controller:'docWidget',action:'createNote']" method="post">
			        <input type="hidden" name="ownerid" value="${ownobjid}"/>
	        		<input type="hidden" name="ownerclass" value="${ownobjclass}"/>
	        		<input type="hidden" name="ownertp" value="${owntp}"/>
	        		<div class="row">
						<div class="input-field col s12">
			                <input type="text" name="title" id="note_title">
			                <label for="note_title">Title</label>
			            </div>
					</div>
	        		<div class="row">
	        			<div class="input-field col s12">
							<textarea id="notesta" name="licenceNote" class="materialize-textarea"></textarea>
							<input type="hidden" name="licenceNoteShared" value="0"/>
							<label for="notesta">Note</label>
						</div>
	        		</div>
	        		<div class="row">
						<div class="input-field col s12">
			                <input type="text" name="creator" id="note_creator">
			                <label for="note_creator">Creator</label>
			            </div>
					</div>
	        		<div class="row">
	        			<div class="input-field col s12">
	            			<input type="submit" class="btn btn-primary" name="SaveNote" value="Save">
	            		</div>
	        		</div>
	    		</g:form>
	    	</div>
    	</div>
    </div>
</div>

<g:render template="/templates/anchorJavascript" model="${['formName': 'createNoteForm']}"/>