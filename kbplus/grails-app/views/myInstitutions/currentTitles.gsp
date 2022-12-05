<!doctype html>
<%
  def workoutLicenceIcon = { icon, note ->
    def result = ["no", "clear"]
    if (icon.equals("greenTick")) {
      result = ["yes", "done", note]
    }
    else if (icon.equals("purpleQuestion"))
    {
      result = ["neither", "info_outline", note]
    }
    else if (icon.equals("redCross")) {
      result = ["no", "clear", note]
    }
    else {
      result = ["", "", note]
    }

    result
  }

  def keyPropsDisplay = { props ->
    def result = [:]
    def keyProps = ["Include in VLE", "Include In Coursepacks", "ILL - InterLibraryLoans", "Walk In Access", "Remote Access", "Alumni Access"]
    props.each { prop ->
      if ((prop?.type?.name) && (keyProps.contains(prop.type.name))) {
        result.put(prop.type.name, workoutLicenceIcon(prop?.refValue?.icon, prop?.note))
      }
    }

    if (result.size() < keyProps.size()) {
      keyProps.each { kp ->
        if (!result.containsKey(kp)) {
          result.put(kp, ["", "", null])
        }
      }
    }

    result
  }

%>
<html lang="en" class="no-js">
<head>
  <parameter name="pagetitle" value="Your Titles" />
  <parameter name="pagestyle" value="Titles" />
  <parameter name="actionrow" value="title-list" />
  <meta name="layout" content="base"/>
