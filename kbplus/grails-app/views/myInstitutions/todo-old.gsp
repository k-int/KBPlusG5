<div class="container home-page">
  <table class="table">
    <g:each in="${todos}" var="todo">
      <tr>
        <td>
          <strong>
                      <g:if test="${todo.item_with_changes instanceof com.k_int.kbplus.Subscription}">
                        <g:link controller="subscriptionDetails" action="index" id="${todo.item_with_changes.id}">${message(code:'subscription')}: ${todo.item_with_changes.toString()}</g:link>
                      </g:if>
                      <g:else>
                        <g:link controller="licenseDetails" action="index" id="${todo.item_with_changes.id}">${message(code:'licence')}: ${todo.item_with_changes.toString()}</g:link>
                      </g:else>
          </strong><br/>
          <span class="badge badge-warning">${todo.num_changes}</span> 
          <span>Change(s) between <g:formatDate date="${todo.earliest}" format="yyyy-MM-dd hh:mm a"/></span>
          <span>and <g:formatDate date="${todo.latest}" format="yyyy-MM-dd hh:mm a"/></span><br/>
        </td>
      </tr>
    </g:each>
  </table>
</div>
