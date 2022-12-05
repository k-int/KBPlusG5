<!doctype html>
<html lang="en" class="no-js">

<head>
  <parameter name="pagetitle" value="Subscription Details" />
  <parameter name="actionrow" value="sub-details-menu" />
  <meta name="layout" content="base" />
  <title>KB+ Subscription</title>
</head>

<body class="subscriptions">

  <!--get the count for notes and docs first-->
  <g:set var="docs_count" value="${0 as Integer}"/>
  <g:set var="notes_count" value="${0 as Integer}"/>
  <g:each in="${subscriptionInstance.documents}" var="docctx">
    <g:if test="${docctx.owner.contentType == 0 && (docctx.status == null || docctx.status?.value != 'Deleted')}">
      <g:set var="notes_count" value="${notes_count+1}"/>
    </g:if>
    <g:elseif test="${(((docctx.owner?.contentType == 1) || (docctx.owner?.contentType == 3)) && (docctx.status?.value != 'Deleted'))}">
      <g:set var="docs_count" value="${docs_count+1}"/>
    </g:elseif>
  </g:each>
  
  <g:set var="params_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>

  <!--page title-->
  <div class="row">
    <div class="col s12 l12">
      <g:if test="${params.asAt}">
        <h1>Snapshot on ${params.asAt} from </h1></g:if>
      <h1 class="page-title left">${subscriptionInstance.name}</h1>
    </div>
  </div>
  <!--page title end-->

  <g:render template="/templates/flash_alert_panels"/>


  <!--tab section start-->
  <div class="row">

    <!--***tab card section***-->
    <div class="row row-content">
      <div class="col s12 m6 l3">
        <div class="card jisc_card small white">
          <div class="card-content text-navy">
            <span class="card-title">Associated Licence</span>
            <g:if test="${(subscriptionInstance.subscriber) && (subscriptionInstance.owner != null)}">
              <div class="launch-out">
                <g:link controller="licenseDetails" action="index" id="${subscriptionInstance.owner.id}" params="${params_sc}" class="btn-floating bordered tooltipped" data-position="top" data-delay="50" data-tooltip="See all licence properties"><i class="material-icons">remove_red_eye</i></g:link>
              </div>
            </g:if>
            <div class="card-detail">
              <ul class="collection">
                <li class="collection-item plain">
                  <div class="col s10">
                    <g:if test="${(subscriptionInstance.subscriber) && (subscriptionInstance.owner != null)}">
                      <g:if test="${subscriptionInstance.owner.reference.length() > 50}">
						<g:link controller="licenseDetails" action="index" id="${subscriptionInstance.owner.id}" params="${params_sc}">${subscriptionInstance.owner.reference.substring(0,50)}...</g:link><i class="material-icons theme-icon tooltipped card-tooltip" data-position="right" data-src="sub-licence">info</i>
						<script type="text/html" id="sub-licence">
						  <div class="kb-tooltip">
							<div class="tooltip-title">Licence Name</div>
							<ul class="tooltip-list">
							  <li>${subscriptionInstance.owner}</li>
							</ul>
						  </div>
						</script>
					  </g:if>
					  <g:else>
						<g:link controller="licenseDetails" action="index" id="${subscriptionInstance.owner.id}" params="${params_sc}">${subscriptionInstance.owner}</g:link>
					  </g:else>
                    </g:if>
                    <g:else>N/A (Subscription offered)</g:else>
                  </div>
                  <div class="col s2">
                    <g:if test="${(subscriptionInstance.subscriber) && (subscriptionInstance.owner != null)}">
                      <g:if test="${editable}">
                        <g:link controller="subscriptionDetails" action="removeLicence" id="${subscriptionInstance.id}" params="${params_sc}" class="right"><i class="material-icons">delete_forever</i></g:link>
                      </g:if>
                    </g:if>
                  </div>
                </li>
              </ul>
            </div>
            <g:if test="${(subscriptionInstance.subscriber) && (subscriptionInstance.owner != null)}">
              <div class="card-action">
                <!-- this needs to be a loop of licence custom properties! -->
                <div class="col s3 l2 property">
                  <div class="circular-image">
                    <i class="small material-icons tooltipped properties-lie" data-position="top" data-delay="50" data-tooltip="Include in VLE">computer_black</i>
                    <i class="small material-icons icon-offset-small ${licVLE}">${licVLE_info}</i>
                  </div>
                </div>
                <div class="col s3 l2 property">
                  <div class="circular-image">
                    <i class="small material-icons tooltipped properties-lie" data-position="top" data-delay="50" data-tooltip="Include in coursepacks">library_books</i>
                    <i class="small material-icons icon-offset-small ${licCoursepacks}">${licCoursepacks_info}</i>
                  </div>
                </div>
                <div class="col s3 l2 property">
                  <div class="circular-image">
                    <i class="small material-icons tooltipped properties-lie" data-position="top" data-delay="50" data-tooltip="Inter-library loan">call_split_black</i>
                    <i class="small material-icons icon-offset-small ${licILL}">${licILL_info}</i>
                  </div>
                </div>
                <div class="col s3 l2 property">
                  <div class="circular-image">
                    <i class="small material-icons tooltipped properties-lie" data-position="top" data-delay="50" data-tooltip="Walk-in access">directions_walk</i>
                    <i class="small material-icons icon-offset-small ${licWalkIn}">${licWalkIn_info}</i>
                  </div>
                </div>
                <div class="col s3 l2 property">
                  <div class="circular-image">
                    <i class="small material-icons tooltipped properties-lie" data-position="top" data-delay="50" data-tooltip="Remote access">cast_connected_black</i>
                    <i class="small material-icons icon-offset-small ${licRA}">${licRA_info}</i>
                  </div>
                </div>
                <div class="col s3 l2 property">
                  <div class="circular-image">
                    <i class="small material-icons tooltipped properties-lie" data-position="top" data-delay="50" data-tooltip="Alumni access">group_black</i>
                    <i class="small material-icons icon-offset-small ${licAA}">${licAA_info}</i>
                  </div>
                </div>
              </div>
            </g:if>
          </div>
        </div>
      </div>
      <div class="col s12 m6 l3">
        <div class="card jisc_card small white">
          <div class="card-content text-navy">
            <span class="card-title">Associated Packages (${subscriptionInstance.packages.size()})</span>
            <g:if test="${editable}">
              <div class="launch-out">
                <g:link controller="subscriptionDetails" action="linkPackage" class="btn-floating bordered" params="${params_sc}" id="${params.id}"><i class="material-icons">add_circle_outline</i></g:link>
              </div>
            </g:if>
            <div class="card-detail no-card-action">
              <ul class="collection with-actions">
                <g:each in="${subscriptionInstance.packages}" var="sp">
                  <li class="collection-item">
                    <div class="col s10">
                      <g:link controller="packageDetails" action="show" id="${sp.pkg?.id}" params="${params_sc}">${sp?.pkg?.name}</g:link> (${sp.pkg?.contentProvider?.name})
                    </div>
                    <g:if test="${editable}">
                      <div class="col s2">
                        <a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'unlinkPackage', params:[subscription:subscriptionInstance.id, package:sp.pkg.id]+params_sc)}" class="right modalButton"><i class="material-icons">delete_forever</i></a>
                      </div>
                    </g:if>
                  </li>
                </g:each>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <div class="col s12 m6 l3">
        <div class="card-panel drop-line">
          <p class="card-label">Start Date: <span class="card-response right"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${subscriptionInstance.startDate}"/></span></p>
          <p class="card-label">End Date: <span class="card-response right"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${subscriptionInstance.endDate}"/></span></p>
        </div>
        <div class="card-panel drop-line">
          <div class="launch-out">
            <g:if test="${editable}">
              <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'addNoteView', params:[ownobjid:subscriptionInstance.id, ownobjclass:subscriptionInstance.class.name, owntp:'subscription', theme:'subscriptions'])}" class="btn-floating bordered modalButton"><i class="material-icons">add_circle_outline</i></a>
            </g:if>
          </div>
          <p class="card-label"><span class="card-text">Notes:</span></p>
          <p class="card-label"><span class="card-response"><a href="#details" class="btn simple-btn selecttab" data-tabs="jisc_tabs"><i class="material-icons left">view_list</i>${notes_count}</a></span></p>
        </div>
      </div>

      <div class="col s12 m6 l3">
        <div class="card-panel">
          <div class="launch-out">
            <a href="#kbmodal" reload="true" id="pendingchanges" ajax-url="${createLink(controller:'subscriptionDetails', action:'pendingChanges', params:params_sc, id:params.id)}" class="btn-floating bordered modalButton"><i class="material-icons">open_in_new</i></a>
          </div>
          <p class="card-title">Pending Changes</p>
          <p class="card-caption"><span><g:if test="${pendingChanges?.size() > 0}">${pendingChanges?.size()}</g:if><g:else>0</g:else></span> items to approve</p>
        </div>
        <div class="card-panel hide-text">
          <div class="launch-out">
            <g:if test="${editable}">
              <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'addDocumentView', params:[ownobjid:subscriptionInstance.id, ownobjclass:subscriptionInstance.class.name, owntp:'subscription', theme:'subscriptions'])}" class="btn-floating bordered modalButton"><i class="material-icons">add_circle_outline</i></a>
            </g:if>
          </div>
          <p class="card-label"><span class="card-text">Documents:</span> </p>
          <p class="card-label"><span class="card-response"><a href="#details" class="btn simple-btn selecttab" data-tabs="jisc_tabs"><i class="material-icons left">description</i>${docs_count}</a></span></p>
        </div>
      </div>
    </div>
    <!--***tab card section end***-->
  </div>

  <div class="row">
    <div class="col s12">
      <ul class="tabs jisc_tabs">
        <li class="tab col s2"><a href="#titles" class="add-anchor">Titles <i class="material-icons">chevron_right</i></a></li>
        <li class="tab col s2"><a href="#details" class="add-anchor">Details <i class="material-icons">chevron_right</i></a></li>
      </ul>
    </div>
    
    <!--***tab Titles content start***-->
    <div id="titles" class="tab-content">
      <g:if test="${subscriptionInstance.packages.size() > 0}">
        <div class="page-response">
          <div class="col s12">
            <h2 class="list-response text-navy left">
              <g:if test="${entitlements?.size() > 0}">
                This subscription gives access to the following: <span>${offset + 1}</span> to <span>${offset+(entitlements?.size())}</span> of <span>${num_sub_rows}</span> titles
              </g:if>
              <g:else>
                No entitlements found
              </g:else>
            </h2>
          </div>
        </div>
        <!-- search-section start-->
        <div class="row">
          <div class="col s12">
            <div class="mobile-collapsible-header" data-collapsible="subscription-detail-collapsible">Search <i class="material-icons">expand_more</i></div>
            <div class="search-section list-search-ui z-depth-1 mobile-collapsible-body" id="subscription-detail-collapsible">
              <g:form action="index" params="${params}" method="get">
                <input type="hidden" name="sort" value="${params.sort}">
                <div class="col s12 mt-10">
                  <h3 class="page-title left">Search Your Subscriptions</h3>
                </div>
                <div class="col s12 m12 l6">
                  <div class="input-field search-main">
                    <input id="search-ct" name="filter" value="${params.filter}" type="search">
                    <label class="label-icon" for="search-ct"><i class="material-icons">search</i></label>
                    <i class="material-icons close" id="clearSearch" search-id="search-ct">close</i>
                  </div>
                </div>
                <div class="col s12 m12 l2 mt-10">
                  <div class="input-field">
                    <select name="pkgfilter">
                      <option value="" selected>All Packages</option>
                      <g:each in="${subscriptionInstance.packages}" var="sp">
                        <option value="${sp.pkg.id}" ${sp.pkg.id.toString()==params.pkgfilter?'selected=true':''}>${sp.pkg.name}</option>
                      </g:each>
                    </select>
                    <label>Package</label>
                  </div>
                </div>
                <div class="col s12 m12 l2 mt-10">
                  <div class="input-field">
                    <g:kbplusDatePicker inputid="asAt" name="asAt" value="${params.asAt}"/>
                    <label class="active">As At</label>
                  </div>
                </div>
                <div class="col s12 m12 l1">
                  <input type="submit" class="waves-effect waves-teal btn" value="Search">
                </div>
                <div class="col s12 m12 l1">
                  <g:link controller="subscriptionDetails" action="index" params="${params_sc}" id="${subscriptionInstance?.id}" class="resetsearch">Reset</g:link>
                </div>
              </g:form>
              <div class="col s12">
                <g:form controller="subscriptionDetails" action="index" id="${params.id}" params="${params_sc}" method="get">
                  <g:hiddenField name="filter" value="${params.filter}" />
                  <g:hiddenField name="pkgfilter" value="${params.pkgfilter}" />
                  <g:hiddenField name="asAt" value="${params.asAt}" />
                  <g:hiddenField name="max" value="${params.max}" />
                  <g:hiddenField name="offset" value="${params.offset}" />
                  <div class="col s12 m12 l6">
                    <div class="input-field">
                      <g:select name="sort" value="${params.sort}" keys="['tipp.title.title:asc','tipp.title.title:desc','startDate:asc','endDate:asc','core_status_asc','core_status_desc']" from="${['A-Z','Z-A','Earliest Date','Latest Date','Not Core','Currently Core']}" onchange="this.form.submit();" />
                      <label>Sort Subscription Titles by...</label>
                    </div>
                  </div>
                </g:form>
                <g:if test="${editable}">
                  <div class="col s12 m12 l6 filter-actions button-area-line hide-on-med-and-down">
                    <a href="#kbmodal" class="btn truncate modalButton" ajax-url="${createLink(controller:'subscriptionDetails', action:'addEntitlements', id:subscriptionInstance.id, params:params_sc)}"><i class="material-icons right">add_circle_outline</i>Add Titles</a>
                    <a href="#kbmodal" id="batchEditIssueEnts" class="btn truncate" ajax-url="${createLink(controller:'subscriptionDetails', action:'batchEditModal', params:params_sc, id:subscriptionInstance?.id)}">Batch Task Selected Titles</a>
                  </div>
                </g:if>
              </div>
            </div>
          </div>
        </div>

        <div class="row">
          <g:form controller="subscriptionDetails" action="subscriptionBatchUpdate" params="${params_sc}" id="${subscriptionInstance?.id}" class="z-depth-1">
            <g:hiddenField name="sort" value="${params.sort}" />
            <g:hiddenField name="order" value="${params.order}" />
            <g:hiddenField name="offset" value="${params.offset}" />
            <g:hiddenField name="max" value="${params.max}" />
            <g:hiddenField name="bulkOperation" value="remove" />
            <div class="col s12">
              <g:if test="${entitlements}">
                <g:set var="badge_today" value="${new java.util.Date()}" />
                <g:set var="counter" value="${offset+1}" />
                <g:each in="${entitlements}" var="ie">
                  <g:set var="otherIdDisplay" value="${false}" />
                  <div class="list-section">
                    <div class="col s12 m10 l9">
                      <ul class="collection with-header">
                        <li class="collection-header">
                          <g:if test="${editable}"><input type="checkbox" name="_bulkflag.${ie.id}" id="_bulkflag.${ie.id}" /></g:if>
                          <label for="_bulkflag.${ie.id}">&nbsp;</label>
                          <g:link controller="issueEntitlement" id="${ie.id}" action="show" params="${params_sc}" class="list-title">${counter++}. ${ie.tipp.title.title}</g:link>
                        </li>
                        <li class="collection-item">Earliest date: <span><g:if test="${ie.startDate}"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.startDate}"/></g:if><g:else>No Earliest Date</g:else></span>
                          <div class="two-in-a-row">Latest Date: <span><g:if test="${ie.endDate}"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.endDate}"/></g:if><g:else>No Latest Date</g:else></span></div>
                        </li>
                        <li class="collection-item">ISSN: <span>${ie?.tipp?.title?.getIdentifierValue('ISSN')}</span>
                          <div class="two-in-a-row">eISSN: <span>${ie?.tipp?.title?.getIdentifierValue('eISSN')}</span></div>
                        </li>
                        <g:each in="${ie?.tipp?.title?.ids?.sort{it.identifier.ns.ns}}" var="oid">
                          <g:if test="${oid.identifier.ns.ns != 'issn' && oid.identifier.ns.ns != 'eissn'}">
                            <g:if test="${oid.identifier.ns.ns.endsWith('_title_id')}">
                              <g:set var="ns" value="${oid.identifier.ns.ns.substring(0,5)}" />
                            </g:if>
                            <g:else>
                              <g:set var="ns" value="${oid.identifier.ns.ns}" />
                            </g:else>
                            <g:if test="${!otherIdDisplay}">
                              <g:set var="otherIdDisplay" value="${true}" />
                              <g:set var="titleFlags" value="${ns}" />
                            </g:if>
                            <g:else>
                              <g:set var="titleFlags" value="${titleFlags + ', ' + ns}" />
                            </g:else>
                          </g:if>
                        </g:each>
                        <g:if test="${otherIdDisplay}">
                          <li class="collection-item">Other Services: <span>${titleFlags}</span></li>
                        </g:if>
                        <li class="collection-item">Core History:
                          <g:if test="${ie?.getTIP()?.coreDates}">
                            <g:if test="${ie?.getTIP()?.coreDates.size()==1}">
                              Start Date:
                              <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie?.getTIP()?.coreDates[0].startDate}" /> - End Date:
                              <g:if test="${ie?.getTIP()?.coreDates[0].endDate}">
                                <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie?.getTIP()?.coreDates.endDate[0]}" /></g:if>
                              <g:else>None</g:else>
                            </g:if>
                            <g:else>
                              <span class="inline-badge tooltipped card-tooltip" data-position="right" data-src="coreDates-${ie.id}">${ie?.getTIP()?.coreDates.size()}</span>
                              <script type="text/html" id="coreDates-${ie.id}">
                                <div class="kb-tooltip">
                                  <div class="tooltip-title">Core History</div>
                                  <ul class="tooltip-list">
                                    <g:if test="${ie?.getTIP()?.coreDates}">
                                      <g:each in="${ie.getTIP().coreDates}" var="cd">
                                        <li>
                                          Start Date:
                                          <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${cd.startDate}" /> - End Date:
                                          <g:if test="${cd.endDate}">
                                            <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${cd.endDate}" /></g:if>
                                          <g:else>None</g:else>
                                        </li>
                                      </g:each>
                                    </g:if>
                                  </ul>
                                </div>
                              </script>
                            </g:else>
                          </g:if>
                          <g:else>
                            <span>No History</span>
                          </g:else>
                        </li>
                        <li class="collection-item">Notes: <span>${ie.coverageNote?:(ie.tipp?.coverageNote?:'')}</span></li>
                      </ul>
                    </div>
                    <div class="col s12 m2 l2 full-height-divider">
                      <ul class="collection">
                        <li class="collection-item first">
                          <g:if test="${(!ie.endDate && badge_today > ie.startDate) || (badge_today < ie.endDate)}">
                            <div class="label centered-label current tooltipped " data-position="right" data-delay="50" data-tooltip="Current">
                              <i class="material-icons">access_time</i>Current
                            </div>
                          </g:if>
                          <g:else>
                            <div class="label centered-label expired tooltipped" data-position="right" data-delay="50" data-tooltip="Expired">
                              <i class="material-icons">timer_off</i>Expired
                            </div>
                          </g:else>
                        </li>
                        <li class="collection-item status">
                          <!--<a class="btn-floating btn-large waves-effect waves-light"><i class="material-icons">launch</i></a><br/>-->
                          <g:render template="/templates/coreStatus" model="${['issueEntitlement': ie, 'date': params.asAt, 'theme':'subscriptions', 'center':true, 'editable':editable]}" />
                        </li>
                      </ul>
                    </div>
                    <div class="col m1 hide-on-med-and-down full-height-divider">
                      <ul class="collection">
                        <li class="collection-item actions first">
                          <div class="actions-container">
                            <!--<a href="" class="btn-floating btn-flat"><i class="material-icons">create</i></a>-->
                            <g:if test="${editable}">
                              <g:link controller="subscriptionDetails" action="removeEntitlement" params="${[ieid:ie.id, sub:subscriptionInstance.id]+params_sc}" onClick="return confirm('Are you sure you wish to delete this entitlement');" class="btn-floating ml-20"><i class="material-icons">delete_forever</i></g:link>
                            </g:if>
                          </div>
                        </li>
                        <li class="collection-item status">
                          <a href="${ie.tipp?.hostPlatformURL}" class="btn-floating btn-large waves-effect waves-light tooltipped hostlink" data-position="top" data-delay="50" data-tooltip="${ie.tipp?.hostPlatformURL}" target="_blank"><i class="material-icons">link</i></a>
                          <p class="center-align"><a href="${ie.tipp?.hostPlatformURL}" target="_blank">Title URL</a></p>
                        </li>
                      </ul>
                    </div>

                  </div>
                  <!--list-section-item end-->
                </g:each>
              </g:if>
            </div>
          </g:form>

          <div class="col s12">
            <div class="pagination">
              <g:if test="${entitlements}">
                <g:paginate action="index" controller="subscriptionDetails" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${num_sub_rows}" class="showme" />
              </g:if>
            </div>
          </div>
        </div>
        <!-- list content end-->
      </g:if>
      <g:else>
        <div class="row">
          <div class="col s12 l12 actions-container">
            You have not added any packages to this subscription yet. Please use the  <g:link controller="subscriptionDetails" action="linkPackage" class="btn-floating bordered" params="${params_sc}" id="${params.id}"><i class="material-icons">add_circle_outline</i></g:link> button in the packages section above to add your first package.
          </div>
        </div>
      </g:else>
    </div>
    <!--***tab Titles content end***-->

    <!--***tab Details content start***-->
    <div id="details" class="tab-content">
      <!--***tab large card section***-->
      <div class="row">
        <!--*** Notifications card ***-->
        <div class="col s12 m6 l3">
          <div class="card jisc_card large white">
            <div class="card-content text-navy">
              <div class="launch-out">
                <g:if test="${editable}">
                  <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'addNoteView', params:[ownobjid:subscriptionInstance.id, ownobjclass:subscriptionInstance.class.name, owntp:'subscription', theme:'subscriptions'])}" class="btn-floating bordered modalButton"><i class="material-icons">add_circle_outline</i></a>
                </g:if>
                <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'viewNotes', params:[ownobjid:subscriptionInstance.id, ownobjclass:subscriptionInstance.class.name, theme:'subscriptions'])}" class="btn-floating bordered left-space modalButton"><i class="material-icons">open_in_new</i></a>
              </div>
              <p class="card-title">Notes</p>
              <div class="card-detail no-card-action">
                <ul class="collection with-actions">
                  <g:set var="hasNotes" value="${false}" />
                  <g:each in="${subscriptionInstance.documents}" var="docctx">
                    <g:if test="${docctx.owner.contentType == 0 && (docctx.status == null || docctx.status?.value != 'Deleted')}">
                      <li class="collection-item">
                        <div class="col s10">
                          <span class="note title">${docctx.owner.title}</span>
                          <span class="truncate">${docctx.owner.content}</span>
                          <p class="text-grey">Creator: ${docctx.owner.creator}</p>
                        </div>
                        <g:if test="${editable}">
                          <div class="col s2 actions-container">
                            <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'editNoteView', id:docctx.owner.id, params:[theme:'subscriptions'])}" class="btn-floating right modalButton"><i class="material-icons">create</i></a>
                            <g:link controller="docWidget" action="deleteDocument" id="${docctx.id}" params="${[anchor:'#details']}" class="btn-floating right" onclick="return confirm('Are you sure you want to delete this Note?')"><i class="material-icons">delete_forever</i></g:link>
                          </div>
                        </g:if>
                      </li>
                      <g:set var="hasNotes" value="${true}" />
                    </g:if>
                  </g:each>
                  <g:if test="${!hasNotes}">
                    <li class="collection-item">None</li>
                  </g:if>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <!--*** Notifications card ***-->
        
        <!--*** Documents card***-->
        <div class="col s12 m6 l3">
          <div class="card jisc_card large white">
            <div class="card-content text-navy">
              <g:if test="${editable}">
                <div class="launch-out">
                  <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'addDocumentView', params:[ownobjid:subscriptionInstance.id, ownobjclass:subscriptionInstance.class.name, owntp:'subscription', theme:'subscriptions'])}" class="btn-floating bordered modalButton"><i class="material-icons">add_circle_outline</i></a>
                </div>
              </g:if>
              <p class="card-title">Documents</p>
              <div class="card-detail no-card-action documents">
                <ul class="collection with-actions">
                  <g:set var="hasDocs" value="${false}" />
                  <g:each in="${subscriptionInstance.documents}" var="docctx">
                    <g:if test="${(((docctx.owner?.contentType == 1) || (docctx.owner?.contentType == 3)) && (docctx.status?.value != 'Deleted'))}">
                      <li class="collection-item avatar">
                        <div class="col s10">
                          <g:link controller="docstore" id="${docctx.owner.uuid}">
                            <i class="material-icons circle">description</i>
                            <span class="title">${docctx.owner.title}</span>
                            <p class="text-grey">
                              File name: ${docctx.owner.filename}<br> Creator: ${docctx.owner.creator}<br> Type: ${docctx.owner?.type?.value}
                            </p>
                          </g:link>
                        </div>
                        <g:if test="${editable}">
                          <div class="col s2 actions-container">
                            <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'editDocumentView', id:docctx.owner.id, params:[theme:'subscriptions'])}" class="btn-floating right modalButton"><i class="material-icons">create</i></a>
                            <g:link controller="docWidget" action="deleteDocument" id="${docctx.id}" params="${[anchor:'#details']}" class="btn-floating right" onclick="return confirm('Are you sure you want to delete this Document?')"><i class="material-icons">delete_forever</i></g:link>
                          </div>
                        </g:if>
                      </li>
                      <g:set var="hasDocs" value="${true}" />
                    </g:if>
                  </g:each>
                  <g:if test="${!hasDocs}">
                    <li class="collection-item">None</li>
                  </g:if>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <!--*** Documents card end ***-->
        
        <!--*** Documents card ***-->
        <div class="col s12 l6">
          <div class="card large white mobilecard">
            <!--*** Internal Cards ***-->
            <div class="internal-card-panel">
              <div class="launch-out">
                <a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'todo_history', params:params_sc, id:params.id)}" class="btn-floating bordered modalButton"><i class="material-icons">open_in_new</i></a>
              </div>
              <p class="card-title">Change History</p>
              <p class="card-caption"><span>${todoHistoryLinesTotal}</span> events</p>
            </div>
            <div class="internal-card-panel">
              <div class="launch-out">
                <a ajax-url="${createLink(controller:'subscriptionDetails', action:'edit_history', params:params_sc, id:params.id)}" class="btn-floating bordered modalButton" href="#kbmodal"><i class="material-icons">open_in_new</i></a>
              </div>
              <p class="card-title">Edit History</p>
              <p class="card-caption"><span>${historyLinesTotal}</span> events</p>
            </div>
            <div class="internal-card-panel">
              <div class="launch-out">
                <a ajax-url="${createLink(controller:'subscriptionDetails', action:'previous', params:params_sc, id:params.id)}" class="btn-floating bordered modalButton" href="#kbmodal"><i class="material-icons">open_in_new</i></a>
              </div>
              <p class="card-title">Previous Titles</p>
              <p class="card-caption"><span>${previousCount}</span> events</p>
            </div>
            <div class="internal-card-panel">
              <div class="launch-out">
                <a ajax-url="${createLink(controller:'subscriptionDetails', action:'expected', params:params_sc, id:params.id)}" class="btn-floating bordered modalButton" href="#kbmodal"><i class="material-icons">open_in_new</i></a>
              </div>
              <p class="card-title">Expected Titles</p>
              <p class="card-caption"><span>${expectedCount}</span> events</p>
            </div>
            <div class="internal-card-panel">
              <p class="card-title">Renewals</p>
              <p class="card-caption">
                <g:if test="${subscriptionInstance.subscriber}">
                  <g:link controller="subscriptionDetails" action="launchRenewalsProcess" id="${params.id}" params="${params_sc}">Start Renewals Process for Subscription ${params.id}</g:link>
                </g:if>
              </p>
            </div>
            <div class="internal-card-panel">
              <p class="card-title">Relationship</p><!--${subscriptionInstance.isSlaved?.value}-->
              <p class="card-caption">
                <g:if test="${subscriptionInstance.isSlaved?.value=='Auto'}">
                  <div class="card-response label default tooltipped" data-position="right" data-delay="50" data-tooltip="Auto"><i class="material-icons">loop</i>Auto</div>
                </g:if>
                <g:elseif test="${subscriptionInstance.isSlaved?.value=='Independent'}">
                  <div class="card-response label default tooltipped" data-position="right" data-delay="50" data-tooltip="Independent"><i class="material-icons">code</i>Indep</div>
                </g:elseif>
                <g:elseif test="${subscriptionInstance.isSlaved?.value=='Yes'}">
                  <div class="card-response label default tooltipped" data-position="right" data-delay="50" data-tooltip="Auto"><i class="material-icons">loop</i>Auto</div>
                </g:elseif>
                <g:elseif test="${subscriptionInstance.isSlaved == null}">
                  <div class="card-response label default tooltipped" data-position="right" data-delay="50" data-tooltip="Auto"><i class="material-icons">loop</i>Manual (default)</div>
                </g:elseif>
                <g:else>
                  <div class="card-response label default tooltipped" data-position="right" data-delay="50" data-tooltip="Manual"><i class="material-icons">build</i>Manual</div>
                </g:else>
              </p>
            </div>
            <!--*** Internal Cards end ***-->
          </div>
        </div>
        <!--*** Documents card end ***-->
        
        <div class="col s12 l6">
          <div class="card-panel drop-line">
            <p class="card-title">Renewal Reminder</p>
            <p class="card-caption"><g:if test="${subscriptionInstance.manualRenewalDate}"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${subscriptionInstance.manualRenewalDate}"/></g:if><g:else>None</g:else></p>
          </div>
          
          <div class="card-panel drop-line">
            <p class="card-title">Cancellation Allowance</p>
            <p class="card-caption">${subscriptionInstance.cancellationAllowances ?: 'None'}</p>
          </div>
        </div>
        
        <div class="col s12 l6">
          <div class="card jisc_card small white">
            <div class="card-content text-navy">
              <span class="card-title">Nominal Platform(s)</span>
              <div class="card-detail no-card-action">
                <g:set var="platform_count" value="${0 as Integer}" />
                <g:each in="${subscriptionInstance.packages}" var="sp">
                  <g:if test="${sp.pkg?.nominalPlatform}">
                    <ul class="collection">
                      <li class="collection-item">${sp.pkg?.nominalPlatform?.name}</li>
                    </ul>
                    <g:set var="platform_count" value="${platform_count + 1}" />
                  </g:if>
                </g:each>
                <g:if test="${platform_count == 0}">
                  <ul class="collection">
                    <li class="collection-item">None</li>
                  </ul>
                </g:if>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!--***tab large card section end***-->
      
      <!--***tabular data***-->
      <div class="row">
        <div class="col s12">
          <div class="tab-table z-depth-1">
            <ul class="tabs jisc_content_tabs">
              <li class="tab"><a href="#financials">Financials</a></li>
              <li class="tab"><a href="#organisation-links">Organisation Links</a></li>
              <li class="tab"><a href="#subscription-id">Subscription ID</a></li>
              <li class="tab"><a href="#permissions">Organisations granted permissions from this licence</a></li>
              <li class="tab"><a href="#costPerUse">Cost per use</a></li>
            </ul>
            
            <!--***table***-->
            <div id="financials" class="tab-content">
  	          <div class="row">
                <table class="highlight bordered responsive-table">
  	              <thead>
                    <tr>
                      <th data-field="cl">CL</th>
                      <th data-field="order-id">Order #</th>
                      <th data-field="start-date">Start Date</th>
                      <th data-field="end-date">End Date</th>
                      <th data-field="ammount">Amount</th>
                    </tr>
                  </thead>
                  <tbody>
                    <g:each in="${subscriptionInstance.costItems}" var="ci">
                      <tr>
                        <td>${ci.id}</td>
                        <td>${ci.order?.orderNumber}</td>
                        <td>${ci.startDate}</td>
                        <td>${ci.endDate}</td>
                        <td>${ci.costInLocalCurrencyIncVAT}</td>
                      </tr>
                    </g:each>
                  </tbody>
                </table>
              </div>
            </div>
            <!--***table end***-->
            
            <!--***table***-->
            <div id="organisation-links" class="tab-content">
              <!--***tab card section***-->
              <div class="row table-responsive-scroll">
                <table class="highlight bordered">
                  <thead>
                    <tr>
                      <th data-field="organisation">Organisation</th>
                      <th data-field="role">Role</th>
                      <th data-field="actions">Delete</th>
                      <g:if test="${editable}">
                        <th>
                          <a href="#kbmodal" reload="true" ajax-url="${createLink(controller:'ajax', action:'getAddOrgLinkView', params:[linkType:subscriptionInstance?.class?.name, domainid:subscriptionInstance?.id, property:'orgs', recip_prop:'sub', theme:'subscriptions', descText:'Select and add a content provider to the subscription details'])}"
                             class="modalButton waves-effect waves-light btn"><i class="material-icons right" style="color: #fff;">add_circle_outline</i>Add Organisation</a>
                        </th>
                      </g:if>
                    </tr>
                  </thead>
                  <tbody>
                    <g:if test="${subscriptionInstance?.orgRelations}">
                      <g:each in="${subscriptionInstance?.orgRelations}" var="role">
                        <tr>
                          <g:if test="${role.org}">
                            <td>
                              <g:link controller="organisations" action="show" id="${role.org.id}">${role?.org?.name}</g:link>
                            </td>
                            <td>${role?.roleType?.value}</td>
                            <g:if test="${editable}">
                              <td>
                                <!--<a href="" class="table-action"><i class="material-icons">create</i></a>-->
                                <g:link controller="ajax" action="delOrgRole" id="${role.id}" params="${[anchor:'#details']}" onclick="return confirm('Really delete this org link?')" class="btn-floating table-action"><i class="material-icons">delete_forever</i></g:link>
                              </td>
                            </g:if>
                            <td></td>
                          </g:if>
                          <g:else>
                            <td colspan="4">Error - Role link without org ${role.id} Please report to support</td>
                          </g:else>
                        </tr>
                      </g:each>
                    </g:if>
                    <g:else>
                      <tr>
                        <td colspan="4">No Data Currently Added</td>
                      </tr>
                    </g:else>
                  </tbody>
                </table>
              </div>
            </div>
            <!--***table end***-->
            
            <!--***table***-->
            <div id="subscription-id" class="tab-content">
              <!--***tab card section***-->
              <div class="row table-responsive-scroll">
                <table class="highlight bordered">
                  <thead>
                    <tr>
                      <th data-field="authority">Authority</th>
                      <th data-field="identifier">Identifier</th>
                      <th data-field="actions">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Reference</td>
                      <td>${subscriptionInstance.impId?:'none'}</td>
                      <td></td>
                    </tr>
                    <g:if test="${subscriptionInstance.ids}">
                      <g:each in="${subscriptionInstance.ids}" var="io">
                        <tr>
                          <td>${io.identifier.ns.ns}</td>
                          <td>${io.identifier.value}</td>
                          <td>
                            <g:if test="${editable}">
                              <g:link controller="ajax" action="deleteThrough" params='${[contextOid:"${subscriptionInstance.class.name}:${subscriptionInstance.id}",contextProperty:"ids",targetOid:"${io.class.name}:${io.id}"]}' class="btn-floating table-action"><i class="material-icons">delete_forever</i></g:link>
                            </g:if>
                          </td>
                        </tr>
                      </g:each>
                    </g:if>
                  </tbody>
                </table>
              </div>
            </div>
            <!--***table end***-->
            
            <!--***table***-->
            <div id="permissions" class="tab-content">
              <!--***tab card section***-->
              <div class="row table-responsive-scroll">
                <table class="highlight bordered">
                  <thead>
                    <tr>
                      <th data-field="organisation">Organisation</th>
                      <th data-field="roles">Roles</th>
                      <th data-field="permissions">Permissions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <g:if test="${subscriptionInstance.orgRelations}">
                      <g:each in="${subscriptionInstance.orgRelations}" var="ol">
                        <tr>
                          <td>${ol.org.name}</td>
                          <td>${ol.roleType?.value?:''}</td>
                          <td>
                            <g:each in="${ol.roleType?.sharedPermissions}" var="sp">
                              <g:if test="${subscriptionInstance.checkPermissions(sp.perm.code,user)}">
                                <g:if test="${sp.perm.code == 'edit'}">
                                  <a class="btn-floating table-action"><i class="material-icons">create</i></a>
                                </g:if>
                                
                                <g:if test="${sp.perm.code == 'view'}">
                                  <a class="btn-floating table-action"><i class="material-icons">visibility</i></a>
                                </g:if>
                              </g:if>
                            </g:each>
                            <!--<a href="" class="table-action"><i class="material-icons">create</i></a>
                                <a href="" class="table-action"><i class="material-icons">visibility</i></a>-->
                          </td>
                        </tr>
                      </g:each>
                    </g:if>
                    <g:else>
                      <tr>
                        <td colspan="3">No Data Currently Added</td>
                      </tr>
                    </g:else>
                  </tbody>
                </table>
              </div>
            </div>
            <!--***table end***-->
            
            <div id="costPerUse" class="tab-content">
              <div class="row table-responsive-scroll">
                <table class="highlight bordered ">
                  <thead>
                    <tr>
                      <th>Period</th>
                      <g:each in="${costItems.periods}" var="p">
                        <th>${p.year}-${p.month+1}</th>
                      </g:each>
                    </tr>
                  </thead>
                  <tbody>
                    <g:each in="${costItems.apportionment}" var="ci">
                      <tr>
                        <td>
                          Apportionment (<g:formatNumber number="${ci.total_cost}" type="number" type="currency" currencyCode="GBP" />)
                        </td>
                        <g:each in="${ci.periods}" var="cip">
                          <td><g:formatNumber number="${cip}" type="number" type="currency" currencyCode="GBP" /></td>
                        </g:each>
                      </tr>
                    </g:each>
                  </tbody>
                  <tfoot>
                    <tr>
                      <th>Total</th>
                      <g:each in="${costItems.periods}" var="p">
                        <th> <g:formatNumber number="${p.total}" type="number" type="currency" currencyCode="GBP"/> </th>
                      </g:each>
                    </tr>
                    <tr>
                      <td>Usage</td>
                      <g:each in="${costItems.periods}" var="p">
                        <td> ${p.usage} </td>
                      </g:each>
                    </tr>
                    <tr>
                      <th>Cost Per Use</th>
                      <g:each in="${costItems.periods}" var="p">
                        <th> <g:formatNumber number="${p.cost_per_use}" type="number" type="currency" currencyCode="GBP"/> </th>
                      </g:each>
                    </tr>
                  </tfoot>
                </table>
              </div>
              ${costItems?.message}
            </div><!-- div id=costPerUse -->
          </div>
          <!--***tabular data end***-->
        </div>
      </div>
      <!--***tab Details content end***-->
    </div>
    <!--tab section end-->
  </body>
</html>
