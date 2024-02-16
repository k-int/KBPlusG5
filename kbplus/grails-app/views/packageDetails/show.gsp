<!doctype html>
<html lang="en" class="no-js">
<head>
  <parameter name="pagetitle" value="Package Details" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="packages-detail" />
    <meta name="layout" content="base"/>
</head>
<body class="packages">

  <!--page title-->
  <div class="row">
       <div class="col s12 l12">
          <h1 class="page-title left">${packageInstance.name}</h1>
       </div>
       <div class="col s12 l12">
         <g:if test="${params.asAt}"><h2 class="page-subtitle">Snapshot of package as at ${params.asAt?:'Now'} </h2></g:if>
       </div>
  </div>
  <!--page title end-->
  <div class="row row-content">
    <div class="col s12 m6 l3">
         <div class="card-panel">
            <p class="card-label">Start Date: <span class="card-response right"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${packageInstance.startDate}"/></span></p>
            <p class="card-label">End Date: <span class="card-response right"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${packageInstance.endDate}"/></span></p>
         </div>
         <div class="card-panel">
             <div class="launch-out">
               <g:if test="${params.defaultInstShortcode}">
                 <a ajax-url="${createLink(controller:'packageDetails', action:'expected', params:[defaultInstShortcode:params.defaultInstShortcode,id:params.id])}" class="btn-floating bordered modalButton" href="#kbmodal"><i class="material-icons">open_in_new</i></a>
               </g:if>
               <g:else>
                 <a ajax-url="${createLink(controller:'packageDetails', action:'expected', params:[id:params.id])}" class="btn-floating bordered modalButton" href="#kbmodal"><i class="material-icons">open_in_new</i></a>
               </g:else>
             </div>
             <p class="card-title">Expected Titles</p>
             <p class="card-caption">
               <g:if test="${expectedCount > 0}">
                 <span>${expectedCount}</span> number of titles
               </g:if>
               <g:else>
                 None
               </g:else>
             </p>
         </div>
    </div>
    <div class="col s12 m6 l3">
         <div class="card-panel">
          <div class="launch-out">
            <g:if test="${params.defaultInstShortcode}">
                 <a ajax-url="${createLink(controller:'packageDetails', action:'history', params:[defaultInstShortcode:params.defaultInstShortcode,id:params.id])}" class="btn-floating bordered modalButton" href="#kbmodal"><i class="material-icons">open_in_new</i></a>
               </g:if>
               <g:else>
                 <a ajax-url="${createLink(controller:'packageDetails', action:'history', params:[id:params.id])}" class="btn-floating bordered modalButton" href="#kbmodal"><i class="material-icons">open_in_new</i></a>
               </g:else>
          </div>
          <p class="card-title">Package History</p>
          <p class="card-caption"><span>${historyLinesTotal}</span> events</p>
      </div>
      <div class="card-panel">
          <div class="launch-out">
            <g:if test="${params.defaultInstShortcode}">
                 <a ajax-url="${createLink(controller:'packageDetails', action:'previous', params:[defaultInstShortcode:params.defaultInstShortcode,id:params.id])}" class="btn-floating bordered modalButton" href="#kbmodal"><i class="material-icons">open_in_new</i></a>
               </g:if>
               <g:else>
                 <a ajax-url="${createLink(controller:'packageDetails', action:'previous', params:[id:params.id])}" class="btn-floating bordered modalButton" href="#kbmodal"><i class="material-icons">open_in_new</i></a>
               </g:else>
              
          </div>
          <p class="card-title">Previous Titles</p>
          <p class="card-caption">
          <g:if test="${previousCount > 0}">
                 <span>${previousCount}</span> number of titles
               </g:if>
               <g:else>
                 None
               </g:else>
             </p>
      </div>
    </div>
    <div class="col s12 m6 l6">
        <div class="card jisc_card small white">
            <div class="card-content text-navy">
              <g:if test="${params.defaultInstShortcode}">
              <g:form action="addToSub" id="${packageInstance.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">
               <span class="card-title pack-detail">Link this package to a subscription</span>
               <div class="card-detail">
                  <div class="col s12 m12 l12 mt-10">
                     <div class="input-field mar-min">
                  <g:select name="subid"
                        id="subscription"
                        from="${subscriptionList}"
                        optionKey="${{it.sub.id}}"
                        optionValue="${{it.sub.name}}"
                        noSelection="['':'Your Subscriptions']" />
                     </div>
                  </div>
  
                  <div class="col s12 m12 l12">
                     <div class="input-field mar-min">
                         <p>
                           <input type="checkbox" id="addEntitlementsCheckbox" name="addEntitlements"/>
                           <label for="addEntitlementsCheckbox">With Entitlements</label>
                      </p>
                     </div>
                  </div>
  
                  <div class="col s12 m12 l12 mt-20">
                    <input id="add_to_sub_submit_id" type="submit" class="waves-effect waves-teal btn left mar-search" value="Submit">
                  </div>
              </div>
              </g:form>
              </g:if>
       </div>
        </div>
    </div>
    
    <!--tab section start-->
    <div class="row">
        <div class="col s12">
            <ul class="tabs jisc_tabs">
              <li class="tab col s2"><a href="#titles" class="add-anchor">Titles<i class="material-icons">chevron_right</i></a></li>
              <li class="tab col s2"><a href="#details" class="add-anchor">Details<i class="material-icons">chevron_right</i></a></li>
            </ul>
        </div>
        <!--***tab Details content start***-->
        <div id="titles" class="tab-content">
           <!-- search-section start-->
           <div class="row">
              <div class="col s12">
                <div class="search-section z-depth-1">
                    <g:form action="show" params="${params}" method="get">
                      <!--search filter -->
                      <div class="col s12">
                        <ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
                            <li>
                              <div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter</div>
                                 <div class="collapsible-body">
                                   <div class="col s6">
                                       <div class="col s6">
                                         <div class="input-field">
                                             <input id="filter" name="filter" type="text" value="${params.filter}">
                                             <label for="filter">Title</label>
                                         </div>
                                       </div>
                                       <div class="col s6">
                                         <div class="input-field">
                                             <input id="coverageNoteFilter" name="coverageNoteFilter" type="text" value="${params.coverageNoteFilter}">
                                             <label for="coverageNoteFilter">Coverage note</label>
                                         </div>
                                       </div>
                                   </div>
                                   <div class="col s6">
                                       <div class="col s4">
                                         <div class="input-field">
                                           <g:kbplusDatePicker inputid="startsBefore" name="startsBefore" value="${params.startsBefore}"/>
                                           <label class="active">Coverage Starts Before</label>
                                         </div>
                                       </div>
                                       <div class="col s4">
                                         <div class="input-field">
                                           <g:kbplusDatePicker inputid="endsAfter" name="endsAfter" value="${params.endsAfter}"/>
                                           <label class="active">Coverage Ends After</label>
                                         </div>
                                       </div>
                                       <div class="col s2">
                                         <input type="submit" class="waves-effect waves-teal btn" value="Search">
                                       </div>
                          <div class="col s2">
                            <g:if test="${params.defaultInstShortcode}">
                            <g:link controller="packageDetails" action="show" id="${params.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
                            </g:if>
                          </div>
                                   </div>
                                 </div>
                            </li>
                        </ul>
                      </div>
                      <!--search filter end -->
                    </g:form>
                </div>
              </div>
           </div>
           <!-- search-section end-->
          <!--***table data***-->
          <div class="row">
              <div class="col s12">
                <div class="tab-table z-depth-1">
                  <h1 class="table-title">This package includes <span>${num_tipp_rows}</span> titles</h1>
              <!--<h1 class="table-title">This package gives access to the following: <span>${offset + 1}</span> to <span>${offset+(titlesList?.size())}</span> of <span>${num_tipp_rows}</span> titles</h1>-->
              <g:if test="${editable}">
                <g:set var="disc" value="${[]}"/>
                <g:if test="${params.defaultInstShortcode}">
                  <g:set var="disc" value="${[defaultInstShortcode:params.defaultInstShortcode]}"/>
                </g:if>
                <a id="batchEditPackageTitles" href="#kbmodal" ajax-url="${createLink(controller:'packageDetails', action:'batchModal', id:packageInstance.id, params:disc)}" class="waves-effect waves-light btn right">Batch Action</a></th>
              </g:if>
                    <!--***table***-->
                    <div id="title">
                      <!--***tab card section***-->
                         <div class="row">
                            <table class="highlight bordered responsive-table">
                                 <thead>
                                   <tr>
                                     <g:if test="${editable}">
                                       <th>Batch</th>
                                     </g:if>
                                       <th data-field="title">Title</th>
                                       <th data-field="tip">TIPP</th>
                                       <th data-field="access">Access</th>
                                       <th data-field="platform">Platform</th>
                                       <th data-field="coveragedepth">Coverage Depth</th>
                                       <th data-field="hybridoa">Hybrid OA</th>
                                       <th data-field="identifiers">Identifiers</th>
                                       <th data-field="coverage-start">Coverage Start</th>
                                       <th data-field="coverage-end">Coverage End</th>
                                       <th data-field="note">Coverage Note</th>
                                       <th data-field="title-id">Title-Id</th>
                                       <g:if test="${editable}">
                                         <th data-field="action">Action</th>
                                       </g:if>
                                   </tr>
                                 </thead>
                                 <tbody>
                                   <g:if test="${titlesList}">
                                     <g:each in="${titlesList}" var="t">
                                       <tr>
                                         <g:if test="${editable}">
                                           <td style="vertical-align:middle;">
                                <input type="checkbox" id="_bulkflag.${t.id}" name="_bulkflag.${t.id}"/>
                                <label for="_bulkflag.${t.id}" class="align">&nbsp;</label>
                              </td>
                            </g:if>
                                           <td>
                              <g:link controller="titleDetails" action="show" id="${t.title.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${t.title.title}</g:link>
                            </td>
                                           <td><g:link controller="tipp" action="show" id="${t.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Link</g:link></td>
                                           <td>${t.availabilityStatus?.value}</td>
                                           <td>
                                             <g:if test="${t.combinedPlatformUrl != null}">
                                           <a href="${t.combinedPlatformUrl}" target="_blank">${t.platform?.name}</a>
                                         </g:if>
                                         <g:else>
                                           ${t.platform?.name}
                                         </g:else>
                                       </td>
                                           <td>${t.coverageDepth}</td>
                                           <td>${t.hybridOA?.value}</td>
                                           <td>
                                             <g:each in="${t.title.ids}" var="id">
                                          <g:if test="${id.identifier.ns.hide != true}">
                                              ${id.identifier.ns.ns}:${id.identifier.value}<br/>
                                          </g:if>
                                        </g:each>
                                      </td>
                                           <td>
                                             Date: <g:if test="${t.startDate}"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.startDate}"/></g:if><br/>
                                        Volume: ${t.startVolume}<br/>
                                        Issue: ${t.startIssue}
                                      </td>
                                           <td>
                                             Date: <g:if test="${t.endDate}"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.endDate}"/></g:if><br/>
                                         Volume: ${t.endVolume}<br/>
                                         Issue: ${t.endIssue}
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
                                             ${t?.localPackageTitleId?:''}
                                           </td>
                                           <g:if test="${editable}">
                                             <td>
                                <div class="actions-container center">
                                  <g:set var="tipp_edit_params" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
                                  <a href="#kbmodal" ajax-url="${createLink(controller:'tipp', action:'edit', id:t.id, params:tipp_edit_params)}" class="action-btn modalButton">
                                    <i class="material-icons theme-icon">create</i>
                                  </a>
                                </div>
                              </td>
                                           </g:if>
                                       </tr>
                                     </g:each>
                                   </g:if>
                                   <g:else>
                                     <tr><td colspan="${editable?'11':'9'}">No Data Currently Added</td></tr>
                                   </g:else>
                                 </tbody>
                           </table>
                       </div>
                  </div>
                    <!--***table end***-->
                </div>
                <g:if test="${titlesList && titlesList.size() > 0}" >
                     <div class="pagination">
                <g:paginate action="show" controller="packageDetails" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${num_tipp_rows}" class="showme" />
              </div>
            </g:if>
              </div>
          </div>
        </div>
          <!--tab section end-->
         <!--***tab Details content start***-->
        <div id="details" class="tab-content">
            <div class="row">
              <div class="col s12 m6 no-padding">
                <div class="row">
                     <div class="col s12">
                      <div class="row card-panel strip-table-alt z-depth-1">
                        <div class="col m12 section">
                            <div class="col m6 title">
                              Package Persistent Identifier
                            </div>
                            <div class="col m6 result">
                              uri://kbplus/${grailsApplication.config.kbplusSystemId}/package/${packageInstance?.id}
                            </div>
                        </div>
                        <div class="col m12 section">
                            <div class="col m6 title">
                               Public?
                            </div>
                            <div class="col m6 result">
                              ${packageInstance.isPublic ?: 'No'}
                            </div>
                        </div>
                        <div class="col m12 section">
                            <div class="col m6 title">
                               Licence
                            </div>
                            <div class="col m6 result">
                              <g:if test="${packageInstance.license}">
                                <g:link controller="licenseDetails" action="index" id="${packageInstance.license.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${packageInstance.license}</g:link>
                              </g:if>
                              <g:else>
                                None
                              </g:else>
                            </div>
                        </div>
                        <div class="col m12 section">
                            <div class="col m6 title">
                               Vendor URL
                            </div>
                            <div class="col m6 result">
                              ${packageInstance.vendorURL ?: 'None'}
                            </div>
                        </div>
                        <div class="col m12 section">
                            <div class="col m6 title">
                               List Status
                            </div>
                            <div class="col m6 result">
                              ${packageInstance.packageListStatus ?: 'None'}
                            </div>
                        </div>
                        <div class="col m12 section">
                            <div class="col m6 title">
                               Breakable
                            </div>
                            <div class="col m6 result">
                              ${packageInstance.breakable ?: 'None'}
                            </div>
                        </div>
                        <div class="col m12 section">
                            <div class="col m6 title">
                               Consistent
                            </div>
                            <div class="col m6 result">
                              ${packageInstance.consistent ?: 'None'}
                            </div>
                        </div>
                        <div class="col m12 section">
                            <div class="col m6 title">
                               Fixed
                            </div>
                            <div class="col m6 result">
                              ${packageInstance.fixed ?: 'None'}
                            </div>
                        </div>
                        <div class="col m12 section">
                            <div class="col m6 title">
                               Package Scope
                            </div>
                            <div class="col m6 result">
                              ${packageInstance.packageScope ?: 'None'}
                            </div>
                        </div>
                      </div>
                  </div>
                </div>
              </div>
              <div class="col s12 m6 no-padding">
                  <div class="col s12 m6">
                       <div class="card jisc_card large xlarge white">
                           <div class="card-content text-navy">
                     <div class="launch-out">
                       <g:if test="${editable}">
                         <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'addNoteView', params:[ownobjid:packageInstance.id, ownobjclass:packageInstance.class.name, owntp:'pkg', theme:'packages'])}" class="btn-floating bordered modalButton"><i class="material-icons">add_circle_outline</i></a>
                       </g:if>
                       <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'viewNotes', params:[ownobjid:packageInstance.id, ownobjclass:packageInstance.class.name, theme:'packages'])}" class="btn-floating bordered left-space modalButton"><i class="material-icons">open_in_new</i></a>
                  </div>
                  <p class="card-title">Notes</p>
                     <div class="card-detail no-card-action">
                       <ul class="collection with-actions">
                         <g:set var="hasNotes" value="${false}"/>
                           <g:each in="${packageInstance.documents}" var="docctx">
                              <g:if test="${docctx.owner.contentType == 0 && (docctx.status == null || docctx.status?.value != 'Deleted')}">
                          <li class="collection-item">
                            <div class="col s10">                                
                              <span class="note title">${docctx.owner.title}</span>
                              <span class="truncate">${docctx.owner.content}</span>
                              <p class="text-grey">Creator: ${docctx.owner.creator}</p>
                            </div>
                            <g:if test="${editable}">
                                <div class="col s2 actions-container">
                                                <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'editNoteView', id:docctx.owner.id, params:[theme:'packages'])}" class="btn-floating right modalButton"><i class="material-icons">create</i></a>
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
                  <div class="col s12 m6">
                      <div class="card jisc_card large xlarge white">
                           <div class="card-content text-navy">
                             <g:if test="${editable}">
                       <div class="launch-out">
                      <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'addDocumentView', params:[ownobjid:packageInstance.id, ownobjclass:packageInstance.class.name, owntp:'pkg', theme:'packages'])}" class="btn-floating bordered modalButton"><i class="material-icons">add_circle_outline</i></a>
                    </div>
                  </g:if>
                  <p class="card-title">Documents</p>
                     <div class="card-detail no-card-action documents">
                       <ul class="collection with-actions">
                         <g:set var="hasDocs" value="${false}"/>
                         <g:each in="${packageInstance.documents}" var="docctx">
                              <g:if test="${(((docctx.owner?.contentType == 1) || (docctx.owner?.contentType == 3)) && (docctx.status?.value != 'Deleted'))}">
                               <li class="collection-item avatar">
                                 <div class="col s10">
                                   <g:link controller="docstore" id="${docctx.owner.uuid}">
                                       <i class="material-icons circle">description</i>
                                       <span class="title">${docctx.owner.title}</span>
                                       <p class="text-grey">
                                          File name: ${docctx.owner.filename}<br>
                                          Creator: ${docctx.owner.creator}<br>
                                          Type: ${docctx.owner?.type?.value}
                                       </p>
                                     </g:link>
                            </div>
                            <g:if test="${editable}">
                                <div class="col s2 actions-container">
                                                <a href="#kbmodal" ajax-url="${createLink(controller:'docWidget', action:'editDocumentView', id:docctx.owner.id, params:[theme:'packages'])}" class="btn-floating right modalButton"><i class="material-icons">create</i></a>
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
                </div>
          </div>
            <!--***tabular data***-->
          <div class="row">
          <div class="col s12">
                <div class="tab-table z-depth-1">
                    <ul class="tabs jisc_content_tabs">
                        <li class="tab"><a href="#organisation-links">Organisation Links</a></li>
                        <li class="tab"><a href="#products">Products</a></li>
                        <li class="tab"><a href="#subscription-id">Other Identifiers</a></li>
                    </ul>
                  <!--***table***--> 
                <div id="organisation-links" class="tab-content">
                  
                <!--***tab card section***--> 
                     <div class="row">
                        <table class="highlight bordered responsive-table">
                                <thead>
                                  <tr>
                                      <th data-field="organisation">Organisation</th>
                                      <th data-field="role">Role</th>
                                      <g:if test="${editable}">
                                          <th data-field="actions">Actions</th>
                                          <th><a href="#kbmodal" ajax-url="${createLink(controller:'ajax', action:'getAddOrgLinkView', params:[linkType:packageInstance?.class?.name, domainid:packageInstance?.id, property:'orgs', recip_prop:'pkg', theme:'packages'])}" class="modalButton waves-effect waves-light btn"><i class="material-icons right" style="color: #fff;">add_circle_outline</i>Add Organisation</a></th>
                                      </g:if>
                                  </tr>
                                </thead>
        
                                <tbody>
                                  <g:if test="${packageInstance?.orgs}">
                                    <g:each in="${packageInstance?.orgs}" var="role">
                            <tr>
                              <g:if test="${role.org}">
                                <td><g:link controller="Organisations" action="show" id="${role.org.id}">${role?.org?.name}</g:link></td>
                                <td>${role?.roleType?.value}</td>
                                <g:if test="${editable}">
                                  <td>
                                    <!--<a href="" class="table-action"><i class="material-icons">create</i></a>--> 
                                    <g:link controller="ajax" action="delOrgRole" id="${role.id}" onclick="return confirm('Really delete this org link?')" class="btn-floating table-action"><i class="material-icons">delete_forever</i></g:link>
                                  </td>
                                  <td></td>
                                </g:if>
                              </g:if>
                              <g:else>
                                      <td colspan="4">Error - Role link without org ${role.id} Please report to support</td>
                                  </g:else>
                            </tr>
                          </g:each>
                        </g:if>
                        <g:else>
                          <tr><td colspan="${editable?'4':'2'}">No Data Currently Added</td></tr>
                        </g:else>
                                </tbody>
                          </table>
                        </div>
                
                </div>  
                <!--***table end***--> 
                
                <!--***table***--> 
                <div id="products" class="tab-content">
                  
                <!--***tab card section***--> 
                     <div class="row">
                        <table class="highlight bordered responsive-table">
                            <thead>
                      <tr>
                        <th data-field="prd">Product Name</th>
                        <th data-field="prdId">Product Id</th>
                        <g:if test="${editable}">
                                        <th data-field="actions">Actions</th>
                                        <th><a href="#kbmodal" ajax-url="${createLink(controller:'packageDetails', action:'getAddPrdView', params:[defaultInstShortcode:params.defaultInstShortcode,id:params.id])}" class="modalButton waves-effect waves-light btn"><i class="material-icons right" style="color: #fff;">add_circle_outline</i>Add Product</a></th>
                                    </g:if>
                      </tr>
                    </thead>
                    
                    <tbody>
                      <g:if test="${packageInstance.products}">
                        <g:each in="${packageInstance.products}" var="prod">
                          <tr>
                            <td>${prod.product.name}</td>
                            <td>${prod.product.identifier}</td>
                            <td>
                              <g:link controller="ajax" action="deleteThrough" params='${[contextOid:"${packageInstance.class.name}:${packageInstance.id}",contextProperty:"products",targetOid:"${prod.class.name}:${prod.id}"]}' class="btn-floating table-action"><i class="material-icons">delete_forever</i></g:link>
                            </td>
                            <td></td>
                          </tr>
                        </g:each>
                      </g:if>
                      <g:else>
                        <tr><td colspan="${editable?'4':'2'}">No Data Currently Added</td></tr>
                      </g:else>
                    </tbody>
                          </table>
                        </div>
                </div>  
                <!--***table end***--> 
        
                <!--***table***--> 
                  <div id="subscription-id" class="tab-content">
                    
                  <!--***tab card section***--> 
                       <div class="row">
                  <table class="highlight bordered responsive-table">
                    <thead>
                      <tr>
                        <th data-field="authority">Authority</th>
                        <th data-field="identifier">Identifier</th>
                        <th data-field="actions">Actions</th>
                      </tr>
                    </thead>
                    
                    <tbody>
                      <g:if test="${packageInstance.ids}">
                        <g:each in="${packageInstance.ids}" var="io">
                          <tr>
                            <td>${io.identifier.ns.ns}</td>
                            <td>${io.identifier.value}</td>
                            <td>
                              <!--<a href="" class="table-action"><i class="material-icons">create</i></a>--> 
                              <g:link controller="ajax" action="deleteThrough" params='${[contextOid:"${packageInstance.class.name}:${packageInstance.id}",contextProperty:"ids",targetOid:"${io.class.name}:${io.id}"]}' class="btn-floating table-action"><i class="material-icons">delete_forever</i></g:link>
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
</body>
</html>
