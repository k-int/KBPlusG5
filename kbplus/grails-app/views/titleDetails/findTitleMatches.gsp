<div class="container" data-theme="titles">
  <div class="row">
    <div class="col s12">
      <h1 class="form-title flow-text navy-text">Add New Title</h1>
      <p class="form-caption flow-text grey-text">Please enter the new title below. Close matches will then be reported to ensure the title is not already present. After confirming
               you wish the new title to be added you can create the new title and move to the edit screen</p>
      <div class="row">
        <form class="col s12" name="findTitleMatches">

          <div class="row">
			  <div class="input-field col s12">
				  <label>Proposed Title:</label><br/>
				  <input type="text" name="proposedTitle" value="${params.proposedTitle}" />
			  </div>
          </div>
          <div class="row">

          	<div class="input-field col s12">
          		<input type="submit" value="Search" class="waves-effect waves-light btn">
          	</div>
          </div>
        </form>
      </div>
      
      <div class="row">
        <g:if test="${titleMatches != null}">
          <g:if test="${titleMatches.size()>0}">
		      <div class="col s12">
		      	<div class="tab-table z-depth-1 table-responsive-scroll">
	                <table class="bordered highlight responsive-table modal-table fixed-table">
	                  <thead>
	                    <tr>
	                      <th>Title</th>
	                      <th>Identifiers</th>
	                      <th>Orgs</th>
	                      <th>Key</th>
	                    </tr>
	                  </thead>
	                  <tbody>
	                    <g:each in="${titleMatches}" var="titleInstance">
	                      <tr>
	                        <td><g:link controller="titleDetails" action="show" id="${titleInstance.id}">${titleInstance.title}</g:link></td>
	                        <td>
	                          <ul>
	                            <g:each in="${titleInstance.ids}" var="id">
	                              <li>${id.identifier.ns.ns}:${id.identifier.value}</li>
	                            </g:each>
	                          </ul>
	                        </td>
	                        <td>
	                          <ul>
	                            <g:each in="${titleInstance.orgs}" var="org">
	                              <li>${org.org.name} (${org.roleType?.value?:''})</li>
	                            </g:each>
	                          </ul>
	                        </td>
	                        <td>${titleInstance.keyTitle}</td>
	                      </tr>
	                    </g:each>
	                  </tbody>
	                </table>
	            </div>
                <p class="form-caption flow-text grey-text">
                    The title <em>"${params.proposedTitle}"</em> matched one or more records in the database. You can still create another title with this name using the button below,
	                but please do confirm this really is a new title for the system before proceeding.
	            </p>
	            <g:link controller="titleDetails" action="createTitle" class="waves-effect waves-light btn" params="${params.defaultInstShortcode?[title:params.proposedTitle, defaultInstShortcode:params.defaultInstShortcode]:[title:params.proposedTitle]}">Create New Title for <em>"${params.proposedTitle}"</em></g:link>
	          </div>
	        </g:if>
	        <g:else>
	          <div class="col s12">
	            <p class="form-caption flow-text grey-text">
	               There were no matches for the title string <em>"${params.proposedTitle}"</em>. This is a good sign that the title
	               you wish to create does not exist in the database. However,
	               cases such as mis-spellings, alternate word spacing and abbreviations may not be caught. To ensure the highest quality database,
	               please double check the title for the previous variants. Click the button below when you are sure the current title does not already exist.
	            </p>
	            <g:link controller="titleDetails" action="createTitle" class="waves-effect waves-light btn" params="${params.defaultInstShortcode?[title:params.proposedTitle, defaultInstShortcode:params.defaultInstShortcode]:[title:params.proposedTitle]}">Create New Title for <em>"${params.proposedTitle}"</em></g:link>
	          </div>
	      </g:else>
	    </g:if>
      </div>
    </div>
  </div>
</div>
<g:set var="findtitles_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>

<script type="text/javascript">
	$('form[name=findTitleMatches]').submit(function() {
		var propTitle = encodeURIComponent($('input[name=proposedTitle]').val());

		console.log(propTitle);
		
		var ajaxUrl = "${createLink(controller:'titleDetails', action:'findTitleMatches', params:findtitles_sc)}?proposedTitle="+ propTitle;
		
		$.ajax({
			type: "GET",
			url: ajaxUrl,
			error: function(jqXHR, textStatus, errorThrown) {
   			  console.log('error finding title matches');
   			  console.log(textStatus);
   			  console.log(errorThrown);
   		  	}
		}).done(function(data) {
			console.log(data);
			$('.modal-content').html(data);
		});
	
		return false;
	});
	
</script>

    
