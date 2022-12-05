<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
      <parameter name="pagetitle" value="Import Financials Data" />
      <parameter name="pagestyle" value="Admin" />
      <parameter name="actionrow" value="none" />
      <title>KB+ Admin::Identifier Same-As Upload</title>
  </head>

  <body class="admin">


       <!--page title start-->
       <div class="row">
           <div class="col s12 l12">
               <h1 class="page-title left">Import Financials Data</h1>
           </div>
       </div>
       <!--page title end-->

       <!--page intro and error start-->
       <div class="row">
           <div class="col s12">
               <div class="row tab-table z-depth-1">
                   <g:if test="${loaderResult==null}">
                    <g:form action="financeImport" method="post" enctype="multipart/form-data">

                    <div class="admin">

                      <div class="file-field input-field">

                        <div class="btn">
                            <span>File <i class="material-icons">add_circle_outline</i></span>
                            <input type="file" name="tsvfile">
                        </div>

                        <div class="file-path-wrapper">
                          <input class="file-path validate" type="text" placeholder="Upload TSV File according to the column definitions above">
                        </div>

                      </div>

                      <div class="input-field ">
                          <input type="checkbox" id="test5" />
                          <label for="test5">Dry Run</label>
                      </div>

                      <div class="input-field ">
                          <button name="load" type="submit" value="Go" class="waves-effect waves-light btn">Upload...</button>
                      </div>

                    </div>

                  </g:form>
                </g:if>
              </div>
            </div>
          </div>

                <!--***table***-->
                <div class="row">
                  <div class="col s12">
                     <div class="row tab-table z-depth-1">
                  <div class="tab-content">
                    <p class="title">This service allows administrators to bulk load cost item records. It understands the following column mappings in the uploaded .tsv file</p>
                       <div class="row table-responsive-scroll">
                            <table class="highlight bordered">
                                <thead>
                                  <tr>
                                      <th>tsv column name</th>
                                      <th>Description</th>
                                      <th>maps to</th>
                                  </tr>
                                </thead>

                                <tbody>
                                  <tr>
                                    <td>Example Header Row:</td>
                                    <td>error.identifier</td>
                                    <td>context.title,</td>
                                  </tr>
                                  <tr>
                                    <td>Example Data Row:</td>
                                    <td>issn:1234-5678</td>
                                    <td>The actual title</td>
                                  </tr>
                                  <tr>
                                    <td>Example Data Row:</td>
                                    <td>eissn:8765-4321</td>
                                    <td>The actual title</td>
                                  </tr>
                                </tbody>
                          </table>
                    </div>
                  </div>
                </div>
              </div>
              </div>
                  <!--***table end***-->

               </div>
           </div>
          <g:if test="${loaderResult}">
            <div class="col s12">
            <div class="row table-responsive-scroll">
              <table class="highlight bordered">
                <thead>
                  <tr>
                    <td></td>
                    <g:each in="${loaderResult.columns}" var="c">
                      <td>${c}</td>
                    </g:each>
                  </tr>
                </thead>
                <tbody>
                  <g:each in="${loaderResult.log}" var="logEntry">
                    <tr>
                      <td rowspan="2">${logEntry.rownum}</td>
                      <g:each in="${logEntry.rawValues}" var="v">
                        <td>${v}</td>
                      </g:each>
                    </tr>
                    <tr ${logEntry.error?'style="background-color:red;"':''}>
                      <td colspan="${loaderResult.columns.size()}">
                        ${logEntry.error?'Row ERROR':'Row OK'}
                        <ul>
                          <g:each in="${logEntry.messages}" var="m">
                            <li>${m}</li>
                          </g:each>
                        </ul>
                      </td>
                    </tr>
                  </g:each>
                </tbody>
              </table>
              </div>
           </div>
          </g:if>


       </div>


    <!--legacy-->
    <!-- <div class="container-fluid">
      <div class="span12">
        <h1>Import Financials Data</h1>
        <g:if test="${loaderResult==null}">
          <p>This service allows administrators to bulk load cost item records. It understands the following column mappings in the uploaded .tsv file</p>
          <table class="table table-striped">
            <thead>
              <tr>
                <th>tsv column name</th>
                <th>Description</th>
                <th>maps to</th>
              </tr>
            </thead>
            <tbody>
              <g:each in="${grailsApplication.config.financialImportTSVLoaderMappings.cols}" var="mpg">
                <tr>
                  <td>${mpg.colname}</td>
                  <td>${mpg.desc}
                      <g:if test="${mpg.type=='vocab'}">
                        <br/>Must be one of : <ul>
                          <g:each in="${mpg.mapping}" var="m,k">
                            <li>${m}</li>
                          </g:each>
                        </ul>
                      </g:if>
                  </td>
                  <td></td>
                </tr>
              </g:each>
            </tbody>
          </table>

          <g:form action="financeImport" method="post" enctype="multipart/form-data">
            <dl>
              <div class="control-group">
                <dt>Upload TSV File according to the column definitions above</dt>
                <dd>
                  <input type="file" name="tsvfile" />
                </dd>
              </div>
              <div class="control-group">
                <dt>Dry Run</dt>
                <dd>
                  <input type="checkbox" name="dryRun" checked value="Y" />
                </dd>
              </div>
              <button name="load" type="submit" value="Go">Upload...</button>
            </dl>
          </g:form>
        </g:if>
      </div>

      <g:if test="${loaderResult}">
        <table class="table table-striped">
          <thead>
            <tr>
              <td></td>
              <g:each in="${loaderResult.columns}" var="c">
                <td>${c}</td>
              </g:each>
            </tr>
          </thead>
          <tbody>
            <g:each in="${loaderResult.log}" var="logEntry">
              <tr>
                <td rowspan="2">${logEntry.rownum}</td>
                <g:each in="${logEntry.rawValues}" var="v">
                  <td>${v}</td>
                </g:each>
              </tr>
              <tr ${logEntry.error?'style="background-color:red;"':''}>
                <td colspan="${loaderResult.columns.size()}">
                  ${logEntry.error?'Row ERROR':'Row OK'}
                  <ul>
                    <g:each in="${logEntry.messages}" var="m">
                      <li>${m}</li>
                    </g:each>
                  </ul>
                </td>
              </tr>
            </g:each>
          </tbody>
        </table>
      </g:if>
    </div> -->
    <!--legacy end-->

  </body>
</html>
