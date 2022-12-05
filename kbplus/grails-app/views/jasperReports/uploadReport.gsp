<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head>
    <parameter name="pagetitle" value="Upload Jasper Reports" />
    <parameter name="pagestyle" value="data-manager" />
    <parameter name="actionrow" value="none" />
    <title>KB+ Upload Jasper Reports</title>
    <meta name="layout" content="base"/>
  </head>
  <body class="data-manager">  
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">Jasper Reports</h1>
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
        <div class="row tab-table z-depth-1">
          <div class="col s12">
            <div class="admin-table-title-section">
              <p>The types of accepted files are .jasper and .jrxml. Any other files selected will be ignored.</p>
            </div>
          </div>
          <g:uploadForm action="uploadReport" controller="jasperReports">
            <div class="file-field input-field col s10">
              <div class="btn">
                <span>File <i class="material-icons">add_circle_outline</i></span>
                <input type="file" name="report_files" multiple>
              </div>
              <div class="file-path-wrapper">
                <input class="file-path validate" type="text" placeholder="Select Reports">
              </div>
            </div>
            <div class="file-field input-field col s1">
              <input type="submit" class="waves-effect waves-light btn" value="Upload Files"/>
            </div>
          </g:uploadForm>
        </div>
      </div>
    </div>
    
<!--legacy-->
<!-- <div class="container">
    <div class="span12">

        <ul class="breadcrumb">
            <li><g:link controller="home" action="index">Home</g:link> <span class="divider">/</span></li>
            <li><g:link controller="jasperReports" action="index">Jasper Reports</g:link> <span
                    class="divider">/</span></li>
        </ul>

        <g:if test="${flash.message}">
            <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
        </g:if>
        <g:if test="${flash.error}">
            <bootstrap:alert class="alert-error">${flash.error}</bootstrap:alert>
        </g:if>

        <p>The types of accepted files are .jasper and .jrxml. Any other files selected will be ignored.</p>
        <g:uploadForm action="uploadReport" controller="jasperReports">

            <b>Select Reports</b>:

            <input type="file" name="report_files" multiple="multiple"><br/>

            <b>Upload Selected</b>

            <input type="submit" class="btn-primary" value="Upload Files"/>

        </g:uploadForm>
    </div>
</div> -->
<!--legacy end-->
  </body>
</html>
