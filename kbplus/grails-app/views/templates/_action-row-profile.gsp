<ul class="action-btn-row right">
  <g:if test="${institution}">
      <li>
        <g:link controller="organisations"
                class="waves-effect waves-light btn "
                action="show"
                id="${institution?.id}"
                params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"><i class="material-icons right">business</i>Organisation</g:link>
      </li>
	</g:if>
    <li>
      <g:link class="waves-effect waves-light btn last"
              controller="logout"><i class="material-icons right">exit_to_app</i>Log out</g:link>
    </li>
</ul>
