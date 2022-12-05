<ul class="action-btn-row right">
    <li>
        <a class="dropdown-button btn" href="#" data-activates="dropdown2"><i class="material-icons right">dehaze</i>Actions  &nbsp; &nbsp; </a>

        <ul id="dropdown2" class="dropdown-content">
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'addLicenceModal', params:params)}" class="modalButton"><i class="material-icons right">add_circle_outline</i>Add</a></li>
		    <li><a href="#kbmodal" ajax-url="${createLink(controller:'licenceCompare', action:'index', params:params)}" class="modalButton"><i class="material-icons right">compare</i>Compare</a></li>
    		<li><g:link controller="licenceCompare" action="compare" params="${params+[format:'csv']}"><i class="material-icons right">file_download</i>CSV Export</g:link></li>
        </ul>
    </li>
</ul>
