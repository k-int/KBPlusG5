<!doctype html>
<html>
  <head>
    <meta name="layout" content="base">
    <g:set var="entityName" value="${message(code: 'package.label', default: 'Package')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
      <parameter name="pagetitle" value="Global Data" />
      <parameter name="pagestyle" value="data-manager" />
      <parameter name="actionrow" value="none" />
  </head>
  <body class="data-manager">
    

    <!--page title start-->
    <div class="row">
        <div class="col s12 l12">
            <h1 class="page-title left"><g:message code="globalDataSync.label" /></h1>
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


      <div class="row">
        <div class="col s12">

          <div class="mobile-collapsible-header" data-collapsible="subscription-list-collapsible">Search <i class="material-icons">expand_more</i></div>
          <div class="search-section z-depth-1 mobile-collapsible-body" id="subscription-list-collapsible">
            <g:form action="index" method="get" class="form-inline">
            <div class="col s12 mt-10">
                <h3 class="page-title left">Search Your Global Data</h3>
            </div>
            <div class="col s12 l10">
                  <div class="input-field search-main">
                      <input id="search" placeholder="enter your search term..." type="search" required value="${params.q?.encodeAsHTML()}">
                      <label class="label-icon" for="search"><i class="material-icons">search</i></label>
                      <i class="material-icons close">close</i>
                  </div>
            </div>

                <div class="col s6 m3 l1">
                    <a href="#" class="btn">Search</a>
                </div>
                <div class="col s6 m3 l1">
                    <a href="#" class="resetsearch">Reset</a>
                </div>

            </g:form>
          </div>

        </div>
      </div>
      <!-- search-section end-->



      <div class="row">
          <div class="col s12">
              <div class="row tab-table z-depth-1">   
                  
                  <div class="admin-table-title-section">
                    <h3>Records <span>${offset}</span> to <span>${offset+items.size()}</span> of <span>${globalItemTotal}</span></h3>
                  </div>  

                  <!--***table***-->
                    <div class="tab-content">
                         <div class="row table-responsive-scroll">
                              <table class="highlight bordered ">
                                  <thead>
                                    <tr>
                                      <g:sortableColumn property="identifier"      title="${message(code: 'package.identifier.label'     )}" />
                                      <g:sortableColumn property="name"            title="${message(code: 'package.name.label'           )}" />
                                      <g:sortableColumn property="desc"            title="${message(code: 'package.description.label'    )}" />
                                      <g:sortableColumn property="source.name"     title="${message(code: 'package.source.label'         )}" />
                                      <g:sortableColumn property="type"            title="${message(code: 'package.type.label'           )}" />
                                      <g:sortableColumn property="kbplusCompliant" title="${message(code: 'package.kbplusCompliant.label')}" />
                                      <th>Actions</th>
                                    </tr>
                                  </thead>
                                  <tbody>
                                    <g:each in="${items}" var="item">
                                      <tr>
                                        <td> <a href="${item.source.baseUrl}resource/show/${item.identifier}">${fieldValue(bean: item, field: "identifier")}</a><br/>
                                             <g:message code="globalDataSync.updated.brackets" args="[formatDate(date: item.ts, formatName: 'default.date.format.notime')]" /></td>
                                        <td> <a href="${item.source.baseUrl}resource/show/${item.identifier}">${fieldValue(bean: item, field: "name")}</a></td>
                                        <td> <a href="${item.source.baseUrl}resource/show/${item.identifier}">${fieldValue(bean: item, field: "desc")}</a></td>
                                        <td> <a href="${item.source.uri}?verb=getRecord&amp;identifier=${item.identifier}&amp;metadataPrefix=${item.source.fullPrefix}">
                                               ${item.source.name}</a></td>
                                        <td> <a href="${item.source.baseUrl}search/index?qbe=g:1packages">${item.displayRectype}</a></td>
                                        <td>${item.kbplusCompliant?.value}</td>
                                        <td><g:link action="newCleanTracker" controller="globalDataSync" id="${item.id}" class="btn btn-success">Track(New)</g:link>
                                            <g:link action="selectLocalPackage" controller="globalDataSync" id="${item.id}" class="btn btn-success">Track(Merge)</g:link></td>
                                      </tr>
                                      <g:each in="${item.trackers}" var="tracker">
                                        <tr>
                                          <td colspan="6">
                                            -> Tracking using id
                                            <g:if test="${tracker.localOid != null}">
                                              <g:if test="${tracker.localOid.startsWith('com.k_int.kbplus.Package')}">
                                                <g:link controller="packageDetails" action="show" id="${tracker.localOid.split(':')[1]}">
                                                  ${tracker.name ?: message(code: 'globalDataSync.noname')}</g:link>
                                                <g:if test="${tracker.name == null}">
                                                  <g:set var="confirm" value="${message(code: 'globalDataSync.cancel.confirm.noname')}" />
                                                </g:if>
                                                <g:else>
                                                  <g:set var="confirm" value="${message(code: 'globalDataSync.cancel.confirm', args: [tracker.name])}" />
                                                </g:else>
                                                <g:link controller="globalDataSync" action="cancelTracking" class="btn btn-danger"
                                                        params="[trackerId: tracker.id, itemName: fieldValue(bean: item, field: 'name')]"
                                                        onclick="return confirm('${confirm}')">
                                                  <g:message code="globalDataSync.cancel" />
                                                </g:link>
                                              </g:if>
                                            </g:if>
                                            <g:else>No tracker local oid</g:else>
                                          </td>
                                        </tr>
                                      </g:each>
                                    </g:each>
                                  </tbody>

                              </table>
                         </div>
                    </div>

              </div>
         </div>
     </div>                         


