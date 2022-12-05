<!doctype html>
<html>
  <head>
    <meta name="layout" content="base">
    <parameter name="pagetitle" value="Create New Template Licence" />
    <title>KB+ :: Create New Template Licence</title>
  </head>

  <body class="licences">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">Create New Template Licence</h1>
      </div>
    </div>
    <!--page title end-->

    <!-- Error messages -->
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
    <!-- Error messages end -->

    <div class="row">
      <div class="col s12">
        <div class="row strip-table z-depth-1">
          <div class="col s12">
            <p>Use this form to create a new template licence. Enter the new licence reference below, click "create" and you will be redirected to the new licence</p>
          </div>
          <!-- Form -->
          <g:form controller="licenseDetails" action="processNewTemplateLicense" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">
            <div class="row">
              <div class="input-field col s12">
                <input type="text" id="reference" name="reference"/>
                <label for="reference">New Licence Reference</label>
              </div>
            </div>

            <div class="row">
              <div class="input-field col s12">
                <input type="submit" class="btn btn-success" value="Create"/>
              </div>
            </div>
          </g:form>
        </div>
      </div>
    </div>
    <!-- End Form -->
  </body>
</html>
