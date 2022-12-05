<!doctype html>
<%
	def workoutLicenceIcon = { icon ->
		def result = ["no", "clear"]
		if (icon.equals("greenTick")) {
			result = ["yes", "done"]
		}
		else if (icon.equals("purpleQuestion"))
		{
			result = ["neither", "info_outline"]
		}
		
		result
	}
	
	def keyPropsDisplay = { props ->
		def result = [:]
		def keyProps = ["Include in VLE", "Include In Coursepacks", "ILL - InterLibraryLoans", "Walk In Access", "Remote Access", "Alumni Access"]
		props.each { prop ->
			if ((prop?.type?.name) && (keyProps.contains(prop.type.name))) {
				def icon = workoutLicenceIcon(prop?.refValue?.icon)
				result.put(prop.type.name, icon)
			}
		}
		
		if (result.size() < keyProps.size()) {
			keyProps.each { kp ->
				if (!result.containsKey(kp)) {
					result.put(kp, ["no", "clear"])
				}
			}
		}
		
		result
	}
%>

<html lang="en" class="no-js">
<head>
  <parameter name="pagetitle" value="Template licences" />
  <parameter name="pagestyle" value="data-manager" />
  <parameter name="actionrow" value="data-manager-licences-list" />
  <meta name="layout" content="base"/>
  <title>KB+ All Licences</title>