<!--legacy-->
<!--     <div class="container">
      <div class="page-header">
        <h1><g:message code="globalDataSync.label" /></h1>
      </div>
      <g:if test="${flash.message}">
        <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
      </g:if>
    </div>

    <div class="container" style="text-align:center">
      <g:form action="index" method="get" class="form-inline">
        <label>Search text</label> <input type="text" name="q" placeholder="enter search term..." value="${params.q?.encodeAsHTML()}"  />
        <input type="submit" class="btn btn-primary" value="Search" />
      </g:form><br/>
    </div>

    <div class="container">
        
      <g:if test="${items != null}">
        <div class="container" style="text-align:center">
          Records ${offset} to ${offset+items.size()} of ${globalItemTotal}
        </div>
      </g:if>
      <table class="table table-bordered table-striped">
        <thead>
          <tr>
            <g:sortableColumn property="identifier"      title="${message(code: 'package.identifier.label'     )}" />
            <g:sortableColumn property="name"            title="${message(code: 'package.name.label'           )}" />
            <g:sortableColumn property="desc"            title="${message(code: 'package.description.label'    )}" />
            <g:sortableColumn property="source.name"     title="${message(code: 'package.source.label'         )}" />
            <g:sortableColumn property="type"            title="${message(code: 'package.type.label'           )}" />
            <g:sortableColumn property="kbplusCompliant" title="${message(code: 'package.kbplusCompliant.label')}" />
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <g:each in="${items}" var="item">
            <tr>
              <td> <a href="${item.source.baseUrl}resource/show/${item.identifier}">${fieldValue(bean: item, field: "identifier")}</a><br/>
                   <g:message code="globalDataSync.updated.brackets" args="[formatDate(date: item.ts, formatName: 'default.date.format.notime')]" /></td>
              <td> <a href="${item.source.baseUrl}resource/show/${item.identifier}">${fieldValue(bean: item, field: "name")}</a></td>
              <td> <a href="${item.source.baseUrl}resource/show/${item.identifier}">${fieldValue(bean: item, field: "desc")}</a></td>
              <td> <a href="${item.source.uri}?verb=getRecord&amp;identifier=${item.identifier}&amp;metadataPrefix=${item.source.fullPrefix}">
                     ${item.source.name}</a></td>
              <td> <a href="${item.source.baseUrl}search/index?qbe=g:1packages">${item.displayRectype}</a></td>
              <td>${item.kbplusCompliant?.value}</td>
              <td><g:link action="newCleanTracker" controller="globalDataSync" id="${item.id}" class="btn btn-success">Track(New)</g:link>
                  <g:link action="selectLocalPackage" controller="globalDataSync" id="${item.id}" class="btn btn-success">Track(Merge)</g:link></td>
            </tr>
            <g:each in="${item.trackers}" var="tracker">
              <tr>
                <td colspan="6">
                  -> Tracking using id
                  <g:if test="${tracker.localOid != null}">
                    <g:if test="${tracker.localOid.startsWith('com.k_int.kbplus.Package')}">
                      <g:link controller="packageDetails" action="show" id="${tracker.localOid.split(':')[1]}">
                        ${tracker.name ?: message(code: 'globalDataSync.noname')}</g:link>
                      <g:if test="${tracker.name == null}">
                        <g:set var="confirm" value="${message(code: 'globalDataSync.cancel.confirm.noname')}" />
                      </g:if>
                      <g:else>
                        <g:set var="confirm" value="${message(code: 'globalDataSync.cancel.confirm', args: [tracker.name])}" />
                      </g:else>
                      <g:link controller="globalDataSync" action="cancelTracking" class="btn btn-danger"
                              params="[trackerId: tracker.id, itemName: fieldValue(bean: item, field: 'name')]"
                              onclick="return confirm('${confirm}')">
                        <g:message code="globalDataSync.cancel" />
                      </g:link>
                    </g:if>
                  </g:if>
                  <g:else>No tracker local oid</g:else>
                </td>
              </tr>
            </g:each>
          </g:each>
        </tbody>
      </table>
      <div class="pagination">
        <bootstrap:paginate  action="index" controller="globalDataSync" params="${params}" next="Next" prev="Prev" max="${max}" total="${globalItemTotal}" />
      </div>
    </div> -->
  </body>
</html>
