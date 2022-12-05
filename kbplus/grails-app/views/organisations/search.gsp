<%@ page import="com.k_int.kbplus.*" %>
<!doctype html>
<html lang="en" class="no-js">
<head>
  <parameter name="pagetitle" value="Organisations" />
  <parameter name="pagestyle" value="organisations" />
  <meta name="layout" content="base"/>
    <g:set var="entityName" value="${message(code: 'org.label', default: 'Org')}" />
</head>
<body class="home">

	<div class="row">

        <div class="col s12">
            <div class="mobile-collapsible-header" data-collapsible="org-search-collapsible">Search <i class="material-icons">expand_more</i></div>
            <div class="search-section z-depth-1 mobile-collapsible-body" id="org-search-collapsible">
                <g:form action="list" method="get" class="form-inline">
                    <div class="col s12 mt-10">
                        <h3 class="page-title left">Search Your Organisations</h3>
                    </div>
                    <div class="col s12 l5">
                        <div class="input-field search-main">
                            <input id="search" placeholder="Enter your search term..." type="search" name="orgNameContains" value="${params.orgNameContains}" required>
                            <label class="label-icon" for="search"><i class="material-icons">search</i></label>
                            <i class="material-icons">close</i>
                        </div>
                    </div>
                    <div class="col s12 l3 mt-10">
                        <div class="input-field">
                            <g:select name="orgRole" noSelection="${['':'Select One...']}" from="${RefdataValue.findAllByOwner(com.k_int.kbplus.RefdataCategory.findByDesc('Organisational Role'))}" value="${params.orgRole}" optionKey="id" optionValue="value"/>
                        </div>
                    </div>
                    <div class="col s12 l3 mt-10">
                        <div class="input-field">
                            <g:select name="orgStatus" noSelection="${['':'Select One...']}" from="${RefdataValue.findAllByOwner(com.k_int.kbplus.RefdataCategory.findByDesc('Org Status'))}" value="${params.orgStatus}" optionKey="id" optionValue="value"/>
                        </div>
                    </div>
                    <div class="col s6 m3 l1">
                        <input type="submit" class="waves-effect waves-teal btn" value="Search"/>
                    </div>
                    <div class="col s6 m3 l1">
                        <a href="#" class="resetsearch">Reset</a>
                    </div>
                </g:form>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col s12">
            <div class="tab-table z-depth-1">
                <div class="title">
                    <div class="row table-responsive-scroll">
                        <table class="highlight bordered">
                            <thead>
                            <tr>
                                <g:sortableColumn property="name" title="${message(code: 'org.name.label', default: 'Name')}" />
                                <g:sortableColumn property="shortcode" title="${message(code: 'org.shortcode.label', default: 'Short Code')}" />
                                <g:sortableColumn property="type" title="${message(code: 'org.type.label', default: 'Type')}" />
                                <g:sortableColumn property="sector" title="${message(code: 'org.sector.label', default: 'Sector')}" />
                                <g:sortableColumn property="status" title="${message(code: 'org.sector.label', default: 'Status')}" />
                                <g:sortableColumn property="membershipOrganisation" title="${message(code: 'org.sector.membershipOrganisation', default: 'Membership Org')}" />
                                <th>Alternative Names</th>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${orgInstanceList}" var="orgInstance">
                                <tr>
                                    <td><g:link  action="show" id="${orgInstance.id}">${fieldValue(bean: orgInstance, field: "name")}</g:link></td>
                                    <td>${fieldValue(bean: orgInstance, field: "shortcode")}</td>
                                    <td>${orgInstance?.orgType?.value}</td>
                                    <td>${fieldValue(bean: orgInstance, field: "sector")}</td>
                                    <td>${orgInstance.status?.value}</td>
                                    <td>${orgInstance.membershipOrganisation}</td>
                                    <td>
                                        <ul>
                                            <g:each in="${orgInstance.variantNames}" var="vn">
                                                <li>${vn.variantName}</li>
                                            </g:each>
                                        </ul>
                                    </td>
                                </tr>
                            </g:each>
                            </tbody>
                        </table>

                        <div class="pagination">
                            <bootstrap:paginate total="${orgInstanceTotal}" params="${params}" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


</body>
</html>
