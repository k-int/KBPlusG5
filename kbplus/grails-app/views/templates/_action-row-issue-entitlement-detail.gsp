<ul class="action-btn-row right">
  <g:if test="${editable}">
      <li>
        <g:if test="${params.defaultInstShortcode}">
          <a href="#kbmodal" ajax-url="${createLink(controller:'issueEntitlement', action:'editIE', id:params.id, params:[defaultInstShortcode:params.defaultInstShortcode])}" class="modalButton btn">
        </g:if>
        <g:else>
          <a href="#kbmodal" ajax-url="${createLink(controller:'issueEntitlement', action:'editIE', id:params.id)}" class="modalButton btn">
        </g:else>
        <i class="material-icons right">create</i>Edit</a>
      </li>
  </g:if>
  <!-- <li><a class="waves-effect waves-light btn last"><i class="material-icons right">help</i>Help</a></li> -->
</ul>
