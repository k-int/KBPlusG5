<%@ page import ="com.k_int.kbplus.Package" %>
<!doctype html>
<html>
<head>
	<meta name="layout" content="base">
	<parameter name="pagetitle" value="Compare Packages" />
	<parameter name="pagestyle" value="Packages" />
	<parameter name="actionrow" value="packages-compare" />
	<g:set var="entityName" value="${message(code: 'package.label', default: 'Package')}" />
	<title>KB+ :: Compare Packages</title>
</head>

<body class="packages">

	<div class="row">
		<div class="col s12 l12">
			<h1 class="page-title text-navy">
				Package compared
			</h1>
		</div>
	</div>

	<g:if test="${flash.message}">
		<p>${flash.message}</p>
	</g:if>
	<g:if test="${request.message}">
		<p>${request.message}</p>
	</g:if>

	<g:if test="${pkgInsts?.get(0) && pkgInsts?.get(1)}">
		<!-- package detail -->
		<div class="row">
			<div class="col s6">
				<div class="card-panel fixed-height-title">
					<p class="card-title">${pkgInsts.get(0).name}</p>
					<p class="card-caption">Package on date: <span>${params.dateA}</span></p>
				</div>
			</div>
			<div class="col s6">
				<div class="card-panel fixed-height-title">
					<p class="card-title">${pkgInsts.get(1).name}</p>
					<p class="card-caption">Package on date: <span>${params.dateB}</span></p>
				</div>
			</div>
		</div>
		<!-- package details end -->
		
	    <div class="row">
	        <div class="col s12">
	            <div class="tab-table">
	                <table class="highlight bordered responsive-table">
	                    <thead>
	                        <tr>
	                            <th>Value</th>
	                            <th>${pkgInsts.get(0).name}</th>
	                            <th>${pkgInsts.get(1).name}</th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                        <tr>
	                            <td>Date Created</td>
	                            <td><g:formatDate format="yyyy-MM-dd" date="${pkgInsts.get(0).dateCreated}"/></td>
	                            <td><g:formatDate format="yyyy-MM-dd" date="${pkgInsts.get(1).dateCreated}"/></td>
	                        </tr>
	                        <tr>
	                            <td>Start Date</td>
	                            <td><g:formatDate format="yyyy-MM-dd" date="${pkgInsts.get(0).startDate}"/></td>
	                            <td><g:formatDate format="yyyy-MM-dd" date="${pkgInsts.get(1).startDate}"/></td>
	                        </tr>
	                        <tr>
	                            <td>End Date</td>
	                            <td><g:formatDate format="yyyy-MM-dd" date="${pkgInsts.get(0).endDate}"/></td>
	                            <td><g:formatDate format="yyyy-MM-dd" date="${pkgInsts.get(1).endDate}"/></td>
	                        </tr>
	                        <tr>
              					<td>Number of TIPPs</td>
              					<td>${params.countA}</td>
              					<td>${params.countB}</td>
            				</tr>
	                    </tbody>
	                </table>
	            </div>
	        </div>
	    </div>

        <!-- TODO this needs to be in a filter search part! -->
        <div class="row">
	        <div class="col s12">
	            <div class="col s12 search-section z-depth-1">
	            	<ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
                    	<li>
                        	<div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter</div>
                        	<div class="collapsible-body">
					           	<g:form controller="packageDetails" action="compare" method="get" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">
							       	<input type="hidden" name="pkgA" value="${params.pkgA}"/>
							       	<input type="hidden" name="pkgB" value="${params.pkgB}"/>
									<input type="hidden" name="dateA" value="${params.dateA}"/>
									<input type="hidden" name="dateB" value="${params.dateB}"/>
									<input type="hidden" name="insrt" value="${params.insrt}"/>
									<input type="hidden" name="dlt" value="${params.dlt}"/>
									<input type="hidden" name="updt" value="${params.updt}"/>
									<input type="hidden" name="nochng" value="${params.nochng}"/>
									<input type="hidden" name="countA" value="${params.countA}"/>
									<input type="hidden" name="countB" value="${params.countB}"/>

									<div class="col s12">
										<div class="col s12 m4 l6 mt-20">
											<div class="input-field">
												<input name="filter" id="filter" type="text" value="${params.filter}">
												<label for="filter">Filter By Title</label>
											</div>
										</div>
										<div class="col s6 m4 l3 mt-20">
											<div class="input-field">
												<g:kbplusDatePicker inputid="startsBefore" name="startsBefore" value="${params.startsBefor}"/>
												<label class="active">Coverage Starts Before</label>
											</div>
										</div>
										<div class="col s6 m4 l3 mt-20">
											<div class="input-field">
												<g:kbplusDatePicker inputid="endsAfter" name="endsAfter" value="${params.endsAfter}"/>
												<label class="active">Coverage Ends After</label>
											</div>

										</div>
									</div>

									<div class="col s12">
										<div class="col s12 m4 l6 mt-20">
											<div class="input-field">
												<input id="coverageNoteFilter" name="coverageNoteFilter" type="text" value="${params.coverageNoteFilter}">
												<label for="coverageNoteFilter">Coverage Note</label>
											</div>
										</div>
										<div class="col s12 m6">
											<div class="col s6">
												<input type="submit" class="waves-effect btn" value="Filter Results" />
											</div>
											<div class="col s6">
												<input id="resetFilters" type="submit" class="resetsearch inputreset" value="Reset Filters" />
											</div>
										</div>
									</div>
			        			</g:form>
			        		</div>
			        	</li>
			        </ul>
	            </div>
	        </div>
	    </div>
	    <!-- end TODO -->

	    <div class="row">
	        <div class="col s12 page-response">
	        	<!-- TODO think about putting if statement here if we have no titles to show -->
	            <h2 class="list-response text-navy">Showing Titles: <span>${offset+1}</span> to <span>${offset+comparisonMap.size()}</span> of <span>${unionListSize}</span></h2>
	        </div>
	    </div>

        <div class="row">
	        <div class="col s12 m6">
	            <ul class="jisc-compare-collection collection with-header compareheight">
	                <li class="collection-header">
	                    <h2 class="navy-text">${pkgInsts.get(0).name} on ${pkgDates.get(0)}</h2>
	                </li>
	                <li class="collection-item"><h3 class="text-blue">Titles: ${listACount}</h3></li>
	                <g:each in="${comparisonMap}" var="entry">
              			<g:set var="pkgATipp" value="${entry.value[0]}"/>
              			<g:set var="currentTitle" value="${pkgATipp?.title}"/>
              			<g:set var="highlight" value="${entry.value[3]}"/>
			            <g:if test="${pkgATipp}">
			            	<li class="collection-item fixed-compare-data" style="${highlight?'background-color: '+highlight+';':''}">
				            	<h3 class="sub-title text-navy"><g:link action="show" controller="titleDetails" id="${currentTitle.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${entry.key}</g:link> <span class="inline-badge tooltipped card-tooltip" data-position="right" data-src="pkgA-${currentTitle.id}-ids"><i class="material-icons">info_outline</i></span></h3>
		                    	<script type="text/html" id="pkgA-${currentTitle.id}-ids">
                    				<div class="kb-tooltip">
                        				<div class="tooltip-title">Detail</div>
                        				<ul class="tooltip-list">
											<g:each in="${currentTitle.ids}" var="id">
			                            		<li>${id.identifier.ns.ns}:${id.identifier.value}</li>
			                        		</g:each>
                        				</ul>
                    				</div>
                    			</script>
                    			<g:render template="compare_cell" model="[obj:pkgATipp, pkgCol:'A']"/>
                    		</li>
                    		<li class="collection-item" style="${highlight?'background-color: '+highlight+';':''}">
                    			<h3 class="text-blue">Coverage Note:</h3>
                    			<p>
                    				<g:if test="${pkgATipp.coverageNote}">
                    					${pkgATipp.coverageNote}
                    				</g:if>
                    				<g:else>
                    					N/A
                    				</g:else>
                    			<p>
                    		</li>
                		</g:if>
                		<g:else>
                			<li class="collection-item fixed-compare-data"></li>
                			<li class="collection-item">&nbsp;</li>
                		</g:else>
            		</g:each>
	            </ul>
	        </div>

			<!-- This is the right hand column, so pkgB, or pkgInsts.get(1) -->
	        <div class="col s12 m6">
	            <ul class="jisc-compare-collection collection with-header compareheight">
	                <li class="collection-header">
	                    <h2 class="navy-text">${pkgInsts.get(1).name} on ${pkgDates.get(1)}</h2>
	                </li>
	                <li class="collection-item"><h3 class="text-blue">Titles: ${listBCount}</h3></li>
	                <g:each in="${comparisonMap}" var="entry">
              			<g:set var="pkgBTipp" value="${entry.value[1]}"/>
              			<g:set var="currentTitle" value="${pkgBTipp?.title}"/>
              			<g:set var="highlight" value="${entry.value[3]}"/>
			            <g:if test="${pkgBTipp}">
			            	<li class="collection-item fixed-compare-data" style="${highlight?'background-color: '+highlight+';':''}">
				            	<h3 class="sub-title text-navy"><g:link action="show" controller="titleDetails" id="${currentTitle.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${entry.key}</g:link> <span class="inline-badge tooltipped card-tooltip" data-position="right" data-src="pkgB-${currentTitle.id}-ids"><i class="material-icons">info_outline</i></span></h3>
		                    	<script type="text/html" id="pkgB-${currentTitle.id}-ids">
                    				<div class="kb-tooltip">
                        				<div class="tooltip-title">Detail</div>
                        				<ul class="tooltip-list">
											<g:each in="${currentTitle.ids}" var="id">
			                            		<li>${id.identifier.ns.ns}:${id.identifier.value}</li>
			                        		</g:each>
                        				</ul>
                    				</div>
                    			</script>
                    			<g:render template="compare_cell" model="[obj:pkgBTipp, pkgCol:'B']"/>
                    		</li>
                    		<li class="collection-item" style="${highlight?'background-color: '+highlight+';':''}">
                    			<h3 class="text-blue">Coverage Note:</h3>
                    			<p>
                    				<g:if test="${pkgBTipp.coverageNote}">
                    					${pkgBTipp.coverageNote}
                    				</g:if>
                    				<g:else>
                    					N/A
                    				</g:else>
                    			<p>
                    		</li>
			            </g:if>
                		<g:else>
                			<li class="collection-item fixed-compare-data"></li>
                			<li class="collection-item">&nbsp;</li>
                		</g:else>
            		</g:each>
	            </ul>
	        </div>
	    </div>

        <div class="row">
	        <div class="col s12 m12">
        		<div class="pagination">
     				<g:paginate action="compare" controller="packageDetails" params="${params}" next="chevron_right" prev="chevron_left" maxsteps="${max}" total="${unionListSize}" />
        		</div>
        	</div>
        </div>
	</g:if>
</body>
</html>
