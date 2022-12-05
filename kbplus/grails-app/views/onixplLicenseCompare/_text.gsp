<%@ page import="com.k_int.kbplus.onixpl.OnixPLService" %>
<g:set var="vals" value="${ OnixPLService.sortTextElements(data) }" />
<g:set var="last_preceding" />
<li>
  <span class="tooltipped card-tooltip" data-position="left" data-delay="50" data-src="${tooltipid}">
    <i class="material-icons default">remove_red_eye</i>
  </span>
  <script type="text/html" id="${tooltipid}">
    <div class="kb-tooltip">
      <div class="tooltip-title">Text</div>
        <ul class="tooltip-list">
          <g:each var="val" in="${ vals }">
            <g:set var="preceding" value="${ val.get('TextPreceding')?.get(0)?.get('_content')}" />
            <g:set var="display_num" value="${ val.get('DisplayNumber')?.get(0)?.get('_content')}" />  
                  
            <g:if test="${preceding && preceding != last_preceding}" >
              <g:if test="${ last_preceding }" >
                </ul>
              </g:if>
              <li>${ preceding?.encodeAsRaw() }
                <ul>
                  <li>
                    <g:if test="${display_num}" >
                      ${ display_num?.encodeAsRaw() } - 
                    </g:if>
                    ${ val.get('Text')?.get(0)?.get('_content')?.encodeAsRaw() }
                  </li>
            </g:if>
            <g:else>
              <g:if test="${ preceding != last_preceding }" >
                </ul>
              </g:if>
              <li>
                <g:if test="${display_num}" >
                  ${ display_num?.encodeAsRaw() } - 
                </g:if>
                ${ val.get('Text')?.get(0)?.get('_content')?.encodeAsRaw() }
              </li>
            </g:else>
            <g:set var="last_preceding" value="${ preceding }" />
          </g:each>
        </ul>
      </div>
    </div>
  </script>
</li>
