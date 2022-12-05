<!doctype html>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="Change Log" />
	<parameter name="pagestyle" value="changeLog" />
	<parameter name="actionrow" value="changelog" />
	<meta name="layout" content="base"/>
	<title>KB+ ${institution.name} Change Log</title>
</head>
<body class="profile">
	<div class="row">
		<div class="col s12 page-response">
			<h2 class="list-response text-navy">
				<g:if test="${params.int('offset')}">
					Showing <span>${params.int('offset') + 1}</span> to <span>${num_todos < (max + params.int('offset')) ? num_todos : (max + params.int('offset'))}</span> of <span>${num_todos}</span> Items with Changes
				</g:if>
				<g:elseif test="${num_todos && num_todos > 0}">
					Showing <span>1</span> to <span>${num_todos < max ? num_todos : max}</span> of <span>${num_todos}</span> Items with Changes
				</g:elseif>
				<g:else>
					Showing <span>${num_todos}</span> Items with Changes
				</g:else>
			</h2>
		</div>
	</div>

	<!--
	<div class="row">
		<div class="col s12">
			<div class="filter-section z-depth-1">
				<div class="col s12 l6">
					<div class="input-field">
						<select>
							<option value="1" selected>A-Z</option>
							<option value="2">Z-A</option>
							<option value="3">Start Date</option>
							<option value="4">End Date</option>
						</select>
						<label>Sort change log by: A-Z (default)</label>
					</div>
				</div>

				<div class="col s12 l6 filter-actions button-area-line">
				</div>
			</div>
		</div>
	</div>
	-->

	<div class="row">
		<div class="col s12">
			<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
				<g:each in="${todos}" var="todo">
					<!--accordian item-->
					<li>
						<!--accordian header-->
						<div class="collapsible-header medium-height">
							<div class="col s12">
								<i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Click to toggle"></i>
								<ul class="collection">
									<li class="collection-item">
										<h2 class="first navy-text">
											<g:if test="${todo.item_with_changes instanceof com.k_int.kbplus.Subscription}">
												<g:link controller="subscriptionDetails" action="index" id="${todo.item_with_changes.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${message(code:'subscription')}: ${todo.item_with_changes.name}</g:link>
											</g:if>
											<g:elseif test="${todo.item_with_changes instanceof com.k_int.kbplus.License}">
												<g:link controller="licenseDetails" action="index" id="${todo.item_with_changes.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${message(code:'licence')}: ${todo.item_with_changes.reference}</g:link>
											</g:elseif>
											<g:else>
												${todo.item_with_changes.toString()}
											</g:else>
										</h2>
									</li>
									<li class="collection-item">
										Change(s) between <span><g:formatDate date="${todo.earliest}" format="yyyy-MM-dd hh:mm a"/></span> and <span><g:formatDate date="${todo.latest}" format="yyyy-MM-dd hh:mm a"/></span>
									</li>
									<li class="collection-item">Associated Changes: <span class="inline-badge">${todo.num_changes}</span></li>
								</ul>
							</div>
						</div>
						<!-- accordian header end-->

						<!-- accordian body-->
						<div class="collapsible-body">
							<div class="row">
								<div class="col s12">
									<h3>Changes</h3>
									<g:each in="${todo.items}" var="item">
										<p>${raw(item.desc)}</p>
									</g:each>
								</div>
							</div>
						</div>
						<!-- accordian body end-->
					</li>
					<!-- accordian item end-->
				</g:each>
			</ul>
		</div>

		<g:if test="${todos!=null}" >
			<div class="col s12">
				<div class="pagination">
					<g:paginate action="changeLog" controller="myInstitutions" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${num_todos}" />
				</div>
			</div>
		</g:if>
	</div>

</body>
</html>
