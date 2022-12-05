<!doctype html>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="Pending Changes" />
	<parameter name="actionrow" value="todoannouncements" />
	<meta name="layout" content="base"/>
	<title>KB+ ${institution.name} ToDo List</title>
</head>
<body class="profile">

  <g:render template="/templates/flash_alert_panels"/>

	<div class="row">
		<div class="col s12 page-response">
			<h2 class="list-response text-navy">
        You currently have ${num_todos} Pending Changes
			</h2>
		</div>
	</div>

	<!-- search-section start-->
	<!--
	<div class="row">
		<div class="col s12">
			<div class="search-section z-depth-1">
				<form>
					<div class="col s12">
						<ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
							<li>
								<div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter Search</div>
								<div class="collapsible-body">
									<div class="col s12 m12 l6 mt-10">
										<div class="input-field">
											<select>
												<option value="" disabled selected>click to choose</option>
												<option value="1">Subscription</option>
												<option value="2">licences</option>
												<option value="3">titles</option>
												<option value="4">packages</option>
											</select>
											<label for="">Section choice</label>
										</div>
									</div>

									<div class="col s6 m6 l3">
										<a class="waves-effect btn">A/Z</a>
										<a class="waves-effect btn active">Recently Edited</a>
									</div>
								</div>
							</li>
						</ul>
					</div>
				</form>
			</div>
		</div>
	</div>
	-->
	<!-- search-section end-->

	<!-- list accordian start-->
	<div class="row">
		<div class="col s12 l12">
			<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
				<g:each in="${todos}" var="todo">
					<g:set var="objectDetailURL" value=""/>
					<g:set var="objectType" value=""/>
					<g:if test="${todo.item_with_changes instanceof com.k_int.kbplus.Subscription}">
						<g:set var="objectDetailURL" value="${createLink(controller:'subscriptionDetails', action:'index', id:todo.item_with_changes.id, params:[defaultInstShortcode:params.defaultInstShortcode])}?#pendingchanges"/>
						<g:set var="objectType" value="${message(code:'subscription')}"/>
					</g:if>
					<g:elseif test="${todo.item_with_changes instanceof com.k_int.kbplus.License}">
						<g:set var="objectDetailURL" value="${createLink(controller:'licenseDetails', action:'index', id:todo.item_with_changes.id, params:[defaultInstShortcode:params.defaultInstShortcode])}?#pendingchanges"/>
						<g:set var="objectType" value="${message(code:'licence')}"/>
					</g:elseif>
					<!--accordian item-->
					<li>
						<!--accordian header-->
						<div class="collapsible-header medium-height">
							<div class="col s12 m10">
								<i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Expand/Collapse"></i>
								<ul class="collection">
									<li class="collection-item">
										<h2 class="first navy-text">
											<g:if test="${objectDetailURL}">
												<a href="${objectDetailURL}" class="no-js">${objectType}: ${todo.item_with_changes.toString()}</a>
											</g:if>
											<g:else>
												${todo.item_with_changes.toString()}
											</g:else>
										</h2>
									</li>
									<li class="collection-item">
										Changes between <span><g:formatDate date="${todo.earliest}" format="yyyy-MM-dd hh:mm a"/></span> and <span><g:formatDate date="${todo.latest}" format="yyyy-MM-dd hh:mm a"/></span>
									</li>
									<li class="collection-item">Pending changes: <span class="inline-badge">${todo.num_changes}</span></li>
								</ul>
							</div>
							<div class="col s12 m2 full-height-divider">
								<ul class="collection">
									<li class="collection-item actions first">
										<div class="actions-container-triple">
											<a href="${objectDetailURL}" class="btn-floating btn-flat no-js"><i class="material-icons">remove_red_eye</i></a>
											<g:link controller="pendingChange" action="acceptAll" id="${todo.oid}" class="btn-floating btn-flat no-js"><i class="material-icons">done_all</i></g:link>
											<g:link controller="pendingChange" action="rejectAll" id="${todo.oid}" class="btn-floating btn-flat no-js"><i class="material-icons">delete_forever</i></g:link>
										</div>
									</li>
								</ul>
							</div>
						</div>
						<!-- accordian header end-->

						<!-- accordian body-->
						<div class="collapsible-body">
							<div class="row">
								<div class="col s12">
									<h2 class="navy-text">Changes</h2>
								</div>
							</div>

							<g:each in="${todo.items}" var="item">
								<div class="row">
									<div class="col s10">
										<p>${raw(item.desc)}</p>
									</div>
									<div class="col s2">
										<div class="center-horizontal">
											<g:link controller="pendingChange" action="accept" params="${[id:item.id, referer:'yes']}" class="btn-floating table-action"><i class="material-icons">done</i></g:link>
											<g:link controller="pendingChange" action="reject" params="${[id:item.id, referer:'yes']}" class="btn-floating table-action"><i class="material-icons">close</i></g:link>
										</div>
									</div>
								</div>
							</g:each>
							<!-- accordian body end-->
						</div>
					</li>
					<!-- accordian item end-->
				</g:each>
			</ul>
		</div>

		<g:if test="${todos!=null}" >
			<div class="col s12 l12">
				<div class="pagination">
					<g:paginate action="todo" controller="myInstitutions" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${num_todos}" />
				</div>
			</div>
		</g:if>

	</div>
	<!-- list accordian end-->

</body>
</html>
