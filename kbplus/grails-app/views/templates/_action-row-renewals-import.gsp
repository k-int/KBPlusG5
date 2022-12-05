<ul class="action-btn-row right">
    <li>
        <a class='dropdown-button btn' href='#' data-activates='dropdown2'><i class="material-icons right">dehaze</i>Actions &nbsp; &nbsp; </a>

        <!-- Dropdown Structure -->
        <ul id='dropdown2' class='dropdown-content'>
            <li>
                <a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'renewalsUploadModal', params:[defaultInstShortcode:params.defaultInstShortcode])}" class="modalButton"><i class="material-icons right">file_upload</i>Upload</a>
            </li>
        </ul>
    </li>
</ul>
