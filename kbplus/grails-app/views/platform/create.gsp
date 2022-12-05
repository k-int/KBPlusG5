<div class="container" data-theme="subscriptions">
  <div class="row">
    <div class="col s12">
      <h1 class="form-title flow-text navy-text">Add New Platform</h1>
      <p class="form-caption flow-text grey-text">This form will create a new empty platform</p>
      <div class="row">
        <g:form class="col s12" controller="platform" action="create">
          <g:if test="${params.defaultInstShortcode}">
            <input type="hidden" name="defaultInstShortcode" value="${params.defaultInstShortcode}"/>
          </g:if>
          <div class="row">
            <div class="input-field col s12">
              <input type="text" id="name" name="name" value="${params.name}" />
              <label for="name">Name</label>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <input type="text" id="primaryUrl" name="primaryUrl" value="${params.primaryUrl}" />
              <label for="primaryUrl">Primary URL</label>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <input type="submit" class="waves-effect waves-light btn" value="Create"/>
            </div>
          </div>
        </g:form>
      </div>
    </div>
  </div>
</div>