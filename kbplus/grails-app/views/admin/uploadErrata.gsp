<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <title>KB+ Admin::Errata Upload</title>
    <parameter name="pagetitle" value="Import Errata" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
  </head>
  <body class="admin">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">Import Errata</h1>
      </div>
    </div>
    <!--page title end-->
    
    <g:if test="${hasStarted}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel blue lighten-1">
            <span class="white-text"><g:message code="admin.upload.issnL" default="CSV Processing has started in the background and will not require intervention"></g:message></span>
          </div>
        </div>
      </div>
    </g:if>
    
    <!--page intro and error start-->
    <div class="row">
      <div class="col s12">
        <div class="row strip-table z-depth-1">
          <ul class="collection">
            <li class="collection-item">Upload a file of tab separated equivalent identifiers. By default, the assumption is ISSN to ISSN-L mappings</li>
            <li class="collection-item">Upload a .csv file formatted as: org_name, sector, id.type...,affiliation.role...,role,</li>
          </ul>
        </div>
      </div>
    </div>
    
    <g:form action="uploadErrata" method="post" enctype="multipart/form-data">  
      <div class="row">
        <div class="col s12">
          <div class="row tab-table z-depth-1">   
            <!--***table***-->
            <div class="tab-content">
              <div class="row table-responsive-scroll">
                <table class="highlight bordered ">
                  <tbody>
                    <tr>
                      <td>Example Header Row:</td>
                      <td>error.identifier</td>
                      <td>context.title</td>
                      <td>correction.identifier</td>
                      <td>comment</td>
                    </tr>
                    <tr>
                      <td>Example Data Row:</td>
                      <td>issn:1234-5678</td>
                      <td>The actual title</td>
                      <td>eissn:1234-5678</td>
                      <td>Title "The actual title" commonly appears with the incorrect issn:1234-5678, that identifier is really an eissn</td>
                    </tr>
                    <tr>
                      <td>Example Data Row:</td>
                      <td>eissn:8765-4321</td>
                      <td>The actual title</td>
                      <td>issn:8765-4321</td>
                      <td>Title "The actual title" commonly appears with the incorrect eissn:8765-4321, that identifier is really an issn(To </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
            <!--***table end***-->
          </div>
        </div>
      </div>
      
      <div class="row">
          <div class="row tab-table z-depth-1">
            <div class="file-field input-field col s10">
              <div class="btn">
                <span>File <i class="material-icons">add_circle_outline</i></span>
                <input type="file" name="eratta">
              </div>
              <div class="file-path-wrapper">
                <input class="file-path validate" type="text" placeholder="Upload Errata">
              </div>
            </div>
            <div class="file-field input-field col s1">
              <button class="waves-effect waves-light btn" name="load" type="submit" value="Go">Upload</button>
            </div>
          </div>
      </div>
    </g:form>
    
    <!--legacy
    <div class="container">
      <div class="span12">
        <h1>Import Errata</h1>
      <g:if test="${hasStarted}">
        <div class="container">
            <bootstrap:alert id="procesing_alert" class="alert-info"><g:message code="admin.upload.issnL" default="CSV Processing has started in the background and will not require intervention"></g:message> </bootstrap:alert>
        </div>
      </g:if>
        <p>Upload a file of tab separated equivalent identifiers. By default, the assumption is ISSN -&gt; ISSNL mappings</p>

        <g:form action="uploadErrata" method="post" enctype="multipart/form-data">

          <p>
            Upload a .csv file formatted as<br/>
            org_name, sector, id.type...,affiliation.role...,role,</br>
            <table class="table">
              <tr>
                <td>Example Header Row:</td>
                <td>error.identifier</td>
                <td>context.title,</td>
                <td>correction.identifier</td>
                <td>comment</td>
              </tr>
              <tr>
                <td>Example Data Row:</td>
                <td>issn:1234-5678</td>
                <td>The actual title</td>
                <td>eissn:1234-5678</td>
                <td>Title "The actual title" commonly appears with the incorrect issn:1234-5678, that identifier is really an eissn</td>
              </tr>
              <tr>
                <td>Example Data Row:</td>
                <td>eissn:8765-4321</td>
                <td>The actual title</td>
                <td>issn:8765-4321</td>
                <td>Title "The actual title" commonly appears with the incorrect eissn:8765-4321, that identifier is really an issn(To </td>
              </tr>
            </table>

            <dl>
              <div class="control-group">
                <dt>Upload Errata</dt>
                <dd>
                  <input type="file" name="eratta" />
                </dd>
              </div>
              <button name="load" type="submit" value="Go">Upload...</button>
            </dl>
          </p>
        </g:form>
      </div>
    </div>
    -->
  </body>
</html>
