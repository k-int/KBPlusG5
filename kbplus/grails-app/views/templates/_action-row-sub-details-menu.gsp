<ul class="action-btn-row right">
  <li>
    <a class='dropdown-button btn' href='#' data-activates='dropdown2'><i class="material-icons right">dehaze</i>Actions &nbsp; &nbsp; </a>

    <!-- Dropdown Structure -->
      <ul id='dropdown2' class='dropdown-content'>
      	<g:if test="${editable}">
      		<g:if test="${params.defaultInstShortcode}">
        		<li><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'emptySubscription', params:[defaultInstShortcode:institution.shortcode])}" class="modalButton"><i class="material-icons right">note_add</i>Add</a></li>
        		<li><a href="#kbmodal" reload="true" ajax-url="${createLink(controller:'subscriptionDetails', action:'editSubscription', params:[defaultInstShortcode:params.defaultInstShortcode,id:params.id])}" class="modalButton"><i class="material-icons right">create</i>Edit</a></li>
        	</g:if>
        	<g:else>
        		<li><a href="#kbmodal" reload="true" ajax-url="${createLink(controller:'subscriptionDetails', action:'editSubscription', params:[id:params.id])}" class="modalButton"><i class="material-icons right">create</i>Edit</a></li>
        	</g:else>
        </g:if>
        <g:if test="${params.defaultInstShortcode}">
        	<li><a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'compareModal', params:[defaultInstShortcode:institution.shortcode])}" class="modalButton"><i class="material-icons right">compare</i>Compare</a></li>
        	<li><a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'exportSubscription', id:subscriptionInstance?.id, params:[defaultInstShortcode:params.defaultInstShortcode])}" class="modalButton"><i class="material-icons right">file_download</i>Export</a></li>
		</g:if>
		<g:else>
			<li><a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'compareModal')}" class="modalButton"><i class="material-icons right">compare</i>Compare</a></li>
        	<li><a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'exportSubscription', id:subscriptionInstance?.id)}" class="modalButton"><i class="material-icons right">file_download</i>Export</a></li>
		</g:else>
      </ul>
  </li>
</ul>
