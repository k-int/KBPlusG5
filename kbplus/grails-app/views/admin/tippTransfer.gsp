<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <parameter name="pagetitle" value="TIPP Transfer" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
    <title>KB+ Admin::TIPP Transfer</title>
  </head>
  <body class="admin">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">TIPP Transfer</h1>
      </div>
    </div>
    <!--page title end-->
    
    <g:each in="${error}" var="err">
      <div class="row">
        <div class="col s12">
          <div class="card-panel red lighten-1">
            <span class="white-text">${err}</span>
          </div>
        </div>
      </div>
    </g:each>
    
    <g:if test="${success}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel blue lighten-1">
            <span class="white-text">Transfer Successful</span>
          </div>
        </div>
      </div>
    </g:if>
    
    <div class="row">
      <div class="col s12">
        <div class="row strip-table z-depth-1">
          <g:form action="tippTransfer" method="get"> 
            <p class="title">Add the appropriate ID's below. All IssueEntitlements of source will be removed and transfered to target. Detailed information and confirmation will be presented before proceeding</p>
            <div class="row admin-form">
              <div class="input-field col s6">
                <input type="text" class="validate" id="sourceTIPP" name="sourceTIPP" value="${params.sourceTIPP}">
                <label for="sourceTIPP">Database ID of TIPP</label>
              </div>
              <div class="input-field col s6">
                <input  type="text" class="validate" id="targetTI" name="targetTI" value="${params.targetTI}">
                <label for="targetTI">Database ID of target TitleInstance</label>
              </div>
            </div>
            <button onclick="return confirm('Any existing TIs on TIPP will be replaced. Continue?')" type="submit" class="waves-effect waves-light btn">Transfer</button>
          </g:form>
        </div>
      </div>
    </div>

    <!--legacy-->
    <!-- <div class="container">
    <h1>TIPP Transfer</h1>

        <g:each in="${error}" var="err">
          <bootstrap:alert class="alert-danger">${err}</bootstrap:alert>
        </g:each>

        <g:if test="${success}">
          <bootstrap:alert class="alert-info">Transfer Sucessful</bootstrap:alert>
        </g:if>

        <g:form action="tippTransfer" method="get">
          <p>Add the appropriate ID's below. All IssueEntitlements of source will be removed and transfered to target. Detailed information and confirmation will be presented before proceeding</p>
          <dl>
            <div class="control-group">
              <dt>Database ID of TIPP</dt>
              <dd>
                <input type="text" name="sourceTIPP" value="${params.sourceTIPP}" />

              </dd>
            </div>

            <div class="control-group">
              <dt>Database ID of target TitleInstance</dt>
              <dd>
                <input type="text" name="targetTI" value="${params.targetTI}"/>
              </dd>
            </div>
    
              <button onclick="return confirm('Any existing TIs on TIPP will be replaced. Continue?')" class="btn-success" type="submit">Transfer</button>
          </dl>
        </g:form>
      </div>
    </div>   -->
    <!--legacy end-->

  </body>
</html>