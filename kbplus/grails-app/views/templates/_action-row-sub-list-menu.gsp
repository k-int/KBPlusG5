<ul class="action-btn-row right">
  <li>
    <a class='dropdown-button btn' href='#' data-activates='dropdown2'><i class="material-icons right">dehaze</i>Actions &nbsp; &nbsp; </a>

    <!-- Dropdown Structure -->
      <ul id='dropdown2' class='dropdown-content'>
      	  <g:if test="${institution}">
      	    <g:if test="${editable}">
          	  <li><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'emptySubscription', params:[defaultInstShortcode:institution.shortcode])}" class="modalButton"><i class="material-icons right">add_circle_outline</i>Add</a></li>
            </g:if>
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'compareModal', params:[defaultInstShortcode:institution.shortcode])}" class="modalButton"><i class="material-icons right">compare</i>Compare</a></li>
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'exportSubscription', params:params)}" class="modalButton"><i class="material-icons right">file_download</i>Export</a></li>
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'exportSubscriptionTitles', params:params)}" class="modalButton"><i class="material-icons right">file_download</i>Export with Titles</a></li>
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'exportSubscriptionTitlesLicenses', params:params)}" class="modalButton"><i class="material-icons right">file_download</i>Export with Titles & Licences</a></li>
          </g:if>
          <g:else>
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'compareModal')}" class="modalButton"><i class="material-icons right">compare</i>Compare</a></li>
          </g:else>
      </ul>
  </li>
  <!--<li><a class="waves-effect waves-light btn last"><i class="material-icons right">help</i>Help</a></li>-->
</ul>