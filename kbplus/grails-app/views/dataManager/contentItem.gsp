<%@ page import="java.util.Locale"%>

<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <parameter name="pagetitle" value="Data Manager :: Content management" />
    <parameter name="pagestyle" value="data-manager" />
    <title>KB+ Data Manager :: Content Management</title>
  </head>

  <body class="data-manager">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">Data Manager :: Current translations and labels for ${params.id}</h1>
      </div>
    </div>
    <!--page title end-->
    
    <div id="content-item-forms" >
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
        <div class="col s12 tab-table z-depth-1">
          <h2>Existing translations for ${params.id}</h2>
          <g:if test="${contentItems?.size()==0}">
            <p style="text-align:center">No Translations for ${params.id} yet. Please add below.</p>
          </g:if>
          <g:else>
            <div class="table-responsive-scroll">
              <table class="highlight bordered ">
                <thead>
                  <tr>
                    <th>Locale</th>
                    <th>Text</th>
                  </tr>
                </thead>
                <tbody>
                  <g:each in="${contentItems}" var="ci">
                    <tr>
                      <td>${ci.locale}</td>
                      <td>
                        <g:form action="updateContent" id="${params.id}" name="${params.id}" >
                          <input type="hidden" name="locale" value="${ci.locale}" />
                          <input type="text" name="content" value="${ci.content}" />
                          <input type="submit" name="update" class="waves-effect btn" value="Update" />
                          <input type="submit" name="delete" class="waves-effect btn" value="Delete"
                            onClick="return confirm('Are you sure you want to delete the ${ci.locale} translation for ${ci.key}')" />
                        </g:form>
                      </td>
                    </tr>
                  </g:each>
                </tbody>
              </table>
            </div>
          </g:else>
        </div>
      </div>
      
      <g:if test="${(otherLocales?.size() ?: 0) > 0}">
        <g:form action="updateContent" id="${params.id}" name="${params.id}" class="row" >
          <div class="col s12 tab-table z-depth-1">
            <h2>Add a new translation for ${params.id}</h2>
            <div class="table-responsive-scroll">
              <table class="highlight bordered ">
                <thead>
                  <tr>
                    <th>Locale</th>
                    <th colspan="2" >Text</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>
                      <div class="input-field">
                        <select name="locale" class="not-browser-default">
                          <g:each in="${otherLocales}" var="ol">
                            <option value="${ol}" ${ol=='en_GB' ? 'selected' : ''}>${ol?:'DEFAULT'}</option>
                          </g:each>
                        </select>
                      </div>
                    </td>
                    <td>
                      <div class="input-field">
                        <input type="text" name="content" value="" />
                      </div>
                    </td>
                    <td><input type="submit" class="waves-effect btn" value="Add Translation" /></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </g:form>
      </g:if>
  	</div>
  </body>
</html>
