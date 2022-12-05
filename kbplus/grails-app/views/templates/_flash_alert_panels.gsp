<g:if test="${flash.message}">
  <div class="row">
    <div class="col s12">
      <div class="card-panel blue lighten-1">
        <span class="white-text"> ${flash.message}</span>
      </div>
    </div>
  </div>
</g:if>

<g:if test="${flash.error}">
  <div class="row">
    <div class="col s12">
      <div class="card-panel red lighten-1">
        <span class="white-text"> ${flash.error}</span>
      </div>
    </div>
  </div>
</g:if>

