<%@ page import="com.k_int.kbplus.*" %>
<!doctype html>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="Organisations" />
	<parameter name="pagestyle" value="organisations" />
	<meta name="layout" content="base"/>
	<g:set var="entityName" value="${message(code: 'org.label', default: 'Org')}" />
	<title>KB+ Organisations List</title>
</head>
<body class="admin">
	<div class="row">
		<div class="col s12">
			<div class="mobile-collapsible-header" data-collapsible="org-search-collapsible">Search <i class="material-icons">expand_more</i></div>
			<div class="search-section z-depth-1 mobile-collapsible-body" id="org-search-collapsible">
				<g:form controller="organisations" action="list" method="get">
					<div class="col s12 mt-10">
						<h3 class="page-title left">Search Your Organisations</h3>
					</div>
					<div class="col s12 l5">
						<div class="input-field search-main">
							<input id="search-orgslist" placeholder="Org Name Contains..." type="search" name="orgNameContains" value="${params.orgNameContains}">
							<label class="label-icon" for="search-orgslist"><i class="material-icons">search</i></label>
							<i class="material-icons close" id="clearSearch" search-id="search-orgslist">close</i>
						</div>
					</div>
					<div class="col s12 l3 mt-10">
						<div class="input-field">
							<g:select name="orgRole"
									  noSelection="${['':'Select One...']}"
									  from="${RefdataValue.findAllByOwner(com.k_int.kbplus.RefdataCategory.findByDesc('Organisational Role'))}"
									  value="${params.orgRole}"
									  optionKey="id"
									  optionValue="value"/>
							<label>Restrict to orgs who are</label>
						</div>
					</div>
					<div class="col s12 l2 mt-10">
						<div class="input-field">
							<g:select name="orgStatus"
									  noSelection="${['':'Select One...']}"
									  from="${RefdataValue.findAllByOwner(com.k_int.kbplus.RefdataCategory.findByDesc('Org Status'))}"
									  value="${params.orgStatus}"
									  optionKey="id"
									  optionValue="value"/>
							<label>With Status</label>
						</div>
					</div>
					<div class="col s6 m3 l1">
						<input type="submit" class="waves-effect waves-teal btn" value="Search"/>
					</div>
					<div class="col s6 m3 l1">
						<g:link controller="organisations" action="list" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
					</div>
                </g:form>
            </div>
        </div>
    </div>

	<div class="row">
		<div class="col s12 page-response">
			<h2 class="list-response text-navy left">
				<g:if test="${params.int('offset')}">
					Showing results: <span>${params.int('offset') + 1}</span> to <span>${orgInstanceTotal < (params.int('max') + params.int('offset')) ? orgInstanceTotal : (params.int('max') + params.int('offset'))}</span> of <span>${orgInstanceTotal}</span>
				</g:if>
				<g:elseif test="${orgInstanceTotal && orgInstanceTotal > 0}">
					Showing results: <span>1</span> to <span>${orgInstanceTotal < params.int('max') ? orgInstanceTotal : params.int('max')}</span> of <span>${orgInstanceTotal}</span>
				</g:elseif>
				<g:else>
					Showing results: <span>${orgInstanceTotal}</span>
				</g:else>
			</h2>
		</div>
	</div>

	<div class="row">
		<div class="col s12">
			<div class="filter-section z-depth-1">
				<g:form controller="organisations" action="list" method="get" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">
					<g:hiddenField name="orgNameContains" value="${params.orgNameContains}"/>
					<g:hiddenField name="orgRole" value="${params.orgRole}"/>
					<g:hiddenField name="orgStatus" value="${params.orgStatus}"/>
					<g:hiddenField name="max" value="${params.max}"/>
					<g:hiddenField name="offset" value="${params.offset}"/>
					<div class="col s12 l6">
						<div class="input-field">
							<g:select name="sort"
									  value="${params.sort}"
									  keys="['name:asc','name:desc','shortcode:asc','shortcode:desc','sector:asc','sector:desc','status:asc','status:desc','membershipOrganisation:asc','membershipOrganisation:desc']"
									  from="${['Name A-Z','Name Z-A','Short Code A-Z','Short Code Z-A','Sector A-Z','Sector Z-A','Status A-Z','Status Z-A','Membership Org A-Z','Membership Org Z-A']}"
									  onchange="this.form.submit();"/>
							<label>Sort Organisations By</label>
						</div>
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
	                                <th>${message(code: 'org.name.label', default: 'Name')}</th>
	                                <th>${message(code: 'org.shortcode.label', default: 'Short Code')}</th>
	                                <th>${message(code: 'org.type.label', default: 'Type')}</th>
	                                <th>${message(code: 'org.sector.label', default: 'Sector')}</th>
	                                <th>${message(code: 'org.sector.label', default: 'Status')}</th>
	                                <th>${message(code: 'org.sector.membershipOrganisation', default: 'Membership Org')}</th>
	                                <th>Alternative Names</th>
	                            </tr>
                            </thead>
                            <tbody>
	                            <g:each in="${orgInstanceList}" var="orgInstance">
	                                <tr>
	                                    <td><g:link controller="organisations" action="show" id="${orgInstance.id}">${orgInstance.name?:'No Org Name Set'}</g:link></td>
	                                    <td>${orgInstance.shortcode}</td>
	                                    <td>${orgInstance?.orgType?.value}</td>
	                                    <td>${orgInstance.sector}</td>
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
                    </div>
                </div>
            </div>

            <div class="pagination">
				<g:paginate controller="organisations" action="list" next="chevron_right" prev="chevron_left" offset="${offset}" max="${max}" total="${orgInstanceTotal}" params="${params}" />
			</div>
        </div>
    </div>


</body>
</html>
