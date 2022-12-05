<%@ page import="com.k_int.kbplus.Package" %>
<!doctype html>
<html>
  <head>
      <parameter name="pagetitle" value="Package - Manual Upload" />
      <parameter name="pagestyle" value="data-manager" />
      <parameter name="actionrow" value="none" />
      <meta name="layout" content="base">
    <g:set var="entityName" value="${message(code: 'package.label', default: 'Package')}" />
    <title><g:message code="default.edit.label" args="[entityName]" /></title>
  </head>
  <body class="data-manager">


  <!--page title start-->
  <div class="row">
      <div class="col s12 l12">
          <h1 class="page-title left">Package - Manual Upload
            <g:if test="${params.strictmode=='off'}">
              Lax Mode - For archival type packages only!
            </g:if>
          </h1>
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
      <div class="card-panel blue lighten-1">
       <ul>
         <g:eachError bean="${packageInstance}" var="error">
         <%--<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>--%>
         </g:eachError>
       </ul>
      </div>
    </div>
  </div>
  </g:hasErrors>


  <g:form elementId="ReviewPackageForm" action="uploadPackageFile" method="post" enctype="multipart/form-data">
    <g:if test="${params.strictmode}">
      <input type="hidden" name="strictmode" value="${params.strictmode}"/>
    </g:if>
      <div class="row">
          <div class="col s12">
              <div class="row tab-table z-depth-1">
                <g:form action="uploadIssnL" method="post" enctype="multipart/form-data">
                <div class="file-field input-field col s11">
                  <div class="btn">
                      <span>File <i class="material-icons">add_circle_outline</i></span>
                      <input type="file" id="soFile" name="soFile">
                  </div>
                  <div class="file-path-wrapper">
                    <input class="file-path validate" type="text" placeholder="Upload File">
                  </div>
                </div>

                <div class="input-field col s12">
                   <select name="docstyle">
                     <option value="csv" selected>Comma Separated</option>
                     <option value="tsv">Tab Separated</option>
                   </select>
                   <label>Doc Style</label>
                </div>

                <div class="input-field col s12">
                   <input type="checkbox" id="_OverrideCharset" name="OverrideCharset" />
                   <label for="_OverrideCharset">Override Character Set Test</label>
                </div>


                <div class="file-field input-field col s1">
                <button class="waves-effect waves-light btn" name="load" type="submit" value="Go">Upload Package</button>
                </div>
                </g:form>
             </div>
          </div>
      </div>     

    </g:form>



<!--legacy-->
      <!-- <div class="container">

        <div class="page-header">
          <h1>Package - Manual Upload</h1>
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
          <%--<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>--%>
          </g:eachError>
        </ul>
        </bootstrap:alert>
        </g:hasErrors>

        <g:form elementId="ReviewPackageForm" action="uploadPackageFile" method="post" enctype="multipart/form-data">
            Upload File: <input type="file" id="soFile" name="soFile"/><br/>

            Doc Style: <select name="docstyle">
              <option value="csv" selected>Comma Separated</option>
              <option value="tsv">Tab Separated</option>
            </select></br/>

            Override Character Set Test: <input type="checkbox" name="OverrideCharset" checked="false"/>

            <button type="submit" class="btn btn-primary">Upload Package</button>
        </g:form>
        
        <br/>

        <g:if test="${validationResult}">
          <g:if test="${validationResult.stats != null}">
            <h3>Stats</h3>
            <ul>
              <g:each in="${validationResult?.stats}" var="msg">
                <li>${msg.key} = ${msg.value}</li>
              </g:each>
            </ul>
          </g:if>

          <g:each in="${validationResult?.messages}" var="msg">
            <div class="alert alert-error">${msg}</div>
          </g:each>

          <hr/>

          <g:if test="${validationResult.processFile==true}">
            <bootstrap:alert class="alert-success">File passed validation checks, new SO details follow:<br/>
              <g:link controller="packageDetails" action="show" id="${validationResult.new_pkg_id}">New Package Details</g:link><br/>
            </bootstrap:alert>
          </g:if>
          <g:else>
            <div class="alert alert-error">File failed validation checks, details follow</div>
          </g:else>
          <table class="table">
            <tbody>
              <g:each in="${['soName', 'soIdentifier', 'soProvider', 'soPackageIdentifier', 'soPackageName', 'aggreementTermStartYear', 'aggreementTermEndYear', 'consortium', 'numPlatformsListed']}" var="fld">
                <tr>
                  <td>${fld}</td>
                  <td>${validationResult[fld]?.value} 
                    <g:if test="${validationResult[fld]?.messages != null}">
                      <hr/>
                      <g:each in="${validationResult[fld]?.messages}" var="msg">
                        <div class="alert alert-error">${msg}</div>
                      </g:each>
                    </g:if>
                  </td>
                </tr>
              </g:each>
            </tbody>
          </table>

          <table class="table">
            <thead>
              <tr>
                <g:each in="${validationResult.soHeaderLine}" var="c">
                  <th>${c}</th>
                </g:each>
              </tr>
            </thead>
            <tbody>
              <g:each in="${validationResult.tipps}" var="tipp">
              
                <tr>
                  <g:each in="${tipp.row}" var="c">
                    <td>${c}</td>
                  </g:each>
                </tr>
                
                <g:if test="${tipp.messages?.size() > 0}">
                  <tr>
                    <td colspan="${validationResult.soHeaderLine.size()}">
                      <ul>
                        <g:each in="${tipp.messages}" var="msg">
                          <%--<g:if test="${msg instanceof java.lang.String || msg instanceof org.codehaus.groovy.runtime.GStringImpl}">
                            <div class="alert alert-error">${msg}</div>
                          </g:if>
                          <g:else>--%>
                            <div class="alert ${msg.type}">${msg.message}</div>
                        </g:each>
                      </ul>
                    </td>
                  </tr>
                </g:if>
              </g:each>
            </tbody>
          </table>
          
        </g:if>
        
      </div> -->

  </body>
</html>
