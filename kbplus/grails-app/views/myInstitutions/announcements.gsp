<!doctype html>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="Announcements" />
	<parameter name="pagestyle" value="Announcements" />
	<parameter name="actionrow" value="todoannouncements" />
	<meta name="layout" content="base"/>
	<title>KB+ ${institution.name} Announcements</title>
</head>
<body class="profile">
	<div class="row">
		<div class="col s12 page-response">
			<h2 class="list-response text-navy">
				<g:if test="${params.int('offset')}">
					Showing <span>${params.int('offset') + 1}</span> to <span>${num_announcements < (max + params.int('offset')) ? num_announcements : (max + params.int('offset'))}</span> of <span>${num_announcements}</span> Announcements
				</g:if>
				<g:elseif test="${num_todos && num_todos > 0}">
					Showing <span>1</span> to <span>${num_announcements < max ? num_announcements : max}</span> of <span>${num_announcements}</span> Announcements
				</g:elseif>
				<g:else>
					Showing <span>${num_announcements}</span> Announcements
				</g:else>
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
				<g:each in="${recentAnnouncements}" var="ra">
					<!--accordian item-->
					<li>
						<!--accordian header-->
						<div class="collapsible-header announcements medium-height">
							<div class="col s12 m12">
								<i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Click to toggle"></i>
								<ul class="collection">
									<li class="collection-item"><h2 class="first navy-text">${raw(ra.title)}</h2></li>
									<li class="collection-item">Date Posted: <span><g:formatDate date="${ra.dateCreated}" format="yyyy-MM-dd hh:mm a"/></span> &nbsp; <g:if test="${ra.user != null}">Posted by: <span><g:link controller="userDetails" action="pub" id="${ra.user?.id}" class="no-js">${ra.user?.displayName}</g:link></span></g:if></li>
								</ul>
							</div>
						</div>
						<!-- accordian header end-->

						<!-- accordian body-->
						<div class="collapsible-body">
							<div class="row">
								<div class="col s12">
									${raw(ra.content)}
								</div>
							</div>
						</div>
						<!-- accordian body end-->
				    </li>
					<!-- accordian item end-->
				</g:each>
			</ul>
		</div>

		<g:if test="${recentAnnouncements!=null}" >
			<div class="col s12 l12">
				<div class="pagination">
					<g:paginate action="announcements" controller="myInstitutions" params="${params}" next="chevron_right" prev="chevron_left" maxsteps="10" total="${num_announcements}"/>
				</div>
			</div>
		</g:if>
	</div>
	<!-- list accordian end-->

</body>
</html>
