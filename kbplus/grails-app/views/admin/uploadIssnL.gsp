<!doctype html>
<html>
<head>
  <meta name="layout" content="base"/>
  <title>KB+ Admin::Identifier Same-As Upload</title>
    <parameter name="pagetitle" value="Import ISSN L" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
    <r:require module='annotations' />
</head>

  <body class="admin">
        <!--page title start-->
  <div class="row">
       <div class="col s12 l12">
          <h1 class="page-title left">Import ISSN L</h1>
       </div>
    </div>
    <!--page title end-->

    <g:if test="${hasStarted}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel blue lighten-1">
            <span class="white-text"><g:message code="admin.upload.issnL" default="admin.upload.issnL=CSV Processing has started in the background and will not require intervention"></g:message> </span>
          </div>
        </div>
      </div>
    </g:if>


    <!--page intro and error start-->

    <div class="row">
        <div class="col s12">
            <div class="row strip-table z-depth-1">
               
                <p class="title">Upload a file of tab separated equivalent identifiers. By default, the assumption is ISSN to ISSN-L mappings</p>

            </div>
        </div>
    </div>  


    <g:form action="uploadIssnL" method="post" enctype="multipart/form-data">
      
        <div class="row">
            <div class="col s12">
                <div class="row tab-table z-depth-1">
                  <g:form action="uploadIssnL" method="post" enctype="multipart/form-data">
                  <div class="file-field input-field col s11">
                    <div class="btn">
                        <span>File <i class="material-icons">add_circle_outline</i></span>
                        <input type="file" name="sameasfile">
                    </div>
                    <div class="file-path-wrapper">
                      <input class="file-path validate" type="text" placeholder="Upload ISSN to ISSN-L mapping file">
                    </div>
                  </div>
                  <div class="file-field input-field col s1">
                  <button class="waves-effect waves-light btn" name="load" type="submit" value="Go">Upload</button>
                  </div>
                  </g:form>
               </div>
            </div>
        </div>     

      </g:form>


    <!--page intro and error start-->


      </div>
    </div>
  </body>
</html>
