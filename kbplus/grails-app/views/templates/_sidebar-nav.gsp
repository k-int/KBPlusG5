<%@ page import="org.springframework.web.servlet.support.RequestContextUtils as RCU"%>
<div class="jisc-left-sidebar nano">

  <ul class="sidebar-elements nano-content">
      <li class="parent ${pageProperty(name: 'page.pagestyle')=='Dashboard'?'active':''} default">
          <g:link controller="home" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">
              <i class="icon icon-home"></i>
              <span data-kb-message-code="mainmenu.dashboard"><g:message code="mainmenu.dashboard" /></span>
          </g:link>
      </li>

     <sec:ifLoggedIn>
        <!-- user prop is set by grails-app/controllers/kbplus/PreferencesInterceptor.groovy -->
        <g:if test="${user}">
            <g:set var="usaf" value="${user.authorizedOrgs}" />
            <!-- Only show the menu if the user is a member of more than one organisation -->
            <g:if test="${usaf.size() > 1}">
                <li class="parent default ${pageProperty(name: 'page.pagestyle')=='institution'?'active':''}">
                    <a href="#">
                        <i class="icon icon-institution "></i>
                        <span data-kb-message-code="mainmenu.institution"><g:message code="mainmenu.institution" /></span>
                    </a>
                    <ul class="sub-menu"><li class="title"><i class="icon icon-institution"></i>Institution</li>
                        <li class="nav-items nano">
                            <div class="content nano-content">
                                <ul>
                                    <g:if test="${usaf && usaf.size() > 0}">
                                        <g:each in="${usaf}" var="org">
                                            <li><g:link controller="myInstitutions"
                                                        action="instdash"
                                                        params="${[defaultInstShortcode:org.shortcode]}">${org.name}</g:link></li>

                                        </g:each>
                                    </g:if>
                                </ul>
                            </div>
                        </li>
                    </ul>
                </li>
            </g:if>
        </g:if>


      <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_KBPLUS_EDITOR">

      <li class="parent default ${pageProperty(name: 'page.pagestyle')=='data-manager'?'active':''}">
          <a href="#">
              <i class="icon icon-datamanager"></i>
              <span>Data Manager</span>
          </a>
          <ul class="sub-menu"><li class="title"><i class="icon icon-datamanager"></i>Data Manager</li>
            <li class="nav-items nano">
              <div class="content nano-content">
                  <ul>
                      <li><g:link controller="upload2" action="uploadPackageFile" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Upload Package</g:link></li>
                      <li><g:link controller="upload2" action="uploadPackageFile" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode,strictmode:'off']:[strictmode:'off']}">Upload Archival Package</g:link></li>
                      <li><g:link controller="licenseImport" action="doImport" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Import ONIX+PL Licence</g:link></li>
                      <g:set var="params_dm_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode,dm:true]:[dm:true]}"/>
                      <li class="close-menu"><a href="#kbmodal" ajax-url="${createLink(controller:'titleDetails', action:'findTitleMatches', params:params_dm_sc)}" class="modalButton">New Title</a></li>
                      <li class="close-menu"><g:link controller="licenseDetails" action="create" params="${params_dm_sc}">New Licence</g:link></li>
                      <li class="close-menu"><a href="#kbmodal" ajax-url="${createLink(controller:'platform', action:'create', params:params_dm_sc)}" class="modalButton">New Platform</a></li>
                      <li class="section-rule"></li>
                      <li><g:link controller="dataManager" action="allLicenses" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Template Licences</g:link></li>
                      <li><g:link controller="dataManager" action="linkJiscLicences" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Link Jisc Licences</g:link></li>
                      <li class="section-rule"></li>
                      <li><g:link controller="packageDetails" action="list" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Search Packages</g:link></li>
                      <li><g:link controller="platform" action="list" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Search Platforms</g:link></li>
                      <li><g:link controller="tipp" action="list" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Search Tipps</g:link></li>
                      <li><g:link controller="titleDetails" action="dmIndex" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Titles</g:link></li>
                      <g:if test="${grailsApplication.config.feature?.v71 == true}">
                        <li><g:link controller="manageTitles" action="index">Manage titles</g:link></li>
                      </g:if>
                      <li class="section-rule"></li>
                      <li class="close-menu"><a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'compareModal')}" class="modalButton">Compare Subscriptions</a></li>
                      <li><g:link controller="subscriptionImport" action="generateImportWorksheet" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode, dm:true]:[dm:true]}">${message(code:'menu.institutions.sub_work')}</g:link></li>
                      <li><g:link controller="subscriptionImport" action="importSubscriptionWorksheet" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode, dm:true]:[dm:true]}">${message(code:'menu.institutions.imp_sub_work')}</g:link></li>
                      <li class="section-rule"></li>
                      <li><g:link controller="dataManager" action="coreTitlesImport" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Import Core Titles</g:link></li>
                      <li><g:link controller="dataManager" action="productImport" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Import Products</g:link></li>
                      <li class="section-rule"></li>
                      <li><g:link controller="jasperReports" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Reports</g:link></li>
                      <li><g:link controller="dataManager" action="changeLog" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Data Manager Change Log</g:link></li>
                      <li><g:link controller="simpleReporting" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">SQL Reports</g:link></li>
                      <li class="section-rule"></li>
                      <li><g:link controller="globalDataSync" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Global Data Download</g:link></li>
                      <li><g:link controller="dataManager" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Dashboard</g:link></li>
                      <li><g:link controller="announcement" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Announcements</g:link></li>
                      <li>
                        <g:link controller="dataManager" action="toggleLang">Toggle Language</g:link>
                      </li>
                      <li><g:link controller="dataManager" action="content">Content</g:link></li>
                  </ul>
              </div>
            </li>
          </ul>
      </li>
      </sec:ifAnyGranted>


      <sec:ifAnyGranted roles="ROLE_SYSADMIN">
        <li class="parent admin ${pageProperty(name: 'page.pagestyle')=='System'?'active':''}">
          <a href="#">
              <i class="icon icon-system"></i>
              <span>System</span>
          </a>
          <ul class="sub-menu">
            <li class="title"><i class="icon icon-system"></i>System</li>
            <li class="nav-items nano">
              <div class="content nano-content">
                <ul>
                  <li><g:link controller="admin" action="jobs" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Jobs</g:link></li>
                </ul>
              </div>
            </li>
          </ul>
        </li>
      </sec:ifAnyGranted>

      <sec:ifAnyGranted roles="ROLE_ADMIN">
      <li class="parent admin ${pageProperty(name: 'page.pagestyle')=='Admin'?'active':''}">
          <a href="#">
              <i class="icon icon-admin"></i>
              <span>Admin</span>
          </a>
          <ul class="sub-menu"><li class="title"><i class="icon icon-admin"></i>Admin</li>
            <li class="nav-items nano">
              <div class="content nano-content">
                  <ul>
                      <li><g:link controller="admin" action="manageContentItems" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Manage Content Items</g:link></li>
                      <li><g:link controller="organisations" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Manage Organisations</g:link> </li>
                      <li><g:link controller="admin" action="manageAffiliationRequests" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Manage Affiliation Requests</g:link></li>
                      <li><g:link controller="propertyDefinition" action="list" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Manage Custom Properties</g:link></li>
                      <li class="section-rule"></li>
                      <li><g:link controller="admin" action="forceSendNotifications" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Send Pending Notifications</g:link></li>
                      <li><g:link controller="stats" action="statsHome" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Statistics</g:link></li>
                      <li><g:link controller="userDetails" action="list" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">User Details</g:link></li>
                      <li class="section-rule"></li>
                      <li><a href="#"  class="has-sub-submenu">Batch Tasks</a>
                          <ul class="sub-sub-menu">
                              <li class="nav-items">
                                  <div class="content">
                                      <ul>
                                          <li><g:link controller="admin" action="triggerHousekeeping">Trigger House Keeping</g:link></li>
                                          <li><g:link controller="admin" action="uploadIssnL">Upload ISSN to ISSN-L File</g:link></li>
                                          <li><g:link controller="admin" action="fullReset">Full ES Index Rebuild</g:link></li>
                                          <li><g:link controller="admin" action="esIndexUpdate">Incremental ES Index Update</g:link></li>
                                          <li><g:link controller="admin" action="juspSync">Run JUSP Sync</g:link>
                                          <li><g:link controller="admin" action="dataCleanse">Data Cleanse (Nominal Platforms)</g:link>
                                          <li><g:link controller="admin" action="triggerDocstoreMigration">Trigger Docstore Migration</g:link></li>
                                      </ul>
                                  </div>
                              </li>
                          </ul>
                      </li>
                      <li>
                      	  <a href="#" class="has-sub-submenu">Tasks</a>
                          <ul class="sub-sub-menu">
                              <li class="nav-items">
                                  <div class="content">
                                      <ul>
                                          <li><g:link controller="dataManager" action="expungeDeletedTitles" onclick="return confirm('You are about to permanently delete all titles with a status of ‘Deleted’. This will also delete any TIPPs and IEs that are attached to this title. Only click OK if you are absolutely sure you wish to proceed')">Expunge Deleted Titles</g:link></li>
                                          <li><g:link controller="dataManager" action="expungeDeletedOrgs" onclick="return confirm('You are about to permanently delete all orgs with a status of ‘Deleted’. Only click OK if you are absolutely sure you wish to proceed')">Expunge Deleted Orgs</g:link></li>
                                          <li><g:link controller="dataManager" onclick="return confirm('This will only delete TIPPs that are not attached to current IEs.')" action="expungeDeletedTIPPS">Expunge Deleted TIPPS</g:link></li>
                                          <li><g:link controller="admin" action="titleMerge" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Title Merge</g:link></li>
                                          <li><g:link controller="admin" action="orgsMerge" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Organisation Merge</g:link></li>
                                          <li><g:link controller="admin" action="platformMerge" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Platform Merge</g:link></li>
                                          <li><g:link controller="admin" action="tippTransfer" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">TIPP Transfer</g:link></li>
                                          <li><g:link controller="admin" action="ieTransfer" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">IE Transfer</g:link></li>
                                          <li><g:link controller="admin" action="userMerge" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">User Merge</g:link></li>
                                          <li><g:link controller="admin" action="propertyMerge" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Property Merge</g:link></li>
                                          <li><g:link controller="admin" action="hardDeletePkgs" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Package Delete</g:link></li>
                                          <li><g:link controller="admin" action="uploadErrata" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Upload Errata</g:link></li>
                                      </ul>
                                  </div>
                              </li>
                          </ul>
                      </li>
                      <li>
                      	  <a href="#"  class="has-sub-submenu">Bulk Tasks</a>
                          <ul class="sub-sub-menu">
                              <li class="nav-items">
                                  <div class="content">
                                      <ul>
                                          <li><g:link controller="admin" action="orgsExport" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Export Organisations</g:link></li>
                                          <li><g:link controller="admin" action="orgsImport" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Import Organisations</g:link></li>
                                          <li><g:link controller="admin" action="titlesImport" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Import/Update Titles</g:link></li>
                                          <li><g:link controller="admin" action="financeImport" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Import Financial Transactions</g:link></li>
                                      </ul>
                                  </div>
                              </li>
                          </ul>
                      </li>
                      <li class="section-rule"></li>
                      <li><g:link controller="admin" action="settings" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">System Settings</g:link></li>
                      <li>
                          <a href="#"  class="has-sub-submenu">
                              <span>System Admin</span>
                          </a>
                          <ul class="sub-sub-menu">
                            <li class="nav-items">
                              <div class="content">
                                  <ul>
                                      <li><g:link controller="sysAdmin" action="appConfig" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">App Config</g:link></li>
                                      <li><g:link controller="sysAdmin" action="appInfo" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">App Info</g:link></li>
                                  </ul>
                              </div>
                            </li>
                          </ul>
                      </li>
                      <li><g:link controller="admin" action="globalSync" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Start Global Sync</g:link></li>
                      <li><g:link controller="admin" action="manageGlobalSources" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Manage Global Sources</g:link></li>
                      <li><g:link controller="jasperReports" action="uploadReport" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Upload Report Definitions</g:link></li>


                      %{--
                      <li><g:link controller="admin" action="showAffiliations">Show Affiliations</g:link></li>
                      <li><g:link controller="admin" action="allNotes">All Notes</g:link></li>
                      <li><g:link controller="admin" action="dataCleanse">Run data cleaning (Nominal Platforms)</g:link></li>
                      <li><g:link controller="admin" action="titleAugment">Run data cleaning (Title Augment)</g:link></li>
                      <li><g:link controller="admin" action="forumSync">Run Forum Sync</g:link></li>
                      --}%




                  </ul>
              </div>
            </li>
          </ul>
      </li>
      </sec:ifAnyGranted>

        <li class="parent licences ${pageProperty(name: 'page.pagestyle')=='Licences'?'active':''}">
            <a href="#">
                <i class="icon icon-licences"></i>
                <span>Licences</span>
            </a>
            <ul class="sub-menu"><li class="title"><i class="icon icon-licences"></i>Licences</li>
                <li class="nav-items nano">
                    <div class="content nano-content">
                        <ul>
                            <g:if test="${params.defaultInstShortcode != null}">
                                <li class="section-search">
                                    <g:form action="currentLicenses" params="${[defaultInstShortcode:params.defaultInstShortcode]}" controller="myInstitutions" method="get">
                                        <div class="input-field search-main">
                                            <input id="search-current-lic-sidenav" name="keyword-search" placeholder="Enter your search term..." autocomplete="off" type="search">
                                            <label class="label-icon" for="search-current-lic-sidenav"><i class="material-icons">search</i></label>
                                            <i class="material-icons menu-search-close close" id="clearSearchSideNav" search-id="search-current-lic-sidenav">close</i>
                                        </div>
                                    </g:form>
                                </li>
                                <li class="section-rule"></li>
                                <li><g:link controller="myInstitutions" action="currentLicenses" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Your licences</g:link></li>
                                <g:if test="${request.user && request.institution && request.user.checkUserHasRole(request.institution, 'INST_ADM')}">
                                  <li class="close-menu"><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'addLicenceModal', params:params)}" class="modalButton">Add licences</a></li>
                                </g:if>
                                <li class="close-menu"><a href="#kbmodal" ajax-url="${createLink(controller:'licenceCompare', action:'index', params:[defaultInstShortcode:params.defaultInstShortcode])}" class="modalButton">Compare your licences</a></li>
                                <li class="close-menu"><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'exportCurrentLicencesModal', params:[defaultInstShortcode:params.defaultInstShortcode])}" class="modalButton">Export your licences</a></li>
                            </g:if>
                            <li class="section-rule"></li>
                            <li class="close-menu">
                                <g:if test="${params.defaultInstShortcode}">
                                    <a href="#kbmodal" ajax-url="${createLink(controller:'onixplLicenseCompare', action:'index', params:[defaultInstShortcode:params.defaultInstShortcode])}" class="modalButton">
                                </g:if>
                                <g:else>
                                    <a href="#kbmodal" ajax-url="${createLink(controller:'onixplLicenseCompare', action:'index')}" class="modalButton">
                                </g:else>
                                Licence comparison tool (ONIX-PL)</a>
                            </li>
                            <!--
                      <li><a href="#"><i class="material-icons left">border_color</i>Edit Licences</a></li>
                      <li><a href="#"><i class="material-icons left">mode_edit</i>Batch Edit Licences</a></li>
                      -->
                        </ul>
                    </div>
                </li>
            </ul>
        </li>

      <!-- Subscriptions menu only available in the context of a specific institution, so only show if we got a ${defaultInstShortcode} from the UrlMapping -->
      <g:if test="${params.defaultInstShortcode != null}">
        <li class="parent  subscriptions ${pageProperty(name: 'page.pagestyle')=='subscriptions'?'active':''}">
            <a href="#">
                <i class="icon icon-subscriptions"></i>
                <span>Subscriptions</span>
            </a>
            <ul class="sub-menu"><li class="title"><i class="icon icon-subscriptions"></i>Subscriptions</li>
              <li class="nav-items nano">
                <div class="content nano-content">
                    <ul>
                        <li class="section-search">


                            <g:form action="currentSubscriptions" params="${[defaultInstShortcode:params.defaultInstShortcode]}" controller="myInstitutions" method="get">
                                <div class="input-field search-main">
                                      <input id="search-cs-sidenav" placeholder="Enter your search term..." autocomplete="off" type="search" name="q">
                                      <label class="label-icon" for="search-cs-sidenav"><i class="material-icons">search</i></label>
                                      <i class="material-icons menu-search-close close" id="clearSearchSideNav" search-id="search-cs-sidenav">close</i>
                                </div>
                            </g:form>


                        </li>
                        <li class="section-rule"></li>

                        <li><g:link controller="myInstitutions"
                                    action="currentSubscriptions"
                                    params="${[defaultInstShortcode:params.defaultInstShortcode]}">${message(code:'menu.institutions.subs')}</g:link></li>

                        <li class="section-rule"></li>
                        <g:if test="${request.user && request.institution && request.user.checkUserHasRole(request.institution, 'INST_ADM')}">
                        	<li class="close-menu"><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'emptySubscription', params:[defaultInstShortcode:params.defaultInstShortcode])}" class="modalButton">${message(code:'menu.institutions.emptySubscription')}</a></li>
                        </g:if>
                        <li class="close-menu"><a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'compareModal', params:[defaultInstShortcode:params.defaultInstShortcode])}" class="modalButton">${message(code:'menu.institutions.comp_sub')}</a></li>
                    	<li class="section-rule"></li>
                    	<li><g:link controller="subscriptionImport" action="generateImportWorksheet" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${message(code:'menu.institutions.sub_work')}</g:link></li>
                    	<li><g:link controller="subscriptionImport" action="importSubscriptionWorksheet" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${message(code:'menu.institutions.imp_sub_work')}</g:link></li>
                    	<li class="section-rule"></li>
                    	<li><g:link controller="myInstitutions" action="renewalsSearch" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Create renewals worksheet</g:link></li>
                    	<li><g:link controller="myInstitutions" action="renewalsUpload" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Import renewals worksheet</g:link></li>
                    </ul>
                </div>
              </li>
            </ul>
        </li>
      </g:if>

      <li class="parent titles ${pageProperty(name: 'page.pagestyle')=='Titles'?'active':''}">
          <a href="#">
              <i class="icon icon-titles"></i>
              <span>Titles</span>
          </a>
          <ul class="sub-menu"><li class="title"><i class="icon icon-titles"></i>Titles</li>
            <li class="nav-items nano">
              <div class="content nano-content">
                  <ul>
                      <g:if test="${params.defaultInstShortcode}">
	                      <li class="section-search">
	                          <g:form action="currentTitles" params="${[defaultInstShortcode:params.defaultInstShortcode]}" controller="myInstitutions" method="get">
	                            <div class="input-field search-main">
	                              <input id="search-current-titles-sidenav" name="filter" placeholder="Enter your search term..." autocomplete="off" type="search">
	                              <label class="label-icon" for="search-current-titles-sidenav"><i class="material-icons">search</i></label>
	                              <i class="material-icons menu-search-close close" id="clearSearchSideNav" search-id="search-current-titles-sidenav">close</i>
	                            </div>
	                          </g:form>
	                      </li>
	                  </g:if>
	                  <g:else>
	                      <li class="section-search">
	                          <g:form action="index" controller="titleDetails" method="get">
	                            <div class="input-field search-main">
	                              <input id="search-all-titles-sidenav" name="q" placeholder="Enter your search term..." autocomplete="off" type="search">
	                              <label class="label-icon" for="search-all-titles-sidenav"><i class="material-icons">search</i></label>
	                              <i class="material-icons menu-search-close close" id="clearSearchSideNav" search-id="search-all-titles-sidenav">close</i>
	                            </div>
	                          </g:form>
	                      </li>
	                  </g:else>
                      <li class="section-rule"></li>
                      <g:if test="${params.defaultInstShortcode}">
                        <li><g:link controller="myInstitutions" action="currentTitles" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Your titles</g:link></li>
                      </g:if>
                      <g:if test="${grailsApplication.config.feature?.v71 == true}">
                      <li><g:link controller="manageTitles" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Manage titles</g:link></li>
                      </g:if>
                      <li><g:link controller="titleDetails" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">All titles</g:link></li>
                      <g:if test="${params.defaultInstShortcode}">
                      	<li class="close-menu"><a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'exportCurrentTitlesModal', params:params)}" class="modalButton">Export your titles</a></li>
                      	<li class="section-rule"></li>
                        <li><g:link controller="myInstitutions" action="tipview" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Your core titles</g:link></li>
                        <g:if test="${grailsApplication.config.feature?.v72 == true}">
                       	  <li class="section-rule"></li>
                          <li><g:link controller="myInstitutions" action="uploadUsageData" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Upload Usage Data</g:link></li>
                        </g:if>
                      </g:if>
                  </ul>
              </div>
            </li>
          </ul>
	  </li>
      

      
      <li class="parent packages ${pageProperty(name: 'page.pagestyle')=='Packages'?'active':''}">
          <a href="#">
              <i class="icon icon-packages"></i>
              <span>Packages</span>
          </a>
          <ul class="sub-menu"><li class="title"><i class="icon icon-packages"></i>Packages</li>
            <li class="nav-items nano">
              <div class="content nano-content">
                  <ul>
                      <li class="section-search">
                      	  <g:form action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" controller="packageDetails" method="get">
                              <div class="input-field search-main">
                                    <input id="search-pkgs-sidenav" name="q" placeholder="Enter your search term..." autocomplete="off" type="search">
                                    <label class="label-icon" for="search-pkgs-sidenav"><i class="material-icons">search</i></label>
                                    <i class="material-icons menu-search-close close" id="clearSearchSideNav" search-id="search-pkgs-sidenav">close</i>
                              </div>
                          </g:form>
                      </li>
                      <li class="section-rule"></li>
                      <!--not in current system<li><a href="#"><i class="material-icons left">flag</i>View Your Packages</a></li>-->
                      <li><g:link controller="packageDetails" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">All packages</g:link></li>
                      <g:if test="${params.defaultInstShortcode}">
                      	<li class="close-menu"><a href="#kbmodal" class="modalButton" ajax-url="${createLink(controller:'packageDetails', action:'compareModal', params:[defaultInstShortcode:params.defaultInstShortcode])}">Compare packages</a></li>
                      </g:if>
                      <g:else>
                      	<li class="close-menu"><a href="#kbmodal" class="modalButton" ajax-url="${createLink(controller:'packageDetails', action:'compareModal')}">Compare Packages</a></li>
                      </g:else>
                      <li class="section-rule"></li>
                      <!-- need to specific users to do these so commenting out until this is implemented
                      <li><a href="#">Add Packages</a></li>
                  	  <li><a href="#">Edit Packages</a></li>
                  	  <li><a href="#">Batch Edit Packages</a></li>
                  	  <li><a href="#">Export Packages</a></li>
                  	  <li><a href="#">Generate Renewals Woksheet</a></li>
                  	  <li><a href="#">Import Renewals</a></li>
                      -->
                  </ul>
              </div>
            </li>
          </ul>
      </li>
      
      <g:if test="${params.defaultInstShortcode != null}">
        <li class="parent finance ${pageProperty(name: 'page.pagestyle')=='Finance'?'active':''}">
          <a href="#">
            <i class="icon icon-finance"></i>
            <span>Finance</span>
          </a>
          <ul class="sub-menu"><li class="title"><i class="icon icon-finance"></i>Finance</li>
            <li class="nav-items nano">
              <div class="content nano-content">
                <ul>
                  <g:set var="params_fin_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
                  <li><g:link controller="finance" action="index" params="${params_fin_sc}">Cost items</g:link></li>
                  <li><a href="#kbmodal" ajax-url="${createLink(controller:'finance', action:'addCostItem', params:params_fin_sc)}" class="modalButton">Add cost item</a></li>
                </ul>
              </div>
            </li>
          </ul>
        </li>
      </g:if>

      <li class="parent default ${pageProperty(name: 'page.pagestyle')=='profile'?'active':''}">
          <a href="#">
              <i class="icon icon-profile"></i>
              <span>Profile</span>
          </a>
          <ul class="sub-menu"><li class="title"><i class="icon icon-profile"></i>Profile</li>
            <li class="nav-items nano">
              <div class="content nano-content">
                  <ul>
                      <li><g:link controller="profile" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Your Profile</g:link></li>
                      <li class="section-rule"></li>
                      <li><g:link controller="logout" action="index">Logout</g:link></li>
                      <li class="section-rule"></li>
                      <li><a href="https://www.kbplus.ac.uk/kbplus7">KB+</a></li>
                      <li><a href="https://www.kbplus.ac.uk/demo">KB+ demo</a></li>
                      <li><a href="https://www.kbplus.ac.uk/test2">KB+ sandpit</a></li>
                      <li><a href="https://jisc.researchfeedback.net/wh/s.asp?k=149424860464&u=knowledgebase">Survey</a></li>
                      <li class="section-rule"></li>
                      <li><a href="https://www.kbplus.ac.uk/kbplus7/signup">Help</a></li>
                      <g:if test="${params.defaultInstShortcode}">
                        <li><g:link controller="myInstitutions" action="todo" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Pending changes</g:link></li>
                        <li><g:link controller="myInstitutions" action="changeLog" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Change log</g:link></li>
                      </g:if>
                      <g:if test="${institution}">
                        <li><g:link controller="organisations" action="show" id="${institution.id}" params="${[defaultInstShortcode:institution.shortcode]}">Organisation Info</g:link></li>
                      </g:if>
                  </ul>
              </div>
            </li>
          </ul>
      </li>
    </sec:ifLoggedIn>
    <li class="parent hidden">
          <a href="#">
              <i class="icon icon-packages"></i>
              <span>&nbsp;</span>
          </a>
      </li>
  </ul>
</div>
