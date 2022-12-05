<ul class="action-btn-row right">
  <li>
    <a class='dropdown-button btn' href='#' data-activates='dropdown2'><i class="material-icons right">dehaze </i>Actions &nbsp; &nbsp; </a>

    <!-- Dropdown Structure -->
      <ul id='dropdown2' class='dropdown-content'>
        <g:if test="${params.defaultInstShortcode}">
          <li><a href="#kbmodal" 
        	     ajax-url="${createLink(controller:'packageDetails', action:'compareModal', params:[defaultInstShortcode:params.defaultInstShortcode])}"
        	     class="modalButton"><i class="material-icons right">compare</i>Compare</a></li>
          <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_KBPLUS_EDITOR">
	          <li><a href="#kbmodal" 
	  		 	     ajax-url="${createLink(controller:'packageDetails', action:'editPackage', params:[defaultInstShortcode:params.defaultInstShortcode,id:params.id])}" 
	  		 	     class="modalButton"><i class="material-icons right">create</i>Edit</a></li>
	  	  </sec:ifAnyGranted>
	  	  <g:if test="${editable}">
	  	    <li><a href="#kbmodal" 
	  		 	     ajax-url="${createLink(controller:'packageDetails', action:'addTitleModal', id:packageInstance.id, params:[defaultInstShortcode:params.defaultInstShortcode])}" 
	  		 	     class="modalButton"><i class="material-icons right">add_circle_outline</i>Add Title</a></li>
	  	  </g:if>
  		</g:if>
  		<g:else>
  		  <li><a href="#kbmodal" 
        	     ajax-url="${createLink(controller:'packageDetails', action:'compareModal')}"
        	     class="modalButton"><i class="material-icons right">compare</i>Compare</a></li>
          <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_KBPLUS_EDITOR">
	          <li><a href="#kbmodal" 
	  		 	     ajax-url="${createLink(controller:'packageDetails', action:'editPackage', params:[id:params.id])}" 
	  		 	     class="modalButton"><i class="material-icons right">create</i>Edit</a></li>
	  	  </sec:ifAnyGranted>   
	  	  <g:if test="${editable}">
	  	    <li><a href="#kbmodal" 
	  		 	     ajax-url="${createLink(controller:'packageDetails', action:'addTitleModal', id:packageInstance.id)}" 
	  		 	     class="modalButton"><i class="material-icons right">add_circle_outline</i>Add Title</a></li>
	  	  </g:if>
  		</g:else>
  		<li><a href="#kbmodal" 
  		 	   ajax-url="${createLink(controller:'packageDetails', action:'exportPackage', params:params)}" 
  		 	   class="modalButton"><i class="material-icons right">file_download</i>Export</a></li>
      </ul>
    </li>
</ul>
