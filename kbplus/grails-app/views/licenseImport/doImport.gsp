<!doctype html>
<html>
  <head>
    <parameter name="pagetitle" value="Import ONIX-PL licence" />
    <parameter name="pagestyle" value="data-manager" />
    <parameter name="actionrow" value="none" />
    <meta name="layout" content="base">
    <g:set var="entityName" value="${message(code: 'onixplLicence.licence.label', default: 'ONIX-PL License')}" />
    <title>KB+ Import ONIX-PL Licence</title>
  </head>
  <body class="data-manager">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <g:unless test="${validationResult?.success}">
          <h1 class="page-title left">Import ONIX-PL licence
            <g:if test="${license}"> for licence '${license.reference}'</g:if>
            <g:else> for unspecified licence</g:else>
          </h1>
        </g:unless>
      </div>
    </div>
    <!--page title end-->
    
    <!--error messages-->
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
          <div class="card-panel blue lighten-1">
            <span class="white-text"> ${flash.error}</span>
          </div>
        </div>
      </div>
    </g:if>
    
    <g:hasErrors bean="${packageInstance}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel red lighten-1">
            <ul>
              <g:eachError bean="${packageInstance}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
              </g:eachError>
            </ul>
          </div>
        </div>
      </div>
    </g:hasErrors>
    
    <%-- Show summary --%>
    <g:if test="${validationResult}">
      <g:if test="${validationResult.messages!=null}">
        <div class="row">
          <div class="col s12">
            <g:each in="${validationResult.messages}" var="msg">
              <div class="card-panel blue lighten-1">${msg}</div>
            </g:each>
          </div>
        </div>
      </g:if>
      
      <g:if test="${validationResult.errors!=null}">
        <g:each in="${validationResult.errors}" var="msg">
          <div class="row">
            <div class="col s12">
              <div class="card-panel red lighten-1">${msg}</div>
            </div>
          </div>
        </g:each>
      </g:if>
      
      <g:if test="${validationResult.success==true}">
        <div class="row">
          <div class="col s12">
            <div class="card-panel green lighten-1">Upload successful</div>
          </div>
        </div>
        
        <div class="row">
          <div class="col s12">
            Imported <b>${upload_filename} (${upload_mime_type})</b>
            <g:if test="${validationResult.license}">
              and associated with
              <g:link action="index" controller="licenseDetails" class="btn btn-info" id="${validationResult.license.id}">license ${validationResult.license.id}</g:link>
              <b>${validationResult.license.reference}.</b>
            </g:if>
            <g:else>
              <br/>
              Existing associations with KB+ licences were maintained.
            </g:else>
          </div>
        </div>
      </g:if>
      <%-- Show the form if no OPL has been created --%>
      <g:else>
        <g:form action="doImport" method="post" enctype="multipart/form-data">
          <g:hiddenField name="license_id" value="${params.license_id!=""?params.license_id:license_id}" />
          <%-- Show overwrite option if there is an existing OPL --%>
          <g:if test="${existing_opl}">
            <div class="row">
              <div class="col s12">
                This ONIX-PL document appears to describe an existing ONIX-PL licence:
                <div class="well">
                  <g:link action="index" controller="onixplLicenseDetails" id="${existing_opl.id}">${existing_opl.title}</g:link>
                </div>
                Would you like to replace the existing ONIX-PL licence or create a new record?
                <br/>
                <br/>
                <button name="replace_opl" id="replace_opl" value="replace" type="submit" class="waves-effect red waves-light btn">Replace</button>
                <button name="replace_opl" id="replace_opl" value="create" type="submit" class="waves-effect waves-light btn">Create New</button>
                <g:hiddenField name="upload_title" value="${upload_title}" />
                <g:hiddenField name="uploaded_file" value="${uploaded_file}" />
                <g:hiddenField name="description" value="${description}" />
                <g:hiddenField name="upload_filename" value="${upload_filename}" />
                <g:hiddenField name="upload_mime_type" value="${upload_mime_type}" />
                <g:hiddenField name="existing_opl_id" value="${existing_opl.id}" />
              </div>
            </div>
          </g:if>
          <g:else>
            <div class="row">
              <div class="col s12">
                <div class="row tab-table z-depth-1">
                  <div class="file-field input-field col s10">
                    <div class="btn">
                      <span>File <i class="material-icons">add_circle_outline</i></span>
                      <input type="file" id="import_file" name="import_file" value="${import_file}">
                    </div>
                    <div class="file-path-wrapper">
                      <input class="file-path validate" type="text" placeholder="Upload Onix-PL file">
                    </div>
                  </div>
                  <div class="file-field input-field col s2">
                    <button class="waves-effect waves-light btn" type="submit">Import Licence</button>
                  </div>
                </div>
              </div>
            </div>
          </g:else>
        </g:form>
      </g:else>
      
      <g:if test="${validationResult.termStatuses}">
        <div class="row">
          <div class="col s12">
            <h2>Usage terms summary</h2>
            <ul>
              <g:each in="${validationResult.termStatuses}" var="ts">
                <li>${ts.value} &times ${ts.key}</li>
              </g:each>
            </ul>
          </div>
        </div>
      </g:if>
      
      <br/>
      <g:if test="${validationResult.onixpl_license}">
        <div class="row">
          <div class="col s12">
            <%-- Show link to ONIX-PL display if no associated license specified, or multiple ones --%>
            <g:link action="index" controller="onixplLicenseDetails" class="btn btn-info" id="${validationResult.onixpl_license.id}">View ${validationResult.replace ? 'updated' : 'new'} ONIX-PL licence</g:link>
          </div>
        </div>
      </g:if>
    </g:if>



