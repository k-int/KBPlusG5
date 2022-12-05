<g:set var="pfm_params_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
<ul class="action-btn-row right">
  <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_KBPLUS_EDITOR">
    <li><a href="#kbmodal" ajax-url="${createLink(controller:'platform', action:'create', params:pfm_params_sc)}" class="waves-effect waves-light btn last modalButton"><i class="material-icons right">compare</i>Add</a></li>
  </sec:ifAnyGranted>
</ul>
