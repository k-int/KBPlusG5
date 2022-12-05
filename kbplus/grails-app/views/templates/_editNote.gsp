<div class="container" data-theme="${theme}">
	<div class="row">
	    <div class="col s12">
	    	<h1 class="form-title flow-text navy-text">Edit Note</h1>
    		<div class="row">
	    		<g:form class="col s12" name="editNoteForm" id="create_note" id="${doc.id}" controller="docWidget" action="processEditNote" method="post">
	        		<div class="row">
						<div class="input-field col s12">
			                <input type="text" name="title" value="${doc.title}" id="note_title">
			                <label for="note_title">Title</label>
			            </div>
					</div>
	        		<div class="row">
	        			<div class="input-field col s12">
							<textarea id="notesta" placeholder="Enter note here" name="content" class="materialize-textarea">${doc.content}</textarea>
							<input type="hidden" name="licenceNoteShared" value="0"/>
							<label for="notesta" class="active" style="transform: translateY(-200%);">Note</label>
						</div>
	        		</div>
	        		<div class="row">
						<div class="input-field col s12">
			                <input type="text" name="creator" value="${doc.creator}" id="note_creator">
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

<g:render template="/templates/anchorJavascript" model="${[formName: 'editNoteForm']}"/>
