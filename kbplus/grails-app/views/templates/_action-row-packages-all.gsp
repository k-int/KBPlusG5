<g:set var="act_pkg_params_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
<ul class="action-btn-row right">
  <li><a href="#kbmodal" class="waves-effect waves-light btn last modalButton" ajax-url="${createLink(controller:'packageDetails', action:'compareModal', params:act_pkg_params_sc)}"><i class="material-icons right">compare</i>Compare</a></li>
</ul>
