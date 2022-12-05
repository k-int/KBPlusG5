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
    <parameter name="actionrow" value="licence-details" />
    <parameter name="pagetitle" value="Licence Details" />
    <title>KB+ :: Licence Details</title>
  </head>
  <body class="licences">

      <g:render template="/templates/flash_alert_panels"/>
    <g:set var="licdetails_sc_params" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
    <!--page title-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">${license.reference?:message(code:'missingLicenseReference', default:'** No Licence Reference Set **')}</h1>
      </div>
      <!--Not sure this belongs here
      <div class="col s12 l2">
        <a href="#" class="waves-effect waves-light btn right"><i class="material-icons right">add_circle_outline</i>Add Title</a>
      </div>-->
    </div>
    <!--page title end-->

    <!--***Top static card section***-->
    <div class="row">
      <div class="row-content">
        <div class="col s12 m6 l3">
          <div class="card jisc_card small white">
            <div class="card-content text-navy">
              <span class="card-title">Associated Subscriptions (${license?.subscriptions?.size() ?: 0})</span>
              <div class="card-detail no-card-action">
                <ul class="collection with-actions">
                  <g:if test="${license.subscriptions && ( license.subscriptions?.size() > 0 )}">
                                  <g:each in="${license.subscriptions}" var="sub">
                                    <li class="collection-item plain"><g:link controller="subscriptionDetails" action="index" id="${sub.id}" params="${licdetails_sc_params}">${sub.name}</g:link></li>
                                  </g:each>
                              </g:if>
                              <g:else>
                                <li class="collection-item plain">No currently linked subscriptions.</li>
                              </g:else>
                </ul>
              </div>
                  </div>
                </div>
              </div>
        <div class="col s12 m6 l3">
          <div class="card jisc_card small white">
            <div class="card-content text-navy">
              <span class="card-title">Associated Packages (${license?.pkgs?.size()?:0})</span>
              <div class="card-detail no-card-action">
                <ul class="collection with-actions">
                  <g:if test="${license?.pkgs && ( license?.pkgs?.size() > 0 )}">
                    <g:each in="${license.pkgs}" var="pkg">
                      <li class="collection-item">
                        <div class="col s12">
                          <g:link controller="packageDetails" action="show" id="${pkg.id}">${pkg.name}</g:link>
                        </div>
                      </li>
                                  </g:each>
                                </g:if>
                                <g:else>
                                  <li class="collection-item plain">No currently linked packages.</li>
                                </g:else>
                            </ul>
              </div>
            </div>
          </div>
        </div>
        <div class="col s12 m6 l3">
          <div class="card-panel">
            <p class="card-label">Start Date:
              <span class="card-response right">
                <g:if test="${license.startDate}">
                  <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${license.startDate}"/>
                </g:if>
                <g:else>
                      None
                    </g:else>
              </span>
            </p>
            <p class="card-label">End Date:
              <span class="card-response right">
                <g:if test="${license.endDate}">
                  <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${license.endDate}"/>
                </g:if>
                <g:else>
                  None
                </g:else>
              </span>
            </p>
          </div>
          <div class="card-panel">
            <div class="card-response right label status default tooltipped" data-delay="50" data-position="left" data-tooltip="${license.status}"><i class="material-icons">timer</i>${license.status}</div>
            <p class="card-label">Status: </p>
            <p class="card-label">Public: <span class="card-response right">${license?.isPublic ?: 'None'}</span></p>
          </div>
        </div>
        <div class="col s12 m6 l3">
          <div class="card-panel">
            <div class="launch-out">
              <a href="#kbmodal" reload="true" id="pendingchanges" ajax-url="${createLink(controller:'licenseDetails', action:'pendingChanges', params:licdetails_sc_params, id:params.id)}" class="btn-floating bordered modalButton"><i class="material-icons">open_in_new</i></a>
            </div>
            <p class="card-title">Pending Changes</p>
            <g:if test="${pendingChanges}">
            	<p class="card-caption"><span>${pendingChanges.size()}</span> changes to approve</p>
            </g:if>
            <g:else>
            	<p class="card-caption"><span>0</span> changes to approve</p>
            </g:else>
          </div>
          <div class="card-panel">
            <p class="card-title">Licensor</p>
            <p class="card-caption">${license.licensor?.name ?: 'None'}</p>
          </div>
        </div>
      </div>
    </div>
    <!--***Top static card section***-->

    <!--tab section start-->
    <div class="row">

      <div class="col s12">
        <ul class="tabs jisc_tabs">
          <li class="tab col s2"><a href="#properties" class="add-anchor">Properties<i class="material-icons">chevron_right</i></a></li>
          <li class="tab col s2"><a href="#details" class="add-anchor">Details<i class="material-icons">chevron_right</i></a></li>
        </ul>
      </div>

      <!-- shows on both tabs, no need to duplicate html -->
      <!--***tab Titles content start***-->
      <div id="all" class="tab-content">

        <!--***tab Details content start***-->
        <div id="properties" class="tab-content">

          <!--***tab large card section***-->
          <g:set var="licProps" value="${keyPropsDisplay(license.customProperties)}"/>
          <div class="row">
            <div class="col s12 l6">
              <div class="card jisc_card large white">
                <div class="card-content text-navy card-center">
                  <p class="card-title">Key Licence Properties</p>
                  <div class="center-row">
                    <div class="row center-graphic licencepropertylist">
                      <g:render template="keyLicProp" model="[propdata:licProps.get('Include in VLE'), icon:'computer_black',propname:'Include in VLE']"/>
                      <g:render template="keyLicProp" model="[propdata:licProps.get('Include In Coursepacks'), icon:'library_books',propname:'Include In Coursepacks']"/>
                      <g:render template="keyLicProp" model="[propdata:licProps.get('ILL - InterLibraryLoans'), icon:'call_split_black',propname:'ILL - InterLibraryLoans']"/>
                      <g:render template="keyLicProp" model="[propdata:licProps.get('Walk In Access'), icon:'directions_walk',propname:'Walk In Access']"/>
                      <g:render template="keyLicProp" model="[propdata:licProps.get('Remote Access'), icon:'cast_connected_black',propname:'Remote Access']"/>
                      <g:render template="keyLicProp" model="[propdata:licProps.get('Alumni Access'), icon:'group_black',propname:'Alumni Access']"/>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!--*** Notifications card ***-->
            <div class="col s12 m6 l3">
              <div class="card jisc_card large white">
                <div class="card-content text-navy">
                  <div class="launch-out">
                    <g:if test="${editable}">
                      <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'addNoteView', params:[ownobjid:license.id, ownobjclass:license.class.name, owntp:'license', theme:'licences'])}" class="btn-floating bordered modalButton"><i class="material-icons">add_circle_outline</i></a>
                    </g:if>
                    <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'viewNotes', params:[ownobjid:license.id, ownobjclass:license.class.name, theme:'licences'])}" class="btn-floating bordered left-space modalButton"><i class="material-icons">open_in_new</i></a>
                  </div>
                  <p class="card-title">Notes</p>
                  <div class="card-detail no-card-action">
                    <ul class="collection with-actions">
                      <g:set var="hasNotes" value="${false}"/>
                      <g:each in="${license.documents}" var="docctx">
                              <g:if test="${docctx.owner.contentType == 0 && (docctx.status == null || docctx.status?.value != 'Deleted')}">
                              <li class="collection-item">
                                <div class="col s10">
                                  <span class="note title" style="font-weight: 500;">${docctx.owner.title}</span>
                                  <span class="truncate">${docctx.owner.content}</span>
                                  <p class="text-grey">Creator: ${docctx.owner.creator}</p>
                                </div>
                                <g:if test="${editable}">
                                <div class="col s2 actions-container">
                                                <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'editNoteView', id:docctx.owner.id, params:[theme:'licences'])}" class="btn-floating right modalButton"><i class="material-icons">create</i></a>
                                                <g:link controller="docWidget" action="deleteDocument" id="${docctx.id}" params="${[anchor:'#details']}" class="btn-floating right" onclick="return confirm('Are you sure you want to delete this Note?')"><i class="material-icons">delete_forever</i></g:link>
                                              </div>
                                            </g:if>
                              </li>
                              <g:set var="hasNotes" value="${true}"/>
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
                      <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'addDocumentView', params:[ownobjid:license.id, ownobjclass:license.class.name, owntp:'license', theme:'licences'])}" class="btn-floating bordered modalButton"><i class="material-icons">add_circle_outline</i></a>
                    </div>
                  </g:if>
                  <p class="card-title">Documents</p>
                  <div class="card-detail no-card-action documents">
                    <ul class="collection with-actions">
                      <g:set var="hasDocs" value="${false}"/>
                      <g:each in="${license.documents}" var="docctx">
                              <g:if test="${(((docctx.owner?.contentType == 1) || (docctx.owner?.contentType == 3)) && (docctx.status?.value != 'Deleted'))}">
                               <li class="collection-item avatar">
                                 <div class="col s10">
                                   <g:link controller="docstore" id="${docctx.owner.uuid}">
                                       <i class="material-icons circle">description</i>
                                       <span class="title">${docctx.owner.title}</span>
                                       <p class="text-grey">
                                          File name: ${docctx.owner.filename}<br>
                                          Creator: ${docctx.owner.creator?:'No creator found'}<br>
                                          Type: ${docctx.owner?.type?.value}
                                       </p>
                                     </g:link>
                                   </div>
                                   <g:if test="${editable}">
                                <div class="col s2 actions-container">
                                                <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'editDocumentView', id:docctx.owner.id, params:[theme:'licences'])}" class="btn-floating right modalButton"><i class="material-icons">create</i></a>
                                                <g:link controller="docWidget" action="deleteDocument" id="${docctx.id}" params="${[anchor:'#details']}" class="btn-floating right" onclick="return confirm('Are you sure you want to delete this Document?')"><i class="material-icons">delete_forever</i></g:link>
                                              </div>
                                            </g:if>
                               </li>
                               <g:set var="hasDocs" value="${true}"/>
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
          </div>

          <g:if test="${flash.error}">
            <div class="row">
              <div class="col s12">
                ${flash.error}
              </div>
            </div>
          </g:if>

          <!--***tabular data***-->
          <div class="row">
            <div class="col s12">
              <div class="tab-table z-depth-1">
                <ul class="tabs jisc_content_tabs">
                  <li class="tab"><a href="#licence-properties">Licence Properties</a></li>
                  <li class="tab"><a href="#organisation-links">Organisation Links</a></li>
                </ul>

                <!--***table***-->
                <div id="licence-properties" class="tab-content">

                  <!--***tab card section***-->
                  <div class="row table-responsive-scroll">
                    <table class="highlight bordered">
                      <thead>
                        <tr>
                          <th data-field="organisation" class="mw-180">Properties</th>
                          <th data-field="roles" class="w150">Values</th>
                          <th data-field="note" class="w400">Note</th>
                          <g:if test="${editable}">
                            <th data-field="permissions">Actions</th>
                            <th data-field="add" class="w200"><a href="#kbmodal" ajax-url="${createLink(controller:'ajax', action:'addCustomPropertyModal', params:[prop_desc:PropertyDefinition.LIC_PROP, ownerId:license.id, ownerClass:license.class.name, editable:editable, propBaseClass:'com.k_int.custprops.PropertyDefinition', theme:'licences'])}" class="btn right modalButton"><i class="material-icons right">add_circle_outline</i>ADD PROPERTIES</a></th>
                          </g:if>
                        </tr>
                      </thead>
                      <tbody>
                        <g:if test="${license.customProperties}">
                          <g:each in="${license.customProperties.sort{it.type.name}}" var="prop">
                            <tr>
                              <td>${prop.type.name}</td>
                              <td class="w150">
                                <g:if test="${prop.type.type == Integer.class.name}">
                                  ${prop.intValue}
                                </g:if>
                                <g:elseif test="${prop.type.type == String.class.name}">
                                  ${prop.stringValue}
                                </g:elseif>
                                <g:elseif test="${prop.type.type == BigDecimal.class.name}">
                                  ${prop.decValue}
                                </g:elseif>
                                <g:elseif test="${prop.type.type == RefdataValue.class.name}">
                                  ${prop?.refValue?.value}
                                </g:elseif>
                              </td>
                              <td>${prop.note}</td>
                              <g:if test="${editable == true}">
                                <td>
                                  <a href="#kbmodal" ajax-url="${createLink(controller:'ajax', action:'editCustomProperty', id:prop.id, params:[propclass:prop.getClass(), ownerId:license.id, ownerClass:license.class.name, editable:editable, referer:'Y', theme:'licences'])}" class="btn-floating table-action hide-on-small-and-down modalButton"><i class="material-icons">create</i></a>
                                  <g:link controller="ajax"
                                      action="delCustomProperty"
                                      id="${prop.id}"
                                      params="${[propclass: prop.getClass(),ownerId:license.id,ownerClass:license.class.name, editable:editable, referer:'Y']}"
                                      onclick="return confirm('Delete the property ${prop.type.name}?')"
                                      class="btn-floating table-action">
                                    <i class="material-icons">delete_forever</i>
                                  </g:link>
                                </td>
                                <td></td>
                              </g:if>
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
                <div id="organisation-links" class="tab-content">
                  <!--***tab card section***-->
                  <div class="row table-responsive-scroll">
                    <table class="highlight bordered">
                      <thead>
                        <tr>
                          <th data-field="organisation">Organisation</th>
                          <th data-field="role">Role</th>
                          <th data-field="actions">Actions</th>
                          <th>
                            <g:if test="${editable}">
                              <a href="#kbmodal" reload="true" ajax-url="${createLink(controller:'ajax', action:'getAddOrgLinkView', params:[linkType:license?.class?.name, domainid:license?.id, property:'orgLinks', recip_prop:'lic', theme:'licences'])}" class="modalButton waves-effect waves-light btn"><i class="material-icons right" style="color: #fff;">add_circle_outline</i>Add Organisation</a>
                            </g:if>
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <g:if test="${license?.orgLinks}">
                          <g:each in="${license?.orgLinks}" var="role">
                            <tr>
                              <g:if test="${role.org}">
                                <td>${role?.org?.name}</td>
                                <td>${role?.roleType?.value}</td>
                                <td>
                                  <g:if test="${editable}">
                                  <!--<a href="" class="table-action"><i class="material-icons">create</i></a>-->
                                    <g:link controller="ajax" action="delOrgRole" id="${role.id}" onclick="return confirm('Really delete this org link?')" class="btn-floating table-action"><i class="material-icons">delete_forever</i></g:link>
                                  </g:if>
                                </td>
                                <td></td>
                              </g:if>
                              <g:else>
                                <td colspan="4">Error - Role link without org ${role.id} Please report to support</td>
                              </g:else>
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
              </div>
            </div>
          </div>

          <!-- this is commented out until the users realise they need it putting back in
          <div class="row">
            <div class="col s12 l6">
              <div class="card jisc_card large white">
                <div class="card-content text-navy card-center">
                  <p class="card-title">Licence Action</p>
                  <div class="center-row">
                    <g:if test="${canCopyOrgs}">
                      <div class="row">
                        <div class="input-field col s9">
                          <g:select from="${canCopyOrgs}" optionValue="name" optionKey="shortcode" id="orgShortcode" name="orgShortcode" noSelection="['':'Choose your option']"/>
                          <label>Copy Licence for</label>
                        </div>
                        <div class="col s3">
                          <g:link name="copyLicenceBtn" controller="myInstitutions" action="actionLicenses" params="${licdetails_sc_params+[baselicense:license.id,'cpy-licence':'Y']}" onclick="return changeLink(this,'Are you sure you want to copy this licence?')" class="waves-effect waves-light btn right"><i class="material-icons right">content_copy</i>Copy</g:link>
                        </div>
                      </div>

                      <div class="row">
                        <g:form id="linkSubscription" name="linkSubscription" action="linkToSubscription">
                          <input type="hidden" name="licence" value="${license.id}"/>
                          <input type="hidden" name="defaultInstShortcode" value="${params.defaultInstShortcode}"/>
                          <div class="input-field col s9">
                            <g:select optionKey="id" optionValue="name" from="${availableSubs}" name="subscription"/>
                            <label>Link to subscription</label>
                          </div>
                          <div class="col s3">
                            <button type="submit" class="waves-effect waves-light btn right"><i class="material-icons right">link</i>Link</button>
                          </div>
                        </g:form>
                      </div>
                          </g:if>
                              <g:else>
                                Actions available to editors only
                              </g:else>
                  </div>
                </div>
              </div>
            </div>
          </div>
          -->
        </div>
        <!--tab section end-->

        <!--***tab Details content start***-->
        <div id="details" class="tab-content">

            <div class="row">
              <div class="col s12 m6 l3">
                <div class="card-panel">
                  <p class="card-title">Jisc License Id</p>
                  <p class="card-caption">${license.jiscLicenseId?:'None'}</p>
                </div>
              </div>
              <div class="col s12 m6 l3">
                <div class="card-panel">
                  <div class="launch-out">
                    <a href="#kbmodal" ajax-url="${createLink(controller:'licenseDetails', action:'todo_history', params:licdetails_sc_params, id:params.id)}" class="btn-floating bordered modalButton"><i class="material-icons">open_in_new</i></a>
                  </div>
                  <p class="card-title">Change History</p>
                  <p class="card-caption">You have <span>${todoHistoryLinesTotal}</span> changes made</p>
                </div>
              </div>
              <div class="col s12 l6">
                <div class="card-panel">
                  <div class="launch-out">
