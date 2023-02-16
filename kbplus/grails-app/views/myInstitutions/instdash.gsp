<!doctype html>
<html lang="en" class="no-js">
<head>
  <parameter name="pagetitle" value="Dashboard" />
  <parameter name="pagestyle" value="Dashboard" />
  <parameter name="actionrow" value="dashboard" />
  <meta name="layout" content="base"/>
</head>
<body class="profile">

  <g:set var="usaf" value="${user.authorizedOrgs}" />

  <div class="row">
    <div class="col s12 hide-on-large-only" id="sizewarning">
      <div class="col s12">
        <div class="row strip-table z-depth-1 blue lighten-1">
          <div class="actions-container">
            <a class="btn-floating right white-text" id="removesizewarning"><i class="material-icons white-text">delete_forever</i></a>
          </div>
          <div class="col m11 section">
            <div class="col s12 title white-text">
              Please be aware that your browser window is smaller than the minimum size required for using KB+ (1024 pixels across and smaller). KB+ will work on your screen, but some advanced editing functions will be unavailable
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>

  <div class="row">
    <div class="col s12 m12 l4">
      <!-- Column 1 -->

      <!-- Change institution panel - only show if user is a member of >1 org -->
      <g:if test="${usaf?.size()>1}">
        <div class="col s12">
          <div class="card-panel clearfix">
            <p class="card-title" data-kb-message-code="dash.instsel.title"><g:message code="dash.instsel.title" /></p>
            <p class="" data-kb-message-code="dash.instsel.brief"><g:message code="dash.instsel.brief" /></p>
            <div class="input-field">
              <select name="changeDefaultInst" id="changeDefaultInst">
                <g:each in="${usaf}" var="org">
                  <option value="${createLink(controller:'myInstitutions', action:'instdash', params:['defaultInstShortcode':org.shortcode])}" ${org.shortcode==params.defaultInstShortcode?'selected':''}>${org.name}</option>
                </g:each>
              </select>
            </div>
          </div>
        </div>
      </g:if>

      <g:if test="${(features != null) && ( features.contains('EXPORT') ) }"> 
        <div class="col s12">
          <div class="card-panel clearfix">
            <p class="card-title" data-kb-message-code="dash.export.title"><g:message code="dash.export.title" /></p>
            <p class="" data-kb-message-code="dash.export.brief"><g:message code="dash.export.brief" /></p>
          </div>
        </div>
      </g:if>

      <!-- Search panel -->
      <div class="col s12">
        <div class="card-panel clearfix">
          <div class="launch-out">
            <a class="btn-floating"><i class="material-icons tooltipped card-tooltip" data-position="right" data-src="search-ref-id" >error_outline</i></a>
          </div>
          <p class="card-title"><span data-kb-message-code="instdash.searchprompt"><g:message code="instdash.searchprompt" /></span></p>
          <p data-kb-message-code="instdash.searchdesc"><g:message code="instdash.searchdesc" /></p>
          <g:form action="search" controller="myInstitutions" params="${[defaultInstShortcode:params.defaultInstShortcode]}" method="get">
            <input type="hidden" name="all" value="yes">
            <div class="input-field search-main">
                    <input name="q" id="search-all" placeholder="Enter your search term..." type="search" required>
                    <label class="label-icon" for="search-all"><i class="material-icons">search</i></label>
                    <i class="material-icons close" id="clearSearch" search-id="search-all">close</i>
            </div>
          </g:form>
          <script type="text/html" id="search-ref-id">
            <div class="kb-tooltip">
              <div class="tooltip-title">Search</div>
              <ul class="tooltip-list">
                <li>Search your titles, subscriptions, identifiers, licences and associated packages and platforms.</li>
              </ul>
            </div>
          </script>
        </div>
      </div>


      <!-- Col 1 panel 4 -->
      <div class="col s12 hide-on-med-and-down">
        <div class="card-panel xsmall clearfix tile">
            <p class="card-title"><g:link controller="myInstitutions" action="currentTitles" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Titles</g:link></p>
            <a href="#"><span>You currently have ${titcount} active titles</span></a>
            <div class="action-set text">
              <a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'exportCurrentTitlesModal', params:params)}" class="modalButton"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Export a list of your titles in a spreadsheet">file_download</i><p>Export</p></a>
          </div>
        </div>
      </div>

		<div class="col s12 hide-on-med-and-down">
			<div class="card-panel xsmall clearfix pacs">
				<p class="card-title"><g:link controller="packageDetails" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Packages</g:link></p>
				<a href="#">There currently are ${pkgcount} active packages</a>
				<div class="action-set text">
					<a href="#kbmodal" ajax-url="${createLink(controller:'packageDetails', action:'compareModal', params:[defaultInstShortcode:params.defaultInstShortcode])}" class="modalButton"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Compare packages in the knowledge base">layers</i><p>Compare</p></a>
				</div>
			</div>
		</div>
  </div>

    <!-- Column 2 -->
    <div class="col s12 m12 l4">

      <!-- Column 2 Panel 1 -->
      <div class="col s12">
        <div class="card-panel clearfix subs">
            <p class="card-title"><g:link controller="myInstitutions" action="currentSubscriptions" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Subscriptions</g:link></p>
            <a href="#">You currently have ${subcount} Subscriptions associated</a>
            <div class="action-set text">
              <a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'emptySubscription', params:[defaultInstShortcode:institution.shortcode])}" class="modalButton"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Add a subscription in your account">add_circle_outline</i><p>Add</p></a>
              <a href="#kbmodal" ajax-url="${createLink(controller:'subscriptionDetails', action:'compareModal', params:[defaultInstShortcode:institution.shortcode])}" class="modalButton"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Compare your subscriptions">layers</i><p>Compare</p></a>
            </div>
        </div>
      </div>

      <!-- Recently edited subscriptions panel -->
      <div class="col s12">
        <div class="card jisc_card small white">
          <div class="card-content text-navy">
            <span class="card-title"><g:link controller="myInstitutions" action="currentSubscriptions" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Recently edited Subscriptions</g:link></span>
            <div class="card-detail no-card-action full">
              <ul class="collection with-actions">
                <g:each in="${recentlyEditedSubscriptions}" var="res">
                  <li class="collection-item">
                    <div class="col s12">
                      <g:link controller="subscriptionDetails" action="index" params="${[defaultInstShortcode:params.defaultInstShortcode]}" id="${res.id}" class="no-js"><g:if test="${res.name}">${res.name}</g:if><g:else>-- Name Not Set --</g:else>
                      <i class="date">Last edited: <g:formatDate format="yyyy-MM-dd" date="${res.lastUpdated}"/></i></g:link>
                    </div>
                  </li>
                </g:each>
              </ul>
            </div>
          </div>
        </div>
      </div> <!-- End recently edited subscriptions panel -->

      <!-- Pending changes panel -->
      <div class="col s12">
        <div class="card jisc_card small white">
          <div class="card-content text-navy">
            <span class="card-title"><g:link controller="myInstitutions" action="todo" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Pending Changes (${todos.size()})</g:link></span>
            <div class="card-detail no-card-action full">
              <ul class="collection with-actions">
                <g:each in="${todos}" var="todo">
                  <li class="collection-item">
                    <div class="col s10">
                      <ul>
                        <li>
                            <g:if test="${todo.item_with_changes instanceof com.k_int.kbplus.Subscription}">
                              <a href="${createLink(controller:'subscriptionDetails', action:'index', id:todo.item_with_changes.id, params:[defaultInstShortcode:institution.shortcode])}?#pendingchanges">${todo.item_with_changes.toString()}</a>
                            </g:if>
                            <g:else>
                              <a href="${createLink(controller:'licenseDetails', action:'index', id:todo.item_with_changes.id, params:[defaultInstShortcode:institution.shortcode])}?#pendingchanges">${todo.item_with_changes.toString()}</a>
                            </g:else>
                        </li>
                        <li>Changes between <g:formatDate date="${todo.earliest}" format="yyyy-MM-dd hh:mm a"/></span> and <g:formatDate date="${todo.latest}" format="yyyy-MM-dd hh:mm a"/></li>
                        <li>Total changes <span class="inline-badge">${todo.num_changes}</span> </li>
                      </ul>
                    </div>
                    <!--
                    <div class="col s2">
                      <a href="#!" class="bordered right"><i class="material-icons">done_all</i></a>
                    </div>
                    -->
                  </li>
                </g:each>
              </ul>
            </div>
          </div>
        </div>
      </div><!-- End pending changes panel -->

      <!-- Announcements-->
      <div class="col s12">
        <div class="card jisc_card small white">
          <div class="card-content text-navy">
            <span class="card-title"><g:link controller="myInstitutions" action="announcements" params="${[defaultInstShortcode:institution.shortcode]}">Announcement (${recentAnnouncements?.size()})</g:link></span>
            <div class="card-detail no-card-action full">
              <ul class="collection with-actions">
                <g:each in="${recentAnnouncements}" var="ann">
                  <li class="collection-item">
                    <div class="col s10">
                      <p>${raw(ann.title)}</p>
                      <ul>
                        <li>${raw(ann.content)}</li>
                        <li>Posted by <em><g:link controller="userDetails" action="pub" id="${ann.user?.id}">${ann.user?.displayName}</g:link></em> on <g:formatDate date="${ann.dateCreated}" format="yyyy-MM-dd hh:mm a"/></li>
                      </ul>
                    </div>
                    <!--
                    <div class="col s2">
                      <a href="#!" class="right"><i class="material-icons">delete_forever</i></a>
                    </div>
                    -->
                  </li>
                </g:each>
              </ul>
            </div>
          </div>
        </div>
      </div> <!-- End announcements panel -->

    </div>

    <!-- Column 3 -->
    <div class="col s12 m12 l4">

      <!-- Licenses Panel -->
      <div class="col s12">
        <div class="card-panel clearfix lice">
            <p class="card-title"><g:link controller="myInstitutions" action="currentLicenses" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Licences</g:link></p>
            <a href="#">You currently have ${liccount} active Licences</a>
            <div class="action-set text">
              <a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'addLicenceModal', params:params)}" class="modalButton"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Add a licence in your account">add_circle_outline</i><p>Add</p></a>
              <a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'exportCurrentLicencesModal', params:params)}" class="modalButton"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Export your licence data in a spreadsheet">file_download</i><p>Export</p></a>
              <a href="#kbmodal" ajax-url="${createLink(controller:'licenceCompare', action:'index', params:params)}" class="modalButton"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Compare your licences' key properties">layers</i><p>Compare</p></a>
          </div>
        </div>
      </div><!-- End Licenses Panel -->

      <!-- Recently edited licenses panel -->
      <div class="col s12">
        <div class="card jisc_card small white">
          <div class="card-content text-navy">
            <span class="card-title"><g:link controller="myInstitutions" action="currentLicenses" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Recently edited Licenses</g:link></span>
            <div class="card-detail no-card-action full">
              <ul class="collection with-actions">
                <g:each in="${recentlyEditedLicenses}" var="rel">
                  <li class="collection-item">
                    <div class="col s12">
                      <g:link action="index" controller="licenseDetails" id="${rel.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}" class="no-js">${rel.reference?:message(code:'missingLicenseReference', default:'** No Licence Reference Set **')}
                      <i class="date">Last edited: <g:formatDate format="yyyy-MM-dd" date="${rel.lastUpdated}"/></i></g:link>
                    </div>
                  </li>
                </g:each>
              </ul>
            </div>
          </div>
        </div>
      </div> <!-- End recently edited licenses panel -->

	  <!-- upcoming renewals -->
      <div class="col s12">
        <div class="card jisc_card small white">
          <div class="card-content text-navy">
            <span class="card-title"><a href="#">Upcoming renewals (${upcomingRenewals?.size()})</a></span><!--where is this supposed to link through too?-->
            <div class="card-detail no-card-action full">
              <ul class="collection with-actions">
                <g:each in="${upcomingRenewals}" var="rensub">
                  <li class="collection-item">
                    <div class="col s10">
                      <a href="#">${rensub.name}</a>
                    </div>
                  </li>
                </g:each>
              </ul>
            </div>
          </div>
        </div>
      </div> <!-- End upcoming renewals panel -->

      <div class="col s12">
        <div class="card jisc_card small white">
          <div class="card-content text-navy">
            <span class="card-title"><a href="https://www.kbplus.ac.uk/kbplus7/signup">Help</a></span>
            <div class="card-detail no-card-action full">
              <div class="help-item">
                <p>This section helps you get around the Knowledge Base Plus site.</p>
                <p>If you have any further queries, please do not hesitate to <a href="mailto:help@jisc.ac.uk">contact the team</a>.</p>
              </div>
            </div>
          </div>
        </div>
      </div><!-- End of help card -->

	  <div class="col s12 hide-on-large-only">
        <div class="card-panel xsmall clearfix tile">
            <p class="card-title"><g:link controller="myInstitutions" action="currentTitles" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Titles</g:link></p>
            <a href="#"><span>You currently have ${titcount} active titles</span></a>
            <div class="action-set text">
                <a href="#kbmodal" ajax-url="${createLink(controller:'myInstitutions', action:'exportCurrentTitlesModal', params:params)}" class="modalButton"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Export a list of your titles in a spreadsheet">file_download</i><p>Export</p></a>
            </div>
        </div>
    </div>


    <div class="col s12 hide-on-large-only">
        <div class="card-panel xsmall clearfix pacs">
            <p class="card-title"><g:link controller="packageDetails" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Packages</g:link></p>
            <a href="#">There currently are ${pkgcount} active packages</a>
            <div class="action-set text">
                <a href="#kbmodal" ajax-url="${createLink(controller:'packageDetails', action:'compareModal', params:[defaultInstShortcode:params.defaultInstShortcode])}" class="modalButton"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Compare packages in the knowledge base">layers</i><p>Compare</p></a>
            </div>
        </div>
    </div>

    </div><!-- End of col 3 -->

  </div>
</div>

</body>
</html>
