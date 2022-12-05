<%@ page import="com.k_int.kbplus.onixpl.OnixPLService" %>
<g:set var="last_preceding" />
<g:set var="onixPLService" bean="onixPLService"/>


<li>
  <span class="tooltipped card-tooltip" data-position="left" data-delay="50" data-src="${tooltipid}">
    Annotations
  </span>
  <script type="text/html" id="${tooltipid}">
    <div class="kb-tooltip">
      <div class="tooltip-title">Annotations</div>
        <ul class="tooltip-list">
          <g:each var="val" in="${ data }">
            <g:set var="preceding" value="${ onixPLService.formatOnixValue( val.get('AnnotationType')?.get(0)?.get('_content') ) }" />  
            
            <g:if test="${preceding && preceding != last_preceding}" >
              <g:if test="${ last_preceding }" >
                </ul>
              </g:if>
              <li>${ preceding }
                <ul>
                  <li>
                    ${ val.get('AnnotationText')?.get(0)?.get('_content')}
                  </li>
            </g:if>
            <g:else>
              <g:if test="${ preceding != last_preceding }" >
                </ul>
              </g:if>
              <li>
                ${ val.get('AnnotationText')?.get(0)?.get('_content') }
              </li>
            </g:else>
            <g:set var="last_preceding" value="${ preceding }" />
          </g:each>
        </ul>
      </div>
    </div>
  </script>
</li>
