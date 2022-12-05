<%@ page import ="com.k_int.kbplus.Subscription" %>
<!doctype html>
<html>
<head>
	<meta name="layout" content="base">
	<parameter name="pagetitle" value="Compare Subscriptions" />
	<parameter name="pagestyle" value="subscriptions" />
	<parameter name="actionrow" value="subscriptions-compare"/>
	<g:set var="entityName" value="${message(code: 'subscription.label', default: 'Subscription')}"/>
	<title>KB+ :: Compare Subscriptions</title>
</head>

<body class="subscriptions">
	<g:set var="params_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
	
	<div class="row">
		<div class="col s12 l12">
			<h1 class="page-title text-navy">
				<g:if test="${institutionName}">
					Compare Subscriptions of ${institutionName}
				</g:if>
				<g:else>
					Compare Subscriptions
				</g:else>
			</h1>
		</div>
        
		<g:if test="${flash.message}">
			<div class="row">
				<div class="col s12">
					${flash.message}
				</div>
			</div>
		</g:if>
		<g:if test="${request.message}">
			<div class="row">
				<div class="col s12">
					${request.message}
				</div>
			</div>
		</g:if>
		
		<g:if test="${subInsts?.get(0) && subInsts?.get(1)}">
			<!-- subscriptions detail -->
			<div class="row">
				<div class="col s6">
					<div class="card-panel fixed-height-title">
						<p class="card-title"><g:link controller="subscriptionDetails" action="index" id="${subInsts.get(0).id}" params="${params_sc}">${subInsts.get(0).name}</g:link></p>
						<p class="card-caption">Subscription on date: <span>${params.dateA}</span></p>
					</div>
				</div>
				<div class="col s6">
					<div class="card-panel fixed-height-title">	
						<p class="card-title"><g:link controller="subscriptionDetails" action="index" id="${subInsts.get(1).id}" params="${params_sc}">${subInsts.get(1).name}</g:link></p>
						<p class="card-caption">Subscription on date: <span>${params.dateB}</span></p>
					</div>
				</div>
			</div>
			<!-- subscription details end -->
			
			<div class="row">
				<div class="col s12">
					<h2 class="list-response text-navy">Subscriptions Compared</h2>
				</div>
			</div>
			
			<div class="row">
				<div class="col s12">
					<div class="tab-table">
						<table class="highlight bordered responsive-table">
							<thead>
								<tr>
									<th>Value</th>
									<th>${subInsts.get(0).name}</th>
									<th>${subInsts.get(1).name}</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>Date Created</td>
									<td><g:formatDate format="yyyy-MM-dd" date="${subInsts.get(0).dateCreated}"/></td>
									<td><g:formatDate format="yyyy-MM-dd" date="${subInsts.get(1).dateCreated}"/></td>
								</tr>
								<tr>
									<td>Start Date</td>
									<td><g:formatDate format="yyyy-MM-dd" date="${subInsts.get(0).startDate}"/></td>
									<td><g:formatDate format="yyyy-MM-dd" date="${subInsts.get(1).startDate}"/></td>
								</tr>
								<tr>
									<td>End Date</td>
									<td><g:formatDate format="yyyy-MM-dd" date="${subInsts.get(0).endDate}"/></td>
									<td><g:formatDate format="yyyy-MM-dd" date="${subInsts.get(1).endDate}"/></td>
								</tr>
								<tr>
									<td>Number of IEs</td>
									<td>${params.countA}</td>
									<td>${params.countB}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col s12">
					<div class="col s12 search-section z-depth-1">
						<g:form action="compare" method="GET" class="form-inline" params="${params_sc}">
							<input type="hidden" name="subA" value="${params.subA}"/>
							<input type="hidden" name="subB" value="${params.subB}"/>
							<input type="hidden" name="dateA" value="${params.dateA}"/>
							<input type="hidden" name="dateB" value="${params.dateB}"/>
							<input type="hidden" name="insrt" value="${params.insrt}"/>
							<input type="hidden" name="dlt" value="${params.dlt}"/>
							<input type="hidden" name="updt" value="${params.updt}"/>
							<input type="hidden" name="nochng" value="${params.nochng}"/>
							<input type="hidden" name="countA" value="${params.countA}"/>
							<input type="hidden" name="countB" value="${params.countB}"/>
							<div class="col s12 m12 l6 mt-10">
								<input placeholder="Filter By Title" name="filter" value="${params.filter}">
							</div>
							<div class="col s12 m12 l6">
								<input type="submit" class="btn btn-primary" value="Filter Results" />
								<input id="resetFilters" type="submit" class="resetsearch inputreset" value="Reset" />
							</div>
						</g:form>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col s12 page-response">
					<h2 class="list-response text-navy">Showing Titles <span>${offset+1}</span> to <span>${offset+comparisonMap.size()}</span> of <span>${unionListSize}</span></h2>
				</div>
			</div>
			
			<div class="row">
				<div class="col s12 m6">
					<ul class="jisc-compare-collection collection with-header">
						<li class="collection-header">
							<h2 class="navy-text">${subInsts.get(0).name} on ${subDates.get(0)}</h2>
						</li>
						<li class="collection-item"><h3 class="text-green">Total IEs: ${listACount}</h3></li>
						
						<g:each in="${comparisonMap}" var="entry">
							<g:set var="subAIE" value="${entry.value[0]}"/>
							<g:set var="currentTitle" value="${subAIE?.tipp?.title}"/>
							<g:set var="highlight" value="${entry.value[3]}"/>
							<li class="collection-item fixed-compare-data" style="${subAIE && highlight?'background-color: '+highlight+';':''}">
								<g:if test="${subAIE}">
									<h3 class="sub-title text-navy"><g:link action="show" controller="titleDetails" id="${currentTitle.id}" params="${params_sc}">${entry.key}</g:link> <span class="inline-badge tooltipped card-tooltip" data-position="right" data-src="subA-${currentTitle.id}-ids"><i class="material-icons">info_outline</i></span></h3>
									<script type="text/html" id="subA-${currentTitle.id}-ids">
										<div class="kb-tooltip">
											<div class="tooltip-title">Detail</div>
											<ul class="tooltip-list">
												<g:each in="${currentTitle.ids}" var="id">
													<li>${id.identifier.ns.ns}:${id.identifier.value}</li>
												</g:each>
											</ul>
										</div>
									</script>
									<g:render template="compare_cell" model="[obj:subAIE, subCol:'A']"/>
								</g:if>
							</li>
						</g:each>
					</ul>
				</div>
				
				<!-- This is the right hand column, so subB, or subInsts.get(1) -->
				<div class="col s12 m6">
					<ul class="jisc-compare-collection collection with-header">
						<li class="collection-header">
							<h2 class="navy-text">${subInsts.get(1).name} on ${subDates.get(1)}</h2>
						</li>
						<li class="collection-item"><h3 class="text-green">Total IEs: ${listBCount}</h3></li>
							                
						<g:each in="${comparisonMap}" var="entry">
							<g:set var="subBIE" value="${entry.value[1]}"/>
							<g:set var="currentTitle" value="${subBIE?.tipp?.title}"/>
							<g:set var="highlight" value="${entry.value[3]}"/>
							<li class="collection-item fixed-compare-data" style="${subBIE && highlight?'background-color: '+highlight+';':''}">
								<g:if test="${subBIE}">
									<h3 class="sub-title text-navy"><g:link action="show" controller="titleDetails" id="${currentTitle.id}" params="${params_sc}">${entry.key}</g:link> <span class="inline-badge tooltipped card-tooltip" data-position="right" data-src="subB-${currentTitle.id}-ids"><i class="material-icons">info_outline</i></span></h3>
									<script type="text/html" id="subB-${currentTitle.id}-ids">
										<div class="kb-tooltip">
											<div class="tooltip-title">Detail</div>
											<ul class="tooltip-list">
												<g:each in="${currentTitle.ids}" var="id">
													<li>${id.identifier.ns.ns}:${id.identifier.value}</li>
												</g:each>
											</ul>
										</div>
									</script>
									<g:render template="compare_cell" model="[obj:subBIE, subCol:'B']"/>
								</g:if>
							</li>
						</g:each>
					</ul>
				</div>
			</div>
			
			<div class="row">
				<div class="col s12 m12">
					<div class="pagination">
						<g:paginate action="compare" controller="subscriptionDetails" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${unionListSize}" />
					</div>
				</div>
			</div>
		</g:if>
	</div>
</body>
</html>
