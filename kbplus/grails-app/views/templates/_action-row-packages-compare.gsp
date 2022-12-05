<ul class="action-btn-row right">
  <li>
    <a class='dropdown-button btn' href='#' data-activates='dropdown2'><i class="material-icons right">dehaze</i>Actions &nbsp; &nbsp; </a>

    <!-- Dropdown Structure -->
      <ul id='dropdown2' class='dropdown-content'>
        <g:if test="${params.defaultInstShortcode}">
          <li><a href="#kbmodal" ajax-url="${createLink(controller:'packageDetails', action:'compareModal', params:[dateA:params.dateA, dateB:params.dateB, pkgA:params.pkgA, pkgB:params.pkgB, insrt:params.insrt, dlt:params.dlt, updt:params.updt, nochng:params.nochng, defaultInstShortcode:params.defaultInstShortcode])}" class="modalButton"><i class="material-icons right">file_upload</i>Edit Comparison</a></li>
        </g:if>
        <g:else>
          <li><a href="#kbmodal" ajax-url="${createLink(controller:'packageDetails', action:'compareModal', params:[dateA:params.dateA, dateB:params.dateB, pkgA:params.pkgA, pkgB:params.pkgB, insrt:params.insrt, dlt:params.dlt, updt:params.updt, nochng:params.nochng])}" class="modalButton"><i class="material-icons right">file_upload</i>Edit Comparison</a></li>
        </g:else>
        <li><g:link controller="packageDetails" action="compare" params="${params+[format:'csv']}"><i class="material-icons right">file_download</i>CSV Export</g:link></li>
      </ul>
    </li>
</ul>
