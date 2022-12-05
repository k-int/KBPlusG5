<div class="container" data-theme="${theme}">
	<div class="row">
	    <div class="col s12">
	    	<h1 class="form-title flow-text navy-text">Edit Document</h1>
	    	<div class="row">
			    <g:form class="col s12" name="editDocForm" id="${doc.id}" controller="docWidget" action="processEditDocument" method="post">
			        <div class="row">
						<div class="input-field col s12">
			                <input type="text" name="title" value="${doc.title}" id="doc_title" required>
			                <label for="doc_title">Title</label>
			            </div>
					</div>
					<div class="row">
						<div class="input-field col s12">
			                <input type="text" name="filename" value="${doc.filename}" id="doc_filename" required>
			                <label class="active" for="doc_filename">File Name</label>
			            </div>
					</div>
					<div class="row">
						<div class="input-field col s12">
			                <input type="text" name="creator" value="${doc.creator}" id="doc_creator">
			                <label for="doc_creator">Creator</label>
			            </div>
					</div>
			        <div class="row">
						<div class="input-field col s12">
			            	<input type="submit" class="btn btn-primary" value="Save">
			            </div>
			        </div>
			    </g:form>
			</div>
		</div>
	</div>
</div>

<g:render template="/templates/anchorJavascript" model="${['formName': 'editDocForm']}"/>
