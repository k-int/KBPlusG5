<!doctype html>
<html>
  <head>
    <meta name="layout" content="base">
    <g:set var="entityName" value="${message(code: 'propertyDefinition.label', default: 'Property Definition')}"/>
    <parameter name="pagetitle" value="${entityName} List" />
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <parameter name="actionrow" value="property-definition-create" />
  </head>
  <body class="admin">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left"><g:message code="default.list.label" args="[entityName]"/></h1>
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
    
    <!--page intro-->
    <div class="row">
      <div class="col s12">
        <div class="row tab-table z-depth-1">
          <!--***table***-->
          <div class="tab-content">
            <div class="row table-responsive-scroll">
              <table class="highlight bordered ">
                <thead>
                  <tr>
                    <g:sortableColumn property="name" title="Name" />
                    <g:sortableColumn property="descr" title="Description" />
                    <g:sortableColumn property="type" title="Type" />
                    <td>Occurrences Count</td>
                    <td>Actions</td>
                  </tr>
                </thead>
                <tbody>
                  <g:each in="${propDefInstanceList}" var="propDefInstance">
                    <tr>
                      <td>${fieldValue(bean: propDefInstance, field: "name")}</td>
                      <td>${fieldValue(bean: propDefInstance, field: "descr")}</td>
                      <td>${fieldValue(bean: propDefInstance, field: "type")}</td>
                      <g:set var="num_lcp" value="${propDefInstance.countOccurrences('com.k_int.kbplus.LicenseCustomProperty','com.k_int.kbplus.SystemAdminCustomProperty','com.k_int.kbplus.OrgCustomProperty')}" />
                      <td> ${num_lcp} </td>
                      <td><g:link action="edit" id="${propDefInstance.id}" class="btn-floating table-action hide-on-small-and-down modalButton"><i class="material-icons">create</i></g:link></td>
                    </tr>
                  </g:each>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        
        <div class="pagination">
          <g:paginate controller="propertyDefinition" action="list" next="chevron_right" prev="chevron_left" total="${propertyDefinitionTotal}"/>
        </div>
      </div>
    </div>
    
<!-- <div class="row-fluid">

    <div class="span2">
        <div class="well">
            <ul class="nav nav-list">
                <li class="nav-header">${entityName}</li>
                <li class="active">
                    <g:link class="list" action="list">
                        <i class="icon-list icon-white"></i>
                        <g:message code="default.list.label" args="[entityName]"/>
                    </g:link>
                </li>
                <li>
                    <g:if test="${editable}">
                        <g:link class="create" action="create">
                            <i class="icon-plus"></i>
                            <g:message code="default.create.label" args="[entityName]"/>
                        </g:link>
                    </g:if>
                </li>
            </ul>
        </div>
    </div>
    <div class="container">
    <div class="span10">

        <div class="page-header">
            <h1><g:message code="default.list.label" args="[entityName]"/></h1>
        </div>

        <g:if test="${flash.message}">
            <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
        </g:if>

        <table class="table table-striped">
            <thead>
            <tr>

              <g:sortableColumn property="name" title="Name" />
              <g:sortableColumn property="descr" title="Description" />
              <g:sortableColumn property="type" title="Type" />
                <th class="header"> Occurrences Count</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${propDefInstanceList}" var="propDefInstance">
                <tr>

                    <td>${fieldValue(bean: propDefInstance, field: "name")}</td>

                    <td>${fieldValue(bean: propDefInstance, field: "descr")}</td>

                    <td>${fieldValue(bean: propDefInstance, field: "type")}</td>
      <g:set var="num_lcp" value="${propDefInstance.countOccurrences('com.k_int.kbplus.LicenseCustomProperty','com.k_int.kbplus.SystemAdminCustomProperty','com.k_int.kbplus.OrgCustomProperty')}" />

                    <td> ${num_lcp} </td>
                    <td class="link">
                        <g:link action="edit" id="${propDefInstance.id}"
                                class="btn btn-small">Edit &raquo;</g:link>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>

        <div class="pagination">
            <bootstrap:paginate total="${propertyDefinitionTotal}"/>
        </div>
    </div>
    </div>

</div> -->
<!--legacy end-->
  </body>
</html>
