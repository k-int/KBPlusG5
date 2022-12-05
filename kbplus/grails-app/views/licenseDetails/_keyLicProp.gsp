<g:set var="key_nonce" value="${java.util.UUID.randomUUID().toString()}"/>
<div class="col s6 m4 licenceproperties">
  <div class="circular-image ${(propdata[2] != null) ? 'tooltipped card-tooltip' : ''}" 
       data-delay="50" 
       data-position="right" 
       data-src="${key_nonce}"><i class="medium material-icons icon-grey">${icon}</i><i class="material-icons icon-offset ${propdata[0]}">${propdata[1]}</i></div>
  ${propname}
  <g:if test="${propdata[2] != null}">
    <script type="text/html" id="${key_nonce}">
      <div class="kb-tooltip">
        <div class="tooltip-title">${propname}</div>
        <ul class="tooltip-list">
          <li>${propdata[2]}</li>
        </ul>
      </div>
    </script>
  </g:if>
</div>
