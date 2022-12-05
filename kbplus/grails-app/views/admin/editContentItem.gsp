<!doctype html>
<html>

<head>
  <parameter name="pagetitle" value="KB+ Manage Content Items" />
  <parameter name="pagestyle" value="Admin" />
  <parameter name="actionrow" value="none" />
  <meta name="layout" content="base"/>
</head>


  <body class="admin">

 <!--page title start-->
  <div class="row">
      <div class="col s12 l12">
          <h1 class="page-title left">Edit Content Items</h1>
      </div>
  </div>
  <!--page title end-->

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


    <div class="row">
        <div class="col s12">
          <div class="row strip-table z-depth-1">
            <g:form action="editContentItem" id="${params.id}">
              <p class="title">Add the appropriate ID's below. Detailed information and confirmation will be presented before proceeding</p>

              <div class="row admin-form">
                  <div class="input-field col s6">
                    <input id="_key" placeholder="Key" type="text" class="validate" readonly name="orgIdToDeprecate" value="${contentItem?.key}">
                    <label for="_key">Key</label>
                  </div>
                  <div class="input-field col s6">
                    <input id="_locale" placeholder="Locale" type="text" class="validate" name="correctOrgId" readonly value="${params.correctOrgId}">
                    <label for="_locale">Locale</label>
                  </div>
              </div>

              <div class="row admin-form">
                  <div class="input-field col s12">
                    <textarea id="_content" name="content" rows="5" class="materialize-textarea">${contentItem?.content}</textarea>
                    <label for="_content">Content (Markdown)</label>
                  </div>
              </div>

              <button type="submit" value="Submit" class="waves-effect waves-light btn">Submit</button>

            </g:form>
          </div>
        </div>
    </div>


  <!-- Legacy -->
    <!-- <div class="container">
        <ul class="breadcrumb">
           <li> <g:link controller="home">KBPlus</g:link> <span class="divider">/</span> </li>
           <li>Content Items</li>
        </ul>
    </div>

    <g:if test="${flash.message}">
      <div class="container">
        <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
      </div>
    </g:if>

    <g:if test="${flash.error}">
      <div class="container">
        <bootstrap:alert class="error-info">${flash.error}</bootstrap:alert>
      </div>
    </g:if>


    <div class="container">
      <g:form action="editContentItem" id="${params.id}">
        <dl>
          <dt>Key</dt>
          <dd>${contentItem?.key}</dd>
          <dt>Locale</dt>
          <dd>${contentItem?.locale}</dd>
          <dt>Content (Markdown)</dt>
          <dd><textarea name="content" rows="5">${contentItem?.content}</textarea></dd>
        </dl>
        <input type="submit" class="btn btn-primary"/>
      </g:form>
    </div> -->

  <!-- end of legacy -->
  </body>
</html>