<!--legacy-->
<!-- <div class="container">

    <div class="page-header">
        <g:unless test="${validationResult?.success}">
            <h1>Import ONIX-PL licence
            <g:if test="${license}"> for licence '${license.reference}'</g:if>
            <g:else> for unspecified licence</g:else>
            </h1>
        </g:unless>
    </div>

    <g:if test="${flash.message}">
        <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
    </g:if>

    <g:if test="${flash.error}">
        <bootstrap:alert class="alert-info">${flash.error}</bootstrap:alert>
    </g:if>

    <g:hasErrors bean="${packageInstance}">
        <bootstrap:alert class="alert-error">
            <ul>
                <g:eachError bean="${packageInstance}" var="error">
                    <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                </g:eachError>
            </ul>
        </bootstrap:alert>
    </g:hasErrors>

    <%-- Show summary --%>
    <g:if test="${validationResult}">

        <g:if test="${validationResult.messages!=null}">
            <g:each in="${validationResult.messages}" var="msg">
                <div class="alert alert-info">${msg}</div>
            </g:each>
        </g:if>

        <g:if test="${validationResult.errors!=null}">
            <g:each in="${validationResult.errors}" var="msg">
                <div class="alert alert-error">${msg}</div>
            </g:each>
        </g:if>

        <g:if test="${validationResult.success==true}">
            <div class="alert alert-success">
                      <h2>Upload successful</h2>

                      Imported <b>${upload_filename} (${upload_mime_type})</b>
            <g:if test="${validationResult.license}">
                and associated with
                <g:link action="index"
                        controller="licenseDetails"
                        class="btn btn-info"
                        id="${validationResult.license.id}">
                    license ${validationResult.license.id}
                </g:link>
                <b>${validationResult.license.reference}.</b>
            </g:if>
            <g:else>
                <br/>
                Existing associations with KB+ licences were maintained.
            </g:else>
        </g:if>
    <%-- Show the form if no OPL has been created --%>
        <g:else>
            <g:form action="doImport" method="post" enctype="multipart/form-data">
                <g:hiddenField name="license_id" value="${params.license_id!=""?params.license_id:license_id}" />
            <%-- Show overwrite option if there is an existing OPL --%>
                <g:if test="${existing_opl}">
                    This ONIX-PL document appears to describe an existing ONIX-PL licence:
                    <div class="well">
                        <g:link action="index"
                                controller="onixplLicenseDetails"
                                id="${existing_opl.id}">
                            ${existing_opl.title}
                        </g:link>
                    </div>
                    Would you like to replace the existing ONIX-PL licence or create a new record?
                    <br/>
                    <br/>
                    <button name="replace_opl" id="replace_opl" value="replace"
                            type="submit" class="btn btn-danger">Replace</button>
                    <button name="replace_opl" id="replace_opl" value="create"
                            type="submit" class="btn btn-primary">Create New</button>

                    <g:hiddenField name="upload_title" value="${upload_title}" />
                    <g:hiddenField name="uploaded_file" value="${uploaded_file}" />
                    <g:hiddenField name="description" value="${description}" />

                    <g:hiddenField name="upload_filename" value="${upload_filename}" />
                    <g:hiddenField name="upload_mime_type" value="${upload_mime_type}" />
                    <g:hiddenField name="existing_opl_id" value="${existing_opl.id}" />

                </g:if>
            <%-- Show  default options is there is no existing OPL and one has not been created --%>
                <g:else>
                <%--Upload File:--%>
                    <br/>
                    <input type="file" id="import_file" name="import_file" value="${import_file}"/>
                    <br/>
                    <br/>
                    <button type="submit" class="btn btn-primary">Import licence</button>
                </g:else>
            </g:form>
        </g:else>


        <g:if test="${validationResult.termStatuses}">
            <h2>Usage terms summary</h2>
            <ul>
                <g:each in="${validationResult.termStatuses}" var="ts">
                    <li>${ts.value} &times ${ts.key}</li>
                </g:each>
            </ul>
        </g:if>

        <br/>
        <g:if test="${validationResult.onixpl_license}">

            <%-- Show link to ONIX-PL display if no associated license specified, or multiple ones --%>
                <g:link action="index"
                        controller="onixplLicenseDetails"
                        class="btn btn-info"
                        id="${validationResult.onixpl_license.id}">
                    View ${validationResult.replace ? 'updated' : 'new'} ONIX-PL licence</g:link>
        </g:if>
        </div>
    </g:if>

</div> -->
  </body>
</html>
