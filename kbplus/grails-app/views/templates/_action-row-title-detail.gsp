<ul class="action-btn-row right">
  <sec:ifLoggedIn>
    <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_KBPLUS_EDITOR">
      <li>
        <a class='dropdown-button btn' href='#' data-activates='dropdown2'><i class="material-icons right">dehaze</i>Actions &nbsp; &nbsp; </a>

    	<!-- Dropdown Structure -->
    	<ul id='dropdown2' class='dropdown-content'>
      	  <g:if test="${params.defaultInstShortcode}">
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'titleDetails', action:'findTitleMatches', params:[defaultInstShortcode:institution.shortcode])}" class="modalButton"><i class="material-icons right">add_circle_outline</i>Add</a></li>
            <!-- not sure we are allowed to edit titles, maybe remove this? -->
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'titleDetails', action:'editTitle', params:[defaultInstShortcode:params.defaultInstShortcode,id:params.id])}" class="modalButton"><i class="material-icons right">create</i>Edit</a></li>
          </g:if>
          <g:else>
            <!--<li><a href="#kbmodal" ajax-url="${createLink(controller:'titleDetails', action:'findTitleMatches')}" class="modalButton"><i class="material-icons right">add_circle_outline</i>Add</a></li>-->
            <!-- not sure we are allowed to edit titles, maybe remove this? -->
            <li><a href="#kbmodal" ajax-url="${createLink(controller:'titleDetails', action:'editTitle', params:[id:params.id])}" class="modalButton"><i class="material-icons right">create</i>Edit</a></li>
          </g:else>
        </ul>
      </li>
    </sec:ifAnyGranted>
  </sec:ifLoggedIn>
</ul>