</head>
<body class="titles">

  <div class="row">
    <div class="col s12">
      <ul class="tabs jisc_tabs mt-40m">
        <li class="tab col s2"><g:link controller="myInstitutions" action="currentTitles" params="${[defaultInstShortcode:params.defaultInstShortcode]}" class="active">Your Titles<i class="material-icons">chevron_right</i></g:link></li>
        <li class="tab col s2"><g:link target="_self" controller="titleDetails" action="index" params="${[defaultInstShortcode:params.defaultInstShortcode]}">All KB+ Titles<i class="material-icons">chevron_right</i></g:link></li>
      </ul>
    </div>
  </div>
  <div id="ourTitles" class="tab-content">
  <!-- search-section start-->
  <div class="row">
    <div class="col s12">
      
      <div class="mobile-collapsible-header" data-collapsible="title-our-collapsible">Search <i class="material-icons">expand_more</i></div>
      <div class="search-section z-depth-1 mobile-collapsible-body" id="title-our-collapsible">
      <!--<div class="search-section list-search-ui z-depth-1">-->
        <g:form controller="myInstitutions" action="currentTitles" params="${[defaultInstShortcode:params.defaultInstShortcode]}" method="get">
          <input type="hidden" name="sort" value="${params.sort}">
          <div class="col s12 mt-10">
            <h3 class="page-title left">Search Your Titles</h3>
          </div>
          <div class="col s12 m12 l8">
            <div class="input-field search-main">
              <input id="search-ct" name="filter" value="${params.filter}" type="search">
              <label class="label-icon" for="search-ct"><i class="material-icons">search</i></label>
              <i class="material-icons close" id="clearSearch" search-id="search-ct">close</i>
            </div>
          </div>
          <div class="col s12 l2 mt-10">
            <div class="input-field">
              <g:kbplusDatePicker inputid="valid_on" name="validOn" value="${validOn}"/>
              <label class="active">Valid On</label>
            </div>
          </div>
          <div class="col s12 l1">
            <input type="submit" class="waves-effect waves-teal btn" value="Search">
          </div>
          <div class="col s12 l1">
            <g:link controller="myInstitutions" action="currentTitles" params="${[defaultInstShortcode:params.defaultInstShortcode]}" class="resetsearch">Reset</g:link>
          </div>
          <div class="col s12">
            <ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
              <li>
                <div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter Search</div>
                  <div class="collapsible-body">
                    <g:set var="filterSub" value="${params.filterSub?params.list('filterSub'):''}" />
                    <g:set var="filterPvd" value="${params.filterPvd?params.list('filterPvd'):''}" />
                    <g:set var="filterHostPlat" value="${params.filterHostPlat?params.list('filterHostPlat'):''}" />
                    <g:set var="filterOtherPlat" value="${params.filterOtherPlat?params.list('filterOtherPlat'):''}" />
                    <div class="col s12 m12 l3">
                      <div class="input-field">
                        <select name="filterSub">
                          <option value="all" selected>All Subscriptions</option>
                          <g:each in="${subscriptions}" var="s">
                            <option value="${s.id}" ${s.id.toString()==params.filterSub?'selected=true':''}>${s.name} <g:if test="${s.consortia}">( ${s.consortia.name} )</g:if></option>
                          </g:each>
                        </select>
                        <label>Subscriptions</label>
                      </div>
                    </div>
                    <div class="col s12 m12 l3">
                      <div class="input-field">
                        <select name="filterPvd">
                          <option value="all" selected>All Providers</option>
                          <g:each in="${providers}" var="p">
                            <option value="${p.id}" ${p.id.toString()==params.filterPvd?'selected=true':''}>${p.name}</option>
                          </g:each>
                        </select>
                        <label>Content Providers</label>
                      </div>
                    </div>
                    <div class="col s12 m12 l3">
                      <div class="input-field">
                        <select name="filterHostPlat">
                          <option value="all" selected>All Platforms</option>
                          <g:each in="${hostplatforms}" var="hp">
                            <option value="${hp.id}" ${hp.id.toString()==params.filterHostPlat?'selected=true':''}>${hp.name}</option>
                          </g:each>
                        </select>
                        <label>Host Platforms</label>
                      </div>
                    </div>
                    <div class="col s12 m12 l3">
                      <div class="input-field">
                        <select name="filterOtherPlat">
                          <option value="all" selected>All Platforms</option>
                          <g:each in="${otherplatforms}" var="op">
                            <option value="${op.id}" ${op.id.toString()==params.filterOtherPlat?'selected=true':''}>${op.name}</option>
                          </g:each>
                        </select>
                        <label>Additional Platforms</label>
                      </div>
                    </div>
                    <div class="col s12 l12 mt-10 single-line-checkbox">
                      <div class="radio-container-float left">
                        <input type="checkbox" id="filterMultiIE" name="filterMultiIE" value="${true}"<%=(params.filterMultiIE)?' checked="true"':''%> />
                        <label class="pt-10" for="filterMultiIE">Titles included in two or more subscriptions</label>
                      </div>
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
  <!-- search-section end-->

  <!-- list returning/results-->
  <div class="row">
    <div class="col s12 page-response">
      <h2 class="list-response text-navy">
        You currently have <span>${num_ti_rows}</span> Titles: Showing <span>${offset + 1}</span> - <span>${offset + titles.size()}</span>
        <span>
          <g:if test="${params.filter}">
             -- Search Text: ${params.filter}
          </g:if>
          <g:if test="${validOn}">
             -- Valid On: ${validOn}
          </g:if>
        </span>
      </h2>
    </div>
    
    <div class="row">
      <div class="col s12">
        <div class="filter-section z-depth-1">
          <g:form controller="myInstitutions" action="currentTitles" params="${[defaultInstShortcode:params.defaultInstShortcode]}" method="get">
            <g:hiddenField name="filter" value="${params.filter?.encodeAsHTML()}"/>
            <g:hiddenField name="validOn" value="${validOn}"/>
            <g:hiddenField name="max" value="${params.max}"/>
            <g:hiddenField name="offset" value="${params.offset}"/>
            <g:hiddenField name="filterSub" value="${params.filterSub}"/>
            <g:hiddenField name="filterPvd" value="${params.filterPvd}"/>
            <g:hiddenField name="filterHostPlat" value="${params.filterHostPlat}"/>
            <g:hiddenField name="filterOtherPlat" value="${params.filterOtherPlat}"/>
            
            <div class="col s12 l6">
              <div class="input-field">
                <g:select name="sort"
                      value="${params.sort}"
                      keys="['title:asc','title:desc']"
                      from="${['A-Z','Z-A']}"
                      onchange="this.form.submit();"/>
                <label>Sort Titles By</label>
              </div>
            </div>
          </g:form>
        </div>
      </div>
    </div>
  </div>
  <!-- list returning/results end-->

  <!-- list accordian start-->
  <div class="row">
    <div class="col s12 l9">
      <ul class="collapsible jisc_collapsible" data-collapsible="accordion">
        <g:set var="counter" value="${offset+1}" />
        <g:each in="${titles}" var="ti">
          <!--accordian item-->
          <li>
            <!--accordian header-->
            <div class="collapsible-header">
              <div class="col s12 m10">
                <div class="icon-collection">
                  <i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Expand/Collapse"></i>
                </div>
                
                <ul class="collection">
                  <g:set var="title_coverage_info" value="${ti.getInstitutionalCoverageSummary(institution, session.sessionPreferences?.globalDateFormat, date_restriction)}" />
                  <li class="collection-item"><h2 class="first navy-text">${counter++}. <g:link controller="titleDetails" action="show" id="${ti.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}" class="no-js">${ti.title}</g:link></h2></li>
                  <g:if test="${params.debug}">
                    <li class="collection-item">${ti.sortTitle}</li>
                  </g:if>
                  <li class="collection-item">Earliest date: <span>${title_coverage_info.earliest}</span> Latest Date: <span>${title_coverage_info.latest ?: 'To Current'}</span></li>
                  <li class="collection-item">Publisher: <span>${ti.getPublisher()?.name?:'None'}</span></li>
                  <li class="collection-item">
                    issn: <span>${ti.getIdentifierValue('ISSN')?:'None'}</span><br>
                    eissn: <span>${ti.getIdentifierValue('eISSN')?:'None'}</span><br>
                    isbn: <span>${ti.getIdentifierValue('isbn')?:'None'}</span><br>
                    jusp: <span>${ti.getIdentifierValue('jusp')?:'None'}</span>
                  </li>
                  <!-- Needs extra logic to remove duplicate subscriptions & licences -->
                  <g:set var="sub_count" value="${0 as Integer}"/>
                  <g:set var="lic_count" value="${0 as Integer}"/>
                  <g:each in="${title_coverage_info?.ies}" var="ie">
                    <g:if test="${ie.subscription}">
                      <g:set var="sub_count" value="${sub_count+1}"/>
                      <g:if test="${ie.subscription.owner}">
                        <g:set var="lic_count" value="${lic_count+1}"/>
                      </g:if>
                    </g:if>
                  </g:each>
                  <li class="collection-item">
                    Associated:
                    <span class="indicator"><i class="material-icons">library_books</i> Subscriptions (${sub_count})</span>
                    <span class="indicator"><i class="material-icons left">description</i> Licences (${lic_count})</span>
                  </li>
                </ul>
              </div>
              <div class="col s12 m2 full-height-divider">
                <ul class="collection">
                  <li class="collection-item terms">
                    <g:if test="${sub_count > 0}">
                      <span class="btn-floating btn-large waves-effect terms centered"><i class="material-icons">collections_bookmark</i></span><br/>
                      <p class="center-align">
                        <a href="${createLink(controller:'titleDetails', action:'show', id:ti.id, params:[defaultInstShortcode:params.defaultInstShortcode])}#issueEnts" class="no-js">Issue Entitlements</a>
                      </p>
                    </g:if>
                    <g:else>
                      <p class="center-align">No Issue Entitlements</p>
                    </g:else>
                  </li>
                </ul>
              </div>
            </div>
            <!-- accordian header end-->

            <!-- accordian body-->
            <div class="collapsible-body">
              <div class="row">
                <div class="col s12 m4">
                  <h3>Included Subscriptions</h3>
                  <ul class="content-list">
                    <g:if test="${sub_count > 0}">
                      <g:each in="${title_coverage_info?.ies}" var="ie">
                        <g:if test="${((ie.status==null)||(!ie.status.value.equals('Deleted')))}">
                          <g:link controller="subscriptionDetails" 
                                  action="index" 
                                  params="${[defaultInstShortcode:params.defaultInstShortcode]}" id="${ie.subscription.id}">${ie.subscription.name}</g:link><br>
                          <g:link controller="issueEntitlement" 
                                  action="show" 
                                  id="${ie.id}" 
                                  params="${[defaultInstShortcode:params.defaultInstShortcode]}">View Issue Entitlements</g:link><br/><br/>
                        </g:if>
                      </g:each>
                    </g:if>
                    <g:else>
                      No Subscription(s) Associated
                    </g:else>
                  </ul>
                </div>
                <div class="col s12 m4">
                  <h3>Licences</h3>
                  <ul class="content-list">
                    <g:if test="${lic_count > 0}">
                      <g:each in="${title_coverage_info?.ies}" var="ie">
                        <g:link controller="licenseDetails" action="index" params="${[defaultInstShortcode:params.defaultInstShortcode]}" id="${ie.subscription.owner?.id}">${ie.subscription.owner?.reference}</g:link><br/><br/>
                      </g:each>
                    </g:if>
                    <g:else>
                      No Licence(s) Associated
                    </g:else>
                  </ul>
                </div>
                <div class="col s12 m4">
                  <h3>Title URL</h3>
                  <ul class="content-list">
                    <li><a href="${title_coverage_info?.ies[0].tipp?.hostPlatformURL}">Host link</a></li>
                  </ul>
                </div>
                
                <div class="col s12 m12">
                  <g:each in="${title_coverage_info?.ies}" var="ie">
                    <g:if test="${ie.subscription?.owner}">
                      <g:set var="licProps" value="${keyPropsDisplay(ie.subscription.owner.customProperties)}"/>
                      <h3>Licences Key Properties: ${ie.subscription.owner.reference}</h3>
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
                    </g:if>
                  </g:each>
                </div>
              </div>
              
              <div class="row">
                <div class="col s12">
                  <div class="cta">
                    <g:link controller="titleDetails" action="show" id="${ti.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}" class="waves-effect waves-light btn">View All</g:link>
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
          <g:paginate action="currentTitles" controller="myInstitutions" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${num_ti_rows}" />
      </div>

    </div>
    <!-- list accordian end-->


    <!-- cards start-->
    <div class="col s12 l3">
      <div class="card jisc_card">
        <div class="card-content">
          <span class="card-title">Pending Changes</span>
          <div class="launch-out">
            <a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'todoModal', params:[defaultInstShortcode:params.defaultInstShortcode, theme:'titles'])}" class="btn-floating bordered left-space modalButton"><i class="material-icons">open_in_new</i></a>
          </div>
          <div class="card-detail">
            <p>Currently ${institution.name} have:</p>
            <p class="giga-size">${num_todos}</p>
            <p>pending changes</p>
          </div>
          <g:if test="${is_admin}">
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

      <!--<div class="card jisc_card white navy-text">
        <div class="card-content">
          <span class="card-title">Useful links **Needs Action**</span>
          <ul class="collection">
            <li class="collection-item"><a href="">Generate New Subscription Worksheet</a></li>
            <li class="collection-item"><a href="">Import New Subscription Worksheet</a></li>
            <li class="collection-item"><a href="">Create New Empty Subscription </a></li>
          </ul>
        </div>
      </div>-->

      <!-- cards end-->

    </div>
  </div>
  <!-- list accordian end-->


  </div>
  <!-- end of tabs -->
</body>
</html>

