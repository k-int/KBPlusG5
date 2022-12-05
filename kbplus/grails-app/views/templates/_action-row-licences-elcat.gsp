<ul class="action-btn-row right">
  <li>
        <a class='dropdown-button btn' href='#' data-activates='dropdown2'><i class="material-icons right">dehaze</i>Actions &nbsp; &nbsp; </a>

        <!-- Dropdown Structure -->
        <ul id='dropdown2' class='dropdown-content'>
        	<li>
        	  <g:if test="${params.defaultInstShortcode}">
        	    <a href="#kbmodal" ajax-url="${createLink(controller:'onixplLicenseCompare', action:'index', params:[defaultInstShortcode:params.defaultInstShortcode])}" class="modalButton">
        	  </g:if>
        	  <g:else>
        	    <a href="#kbmodal" ajax-url="${createLink(controller:'onixplLicenseCompare', action:'index')}" class="modalButton">
        	  </g:else>
        	  <i class="material-icons right">compare</i>Licence Comparison Tool (ONIX-PL)</a>
        	</li>
        </ul>
    </li>
</ul>