`                    <a ajax-url="${createLink(controller:'licenseDetails', action:'edit_history', params:licdetails_sc_params, id:params.id)}" class="btn-floating bordered modalButton" href="#kbmodal"><i class="material-icons">open_in_new</i></a>
                  </div>
                  <p class="card-title">Edit History</p>
                  <p class="card-caption">You have <span>${historyLinesTotal}</span> events</p>
                </div>
              </div>

              <div class="col s12 m6 l3">
                <div class="card-panel">
                  <p class="card-title">Licence URL</p>
                  <p class="card-caption truncate">
                                <g:if test="${license.licenseUrl}">
                                  <a href="${license.licenseUrl}" target="_blank">${license.licenseUrl}</a>
                                </g:if>
                                <g:else>
                                  None
                                </g:else>
                  </p>
                </div>
              </div>

              <div class="col s12 m6 l3">
                <div class="card-panel">
                  <p class="card-title">Licencee Ref</p>
                  <p class="card-caption">${license.licenseeRef?:'None'}</p>
                </div>
              </div>

              <div class="col s12 m6 l3">
                <div class="card-panel">
                  <p class="card-title">Licensor Ref</p>
                  <p class="card-caption">${license.licensorRef?:'None'}</p>
                </div>
              </div>

              <div class="col s12 m6 l3">
                <div class="card-panel">
                  <p class="card-title">Licence Contact</p>
                  <p class="card-caption">${license.contact?:'None'}</p>
                </div>
              </div>

              <div class="col s12 m6 l3">
                <div class="card-panel">
                  <p class="card-title">Licence Category</p>
                  <p class="card-caption">${license.licenseCategory?:'None'}</p>
                </div>
              </div>

              <div class="col s12 m6 l3">
                <div class="card-panel">
                  <p class="card-title">ONIX-PL Licence</p>

                    <g:if test="${license.onixplLicense}">
                      <g:if test="${editable}">
                        <g:link class="btn simple-btn right spaceleft10" controller="licenseDetails" action="unlinkLicense" params="${[license_id: license.id, opl_id: license.onixplLicense.id]+licdetails_sc_params}"><i class="material-icons left">link</i> Unlink</g:link>
                      </g:if>
                      <p class="card-caption truncate">
                        <g:link controller="onixplLicenseDetails" action="index" id="${license.onixplLicense?.id}">${license.onixplLicense.title ?: 'ONIX License without Title'}</g:link>
                      </p>
                    </g:if>
                    <g:else>
                      <sec:ifAnyGranted roles="ROLE_ADMIN">
                        <g:link class="btn btn-warning" controller="licenseImport" action="doImport" params="${[license_id: license.id]+licdetails_sc_params}">Import an ONIX-PL licence</g:link>
                      </sec:ifAnyGranted>
                    </g:else>

                </div>
              </div>

              <div class="col s12 m6 l3">
                <div class="card-panel">
                  <p class="card-title">Incoming Licence Links</p>
                  <g:if test="${license?.incomingLinks}">
                    <g:each in="${license?.incomingLinks}" var="il">
                      <g:if test="${il.isSlaved?.value=='Yes'}">
                        <span class="card-response right label default"><i class="material-icons">loop</i>Auto</span>
                      </g:if>
                      <g:else>
                        <span class="card-response right label default"><i class="material-icons">build</i>Manual</span>
                      </g:else>
                    </g:each>
                  </g:if>
                  <p class="card-caption truncate">
                    <g:if test="${license?.incomingLinks}">
                      <g:each in="${license?.incomingLinks}" var="il">
                        <g:link controller="licenseDetails" action="index" id="${il.fromLic.id}" params="${licdetails_sc_params}">${il.fromLic.reference ?: 'Linked Licence (No reference)'}</g:link>
                      </g:each>
                    </g:if>
                    <g:else>
                      None
                    </g:else>
                  </p>
                </div>
              </div>

              <div class="col s12 m6 l3">
                <div class="card-panel">
                  <p class="card-title">Licence Type</p>
                  <p class="card-caption">${license.type?.value} Licence</p>
                </div>
              </div>
            </div>

            <!--***tabular data***-->
            <div class="row">
              <div class="col s12">
                <div class="tab-table z-depth-1">
                  <ul class="tabs jisc_content_tabs">
                    <li class="tab"><a href="#user-permissions" >Logged in user permissions</a></li>
                            <li class="tab"><a href="#granted-permissions" >Granted permissions from this licence</a></li>
                  </ul>

                  <!--***table***-->
                  <div id="user-permissions" class="tab-content">

                    <!--***tab card section***-->
                    <div class="row table-responsive-scroll">
                      <table class="highlight bordered">
                        <thead>
                          <tr>
                            <th>Affiliated via Role</th>
                            <th>Permissions</th>
                          </tr>
                        </thead>
                        <tbody>
                          <g:if test="${user.affiliations}">
                            <g:each in="${user.affiliations}" var="ol">
                              <g:if test="${((ol.status==1) || (ol.status==3))}">
                                <tr>
                                  <td>Affiliated to ${ol.org?.name} with role <g:message code="cv.roles.${ol.formalRole?.authority}"/></td>
                                  <td>
                                    <g:each in="${ol.formalRole.grantedPermissions}" var="gp">
                                      <g:if test="${gp.perm.code == 'edit'}">
                                        <a class="btn-floating table-action"><i class="material-icons">create</i></a>
                                      </g:if>

                                      <g:if test="${gp.perm.code == 'view'}">
                                        <a class="btn-floating table-action"><i class="material-icons">visibility</i></a>
                                      </g:if>
                                    </g:each>
                                  </td>
                                </tr>
                                <g:each in="${ol.org.outgoingCombos}" var="oc">
                                  <tr>
                                    <td> --&gt; This org is related to ${oc.toOrg.name} ( ${oc.type.value} )</td>
                                    <td>
                                      <g:each in="${oc.type.sharedPermissions}" var="gp">
                                        <g:if test="${gp.perm.code == 'edit'}">
                                          <a class="btn-floating table-action"><i class="material-icons">create</i></a>
                                        </g:if>

                                        <g:if test="${gp.perm.code == 'view'}">
                                          <a class="btn-floating table-action"><i class="material-icons">visibility</i></a>
                                        </g:if>
                                      </g:each>
                                    </td>
                                  </tr>
                                </g:each>
                              </g:if>
                            </g:each>
                          </g:if>
                          <g:else>
                            <tr><td colspan="2">No Data Currently Added</td></tr>
                          </g:else>
                        </tbody>
                      </table>
                    </div>
                  </div>
                  <!--***table end***-->

                  <!--***table***-->
                  <div id="granted-permissions" class="tab-content">
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
                          <g:if test="${license.orgLinks}">
                            <g:each in="${license.orgLinks}" var="ol">
                              <tr>
                                <td>${ol.org.name}</td>
                                <td>${ol.roleType?.value?:''}</td>
                                <td>
                                  <g:each in="${ol.roleType?.sharedPermissions}" var="sp">
                                    <g:if test="${license.checkPermissions(sp.perm.code,user)}">
                                      <g:if test="${sp.perm.code == 'edit'}">
                                        <a class="btn-floating table-action"><i class="material-icons">create</i></a>
                                      </g:if>

                                      <g:if test="${sp.perm.code == 'view'}">
                                        <a class="btn-floating table-action"><i class="material-icons">visibility</i></a>
                                      </g:if>
                                    </g:if>
                                          </g:each>
                                </td>
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

                </div>
                <!--***tabular data end***-->

              </div>
            </div>
            <!--***tab Details content end***-->

          </div>
          <!--tab section end-->
        </div>
      </div>
    </div>
  </body>
</html>
