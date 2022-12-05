<ul class="action-btn-row right">
  <li>
    <a class='dropdown-button btn last' href='#' data-activates='dropdown2'><i class="material-icons right">dehaze</i>Actions &nbsp; &nbsp; </a>

    <!-- Dropdown Structure -->
      <ul id='dropdown2' class='dropdown-content'>
        <g:if test="${params.defaultInstShortcode}">
           <li><a href="#kbmodal" class="modalButton" ajax-url="${createLink(controller:'packageDetails', action:'compareModal', params:[defaultInstShortcode:params.defaultInstShortcode])}"><i class="material-icons right">compare</i>Compare</a></li>
         </g:if>
         <g:else>
           <li><a href="#kbmodal" class="modalButton" ajax-url="${createLink(controller:'packageDetails', action:'compareModal')}"><i class="material-icons right">compare</i>Compare</a></li>
         </g:else>
        <li><g:link controller="packageDetails" action="list" params="${params+['format':'csv']}"><i class="material-icons right">file_download</i>Export</g:link></li>
      </ul>
    </li>
</ul>
