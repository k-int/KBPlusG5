<g:set var="pfm_params_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
<ul class="action-btn-row right">
  <li>
    <a class='dropdown-button btn' href='#' data-activates='dropdown2'><i class="material-icons right">dehaze </i>Actions &nbsp; &nbsp; </a>

    <!-- Dropdown Structure -->
      <ul id='dropdown2' class='dropdown-content'>
      	<sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_KBPLUS_EDITOR">
  		  <li><a href="#kbmodal" 
        	     ajax-url="${createLink(controller:'platform', action:'create', params:pfm_params_sc)}"
        	     class="modalButton"><i class="material-icons right">note_add</i>Add</a></li>
	      <li><a href="#kbmodal"
	  		 	 ajax-url="${createLink(controller:'platform', action:'editPlatform', params:[id:params.id]+pfm_params_sc)}" 
	  		 	 class="modalButton"><i class="material-icons right">create</i>Edit</a></li>
		  <li><a href="#kbmodal"
				 ajax-url="${createLink(controller:'platform', action:'template', id:platformInstance.id, params:pfm_params_sc)}"
				 class="modalButton">
			     <i class="material-icons right">add_circle_outline</i>Add URL Template</a></li>
	  	</sec:ifAnyGranted>
      </ul>
    </li>
</ul>
