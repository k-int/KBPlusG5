<ul class="action-btn-row right">
  <li>
        <a class='dropdown-button btn' href='#' data-activates='dropdown2'><i class="material-icons right">dehaze</i>Actions &nbsp; &nbsp; </a>

        <!-- Dropdown Structure -->
        <ul id='dropdown2' class='dropdown-content'>
        	<g:if test="${editable}">
            	<li><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'addLicenceModal', params:params)}" class="modalButton"><i class="material-icons right">add_circle_outline</i>Add</a></li>
            </g:if>
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'licenceCompare', action:'index', params:params)}" class="modalButton"><i class="material-icons right">compare</i>Compare</a></li>
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'exportCurrentLicencesModal', params:params)}" class="modalButton"><i class="material-icons right">file_download</i>Export</a></li>

        </ul>
    </li>

</ul>
