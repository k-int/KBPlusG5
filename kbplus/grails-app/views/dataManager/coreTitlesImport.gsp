<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <title>KB+ Data Manager::Title Import</title>
    <parameter name="pagetitle" value="Core Title Import" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
  </head>
  <body class="admin">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">Core Titles Import - Add Core Dates</h1>
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
    <g:form action="coreTitlesImport" method="post" enctype="multipart/form-data">
      <div class="row">
        <div class="col s12">
          <div class="row strip-table z-depth-1">
            <div class="file-field input-field col s12">
              <div class="btn">
                <span>File <i class="material-icons">add_circle_outline</i></span>
                <input type="file" name="titles_file" >
              </div>
              <div class="file-path-wrapper">
                <input class="file-path validate" type="text" placeholder="Titles CSV File">
              </div>
            </div>
          </div>
        </div>
      </div>
    
      <div class="row">
        <div class="col s12">
    	  <div class="row strip-table z-depth-1">
		    <div class="input-field col s12">
			  <input type="text" id="subId" name="subId" value="${params.subId}" placeholder="Subscription Id">
			  <label for="subId" class="active">In Subscription</label>
		    </div>
			<div class="input-field col s12">
			  <button type="submit" class="waves-effect waves-light btn">Upload</button>
			</div>
		  </div>
	    </div>
	  </div>
    </g:form>
    
    <!--page intro-->
    <div class="row">
      <div class="col s12">
        <div class="row strip-table z-depth-1">
          <div class="col s12">
            <ul class="collection">
              <li class="collection-item">CSV upload of core titles requires a column containing either the ISSN or eISSN of each title, as well as a column with the core start date.</li>
              <li class="collection-item">For the id column, the title needs to be 'Identifier' and each id value should be preceded with either 'issn:' or 'eissn:'.</li>
              <li class="collection-item">The start date column should have the title 'coreStart' and each date should have the format 'yyyy-MM-dd'.</li>
              <li class="collection-item">The column for end dates should have the title 'coreEnd', but having an end date value for core titles is optional and can be left blank.</li>
              <li class="collection-item">A Subscription Id input is required. If core titles need to be added to multiple subscriptions then it will need to be done over multiple uploads.</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
