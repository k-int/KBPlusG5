<g:set var="impsubws_params_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
<ul class="action-btn-row right">
  <li>
    <a class='dropdown-button btn' href='#' data-activates='dropdown2'><i class="material-icons right">dehaze</i>Actions &nbsp; &nbsp; </a>

    <!-- Dropdown Structure -->
      <ul id='dropdown2' class='dropdown-content'>
      	  <g:if test="${editable && institution}">
          	<li><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'emptySubscription', params:[defaultInstShortcode:institution.shortcode])}" class="modalButton"><i class="material-icons right">add_circle_outline</i>Add</a></li>
          </g:if>
          <li><a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'compareModal', params:impsubws_params_sc)}" class="modalButton"><i class="material-icons right">compare</i>Compare</a></li>
          <li><a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionImport', action:'importSubscriptionWorksheetModal', params:impsubws_params_sc)}" class="modalButton"><i class="material-icons right">file_upload</i>Upload Worksheet</a></li>
    </ul>
  </li>
  <!--<li><a class="waves-effect waves-light btn last"><i class="material-icons right">help</i>Help</a></li>-->
</ul>