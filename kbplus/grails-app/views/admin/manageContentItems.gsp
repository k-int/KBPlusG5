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
        <h1 class="page-title left">Manage Content Items</h1>
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
        <div class="row tab-table z-depth-1 nobreak">
        <!--***table***-->
          <div class="tab-content">
            <div class="row table-responsive-scroll">
              <table class="highlight bordered ">
                <thead>
                  <tr>
                    <td class="w150">Key</td>
                    <td class="w150">Locale</td>
                    <td>Content</td>
                    <td class="w100">Actions</td>
                  </tr>
                </thead>
                <tbody>
                  <g:each in="${items}" var="item">
                    <tr>
                      <td class="w150">${item.key}</td>
                      <td class="w150">${item.locale}</td>
                      <td>${item.content}</td>
                      <td class="w100"><g:link action="editContentItem" id="${item.id}" class="btn-floating table-action"><i class="material-icons">create</i></g:link></td>
                    </tr>
                  </g:each>
                </tbody>
              </table>
            </div>
          </div>          
        </div>
      </div>
    </div>
    
    <div class="row">
      <div class="col s12">
        <div class="mobile-collapsible-header" data-collapsible="packages-list-collapsible">Create <i class="material-icons">expand_more</i></div>
        <div class="search-section z-depth-1 mobile-collapsible-body" id="packages-list-collapsible">
          <div class="col s12 mb-20">
            <h3 class="page-title mt-20 ml-10">Create Content Item</h3>
          </div>
            
          <!--form-->
          <div class="row">
            <g:form action="newContentItem" class="col s12">    
              <div class="row">
                <div class="input-field col s6">
                  <input id="newkey" name="key" type="text"/>
                  <label for="newkey">New Content Item Key</label>
                </div>
                <div class="input-field col s6">
                  <select>
                    <option value="" selected>No Locale (Default)</option>
                    <option value="en_GB">British English</option>
                    <option value="es">Español</option>
                    <option value="fr">Français</option>
                    <option value="it">Italiano</option>
                    <option value="ja">日本人</option>
                    <option value="zn-CH">中国的</option>
                    <option value="en_US">US English</option>
                  </select>
                  <label>New Content Item Locale (Or blank for none)</label>
                </div>
              </div>
                           
              <div class="row">
                <div class="input-field col s12">
                  <textarea name="content" rows="5" id="content_markdown" class="materialize-textarea"></textarea>
                  <label for="content_markdown">New Content (Markdown)</label>
                </div>
              </div>
              
              <div class="row">
                <div class="input-field col s12">
                  <input type="submit" value="Create" class="btn btn-primary"/>
                </div>
              </div>
            </g:form>
          </div>
          <!--form end-->
        </div>
      </div>
    </div>

<!-- LEGACY

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


    <div class="container-fluid">
      <div class="row-fluid">
        <div class="span9">
          <table id="ContentItemsTable" class="table table-bordered">
	        <thead>
              <tr>
                <td>Key</td>
                <td>Locale</td>
                <td>Actions</td>
              </tr>
              <tr>
                <td colspan="3">Content</td>
              </tr>
            </thead>
            <tbody>
              <g:each in="${items}" var="item">
                <tr>
                  <td>${item.key}</td>
                  <td>${item.locale}</td>
	          <td><g:link action="editContentItem" id="${item.id}">Edit</g:link></td>
	        </tr>
                <tr>
                  <td colspan="3">${item.content}</td>
	        </tr>
	      </g:each>
	    </tbody>
	  </table>
	</div>
        <div class="span3">
          <g:form action="newContentItem">
            <dl>
              <dt>New Content Item Key</dt>
              <dd><input name="key" type="text"/></dd>

              <dt>New Content Item Locale (Or blank for none)</dt>
              <dd><select name="locale">
                    <option value="">No Locale (Default)</option>
                    <option value="en_GB">British English</option>
                    <option value="es">Español</option>
                    <option value="fr">Français</option>
                    <option value="it">Italiano</option>
                    <option value="ja">日本人</option>
                    <option value="zn-CH">中国的</option>
                    <option value="en_US">US English</option>
                  </select></dd>
              <dt>New Content (Markdown)</dt>
              <dd><textarea name="content" rows="5"></textarea></dd>
            </dl>
            <input type="submit" value="Create" class="btn btn-primary"/>
          </g:form>
        </div>
      </div>
    </div> 

LEGACY END-->

  </body>
</html>
