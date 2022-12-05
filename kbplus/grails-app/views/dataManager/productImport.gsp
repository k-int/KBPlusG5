<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <title>KB+ Data Manager::Product Import</title>
    <parameter name="pagetitle" value="Product Import" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
  </head>
  <body class="admin">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">Import Products with links to packages</h1>
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
    <g:form action="productImport" method="post" enctype="multipart/form-data">
      <div class="row">
        <div class="col s12">
          <div class="row strip-table z-depth-1">
            <div class="file-field input-field col s12">
              <div class="btn">
                <span>File <i class="material-icons">add_circle_outline</i></span>
                <input type="file" name="products_file" >
              </div>
              <div class="file-path-wrapper">
                <input class="file-path validate" type="text" placeholder="Product CSV File">
              </div>
            </div>
          </div>
        </div>
      </div>
    
      <div class="row">
        <div class="col s12">
    	  <div class="row strip-table z-depth-1">
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
              <li class="collection-item">CSV upload requires a column containing the Product name with title 'Product' and an Id in column 'Identifier'.</li>
              <li class="collection-item">Products can optionally be added to a package by putting the relevant Package id in a 'Package' column.</li>
          	  <li class="collection-item">If the product is being added to multiple packages, repeat the product information and add only a single package per row.</li>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
