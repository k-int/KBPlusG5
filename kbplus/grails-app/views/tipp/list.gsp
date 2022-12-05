
<%@ page import="com.k_int.kbplus.Platform" %>
<!doctype html>
<html>
  <head>
  	<parameter name="pagetitle" value="TIPPs List" />
    <meta name="layout" content="base">
    <g:set var="entityName" value="${message(code: 'platform.label', default: 'TIPPs')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
    <style>
    .select2-container-multi .select2-choices .select2-search-field input {
      height:auto;
    }
    </style>
  </head>
  <body class="titles">


    <!--page title-->
  <div class="row">
    <div class="col s12 l10">
      <h1 class="page-title"><g:message code="default.list.label" args="[entityName]" /></h1>
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

  <g:form action="list" method="get" class="form-inline">

    <div class="row">
        <div class="col s12">
            <div class="row tab-table z-depth-1">

              <div class="input-field col s12">
                <input placeholder="enter search term..." value="${params.title?.encodeAsHTML()}" name="title" type="text">
                <label for="title">Title text</label>
              </div>

              <div class="input-field col s12" style="margin-bottom: 30px;">
                <input  id="ApkgToAdd" name="pkgsToInclude" type="hidden">
                <label class="active" style="transform: translateY(-200%);">Packages</label>
              </div>

              <div class="input-field col s12">
                <input  name="platformsToInclude" id="BplatformToAdd" type="hidden">
                <label class="active" style="transform: translateY(-200%);">Platforms</label>
              </div>

              <div class="file-field input-field col s1">
                <button class="waves-effect waves-light btn" type="submit" value="Search">Search</button>
              </div>

           </div>
        </div>
    </div>

  </g:form>

  <div class="row">
    <div class="col s12">
    <div class="row tab-table z-depth-1">
      <g:form action="tippAction" method="post" class="form-inline">
          <input type="hidden" name="h_title" value="${params.title}"/>
          <input type="hidden" name="h_pkgs" value="${params.pkgsToInclude}"/>
          <input type="hidden" name="h_platforms" value="${params.platformsToInclude}"/>
          <input type="hidden" name="h_count" value="${tippTotal}"/>
          <input type="hidden" name="selectAll" value="on"/>

          <g:if test="${tippTotal && tippTotal > 0}">
              <p>
                The selected criteria matches ${tippTotal} tipp records. Some examples are shown below, but this is only an indicative sample.
                Selecting the Go button will perform the selected operation on <strong>ALL ${tippTotal}</strong> tipp records matching the critera given.
              </p>
              <div class="input-field col s11">
                <select name="tippAction" class="pull-right">
                  <option name="platformMigration" value="platformMigration">Platform Migration</option>
                </select>
              </div>
              <div class="input-field col s1">
                <button type="submit" class="waves-effect waves-light btn pull-right">Go -&gt;</button>
               </div>
          </g:if>

          <table class="table bordered striped">
            <thead>
              <tr>
                <th>TIPP ID</th>
                <th>Title</th>
                <th>Package</th>
                <th>Platform</th>
                <th>TIPP Status</th>
              </tr>
            </thead>
            <tbody>
            <g:each in="${tipps}" var="tipp">
              <tr>
                <td>${tipp.id}</td>
                <td><g:link controller="titleDetails" action="show" id="${tipp.title.id}">${tipp.title.title}</g:link></td>
                <td><g:link controller="packageDetails" action="show" id="${tipp.pkg.id}">${tipp.pkg.name}</g:link></td>
                <td><g:link controller="platform" action="show" id="${tipp.platform.id}">${tipp.platform.name}</g:link></td>
                <td>${tipp.status?.value}</td>
              </tr>
            </g:each>
            </tbody>
          </table>
        </g:form>
        </div>
    </div>
  </div>


    <!-- Legacy -->
    <!-- <div class="container">
      <div class="span12">

        <div class="page-header">
          <h1><g:message code="default.list.label" args="[entityName]" /></h1>
        </div>

        <g:if test="${flash.message}">
        <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
        </g:if>

        <div class="container" style="text-align:left">
          <g:form action="list" method="get" class="form-inline">
            <fieldset class="inline-lists">

              <dl>
                <dt><label>Title text</label></dt>
                <dd>
                  <input type="text" name="title" placeholder="enter search term..." value="${params.title?.encodeAsHTML()}"  />
                </dd>
              </dl>

              <dl>
                <dt><label>Packages</label></dt>
                <dd>
                  <input type="hidden" name="pkgsToInclude" id="ApkgToAdd" value=""/>
                </dd>
              </dl>

              <dl>
                <dt><label>Platforms</label></dt>
                <dd>
                  <input type="hidden" name="platformsToInclude" id="BplatformToAdd" value=""/>
                </dd>
              </dl>

              <dl>
                <dt></dt>
                <dd>
                  <button type="submit" class="btn btn-primary" value="Search">Search</button>
                </dd>
              </dl>

            </fieldset>
          </g:form>
        </div>



        <g:form action="tippAction" method="post" class="form-inline">
          <input type="hidden" name="h_title" value="${params.title}"/>
          <input type="hidden" name="h_pkgs" value="${params.pkgsToInclude}"/>
          <input type="hidden" name="h_platforms" value="${params.platformsToInclude}"/>
          <input type="hidden" name="h_count" value="${tippTotal}"/>
          <input type="hidden" name="selectAll" value="on"/>

          <g:if test="${tippTotal && tippTotal > 0}">
            <div class="container">
              <p>
                The selected criteria matches ${tippTotal} tipp records. Some examples are shown below, but this is only an indicative sample.
                Selecting the Go button will perform the selected operation on <strong>ALL ${tippTotal}</strong> tipp records matching the critera given.
              </p>
              <button type="submit" class="btn btn-warning pull-right">Go -&gt;</button>
              <select name="tippAction" class="pull-right">
                <option name="platformMigration" value="platformMigration">Platform Migration</option>
              </select>
            </div>
          </g:if>

          <table class="table table-bordered table-striped">
            <thead>
              <tr>
                <th>TIPP ID</th>
                <th>Title</th>
                <th>Package</th>
                <th>Platform</th>
                <th>TIPP Status</th>
              </tr>
            </thead>
            <tbody>
            <g:each in="${tipps}" var="tipp">
              <tr>
                <td>${tipp.id}</td>
                <td><g:link controller="titleDetails" action="show" id="${tipp.title.id}">${tipp.title.title}</g:link></td>
                <td><g:link controller="packageDetails" action="show" id="${tipp.pkg.id}">${tipp.pkg.name}</g:link></td>
                <td><g:link controller="platform" action="show" id="${tipp.platform.id}">${tipp.platform.name}</g:link></td>
                <td>${tipp.status?.value}</td>
              </tr>
            </g:each>
            </tbody>
          </table>
        </g:form>

      </div>

    </div> -->
    <!-- end of legacy -->

