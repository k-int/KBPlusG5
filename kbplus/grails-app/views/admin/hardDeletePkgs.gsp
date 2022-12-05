<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <parameter name="pagetitle" value="Package Delete" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
    <title>KB+ Admin::Package Delete</title>
  </head>
  <body class="admin">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">Package Delete</h1>
      </div>
    </div>
    <!--page title end-->
    
    <!--page intro and error start-->
    <g:if test="${flash.message}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel blue lighten-1">
            <span class="white-text">${flash.message}</span>
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
    
    <!-- search-section start-->
    <div class="row">
      <div class="col s12">
        <div class="search-section z-depth-1">
          <div class="col s12 mt-10">
            <h3 class="page-title left">Search Your Packages</h3>
          </div>
          <g:form action="hardDeletePkgs" method="get" params="${params}">
            <input type="hidden" name="offset" value="${params.offset}"/>
            <div class="col s12 m12 l8">
              <div class="input-field search-main">
                <input name="pkg_name" id="search-pkg-name" placeholder="Enter your search term..." type="search" value="${params.pkg_name}" required>
                <label class="label-icon" for="search-pkg-name"><i class="material-icons">search</i></label>
                <i class="material-icons close" id="clearSearch" search-id="search-pkg-name">close</i>
              </div>
            </div>
            <div class="col s12 m12 l2">
              <button type="submit" name="search" value="yes" class="waves-effect waves-teal btn right">Search</button>
            </div>
            <div class="col s12 m12 l2">
              <g:link controller="admin" action="hardDeletePkgs" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
            </div>
          </g:form>
        </div>
      </div>
    </div>
    <!-- search-section end-->
    
    <g:if test="${pkgs}">
      <!--***tabular data***-->
      <div class="row">
        <div class="col s12">
          <div class="tab-table z-depth-1">
            <!--***table***-->
            <div id="packages-table" class="tab-content">
              <div class="row table-responsive-scroll">
                <table class="highlight bordered ">
                  <thead>
                    <tr>
                      <g:sortableColumn property="name" title="${message(code: 'package.name.label', default: 'Name')}" />
                      <th data-field="order-id">Action #</th>
                    </tr>
                  </thead>
                  <tbody>
                    <g:each in="${pkgs}" var="packageInstance">
                      <tr>
                        <td>
                          <g:link controller="packageDetails" action="show" id="${packageInstance.id}">${fieldValue(bean: packageInstance, field: "name")} (${packageInstance?.contentProvider?.name})</g:link>
                        </td>
                        <td class="link">
                          <a href="#kbmodal" ajax-url="${createLink(controller:'admin', action:'hardDeletePkgs', id:packageInstance.id)}" class="btn btn-small modalButton">Prepare Delete</a>
                        </td>
                      </tr>
                    </g:each>
                  </tbody>
                </table>
              </div>
            </div>
            <!--***table end***-->
          </div>
          
          <div class="pagination">
            <g:paginate controller="admin" action="hardDeletePkgs" params="${params}" next="chevron_right" prev="chevron_left" total="${pkgs.totalCount}" />
          </div>
        </div>
      </div>
    </g:if>
  </body>
</html>
