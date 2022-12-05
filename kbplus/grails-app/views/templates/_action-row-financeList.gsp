<g:set var="fin_ar_params_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
<ul class="action-btn-row right">
  <li>
    <a class='dropdown-button btn last' href='#' data-activates='dropdown2'><i class="material-icons right">dehaze</i>Actions &nbsp; &nbsp; </a>

    <!-- Dropdown Structure -->
      <ul id='dropdown2' class='dropdown-content'>
      <li>
        <a href="#kbmodal" ajax-url="${createLink(controller:'finance', action:'addCostItem', params:fin_ar_params_sc)}" class="modalButton"><i class="material-icons right">add_circle_outline</i>Add Cost Item</a> 
        <!--<g:link controller="finance" action="addCostItem" params="${[defaultInstShortcode:institution.shortcode]}">
          <i class="material-icons right">add_circle_outline</i>Add</g:link>-->
      </li>
      <!-- No institutional finance upload yet - dm only. <li><a><i class="material-icons right">file_upload</i>Upload</a></li> -->
      <li><g:link controller="finance" action="financialsExport"params="${[defaultInstShortcode:institution.shortcode,format:'csv']}"><i class="material-icons right">file_download</i>Export (CSV)</g:link></li>
      <li><g:link controller="finance" action="financialsExport"params="${[defaultInstShortcode:institution.shortcode,format:'tsv']}"><i class="material-icons right">file_download</i>Export (TSV)</g:link></li>
      </ul>
  </li>
</ul>