<script language="JavaScript">

window.setTimeout(function(){
    $(function(){

      $("#ApkgToAdd").select2({
        width: '100%',
        multiple: true,
        placeholder: "Type package name...",
        minimumInputLength: 1,
        ajax: {
            url: '<g:createLink controller='ajax' action='lookup'/>',
            dataType: 'json',
            data: function (term, page) {
                return {
                  q: term , // search term
                  page_limit: 10,
                  baseClass:'com.k_int.kbplus.Package'
                };
            },
            results: function (data, page) {
                return {results: data.values};
            }
        },
         allowClear: true,
         formatSelection: function(data) {
            return data.text;
        }
      });

      $("#BplatformToAdd").select2({
        width: '100%',
        multiple: true,
        placeholder: "Type platform name...",
        minimumInputLength: 1,
        ajax: {
            url: '<g:createLink controller='ajax' action='lookup'/>',
            dataType: 'json',
            data: function (term, page) {
                return {
                  q: term , // search term
                  page_limit: 10,
                  baseClass:'com.k_int.kbplus.Platform'
                };
            },
            results: function (data, page) {
                return {results: data.values};
            }
        },
        allowClear: true,
        formatSelection: function(data) {
            return data.text;
        }
      });


    });
}, 100);


</script>
  </body>
</html>
