<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <title>KB+ Admin::Title Import</title>
    <parameter name="pagetitle" value="Title Import" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
  </head>
  <body class="admin">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">Titles Import - Create/Add Identifiers</h1>
      </div>
    </div>
    <!--page title end-->
    
    <div class="row">
      <div class="col s12">
        <div class="row strip-table z-depth-1">
          <g:form action="titlesImport" method="post" enctype="multipart/form-data">
            <div class="file-field input-field col s10">
              <div class="btn">
                <span>File <i class="material-icons">add_circle_outline</i></span>
                <input type="file" name="titles_file" >
              </div>
              <div class="file-path-wrapper">
                <input class="file-path validate" type="text" placeholder="Titles CSV File">
              </div>
            </div>
            <div class="file-field input-field col s1">
              <button class="waves-effect waves-light btn" name="load" type="submit" value="Go">Upload</button>
            </div>
          </g:form>
        </div>
      </div>
    </div>
    
    <!--page intro-->
    <div class="row">
      <div class="col s12">
        <div class="row strip-table z-depth-1">
          <div class="col s12">
            <ul class="collection">
              <li class="collection-item">This form allows an administrator to upload a CSV of titles containing one or more identifiers and titles. If a title can be uniquely matched using any/all of the identifiers then any missing identifiers will be added. If multiple identifiers match different titles no update will be made. If the identifiers do not match any existing titles, and the file includes a 'title.title' column, a new journal title record is created.</li>
              <li class="collection-item">Currently there is no error reporting for this upload.</li>
              <li class="collection-item">At the end, a bad file is available for corrections and re-ingest</li>
              <li class="collection-item">Upload a .csv file with any combination of the following columns. For titles to be created the 'title.title' column must be present. If there is no 'title.title' column, new titles will not be created, and only identifier enrichment (for matched titles) will be processed.<br/>The columns supported are: title.title,title.id,title.id.namespace</li>
              <li class="collection-item">The last of these can be repeated for each type of identifier in the file, with the 'namespace' being replaced by the type of identifier (e.g. title.id.ISSN, title.id.eISSN)<br/>N.B. The 'namespace' must be exactly the same as the namespace already used in the system for identifiers to match successfully. This is case-sensitive.</li>
              <li class="collection-item">Example header "title.id","title.title","title.id.Ringold","title.id.Ingenta",'title.id.ISSN','title.id.eISSN','title.id.jusp','title.id.zdb'</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
