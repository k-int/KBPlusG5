<ul class="action-btn-row right">
    <li>
      <g:link class="waves-effect waves-light btn"
              controller="profile" 
              action="index"
              params="${[defaultInstShortcode:params.defaultInstShortcode]}"><i class="material-icons right">account_circle</i>Profile</g:link>
    </li>
    <li>
      <g:link controller="organisations"
              class="waves-effect waves-light btn "
              action="show"
              params="${[id:institution?.id, defaultInstShortcode:params.defaultInstShortcode]}"><i class="material-icons right">business</i>Organisation</g:link>
    </li>
    <li>
      <g:link class="waves-effect waves-light btn last"
              controller="logout"><i class="material-icons right">exit_to_app</i>Log out</g:link>
    </li>
</ul>
