<!doctype html>
<html lang="en" class="no-js">
	<head>
	   <meta name="layout" content="base"/>
	   <parameter name="pagetitle" value="TIPP Details"/>
	   <parameter name="actionrow" value="tipp-details" />
	</head>
	<body class="home">

		<div class="row">
			<div class="col s12 l12">
				<h1 class="page-title left"><g:link controller="titleDetails" action="show" id="${tipp.title.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${titleInstanceInstance?.title}</g:link></h1>
			</div>
		</div>

		<div class="row">
			<div class="col s12 l6">
				<div class="card-panel drop-line">
					<p class="card-title">In</p>
					<p class="card-caption"><g:link controller="packageDetails" action="show" id="${tipp.pkg.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${tipp.pkg.name}</g:link></p>
				</div>
			</div>

			<div class="col s12 l6">
				<div class="card-panel drop-line">
					<p class="card-title">On</p>
					<p class="card-caption"><g:link controller="platform" action="show" id="${tipp.platform.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${tipp.platform.name}</g:link></p>
				</div>
			</div>
		</div>

	    <div class="row row-content">
	    	<div class="col s12 m6 l3">
	        	<div class="card jisc_card nsmall white">
	            	<div class="card-content text-navy">
	              		<span class="card-title">IDs</span>
              			<div class="card-detail no-card-action">
	              			<g:if test="${titleInstanceInstance?.ids}">
	              				<ul class="collection">
		              				<g:each in="${titleInstanceInstance.ids}" var="i">
		              	 				<li class="collection-item plain">${i.identifier.ns.ns}:${i.identifier.value}</li>
		              				</g:each>
		            			</ul>
		          			</g:if>
		          			<g:else>
		          				<ul class="collection">
		          					<li class="collection-item plain">No IDs</li>
		          				</ul>
		          			</g:else>
              			</div>
            		</div>
         		</div>
            </div>
            <div class="col s12 m6 l3">
            	<div class="card-panel">
                	<p class="card-title">Status</p>
                 	<p class="card-label">${tipp.availabilityStatus?.value}
                 		<g:if test="${tipp.availabilityStatusExplanation}">
                 			<span class="ml-10 va">
		                        <i class="material-icons theme-icon tooltipped card-tooltip" data-position="left" data-src="availabilityExp">info</i>
		                        <script type="text/html" id="availabilityExp">
		                        	<div class="kb-tooltip">
	                            		<div class="tooltip-title">TIPP Status</div>
	                            			<ul class="tooltip-list">
	                            				<li>${tipp.availabilityStatusExplanation}</li>
	                            			</ul>
	                           			</div>
									</div
	                           	</script>
                           	</span>
                        </g:if>
                    </p>
              	</div>
              	<div class="card-panel">
              		<p class="card-title">Host Platform</p>
               		<p class="card-label">${tipp.platform.name}</p>
              	</div>
            </div>
            <div class="col s12 m6 l3">
               	<div class="card-panel">
                  	<p class="card-title">Access Start Date</p>
                  	<p class="card-label"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp?.accessStartDate}"/></p>
               	</div>
               	<div class="card-panel">
                	<p class="card-title">Access End Date</p>
                	<p class="card-label"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp?.accessEndDate}"/></p>
              	</div>
            </div>
            <div class="col s12 m6 l3">
               	<div class="card-panel">
                	<p class="card-title">Coverage Depth</p>
                	<p class="card-label">${tipp.coverageDepth}</p>
            	</div>
               	<div class="card-panel" style="overflow: scroll;">
                	<p class="card-title">Coverage Note</p>
                	<p class="card-caption">${tipp.coverageNote}</p>
               	</div>
            </div>
      	</div>

    	<div class="row">
      		<div class="col s12">
          		<div class="row strip-table z-depth-1">
            		<div class="col m12 l6 section">
              			<div class="col m6 title">
                			TIPP Start Date
              			</div>
              			<div class="col m6 result">
                			<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp?.startDate}"/>
              			</div>
            		</div>

            		<div class="col m12 l6 section">
              			<div class="col m6 title">TIPP End Date</div><div class="col m6 result">
				<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp?.endDate}"/>
              			</div>
            		</div>

            		<div class="col m12 l6 section">
              			<div class="col m6 title">
                			TIPP Start Volume
              			</div>
              			<div class="col m6 result">
                			${tipp.startVolume}
             			</div>
            		</div>

            		<div class="col m12 l6 section">
              			<div class="col m6 title">TIPP End Volume</div>
              			<div class="col m6 result">${tipp.endVolume}</div>
            		</div>
            		<div class="col m12 l6 section">
              			<div class="col m6 title">
                			TIPP Start Issue
              			</div>
              			<div class="col m6 result">
                			${tipp.startIssue}
              			</div>
            		</div>
            		<div class="col m12 l6 section">
              			<div class="col m6 title">
                			TIPP End Issue
              			</div>
              			<div class="col m6 result">
							${tipp.endIssue}
              			</div>
            		</div>
          		</div>
      		</div>
    	</div>
    	<div class="row">
      		<div class="col s12">
          		<div class="row strip-table z-depth-1">
            		<div class="col m12 l6 section">
              			<div class="col m6 title">
                			Embargo
              			</div>
              			<div class="col m6 result">
              				${tipp.embargo}
              			</div>
            		</div>
            		<div class="col m12 l6 section">
              			<div class="col m6 title">
                			Status Reason
              			</div>
              			<div class="col m6 result">
              				${tipp.statusReason}
              			</div>
            		</div>
            		<div class="col m12 l6 section">
              			<div class="col m6 title">
                			Payment
              			</div>
              			<div class="col m6 result">
              				${tipp.payment}
              			</div>
            		</div>
            		<div class="col m12 l6 section">
              			<div class="col m6 title">
                			Delayed OA
              			</div>
              			<div class="col m6 result">
              				${tipp.delayedOA}
              			</div>
            		</div>
	            	<div class="col m12 l6 section">
	              		<div class="col m6 title">
	                		Hybrid OA
	              		</div>
	              		<div class="col m6 result">
	              			${tipp.hybridOA}
	              		</div>
	            	</div>
	            	<div class="col m12 l6 section">
	              		<div class="col m6 title">
	              			Host Platform URL
	              		</div>
	              		<div class="col m6 result" style="word-wrap: break-word;">
	              			${tipp.hostPlatformURL}
	              		</div>
	            	</div>
	          	</div>
	      	</div>
	    </div>
   		<div class="row">
     		<div class="col s12">
         		<div class="tab-table z-depth-1">
            		<h1 class="table-title">Additional Platforms</h1>
            		<div class="title">
               			<div class="row table-responsive-scroll">
                   			<table class="highlight bordered">
                       			<thead>
                       				<tr>
                           				<th data-field="id">Relationship</th>
                           				<th data-field="idnamespace">Platform name</th>
                           				<th data-field="identifier">Primary URL</th>
                       				</tr>
                       			</thead>
                       			<tbody>
                       				<g:if test="${tipp.additionalPlatforms}">
	                       				<g:each in="${tipp.additionalPlatforms}" var="ap">
	                  						<tr>
							                    <td>${ap.rel}</td>
							                    <td>${ap.platform.name}</td>
							                    <td>${ap.platform.primaryUrl}</td>
	                  						</tr>
	                					</g:each>
	                				</g:if>
	                				<g:else>
	                					<tr><td colspan="3">No Data Currently Added</td></tr>
	                				</g:else>
                       			</tbody>
                   			</table>
               			</div>
            		</div>
         		</div>
     		</div>
    	</div>
    	<g:if test="${titleInstanceInstance?.tipps}">
    		<div class="row">
     			<div class="col s12">
       				<div class="search-section z-depth-1">
         				<g:form action="show" params="${params}" method="get">
         					<div class="col s12">
           						<ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
               						<li>
                   						<div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter Titles Search</div>
                   						<div class="collapsible-body">
                     						<div class="col s5">
                       							<div class="input-field">
                           							<input name="filter" value="${params.filter}"/>
                           							<label>Package name</label>
                         						</div>
                    						</div>
                     						<div class="col s7">
                       							<div class="col s4">
                       								<div class="input-field">
                       									<g:kbplusDatePicker inputid="startsBefore" name="startsBefore" value="${params.startsBefore}"/>
                         								<label class="active">Starts Before</label>
                       								</div>
                       							</div>
                       							<div class="col s4">
                       								<div class="input-field">
                       									<g:kbplusDatePicker inputid="endsAfter" name="endsAfter" value="${params.endsAfter}"/>
                         								<label class="active">Ends After</label>
                       								</div>
                       							</div>
                       							<div class="col s2">
                       								<input type="submit" class="waves-effect waves-teal btn" value="Search">
                       							</div>
                       							<div class="col s2">
													<g:link controller="tipp" action="show" id="${params.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
												</div>
                     						</div>
                     					</div>
           							</li>
       							</ul>
       						</div>
       					</g:form>
   					</div>
				</div>
			</div>
		</g:if>

        <div class="row row-content">
            <div class="col s12">
                <div class="tab-table z-depth-1">
                    <h1 class="table-title">Occurences against Packages / Platforms</h1>
                    <div class="title">
                        <div class="row table-responsive-scroll">
                            <table class="highlight bordered">
                                <thead>
                                   	<tr>
                                        <th data-field="id">From Date</th>
                                        <th data-field="idnamespace">From Volume</th>
                                        <th data-field="identifier">From Issue</th>
                                        <th data-field="id">To date</th>
                                        <th data-field="idnamespace">To volume</th>
                                        <th data-field="identifier">To Issue</th>
                                        <th data-field="id">Coverage Depth</th>
                                        <th data-field="idnamespace">Platform</th>
                                        <th data-field="identifier">Package</th>
                                    </tr>
                                </thead>
                        		<tbody>
                        			<g:if test="${tippList}">
	                         			<g:each in="${tippList}" var="t">
	                						<tr>
							                  	<td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t?.startDate}"/></td>
							              	    <td>${t.startVolume}</td>
							                	<td>${t.startIssue}</td>
							                  	<td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t?.endDate}"/></td>
							                  	<td>${t.endVolume}</td>
							                  	<td>${t.endIssue}</td>
							                  	<td>${t.coverageDepth}</td>
							                  	<td><g:link controller="platform" action="show" id="${t.platform.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${t.platform.name}</g:link></td>
							                  	<td><g:link controller="packageDetails" action="show" id="${t.pkg.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${t.pkg.name} (${t.pkg.contentProvider?.name})</g:link></td>
	                						</tr>
	              						</g:each>
	              					</g:if>
	              					<g:else>
	              						<tr><td colspan="9">No Data Currently Added</td></tr>
	              					</g:else>
                     			</tbody>
               				</table>
            			</div>
          			</div>
       			</div>
     		</div>
     	</div>
	</body>
</html>