</head>
<body class="data-manager">
  <!-- context bar start-->
  <!--<div class="row">
     <div class="col s12">
      <div class="row strip-table z-depth-1">
        <p class="left">Subscriptions are usually agreements between an institution and a publisher to gain to set of resource, for a period of time, under specific conditions (set out in Licences). <a href="#">Learn more about Licences</a>.</p><a href="#"><i class="material-icons right">close</i></a>
     </div>
    </div>
  </div>-->
  <!-- context bar end-->
  	
  <g:render template="/templates/flash_alert_panels"/>

	<!-- search-section start-->
	<div class="row">
		<div class="col s12">

			<div class="mobile-collapsible-header" data-collapsible="licence-list-collapsible">Search <i class="material-icons">expand_more</i></div>
			<div class="search-section z-depth-1  mobile-collapsible-body" id="licence-list-collapsible">
				<form>
					<div class="col s12 mt-10">
						<h3 class="page-title left">Search All Licences</h3>
					</div>
					<div class="col s12 l8">
				        <div class="input-field search-main">
							<input id="searchAllLicences" name="keyword-search" type="search" value="${params['keyword-search']?:''}">
							<label class="label-icon" for="searchAllLicences"><i class="material-icons">search</i></label>
							<i id="clearSearch" class="material-icons close" search-id="searchAllLicences">close</i>
				        </div>
					</div>
					<div class="col s12 l2 mt-10">
						<div class="input-field">
							<g:kbplusDatePicker inputid="datepicker-validOn" name="validOn" value="${validOn}"/>
							<label class="active">Valid On</label>
						</div>
					</div>
					<div class="col s6 m3 l1">
						<input type="submit" class="waves-effect waves-teal btn" value="Search" />
					</div>

					<div class="col s6 m3 l1">
						<g:link controller="dataManager" action="allLicenses" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
					</div>
	
					<!--search filter -->
					<div class="col s12">
						<ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
						    <li>
						      	<div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter Search</div>
						      	<div class="collapsible-body">
	
		  					      	<div class="col s12 l6 mt-10">
		  	      						<div class="input-field">
		  	      							<g:select id="availablePropertyTypes"
		  	      									  name="availablePropertyTypes"
		  	      									  from="${custom_prop_types}"
		  	      									  optionKey="value"
		  	      									  optionValue="key"
		  	      									  value="${params.propertyFilterType}"
		  	      									  noSelection="['':'Select one']"
		  	      									  lookupurl="${createLink(controller:'ajax', action:'sel2RefdataSearch')}"/>
											<label>Key Properties</label>
		  								</div>
		  	      					</div>
	
							      	<div class="col s12 l6 mt-10">
							      		<div class="input-field">
							      			<input id="selectVal" type="text" name="propertyFilter" placeholder="Property value..." value="${params.propertyFilter?:''}" />
											<label>Property Value</label>
							      		</div>
								    </div>
								    <div class="col s12 l12 mt-10 single-line-checkbox">
                      					<div class="radio-container-float left">
                        					<input type="checkbox" id="jiscLicSearch" name="jiscLicSearch" value="${true}"<%=(params.jiscLicSearch)?' checked="true"':''%> />
                        					<label class="pt-10" for="jiscLicSearch">Search by JISC License Id</label>
                      					</div>
                    				</div>
	                  			</div>
						    </li>
						</ul>
					</div>
					<!--search filter end -->
					<input type="hidden" id="propFilter" name="tempFilter" value="${params.propertyFilter}"/>
					<input type="hidden" id="propertyFilterType" name="propertyFilterType" value="${params.propertyFilterType}"/>
				</form>
			</div>

		</div>
	</div>
	<!-- search-section end-->


	<!-- list returning/results-->
	<div class="row">
		<div class="col s12 page-response">
      		<h2 class="list-response text-navy left">
      			<g:if test="${licenseCount && licenseCount>0}">
          			You currently have <span>${licenseCount}</span> Licences: Showing <span>${offset + 1}</span> - <span>${offset + licenses.size()}</span>
        		</g:if>
        		<g:else>
        			You currently have <span>0</span> Licences
        		</g:else>
        		<span>
					<g:if test="${params['keyword-search']}">
						 -- Search Text: ${params['keyword-search']} 
					</g:if>
					<g:if test="${validOn}">
						 -- Valid On: ${validOn}
					</g:if>
					<g:if test="${params.propertyFilterType}">
						 -- Property Key: ${params.propertyFilterType}
					</g:if>
					<g:if test="${params.propertyFilter}">
						 -- Property Value: ${params.propertyFilter}
					</g:if>
				</span>
      		</h2>
      	</div>
	</div>
	
	<div class="row">
		<div class="col s12">
			<div class="filter-section z-depth-1">
				<g:form controller="dataManager" action="allLicenses" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" method="get">
					<g:hiddenField name="keyword-search" value="${params['keyword-search']?.encodeAsHTML()}"/>
					<g:hiddenField name="validOn" value="${validOn}"/>
					<g:hiddenField name="propertyFilterType" value="${params.propertyFilterType}"/>
					<g:hiddenField name="propertyFilter" value="${params.propertyFilter}"/>
					<g:hiddenField name="max" value="${params.max}"/>
					<g:hiddenField name="offset" value="${params.offset}"/>
					
					<div class="col s12 l6">
						<div class="input-field">
							<g:select name="sort"
									  value="${params.sort}"
									  keys="['reference:asc','reference:desc','startDate:asc','endDate:asc']"
									  from="${['A-Z','Z-A','Start Date','End Date']}"
									  onchange="this.form.submit();"/>
							<label>Sort Licences By:</label>
						</div>
					</div>
				</g:form>
			</div>
		</div>
	</div>
	<!-- list returning/results end-->


	<!-- list accordian start-->
	<div class="row">
		<div class="col s12">
			<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
				<g:each in="${licenses}" var="l">
				    <!--accordian item-->
				    <li>
				    	<!--accordian header-->
				      	<div class="collapsible-header">
				      		<div class="col s12 m10">
				      			<i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Expand/Collapse"></i>
				      			<ul class="collection">
				      				<li class="collection-item">
										<h2 class="first navy-text"><g:link action="index" controller="licenseDetails" id="${l.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="no-js">${l.reference?:message(code:'missingLicenseReference', default:'** No Licence Reference Set **')}</g:link> ${l.type?.value.equals('Template') ? '(Template License)' : '' }</h2>
				      				</li>
				      				<li class="collection-item">
				      					<g:if test="${l.startDate}">
				      						<span><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${l.startDate}"/></span>
				      					</g:if>
				      					<g:else>
				      						<span>No Start Date</span>
				      					</g:else>
				      					 until 
				      					<g:if test="${l.endDate}">
				      						<span><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${l.endDate}"/></span>
				      					</g:if>
				      					<g:else>
				      						<span>No End Date</span>
				      					</g:else>
				      				</li>
				      				<li class="collection-item">Licensor: <span>${l.licensor?.name ?: 'No Licensor'}</span></li>
				      				<li class="collection-item">Linked Subscriptions: 
	                    				<g:if test="${l.subscriptions && ( l.subscriptions.size() > 0 )}">
											<g:if test="${l.subscriptions.size()==1}">
												<g:if test="${l.subscriptions.getAt(0).status?.value != 'Deleted'}">
				      								<span><g:link controller="subscriptionDetails" action="index" id="${l.subscriptions.getAt(0).id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${l.subscriptions.getAt(0).name}</g:link></span>
												</g:if>
												<g:else>
													<span>No Linked Subscriptions</span>
												</g:else>
				      						</g:if>
				      						<g:else>
				      							<span class="inline-badge tooltipped card-tooltip" data-position="right" data-src="subs-${l.id}">${l.subscriptions.size()}</span>
				      							<script type="text/html" id="subs-${l.id}">
												<div class="kb-tooltip">
				      								<div class="tooltip-title">Subscriptions</div>
				      								<ul class="tooltip-list">
														<g:each in="${l.subscriptions}" var="sub">
			                          						<g:if test="${sub.status?.value != 'Deleted'}">
	                  											<li>
	                    											${sub.name}
	                  											</li>
	                										</g:if>
														</g:each>
													</ul>
				      							</div>
				      							</script>
				      						</g:else>
				      					</g:if>
				      					<g:else>
				      						<span>No Linked Subscriptions</span>
				      					</g:else>
				      				</li>
	                    			
	                    			<li class="collection-item">
	                    				Associated:
	                    				<!-- set up counters and loop through documents to find and count each type -->
	                    				<g:set var="docs_count" value="${0 as Integer}"/>
	                    				<g:set var="notes_count" value="${0 as Integer}"/>
	                    				<g:each in="${l.documents}" var="docctx">
            								<g:if test="${docctx.owner.contentType == 0 && (docctx.status == null || docctx.status?.value != 'Deleted')}">
            									<g:set var="notes_count" value="${notes_count+1}"/>
            								</g:if>
            								<g:elseif test="${(((docctx.owner?.contentType == 1) || (docctx.owner?.contentType == 3)) && (docctx.status?.value != 'Deleted'))}">
            									<g:set var="docs_count" value="${docs_count+1}"/>
            								</g:elseif>
            							</g:each>
				      					<span class="indicator"><i class="material-icons left">view_list</i>  Notes (${notes_count})</span>
				      					<span class="indicator"><i class="material-icons left">description</i> Documents (${docs_count})</span>
				      				</li>
				      			</ul>
				      		</div>
				      		<div class="col s12 m2 full-height-divider">
								<ul class="collection">
									<li class="collection-item actions first">
										<div class="actions-container">
											<g:if test="${params.defaultInstShortcode}">
												<g:link controller="myInstitutions" action="actionLicenses" params="${[defaultInstShortcode:params.defaultInstShortcode,baselicense:l.id,'cpy-licence':'Y']}" class="btn-floating btn-flat waves-effect waves-light no-js"><i class="material-icons">content_copy</i></g:link>
											</g:if>
										</div>
									</li>
								</ul>
				      		</div>
				      	</div>
				      	<!-- accordian header end-->
	
				      	<!-- accordian body-->
				      	<div class="collapsible-body">
							<g:set var="licProps" value="${keyPropsDisplay(l.customProperties)}"/>
				      		<div class="row">
				      			<div class="col s12">
				      				<h3>Licences Key Properties</h3>
				      				<div class="properties-container center-graphic">
				      					<div class="col s6 l2 property">
				      						<g:set var="klp_vle" value="${licProps.get('Include in VLE')}"/>
	                        				<div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">computer_black</i><i class="material-icons icon-offset ${klp_vle[0]}">${klp_vle[1]}</i></div>
	                        				Include in VLE
				      					</div>
				      					<div class="col s6 l2 property">
				      						<g:set var="klp_cp" value="${licProps.get('Include In Coursepacks')}"/>
	                        				<div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">library_books</i><i class="material-icons icon-offset ${klp_cp[0]}">${klp_cp[1]}</i></div>
	                        				Include in Coursepacks
				      					</div>
				      					<div class="col s6 l2 property">
				      						<g:set var="klp_ill" value="${licProps.get('ILL - InterLibraryLoans')}"/>
	                        				<div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">call_split_black</i><i class="material-icons icon-offset ${klp_ill[0]}">${klp_ill[1]}</i></div>
	                        				Inter-library Loan
				      					</div>
				      					<div class="col s6 l2 property">
				      						<g:set var="klp_wia" value="${licProps.get('Walk In Access')}"/>
	                        				<div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">directions_walk</i><i class="material-icons icon-offset ${klp_wia[0]}">${klp_wia[1]}</i></div>
	                        				Walk-in access
				      					</div>
				      					<div class="col s6 l2 property">
				      						<g:set var="klp_ra" value="${licProps.get('Remote Access')}"/>
	                        				<div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">cast_connected_black</i><i class="material-icons icon-offset ${klp_ra[0]}">${klp_ra[1]}</i></div>
	                        				Remote access
				      					</div>
				      					<div class="col s6 l2 property">
				      						<g:set var="klp_aa" value="${licProps.get('Alumni Access')}"/>
	                        				<div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">group_black</i><i class="material-icons icon-offset ${klp_aa[0]}">${klp_aa[1]}</i></div>
	                        				Alumni Access
				      					</div>
				      				</div>
				      			</div>
				      		</div>
				      		<div class="row hide-on-small-and-down">
				      			<div class="col s12">
						      		<div class="cta">
						      			<g:link action="index" controller="licenseDetails" id="${l.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="waves-effect waves-light btn">View All</g:link>
						      			<g:if test="${params.defaultInstShortcode}">
						      				<g:link controller="myInstitutions" action="actionLicenses" params="${[defaultInstShortcode:params.defaultInstShortcode,baselicense:l.id,'cpy-licence':'Y']}" class="waves-effect btn">Copy <i class="material-icons right">content_copy</i></g:link>
						      				<g:link controller="myInstitutions" action="actionLicenses" onclick="return confirm('Are you sure you want to delete ${l.reference?:'** No licence reference ** '}?')" params="${[defaultInstShortcode:params.defaultInstShortcode,baselicense:l.id,'delete-licence':'Y']}" class="waves-effect btn">Delete <i class="material-icons right">delete_forever</i></g:link>
						      			</g:if>
						      		</div>
					      		</div>
				      		</div>
	
				      	</div>
				      	<!-- accordian body end-->
				    </li>
					<!-- accordian item end-->
				</g:each>
			</ul>
			
			<div class="pagination">
				<g:paginate action="allLicenses" controller="dataManager" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${licenseCount}" />
			</div>
		</div>
	</div>
	<!-- list accordian end-->
</body>
</html>
