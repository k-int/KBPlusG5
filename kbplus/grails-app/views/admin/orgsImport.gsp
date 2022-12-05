<!doctype html>
<html>
<head>
  <meta name="layout" content="base"/>
  <title>KB+ Import Organisations</title>
  <r:require module='annotations' />
  <parameter name="pagetitle" value="Import Organisations" />
  <parameter name="pagestyle" value="admin" />
</head>

  <body class="admin">
        <!--page title start-->
  <div class="row">
       <div class="col s12 l12">
          <h1 class="page-title left">KB+ Import Organisations</h1>
       </div>
    </div>

    <!--page title end-->

  <g:if test="${flash.message}">
      <div class="row">
          <div class="col s12">
              <div class="card-panel red lighten-1">
                  <span id="alert-info" class="white-text">${flash.message}</span>
              </div>
          </div>
      </div>
  </g:if>

  <g:if test="${flash.error}">
      <div class="row">
          <div class="col s12">
              <div class="card-panel red lighten-1">
                  <span class="white-text">${flash.error}</span>
              </div>
          </div>
      </div>
  </g:if>

    <!--page intro and error start-->
    <div class="row">
      <div class="col s12">
          <div class="row strip-table z-depth-1">
            <div class="col m12 title">
              <p>Upload a .csv file formatted as per the example below (10 columns, layout is mandatory, blank cells or "" indicate no value</p>
            </div>
          </div>
      </div>
    </div>
    <!--page intro and error start-->

    <div class="row">
      <div class="col s12">
          <div class="row strip-table z-depth-1">
            <g:form name="orgsUploadForm" action="orgsImport" method="post" enctype="multipart/form-data">
                <div class="file-field input-field col s10">
                  <div class="btn">
                      <span>File <i class="material-icons">add_circle_outline</i></span>
                      <input type="file" name="orgs_file" >
                  </div>
                  <div class="file-path-wrapper">
                    <input class="file-path validate" type="text" placeholder="Orgs CSV File">
                  </div>
                </div>
                <div class="file-field input-field col s1">
                <button id="uploadOrgsCSV" class="waves-effect waves-light btn" name="load" type="submit" value="Go">Upload</button>
                </div>
            </g:form>
          </div>
        </div>
    </div>

        <!--***tabular data***-->
        <div class="row">

          <div class="col s12">
            <div class="tab-table z-depth-1">
              <h3>Example Structure</h3>
            <!--***table***-->
              <div id="financials" class="tab-content">

                   <div class="row table-responsive-scroll">

                        <table class="highlight bordered ">
                            <thead>
                              <tr>
                                <td>Example Header Row:</td>
                                <td>name,</td>
                                <td>sector,</td>
                                <td>org.consortium,</td>
                                <td>id.jusplogin</td>
                                <td>id.jusp</td>
                                <td>id.JC</td>
                                <td>id.Ringold</td>
                                <td>id.UKAMF</td>
                                <td>iprange</td>
                                <td>membershipOrgYesNo</td>
                              </tr>
                            </thead>

                            <tbody>
                    <tr>
                      <td>Type/Values</td>
                      <td>String</td>
                      <td>"Higher Education"</td>
                      <td>String - consortia name</td>
                      <td>Identifier</td>
                      <td>Identifier</td>
                      <td>Identifier</td>
                      <td>Identifier</td>
                      <td>Identifier</td>
                      <td>String - IPRange</td>
                      <td>Yes|No</td>
                    </tr>
                    <tr>
                      <td>Example Body Row:</td>
                      <td>"Some inst",</td>
                      <td>"Higher Education",</td>
                      <td>"JISC Collections",</td>
                      <td>"",</td>
                      <td>"",</td>
                      <td>"",</td>
                      <td>"",</td>
                      <td>"",</td>
                      <td>"n.n.n.n,n.n.n.n"</td>
                      <td>"Yes"</td>
                    </tr>
                    </tbody>
                  </table>
                </div>
              </div>
              <!--***table end***-->

</body>
</html>
