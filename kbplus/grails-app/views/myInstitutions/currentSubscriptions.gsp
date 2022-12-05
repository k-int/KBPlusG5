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
  <parameter name="pagetitle" value="Your subscriptions" />
  <parameter name="pagestyle" value="subscriptions" />
  <parameter name="actionrow" value="sub-list-menu" />
  <meta name="layout" content="base"/>
</head>
<body class="subscriptions">  
  <!-- search-section start-->
  <div class="row">
    <div class="col s12">
      
      <div class="mobile-collapsible-header" data-collapsible="subscription-list-collapsible">Search <i class="material-icons">expand_more</i></div>
      <div class="search-section z-depth-1 mobile-collapsible-body" id="subscription-list-collapsible">
        <g:form action="currentSubscriptions" params="${[defaultInstShortcode:params.defaultInstShortcode]}" controller="myInstitutions" method="get">
          <input type="hidden" name="sort" value="${params.sort}"/>
          <div class="col s12 mt-10">
            <h3 class="page-title left">Search Your Subscriptions</h3>
          </div>
          <div class="col s12 l4">
                <div class="input-field search-main">
                    <input id="search-cs" type="search" name="q" value="${params.q?.encodeAsHTML()}">
                    <label class="label-icon" for="search-cs"><i class="material-icons">search</i></label>
                    <i id="clearSearch" class="material-icons close" search-id="search-cs">close</i>
                </div>
          </div>

          <div class="col s12 l3 mt-10">
            <div class="input-field">
              <g:select name="dateFilterType" value="${params.dateFilterType}" from="${['Valid On','Renewal Date','End Date']}"/>
              <label>Date Filter Type</label> 
            </div>
          </div>

          <div class="col s12 l3 mt-10">
            <div class="input-field">
              <g:kbplusDatePicker inputid="date_filter" name="dateFilter" value="${dateFilter}"/>
              <label class="active">Valid On</label>
            </div>
          </div>

          <div class="col s6 m3 l1">
            <input type="submit" class="waves-effect waves-teal btn" value="Search" />
          </div>

          <div class="col s6 m3 l1">
            <g:link controller="myInstitutions" action="currentSubscriptions" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
          </div>
        </g:form>
      </div>
      
    </div>
  </div>
  <!-- search-section end-->

  
  <!-- list returning/results-->
  <div class="row">
    <div class="col s12 page-response">
      <h2 class="list-response text-navy">
        <g:if test="${subscriptions}">
          You currently have <span>${num_sub_rows} Current</span> Subscriptions: Showing <span>${offset + 1}</span> - <span>${offset + subscriptions.size()}</span>
        </g:if>
        <g:else>
          You have <span>0 Current</span> Subscriptions
        </g:else> 
        <span>
          <g:if test="${params.q}">
             -- Search Text: ${params.q} 
          </g:if>
          <g:if test="${dateFilter}">
             -- Valid On: ${dateFilter}
          </g:if>
          <g:if test="${params.dateBeforeFilter}">
             -- Date Before Filter: ${params.dateBeforeFilter}
          </g:if>
          <g:if test="${params.dateBeforeVal}">
             -- Date Before: ${params.dateBeforeVal}
          </g:if>
        </span>
      </h2>
    </div>
  </div>
  
  <div class="row">
    <div class="col s12">
      <div class="filter-section z-depth-1">
        <g:form controller="myInstitutions" action="currentSubscriptions" params="${[defaultInstShortcode:params.defaultInstShortcode]}" method="get">
          <g:hiddenField name="q" value="${params.q?.encodeAsHTML()}"/>
          <g:hiddenField name="validOn" value="${validOn}"/>
          <g:hiddenField name="dateBeforeFilter" value="${params.dateBeforeFilter}"/>
          <g:hiddenField name="dateBeforeVal" value="${params.dateBeforeVal}"/>
          <g:hiddenField name="max" value="${params.max}"/>
          <g:hiddenField name="offset" value="${params.offset}"/>
          <div class="col s12 l6">
            <div class="input-field">
              <g:select name="sort"
                    value="${params.sort}"
                    keys="['name:asc','name:desc','startDate:asc','startDate:desc','endDate:asc','endDate:desc','manualRenewalDate:asc','manualRenewalDate:desc']"
                    from="${['A-Z','Z-A','Start Date (Asc)','Start Date (Desc)','End Date (Asc)','End Date (Desc)','Renewal Date (Asc)', 'Renewal Date (Desc)']}"
                    onchange="this.form.submit();"/>
              <label>Sort By</label>
            </div>
          </div>
        </g:form>
      </div>
    </div>
  </div>
  <!-- list returning/results end-->
  

  <!-- list accordian start-->
  <div class="row">

    <div class="col s12 l9">

      <ul class="collapsible jisc_collapsible" data-collapsible="accordion">
      
      <g:set var="now" value="${new java.util.Date()}"/>
      <g:set var="counter" value="${offset+1}" />
      <g:each in="${subscriptions}" var="s">
              <li>
          
          <!--accordian item-->
            <!--accordian header-->
              <div class="collapsible-header">
                <div class="col s12 m10">
                  <i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Expand/Collapse"></i>
                  <ul class="collection">
                    <li class="collection-item">
                      <h2 class="first navy-text">
                        ${counter++}. <g:link controller="subscriptionDetails" action="index" params="${[defaultInstShortcode:params.defaultInstShortcode]}" id="${s.id}" class="no-js"><g:if test="${s.name}">${s.name}</g:if><g:else>-- Name Not Set --</g:else></g:link>
                      </h2>
                    </li>
                    <li class="collection-item">Duration: <span><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${s.startDate}"/></span> until <span><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${s.endDate}"/></span></li>
                    <li class="collection-item">Associated Licence:
                      <span>
                        <g:if test="${s.owner}"> 
                                <g:link controller="licenseDetails" action="index" id="${s.owner.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}" class="no-js">${s.owner?.reference}</g:link>
                            </g:if>
                            <g:else>
                              No Licence
                            </g:else>
                      </span>
                    </li>
                    <li class="collection-item">Associated Packages: 
                      <g:if test="${s.packages}">
                        <g:if test="${s.packages.size()==1}">
                          <span><g:link controller="packageDetails" action="show" id="${s.packages.getAt(0).pkg.id}" title="${s.packages.getAt(0).pkg.contentProvider?.name}" class="no-js" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${s.packages.getAt(0).pkg.name}</g:link></span>
                        </g:if>
                        <g:else>
                          <span class="inline-badge tooltipped card-tooltip" data-position="right" data-src="packages-${s.id}">${s.packages.size()}</span>
                          <script type="text/html" id="packages-${s.id}">
                      <div class="kb-tooltip">
                            <div class="tooltip-title">Packages</div>
                            <ul class="tooltip-list">
                          <g:if test="${s.packages}">
                            <g:each in="${s.packages}" var="sp">
                                        <li>
                                          ${sp.pkg.name}
                                        </li>
                                    </g:each>
                          </g:if>
                        </ul>
                          </div>
                          </script>
                        </g:else>
                      </g:if>
                      <g:else>
                        <span>No Packages</span>
                      </g:else>
                    </li>
                    <li class="collection-item">
                            Associated:
                            <g:set var="docs_count" value="${0 as Integer}"/>
                            <g:set var="notes_count" value="${0 as Integer}"/>
                            <g:each in="${s.documents}" var="docctx">
                          <g:if test="${docctx.owner.contentType == 0 && (docctx.status == null || docctx.status?.value != 'Deleted')}">
                            <g:set var="notes_count" value="${notes_count+1}"/>
                          </g:if>
                          <g:elseif test="${(((docctx.owner?.contentType == 1) || (docctx.owner?.contentType == 3)) && (docctx.status?.value != 'Deleted'))}">
                            <g:set var="docs_count" value="${docs_count+1}"/>
                          </g:elseif>
                        </g:each>
                            <span class="indicator"><i class="material-icons left">view_list</i> Notes (${notes_count})</span>
                            <span class="indicator"><i class="material-icons left">description</i> Documents (${docs_count})</span>
                    </li>
                  </ul>
                </div>
                <div class="col s12 m2 full-height-divider">
                  <ul class="collection">
                    <li class="collection-item first">
                      <g:if test="${s.startDate != null && s.endDate != null && now?.after(s.startDate) && now?.before(s.endDate)}">
                        <div class="label centered-label current tooltipped" data-position="right" data-delay="50" data-tooltip="Current"><i class="material-icons">access_time</i>Current</div>
                      </g:if>
                      <g:elseif test="${s.endDate != null && now?.after(s.endDate)}">
                        <div class="label centered-label expired current tooltipped" data-position="right" data-delay="50" data-tooltip="Expired"><i class="material-icons">timer_off</i>Expired</div>
                      </g:elseif>
                      <g:elseif test="${(s.startDate != null) && (now?.before(s.startDate))}">
                        <div class="label centered-label expired current tooltipped" data-position="right" data-delay="50" data-tooltip="Yet To Start"><i class="material-icons">timer_off</i>Yet To Start</div>
                      </g:elseif>
                    </li>
                    <li class="collection-item">
                      <g:if test="${s.isSlaved?.value=='Auto'}">
                        <div class="label centered-label default tooltipped" data-position="right" data-delay="50" data-tooltip="All pending changes will be accepted when you open your subscription"><i class="material-icons">loop</i>Auto Update</div>
                      </g:if>
                      <g:elseif test="${s.isSlaved?.value=='Independent'}">
                        <div class="label centered-label default tooltipped" data-position="right" data-delay="50" data-tooltip="This subscription is not associated to a package, no changes will be applied"><i class="material-icons">code</i>Independent update</div>
                      </g:elseif>
                      <g:elseif test="${s.isSlaved?.value=='Yes'}">
                        <div class="label centered-label default tooltipped" data-position="right" data-delay="50" data-tooltip="All pending changes will be accepted when you open your subscription"><i class="material-icons">loop</i>Auto Update</div>
                      </g:elseif>
                      <g:else>
                        <div class="label centered-label default tooltipped" data-position="right" data-delay="50" data-tooltip="Pending changes have to be accepted/rejected manually"><i class="material-icons">build</i>Manual Update</div>
                      </g:else>
                    </li>
                    <g:if test="${editable}">
                      <li class="collection-item actions first hide-on-small-and-down">
                             <div class="actions-container">
                               <a href="#kbmodal" reload="true" ajax-url="${createLink(controller:'subscriptionDetails', action:'editSubscription', params:[defaultInstShortcode:params.defaultInstShortcode,id:s?.id])}" class="btn-floating modalButton"><i class="material-icons">create</i></a>
                          <g:link controller="myInstitutions" action="actionCurrentSubscriptions" params="${[defaultInstShortcode:params.defaultInstShortcode,basesubscription:s.id]}" onclick="return confirm('Are you sure you want to delete ${s.name?:'this subscription'}?')" class="btn-floating right"><i class="material-icons">delete_forever</i></g:link>
                      </div>
                      </li>
                    </g:if>
                  </ul>
                </div>
              </div>
              <!-- accordian header end-->

              <!-- accordian body-->
              <div class="collapsible-body">
                
                <div class="row">
                  <div class="col s6 l3">
                    <h3>Associated Packages</h3>
                    <g:if test="${s.packages}">
                  <g:each in="${s.packages}" var="sp">
                              <p>
                                <g:link controller="packageDetails" action="show" id="${sp.pkg?.id}" title="${sp.pkg?.contentProvider?.name}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${sp.pkg.name}</g:link>
                              </p>
                          </g:each>
                </g:if>
                <g:else>
                            <p>No data</p>
                </g:else>
                  </div>
                  <div class="col s6">
                    <h3>Licence</h3>
                    <g:if test="${s.owner}">
                      <p><g:link controller="licenseDetails" action="index" id="${s.owner.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${s.owner?.reference}</g:link></p>
                          <g:set var="licProps" value="${keyPropsDisplay(s.owner.customProperties)}"/>
                          <ul class="licence-properties">
                        <li>
                          <g:set var="klp_vle" value="${licProps.get('Include in VLE')}"/>
                          <i class="small material-icons tooltipped" data-position="top" data-delay="50" data-tooltip="Include in VLE">computer_black</i>
                          <i class="small material-icons icon-offset-small ${klp_vle[0]}">${klp_vle[1]}</i>
                        </li>
                        <li>
                          <g:set var="klp_cp" value="${licProps.get('Include In Coursepacks')}"/>
                          <i class="small material-icons tooltipped" data-position="top" data-delay="50" data-tooltip="Include in coursepacks">library_books</i>
                          <i class="small material-icons icon-offset-small ${klp_cp[0]}">${klp_cp[1]}</i>
                        </li>
                        <li>
                          <g:set var="klp_ill" value="${licProps.get('ILL - InterLibraryLoans')}"/>
                          <i class="small material-icons tooltipped" data-position="top" data-delay="50" data-tooltip="Inter-library loan">call_split_black</i>
                          <i class="small material-icons icon-offset-small ${klp_ill[0]}">${klp_ill[1]}</i>
                        </li>
                        <li>
                          <g:set var="klp_wia" value="${licProps.get('Walk In Access')}"/>
                          <i class="small material-icons tooltipped" data-position="top" data-delay="50" data-tooltip="Walk-in access">directions_walk</i>
                          <i class="small material-icons icon-offset-small ${klp_wia[0]}">${klp_wia[1]}</i>
                        </li>
                        <li>
                          <g:set var="klp_ra" value="${licProps.get('Remote Access')}"/>
                          <i class="small material-icons tooltipped" data-position="top" data-delay="50" data-tooltip="Remove access">cast_connected_black</i>
                          <i class="small material-icons icon-offset-small ${klp_ra[0]}">${klp_ra[1]}</i>
                        </li>
                        <li>
                          <g:set var="klp_aa" value="${licProps.get('Alumni Access')}"/>
                          <i class="small material-icons tooltipped" data-position="top" data-delay="50" data-tooltip="Alumni access">group_black</i>
                          <i class="small material-icons icon-offset-small ${klp_aa[0]}">${klp_aa[1]}</i>
                        </li>
                      </ul>
                        </g:if>
                        <g:else>
                          <p>No Licence</p>
                        </g:else>
                  </div>
                  <div class="col s12 l3">
                    <h3>Consortia</h3>
                    <p>${s.consortia?.name ?: 'No data' }</p>
                    <h3>Platform</h3>
                    <p>
                      <g:if test="${s.instanceOf?.packages}">
                        <g:each in="${s.instanceOf?.packages}" var="sp">
                                ${sp.pkg?.nominalPlatform?.name}<br/>
                            </g:each>
                          </g:if>
                          <g:else>
                            No data
                          </g:else>
                        </p>
                    <h3>Cancellation Allowances</h3>
                    <p>${sp?.cancellationAllowances ?: 'No data'}</p>
                  </div>
                </div>
                <div class="row">
                  <div class="col s12">
                    <div class="cta">
                      <g:link controller="subscriptionDetails" action="index" params="${[defaultInstShortcode:params.defaultInstShortcode]}" id="${s.id}" class="waves-effect waves-light btn">
                              View All
                          </g:link>
                          <g:if test="${editable}">
                        <a href="#kbmodal" reload="true" ajax-url="${createLink(controller:'subscriptionDetails', action:'editSubscription', params:[defaultInstShortcode:params.defaultInstShortcode,id:s?.id])}" class="waves-effect btn modalButton">Edit <i class="material-icons right">create</i></a>
                        <g:link controller="myInstitutions" action="actionCurrentSubscriptions" params="${[defaultInstShortcode:params.defaultInstShortcode,basesubscription:s.id]}" onclick="return confirm('Are you sure you want to delete ${s.name?:'this subscription'}?')" class="waves-effect btn">Delete <i class="material-icons right">delete_forever</i></g:link>
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
      
      <!-- Infinite loading refreshing -->

      <!-- Pagination as a temporary measure for navigation -->
      <div class="pagination">
            <g:if test="${subscriptions}" >
              <g:paginate action="currentSubscriptions" controller="myInstitutions" params="${params}" next="chevron_right" prev="chevron_left" max="${params.max?:user.defaultPageSize}" total="${num_sub_rows}" />
            </g:if>
          </div>
    </div>  
    <!-- list accordian end-->
    
    

    
    <!-- cards start-->
    <div class="col s12 l3">
      
      <div class="card jisc_card">
        <div class="card-content">
          <span class="card-title">Pending Changes</span>
          <div class="launch-out">
            <a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'todoModal', params:[defaultInstShortcode:params.defaultInstShortcode, theme:'subscriptions'])}" class="btn-floating bordered left-space modalButton"><i class="material-icons">open_in_new</i></a>
          </div>
          <div class="card-detail">
            <p>Currently ${institution.name} have:</p>
            <p class="giga-size">${num_todos}</p>
            <p>pending changes</p>
          </div>
          <g:if test="${editable}">
            <div class="card-meta">
              <g:link controller="myInstitutions" action="todo" params="${[defaultInstShortcode:params.defaultInstShortcode]}" class="btn"><i class="material-icons right">list</i>Review All</g:link>
            </div>
          </g:if>
          <div class="card-detail scrollable-content mt-20">
            <h3>Selected Changes</h3>
            <ul class="collection coloured with-actions">
              <g:each in="${todos.sort {it.earliest}}" var="todo">
                <li class="collection-item">
                  <div class="col s12">
                    <g:if test="${todo.item_with_changes instanceof com.k_int.kbplus.Subscription}">
                      <g:link controller="subscriptionDetails" 
                          action="index" 
                          params="${[defaultInstShortcode:institution.shortcode]}" 
                          id="${todo.item_with_changes.id}">${todo.item_with_changes.toString()}</g:link>
                                </g:if>
                                <g:elseif test="${todo.item_with_changes instanceof com.k_int.kbplus.License}">
                      <g:link controller="licenseDetails" 
                          action="index" 
                          params="${[defaultInstShortcode:institution.shortcode]}" 
                          id="${todo.item_with_changes.id}">${todo.item_with_changes.toString()}</g:link>
                                </g:elseif>
                                <g:else>
                                  ${todo.item_with_changes.toString()}
                                </g:else>
                    <p class="meta">Associated Changes: <span>${todo.num_changes}</span></p>
                  </div>
                </li>
              </g:each>
            </ul>
          </div>
        </div>
      </div>
        
      <!-- <div class="card jisc_card white navy-text">
        <div class="card-content">
          <span class="card-title">Useful links</span>
          <ul class="collection">
            <li class="collection-item"><g:link controller="subscriptionImport" action="generateImportWorksheet" params="${[defaultInstShortcode:institution.shortcode,id:institution.id]}"><i class="material-icons right">sync</i> Generate New Subscription Worksheet</g:link></li>
            <li class="collection-item"><g:link controller="subscriptionImport" action="importSubscriptionWorksheet" params="${[defaultInstShortcode:institution.shortcode,id:institution.id]}"><i class="material-icons right">file_upload</i> Import New Subscription Worksheet</g:link></li>
            <li class="collection-item"><a href="#modal1" ajax-url="${createLink(controller:'myInstitutions', action:'emptySubscription', params:[defaultInstShortcode:institution.shortcode])}" class="modalButton"><i class="material-icons right">note_add</i> Create New Empty Subscription</a></li>
          </ul>
        </div>
      </div> -->
      <!--<a href="#modal2" class="waves-effect btn">Export <i class="material-icons right">create</i></a>-->

    <!-- cards end-->

    </div>    
  </div>
  <!-- list accordian end-->
</body>
</html>
