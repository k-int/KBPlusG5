<ul class="action-btn-row right">
  <li>
    <g:link class="waves-effect waves-light btn" controller="profile" action="index"><i class="material-icons right">account_circle</i>Profile</g:link>
  </li>
  <li>
    <g:link controller="organisations" class="waves-effect waves-light btn last" action="show" params="${[id:institution?.id]}"><i class="material-icons right">business</i>Organisation</g:link>
  </li>
</ul>
