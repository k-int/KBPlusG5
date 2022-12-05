<g:set var="ar_ld_sc_params" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
<ul class="action-btn-row right">
    <li>
        <a class="dropdown-button btn" href="#" data-activates="dropdown2"><i class="material-icons right">dehaze</i>Actions  &nbsp; &nbsp; </a>

        <ul id="dropdown2" class="dropdown-content">
        	<g:if test="${params.defaultInstShortcode && editable}">
            	<li><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'addLicenceModal', params:params)}" class="modalButton"><i class="material-icons right">add_circle_outline</i>Add</a></li>
            </g:if>
            <g:if test="${editable}">
            	<li><a href="#kbmodal" ajax-url="${createLink(controller:'licenseDetails', action:'editLicense', id:license.id, params:params)}" class="modalButton"><i class="material-icons right">create</i>Edit</a></li>
            </g:if>
            <g:if test="${params.defaultInstShortcode}">
            	<li><a href="#kbmodal" ajax-url="${createLink(controller:'licenceCompare', action:'index', params:params)}" class="modalButton"><i class="material-icons right">compare</i>Compare</a></li>
            	<g:if test="${editable}">
            	  <li><g:link controller="myInstitutions" action="actionLicenses" params="${ar_ld_sc_params+[baselicense:license.id,'cpy-licence':'Y']}" ><i class="material-icons right">content_copy</i>Copy</g:link></li>
            	</g:if>
            </g:if>
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'licenseDetails', action:'exportLicense', id:license.id, params:params)}" class="modalButton"><i class="material-icons right">file_download</i>Export</a></li>
        </ul>
    </li>
</ul>
