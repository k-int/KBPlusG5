<ul class="action-btn-row right">
  <g:if test="${editable}">
    <li><a href="#kbmodal" ajax-url="${createLink(controller:'tipp', action:'edit', id:tipp.id)}" class="waves-effect waves-light btn last modalButton"><i class="material-icons right">create</i>Edit</a></li>
  </g:if>
</ul>
