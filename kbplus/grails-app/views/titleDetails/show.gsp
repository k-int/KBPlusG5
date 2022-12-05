<!doctype html>
<%@ page import="com.k_int.custprops.PropertyDefinition" %>
<%@ page import="com.k_int.kbplus.RefdataValue" %>

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
   <meta name="layout" content="base"/>
   <parameter name="pagetitle" value="Title Details" />
   <parameter name="actionrow" value="title-detail" />
</head>
<body class="titles">

  <!--page title-->
  <div class="row">
     <div class="col s12 l12">
        <h1 class="page-title left">${ti.title}</h1>
     </div>
  </div>
  <!--page title end-->
  <g:set var="title_coverage_info" value="${ti.getInstitutionalCoverageSummary(institution, session.sessionPreferences?.globalDateFormat, date_restriction)}" />
    <div class="row row-content">
        <div class="col s12 m6 l3">
            <div class="card jisc_card small white">
                <div class="card-content text-navy">
                   <span class="card-title">Linked Subscriptions</span>
                  <div class="card-detail no-card-action">
                    <ul class="collection">
                      <g:if test="${title_coverage_info?.ies}">
                        <g:each in="${title_coverage_info?.ies}" var="ie">
                           <li class="collection-item">
                             <g:if test="params.defaultInstShortcode">
                               <g:link controller="subscriptionDetails" action="index" params="${[defaultInstShortcode:params.defaultInstShortcode]}" id="${ie.subscription.id}">${ie.subscription.name}</g:link>
                             </g:if>
                             <g:else>
                               ${ie.subscription.name}
                             </g:else>
                           </li>
                         </g:each>
                       </g:if>
                       <g:else>
                         <li class="collection-item">No linked subscriptions</li>
                       </g:else>
                    </ul>
                  </div>
              </div>
            </div>
        </div>
        <div class="col s12 m6 l3">
            <div class="card jisc_card small white">
                <div class="card-content text-navy">
                 <span class="card-title">Linked Packages</span>
                 <div class="card-detail no-card-action">
                     <ul class="collection">
                       <g:if test="${title_coverage_info?.ies}">
                         <g:each in="${title_coverage_info?.ies}" var="ie">
                            <li class="collection-item">
                              <g:link controller="packageDetails" action="show" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" id="${ie.tipp.pkg.id}">${ie.tipp.pkg.name}</g:link>
                            </li>
                          </g:each>
                        </g:if>
                       <g:else>
                         <li class="collection-item">No linked packages</li>
                       </g:else>
                     </ul>
                 </div>
               </div>
             </div>
        </div>
        <div class="col s12 m6 l3">
            <div class="card-panel">
                <p class="card-title">Published from</p>
                <p class="card-label">
                     <g:if test="${ti.publishedFrom}">
                       <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ti.publishedFrom}"/>
                     </g:if>
                     <g:else>
                       None
                     </g:else>
                </p>
            </div>
            <div class="card-panel">
                <p class="card-title">Associated Updates</p>
                <div class="card-content-scrollable">
          <p class="card-caption">
            <g:set var="au_content" value="${false}"/>
                    <g:if test="${ti.parentTitle}">
                      Parent: <g:link controller="titleDetails" action="show" id="${ti.parentTitle?.id}">${ti.parentTitle?.title}</g:link>
                        <g:link controller='titleDetails' action='clearParent' id="${ti?.id}" class="right"><i class="material-icons">delete_forever</i></g:link><br/>
                        <g:set var="au_content" value="${true}"/>
                    </g:if>
                    <g:each in="${ti.childTitles}" var="cp">
                        Child: ${cp.title}<br/>
                        <g:set var="au_content" value="${true}"/>
                    </g:each>
                    <g:if test="${au_content == false}">
                      None
                    </g:if>
                  </p>
                </div>
             </div>
        </div>
        <div class="col s12 m6 l3">
            <div class="card-panel">
                <p class="card-title">Published to</p>
                 <p class="card-label">
                     <g:if test="${ti.publishedTo}">
                       <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ti.publishedTo}"/>
                     </g:if>
                     <g:else>
                       None
                     </g:else>
                </p>
             </div>
             <div class="card-panel">
               <p class="card-title">Publication Type</p>
                 <p class="card-caption">${ti?.publicationType?:'None'}</p>
             </div>
        </div>
  </div>
  
  <g:if test="${title_coverage_info?.ies}">
    <div class="row">
      <div class="col s12">
        <ul class="tabs jisc_tabs">
          <li class="tab"><a href="#details" class="add-anchor">Details<i class="material-icons">chevron_right</i></a></li>
          <li class="tab"><a href="#issueEnts" class="add-anchor">Issue Entitlements<i class="material-icons">chevron_right</i></a></li>
        </ul>
      </div>
      
      <!--***tab Details content start***-->
      <div id="details" class="tab-content">
  </g:if>
  
  <div class="row row-content">
    <div class="col s12 m6 l6">
          <div class="card-panel">
              <p class="card-title">First Author</p>
              <p class="card-label">${ti.firstAuthor?:'None'}</p>
          </div>
        </div>
        <div class="col s12 m6 l6">
          <div class="card-panel">
              <p class="card-title">Parent Publication</p>
              <p class="card-label">${ti.parentTitle?.title?:'None'}</p>
          </div>
        </div>
     </div>
  
    <!--tab section start-->
    <div class="row">
        <div class="col s12">
            <div class="row strip-table z-depth-1">

              <div class="col m12 l6 section">
                  <div class="col m6 title">
                    Monograph Edition
                  </div>
                  <div class="col m6 result">
                    ${ti.monographEdition?:'None'}
                  </div>
              </div>
              
              <div class="col m12 l6 section">
                  <div class="col m6 title">
                    Date Monograph Published Print
                  </div>
                  <div class="col m6 result">
                    <g:if test="${ti.dateMonographPublishedPrint}">
                      <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ti.dateMonographPublishedPrint}"/>
                    </g:if>
                    <g:else>
                      None
                    </g:else>
                  </div>
              </div>
              
              <div class="col m12 l6 section">
                  <div class="col m6 title">
                    Monograph Volume
                  </div>
                  <div class="col m6 result">
                    ${ti.monographVolume?:'None'}
                  </div>
              </div>

              <div class="col m12 l6 section">
                  <div class="col m6 title">
                    Date Monograph Published Online
                  </div>
                  <div class="col m6 result">
                    <g:if test="${ti.dateMonographPublishedOnline}">
                      <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ti.dateMonographPublishedOnline}"/>
                    </g:if>
                    <g:else>
                      None
                    </g:else>
                  </div>
              </div>

              <div class="col m12 l6 section">
                  <div class="col m6 title">
                    First Editor
                  </div>
                  <div class="col m6 result">
                    ${ti.firstEditor?:''}
                  </div>
              </div>

            </div>
    </div>
  </div>
    
    <!--***tabular data***-->
    <div class="row">
        <div class="col s12">
          <div class="tab-table z-depth-1">

              <ul class="tabs jisc_content_tabs">
                <li class="tab"><a href="#occurrences">Occurrences in Packages & Platforms</a></li>
                  <li class="tab"><a href="#identifiers">Identifiers</a></li>
                  <li class="tab"><a href="#orgLinks">Org Links</a></li>
                  <li class="tab"><a href="#dataHistory">Database Title History</a></li>
                  <li class="tab"><a href="#bibHistory">Bibliography Title History</a></li>
              </ul>
              
              <!--***table***-->
              <div id="occurrences" class="tab-content">
          <div class="row table-responsive-scroll">
            <table class="highlight bordered">
              <thead>
                <tr>
                  <g:if test="${editable}">
                    <th data-field="batch">Batch</th>
                  </g:if>
                  <th data-field="platform">Platform</th>
                  <th data-field="package">Package</th>
                  <th data-field="start">Start</th>
                  <th data-field="end">End</th>
                  %{-- <th data-field="coverageD">Coverage Depth</th> --}%
                  <th data-field="id">Platform Link</th>
                  <th data-field="coverageN">Coverage Note</th>
                  <g:if test="${editable}">
                    <th data-field="add">
                      <g:set var="disc" value="${[]}"/>
                      <g:if test="${params.defaultInstShortcode}">
                        <g:set var="disc" value="${[defaultInstShortcode:params.defaultInstShortcode]}"/>
                      </g:if>
                      <a id="title_batchEditTipps" href="#kbmodal" ajax-url="${createLink(controller:'titleDetails', action:'batchEditTIPPsModal', id:ti.id, params:disc)}" class="waves-effect waves-light btn">Batch TIPPs</a></th>
                  </g:if>
                </tr>
              </thead>
              <tbody>
                <g:if test="${ti.tipps?.size() > 0}">
                  <g:each in="${ti.tipps}" var="t">
                    <tr>
                      <g:if test="${editable}">
                        <td style="vertical-align:middle;">
                          <input type="checkbox" id="_bulkflag.${t.id}" name="_bulkflag.${t.id}" class="bulkcheck"/>
                          <label for="_bulkflag.${t.id}" class="align">&nbsp;</label>
                        </td>
                      </g:if>
                      <td><g:link controller="platform" action="show" id="${t.platform.id}">${t.platform.name}</g:link></td>
                      <td><g:link controller="packageDetails" action="show" id="${t.pkg.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${t.pkg.name}</g:link></td>
                      <td>
                        Date: <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.startDate}"/><br/>
                        Volume: ${t.startVolume}<br/>
                        Issue: ${t.startIssue}
                      </td>
                      <td>
                        Date: <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.endDate}"/><br/>
                        Volume: ${t.endVolume}<br/>
                        Issue: ${t.endIssue}
                      </td>
                       %{--<td>${t.coverageDepth}</td> --}%
                      <td>
                        <g:if test="${t.hostPlatformURL}">
                          <a href="${t.hostPlatformURL}" target="_blank">Link</a>
                        </g:if>
                        <g:if test="${grailsApplication.config.feature.v61}">
                          <br/>New Generated Host Platform URL: ${t.getComputedTemplateURL()}
                        </g:if>
                      </td>
                      <td>
                        <g:if test="${t.coverageNote}">
							${t.coverageNote}
						</g:if>
                    	<g:else>
							N/A
						</g:else>
                      </td>
                      <td>
                        <g:link controller="tipp" action="show" id="${t.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">TIPP</g:link>
                      </td>
                      <g:if test="${editable}">
                        <td></td>
                      </g:if>
                    </tr>
                  </g:each>
                  <ul class="checkbox-collection mt-30 ml-5">
                    <li>
                      <input type="checkbox" name="checkall" id="batchCheckAll">
                      <label for="batchCheckAll">Select All TIPPs</label>
                    </li>
                  </ul>
                </g:if>
                <g:else>
                  <tr><td colspan="${editable?'9':'7'}">No Data Currently Added</td></tr>
                </g:else>
              </tbody>
            </table>
          </div>
        </div>
        <!--***table end***-->

              <!--***table***-->
              <div id="identifiers" class="tab-content">
                   <div class="row table-responsive-scroll">
                      <table class="highlight bordered">
                          <thead>
                              <tr>
                                  <th data-field="id">ID</th>
                                  <th data-field="idnamespace">Identifier Namespace</th>
                                  <th data-field="identifier">Identifier</th>
                              </tr>
                          </thead>

                          <tbody>
                            <g:if test="${ti.ids}">
                              <g:each in="${ti.ids}" var="io">
                              <tr>
                                <td>${io?.id}</td>
                                <td>${io?.identifier?.ns?.ns}</td>
                                <td>${io?.identifier?.value}</td>
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
              <!--***table end***-->

              <!--***table***-->
              <div id="orgLinks" class="tab-content">
                <div class="row table-responsive-scroll">
                  <table class="highlight bordered">
                    <thead>
                        <tr>
                            <th>ID</td>
                            <th>Org</th>
                            <th>Role</th>
                            <th>From</th>
                            <th>To</th>
                            <!--this does not appear in the current live system-->
                            <!--<th><a href="#kbmodal" ajax-url="${createLink(controller:'ajax', action:'getAddOrgLinkView', params:[linkType:subscriptionInstance?.class?.name, domainid:subscriptionInstance?.id, property:'orgs', recip_prop:'sub', theme:'titles'])}" class="waves-effect waves-light btn modalButton"><i class="material-icons right" style="color: #fff;">add_circle_outline</i>Add Organisation</a></th>-->
                        </tr>
                      </thead>
                      <tbody>
                        <g:if test="${ti.orgs}">
                          <g:each in="${ti.orgs}" var="org">
                              <tr>
                                <td>${org?.id}</td>
                                <td>${org?.org?.name}</td>
                                <td>${org?.roleType?.value}</td>
                                <td>
                                  <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${org.startDate}"/>
                                </td>
                                <td>
                                    <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${org.endDate}"/>
                                </td>
                                <!--<td></td>-->
                              </tr>
                          </g:each>
                        </g:if>
                        <g:else>
                          <tr><td colspan="5">No Data Currently Added</td></tr>
                        </g:else>
                      </tbody>
                  </table>
                </div>
              </div>
              <!--***table end***-->

              <!--***table***-->
              <div id="dataHistory" class="tab-content">
                <div class="row table-responsive-scroll">
                  <table class="highlight bordered">
                    <thead>
                      <tr>
                          <td class="w150">Name</td>
                          <td class="w150">Actor</td>
                          <td class="w150">Event name</td>
                          <td class="w150">Property</td>
                          <td class="w150">Old</td>
                          <td>New</td>
                          <td class="w150">Date</td>
                      </tr>
                    </thead>
                    <tbody>
                      <g:if test="${formattedHistoryLines}">
                        <g:each in="${formattedHistoryLines}" var="hl">
                            <tr>
                              <td><a href="${hl.link}">${hl.name}</a></td>
                              <td class="w150">
                                  <g:link controller="userDetails" action="edit" id="${hl.actor?.id}">${hl.actor?.displayName}</g:link>
                              </td>
                              <td class="w150">${hl.eventName}</td>
                              <td class="w150">${hl.propertyName}</td>
                              <td>${hl.oldValue}</td>
                              <td>${hl.newValue}</td>
                              <td class="w150"><g:formatDate format="yyyy-MM-dd" date="${hl.lastUpdated}"/></td>
                            </tr>
                        </g:each>
                      </g:if>
                        <g:else>
                          <tr><td colspan="7">No Data Currently Added</td></tr>
                        </g:else>
                    </tbody>
                  </table>
                </div>
              </div>
              <!--***table end***-->

              <!--***table***-->
              <div id="bibHistory" class="tab-content">
                <div class="row table-responsive-scroll">
                  <table class="highlight bordered">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>From</th>
                            <th>To</th>
                            <th>Action</th>
                        </tr>
                      </thead>
                      <tbody>
                        <g:if test="${titleHistory}">
                          <g:each in="${titleHistory}" var="th">
                              <tr>
                                <td>
                                  <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${th.eventDate}"/>
                                </td>
                                <td>
                                    <g:each in="${th.participants}" var="p">
                                      <g:if test="${p.participantRole=='In'}">
                                          <g:link controller="titleDetails" action="show" id="${p.participant.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${p.participant.title}</g:link><br/>
                                      </g:if>
                                    </g:each>
                                </td>
                                <td>
                                    <g:each in="${th.participants}" var="p">
                                      <g:if test="${p.participantRole=='Out'}">
                                          <g:link controller="titleDetails" action="show" id="${p.participant.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${p.participant.title}</g:link><br/>
                                      </g:if>
                                    </g:each>
                                </td>
                                <td>
                                    <g:link controller="titleDetails" action="deleteTHParticipant" id="${ti.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="btn btn-danger" params="${[event:th.id]}">Delete Change Record</g:link><br/>
                                </td>
                              </tr>
                          </g:each>
                        </g:if>
                        <g:else>
                          <tr><td colspan="4">No Data Currently Added</td></tr>
                        </g:else>
                      </tbody>
                  </table>
                </div>
              </div>
              <!--***table end***-->
          </div>
        </div>
    </div>

    <g:if test="${title_coverage_info?.ies}">
          <!-- key licences props here-->
          <!--***Licence card section starts and should be 4loop if more than one licence as per list tooggle***-->
        <div class="row">
          <div class="col s12">
            <div class="row strip-table z-depth-1">
              <!--loop from here-->
              <g:set var="showNoPropText" value="${true}"/>
              <g:each in="${title_coverage_info?.ies}" var="ie">
                <g:if test="${ie.subscription?.owner}">
                  <g:set var="licProps" value="${keyPropsDisplay(ie.subscription.owner.customProperties)}"/>
                  <div class="col s12">
                    <h3>Licences Key Properties: ${ie.subscription.owner.reference}</h3>
                    <div class="properties-container center-graphic">
                      <g:render template="keyLicProp" model="[propdata:licProps.get('Include in VLE'), icon:'computer_black',propname:'Include in VLE']"/>
                      <g:render template="keyLicProp" model="[propdata:licProps.get('Include In Coursepacks'), icon:'library_books',propname:'Include In Coursepacks']"/>
                      <g:render template="keyLicProp" model="[propdata:licProps.get('ILL - InterLibraryLoans'), icon:'call_split_black',propname:'ILL - InterLibraryLoans']"/>
                      <g:render template="keyLicProp" model="[propdata:licProps.get('Walk In Access'), icon:'directions_walk',propname:'Walk In Access']"/>
                      <g:render template="keyLicProp" model="[propdata:licProps.get('Remote Access'), icon:'cast_connected_black',propname:'Remote Access']"/>
                      <g:render template="keyLicProp" model="[propdata:licProps.get('Alumni Access'), icon:'group_black',propname:'Alumni Access']"/>
                    </div>
                  </div>
                </g:if>
              </g:each>
              <!--to here-->
            </div>
          </div>
        </div>
        <!--***Licence card section ends***-->

      <!--this closes the details tab div that is opened if the if statement above-->
        </div>

        <!-- issue entitlements tab here! -->
        <!--***tab issue entitlements content start**-->
      <div id="issueEnts" class="tab-content">
        <!--***tab card section***-->
        <g:each in="${title_coverage_info?.ies}" var="ie">
          <div class="row row-content">
            <div class="col s12 m6 no-padding">
              <div class="row">
                <div class="col s12">
                  <div class="row card-panel strip-table-issue-ents-T z-depth-1">
                    <div class="col m12 section">
                      <div class="col s12">
                        <h3>Issue Entitlement for ${ie?.tipp.title.title} ${ie.status ? '('+ie.status.value+')' : ''} - Access: 
                                <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.getDerivedAccessStartDate()}"/> -
                                <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.getDerivedAccessEndDate()}"/></h3>
                      </div>
                    </div>

                    <div class="col m12 section">
                      <div class="col m6 title">
                        Subscription
                      </div>
                      <div class="col m6 result">
                        <g:if test="${ie?.subscription}">
                          <g:link controller="subscriptionDetails" action="index" id="${ie.subscription.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${ie.subscription.name?.encodeAsHTML()}</g:link>${ie.subscription.status ? '('+ie.subscription.status.value+')' : ''}
                           <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.subscription.startDate}"/> -
                           <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.subscription.endDate}"/>
                        </g:if>
                        <g:else>
                          None
                        </g:else>
                      </div>
                    </div>

                    <div class="col m12 section">
                      <div class="col m6 title">
                        Licence
                      </div>
                      <div class="col m6 result">
                        <g:if test="${ie?.subscription.owner}">
                          ${ie?.subscription?.owner.reference.encodeAsHTML()}
                        </g:if>
                        <g:else>
                          None
                        </g:else>
                      </div>
                    </div>

                    <div class="col m12 section">
                      <div class="col m6 title">
                        ONIX-PL Licence
                      </div>
                      <div class="col m6 result">
                        <g:if test="${ie?.subscription?.owner?.onixplLicense}">
                          ${ie.subscription.owner.onixplLicense.title.encodeAsHTML()}
                        </g:if>
                        <g:else>
                          None
                        </g:else>
                      </div>
                    </div>

                    <div class="col m12 section">
                      <div class="col m6 title">
                        Title
                      </div>
                      <div class="col m6 result">
                        <g:if test="${ie?.tipp?.title}">
                          ${ie?.tipp?.title.title.encodeAsHTML()}
                        </g:if>
                        <g:else>
                          None
                        </g:else>
                      </div>
                    </div>

                    <div class="col m12 section">
                      <div class="col m6 title">
                        TIPP Delayed OA
                      </div>
                      <div class="col m6 result">
                        <g:if test="${ie?.tipp?.delayedOA?.value}">
                          ${ie.tipp.delayedOA.value}
                        </g:if>
                        <g:else>
                          None
                        </g:else>
                      </div>
                    </div>

                    <div class="col m12 section">
                      <div class="col m6 title">
                        TIPP Hybrid OA
                      </div>
                      <div class="col m6 result">
                        <g:if test="${ie?.tipp?.hybridOA?.value}">
                          ${ie.tipp.hybridOA.value}
                        </g:if>
                        <g:else>
                          None
                        </g:else>
                      </div>
                    </div>

                    <div class="col m12 section">
                      <div class="col m6 title">
                        Date Title Joined Package
                      </div>
                      <div class="col m6 result">
                        <g:if test="${ie?.tipp?.accessStartDate}">
                          <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.tipp.accessStartDate}"/>
                        </g:if>
                        <g:else>
                          None
                        </g:else>
                      </div>
                    </div>

                    <div class="col m12 section">
                      <div class="col m6 title">
                        <g:link controller="issueEntitlement" action="show" id="${ie.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="waves-effect btn mt-20">See Full</g:link>
                      </div>
                      <div class="col m6 result">
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="col s12 m6 no-padding">
              <div class="row">
                <div class="col s12">
                  <div class="row card-panel strip-table-issue-ents-T z-depth-1">
                    <div class="col m12 section">
                      <div class="col s12 mt-30">
                        <h3> </h3>
                      </div>
                    </div>

                    <div class="col m12 section">
                      <div class="col m6 title">
                        Title Identifiers
                      </div>
                      <div class="col m6 result">
                        <g:if test="${ie?.tipp.title?.ids}">
                          <g:each in="${ie?.tipp.title?.ids}" var="i" status="counter">
                            <g:if test="${counter > 0}">, </g:if>
                            <span>${i.identifier.ns.ns}:${i.identifier.value}</span>
                            <g:if test="${i.identifier.ns.ns.equalsIgnoreCase('issn')}">
                              (<a href="https://portal.issn.org/resource/issn/{i.identifier.value}" target="_blank">ISSN Agency</a>)
                            </g:if>
                            <g:if test="${i.identifier.ns.ns.equalsIgnoreCase('eissn')}">
                              (<a href="https://portal.issn.org/resource/issn/${i.identifier.value}" target="_blank">ISSN Agency</a>)
                            </g:if>
                          </g:each>
                        </g:if>
                        <g:else>
                          None
                        </g:else>
                      </div>
                    </div>

                    <div class="col m12 section">
                      <div class="col m6 title">
                        Embargo
                      </div>
                      <div class="col m6 result">
                        <g:if test="${ie?.embargo}">
                          ${ie.embargo}
                        </g:if>
                        <g:else>
                          None
                        </g:else>
                      </div>
                    </div>

                    <div class="col m12 section">
                      <div class="col m6 title">
                        Coverage Depth
                      </div>
                      <div class="col m6 result">
                        <g:if test="${ie?.coverageDepth}">
                          ${ie.coverageDepth}
                        </g:if>
                        <g:else>
                          None
                        </g:else>
                      </div>
                    </div>

                    <div class="col m12 section">
                      <div class="col m6 title">
                        Coverage Note
                      </div>
                      <div class="col m6 result">
                        <g:if test="${ie?.coverageNote}">
                          ${ie.coverageNote}
                        </g:if>
                        <g:else>
                          None
                        </g:else>
                      </div>
                    </div>

                    <div class="col m12 section">
                      <div class="col m6 title">
                        Core Status
                      </div>
                      <div class="col m6 result">
                        <g:render template="/templates/coreStatus" model="${['issueEntitlement': ie, 'theme':'titles', 'center':false, 'editable':editable]}"/>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </g:each>
        <!--***tab card section end***-->
        <!--***tab issue entitlements content end**-->
      <!--this closes the issue ents tab-->
      </div>

      <!--this closes the row above the jisc tabs-->
      </div>
    </g:if>
</body>
</html>
