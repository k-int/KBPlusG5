<ul class="action-btn-row right">
    <li>
      <a class='dropdown-button btn last' href='#' data-activates='dropdown2'><i class="material-icons right">dehaze</i>Actions &nbsp; &nbsp; </a>

      <!-- Dropdown Structure -->
        <ul id='dropdown2' class='dropdown-content'>
          <g:if test="${params.defaultInstShortcode}">
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'compareModal', params:[defaultInstShortcode:params.defaultInstShortcode, dateA:params.dateA, dateB:params.dateB, subA:params.subA, subB:params.subB, insrt:params.insrt, dlt:params.dlt, updt:params.updt, nochng:params.nochng])}" class="modalButton"><i class="material-icons right">file_upload</i>Update Subscriptions</a></li>
          </g:if>
          <g:else>
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'compareModal', params:[dateA:params.dateA, dateB:params.dateB, subA:params.subA, subB:params.subB, insrt:params.insrt, dlt:params.dlt, updt:params.updt, nochng:params.nochng])}" class="modalButton"><i class="material-icons right">file_upload</i>Update Subscriptions</a></li>
          </g:else>
          <li><g:link controller="subscriptionDetails" action="compare" params="${params+[format:'csv']}"><i class="material-icons right">file_download</i>Export (CSV)</g:link></li>
          <li><g:link controller="subscriptionDetails" action="compare" params="${params+[format:'xls']}"><i class="material-icons right">file_download</i>Export with Colour (XLS)</g:link></li>
        </ul>
      </li>
</ul>
