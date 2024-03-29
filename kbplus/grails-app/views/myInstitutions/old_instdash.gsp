<!doctype html>
<html>
  <head>
    <parameter name="pagetitle" value="${institution?.name} : Dashboard" />
    <parameter name="pagestyle" value="dashboard" />
    <meta name="layout" content="base"/>

    <title>${institution?.name} : Dashboard</title>
  </head>

  <body>

    <div class="container">
      <ul class="breadcrumb">
        <li> <g:link controller="home" action="index">Home</g:link> <span class="divider">/</span> </li>
        <li> <g:link controller="myInstitutions" action="instdash" params="${[defaultInstShortcode:params.defaultInstShortcode]}">${institution?.name} Dashboard</g:link> </li>
      </ul>
    </div>


    <div class="container home-page">
      <div class="well">
        <h1>${institution.name} Dashboard</h1>
        <ul class="inline">
          <li><h5>View:</h5></li>
          <li><g:link controller="myInstitutions" 
                                       action="currentLicenses" 
                                       params="${[defaultInstShortcode:params.defaultInstShortcode]}">Licences</g:link></li>
          <li><g:link controller="myInstitutions" 
                                       action="currentSubscriptions" 
                                       params="${[defaultInstShortcode:params.defaultInstShortcode]}">Subscriptions</g:link></li>
          <li><g:link controller="myInstitutions" 
                                       action="currentTitles" 
                                       params="${[defaultInstShortcode:params.defaultInstShortcode]}">Titles</g:link></li>
          <li><h5>Renewals:</h5></li>
          <li><g:link controller="myInstitutions" 
                                       action="renewalsSearch" 
                                       params="${[defaultInstShortcode:params.defaultInstShortcode]}">Generate Renewals Worksheet</g:link></li>
          <li><g:link controller="myInstitutions" 
                                       action="renewalsUpload" 
                                       params="${[defaultInstShortcode:params.defaultInstShortcode]}">Import Renewals</g:link></li>
          <g:if test="${grailsApplication.config.feature_finance}">
            <li><g:link controller="myInstitutions"
                                       action="finance"
                                       params="${[defaultInstShortcode:params.defaultInstShortcode]}">Finance</g:link></li>
          </g:if>
        </ul>
      </div>
    </div>

    <g:if test="${flash.message}">
      <div class="container">
        <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
      </div>
    </g:if>

    <g:if test="${flash.error}">
      <div class="container">
        <bootstrap:alert class="error-info">${flash.error}</bootstrap:alert>
      </div>
    </g:if>

    <div class="container home-page">
      <div class="row">
      	<g:if test="${zendesk_updates == 'true'}"> 
        	<div class="span4">
        </g:if>
        <g:else>
        	<div class="span6">
        </g:else>
            <table class="table table-bordered dashboard-widget">
              <thead>
                <th>
                  <h5 class="pull-left">To Do</h5>
                  <img src="${resource(dir: 'images', file: 'icon_todo.png')}" alt="To-Dos" class="pull-right" />
                </th>
              </thead>
              <tbody>
              <g:each in="${todos.sort {it.earliest}}" var="todo">
                <tr>
                  <td>
                    <div class="pull-left icon">
                      <img src="${resource(dir: 'images', file: 'icon_todo.png')}" alt="To-Dos" /><br/>
                      <span class="badge badge-warning">${todo.num_changes}</span>
                    </div>
                    <div class="pull-right message">
                      <p>
                        <g:if test="${todo.item_with_changes instanceof com.k_int.kbplus.Subscription}">
                          <g:link controller="subscriptionDetails" action="index" id="${todo.item_with_changes.id}">${todo.item_with_changes.toString()}</g:link>
                        </g:if>
                        <g:else>
                          <g:link controller="licenseDetails" action="index" id="${todo.item_with_changes.id}">${todo.item_with_changes.toString()}</g:link>
                        </g:else>
                      </p>

                      <p>Changes between <g:formatDate date="${todo.earliest}" format="yyyy-MM-dd hh:mm a"/></span> and <g:formatDate date="${todo.latest}" format="yyyy-MM-dd hh:mm a"/></p>
                    </div>
                  </td>
                </tr>
              </g:each>
                <tr>
                  <td>
                    <g:link action="todo" params="${[defaultInstShortcode:params.defaultInstShortcode]}" class="btn btn-primary pull-right">View To Do List</g:link>
                  </td>
                </tr>
              </tbody>
            </table>
        </div>
        <g:if test="${zendesk_updates == 'true'}"> 
        	<div class="span4">
        </g:if>
        <g:else>
        	<div class="span6">
        </g:else>
            <table class="table table-bordered dashboard-widget">
              <thead>
                <th>
                  <h5 class="pull-left">Announcements</h5>
                  <img src="${resource(dir: 'images', file: 'icon_announce.png')}" alt="To-Dos" class="pull-right" />
                </th>
              </thead>
              <tbody>
              <g:each in="${recentAnnouncements}" var="ra">
                <tr>
                  <td>
                    <div class="pull-left icon">
                      <img src="${resource(dir: 'images', file: 'icon_announce.png')}" alt="Annoucement" />
                    </div>
                    <div class="pull-right message">
                      <p><strong>${ra.title}</strong></p>
                      <div>
                        <span class="widget-content">${ra.content}</span>
                        <div class="see-more"><a href="">[ See More ]</a></div>
                      </div> 
                      <p>Posted by <em><g:link controller="userDetails" action="pub" id="${ra.user?.id}">${ra.user?.displayName}</g:link></em> on <g:formatDate date="${ra.dateCreated}" format="yyyy-MM-dd hh:mm a"/></p>
                    </div>
                  </td>
                </tr>
              </g:each>
                <tr>
                  <td>
                     <g:link action="announcements" params="${[defaultInstShortcode:params.defaultInstShortcode]}" class="btn btn-primary pull-right">View All Announcements</g:link>
                  </td>
                </tr>
              </tbody>
            </table>
        </div>
        <g:if test="${grailsApplication.config.ZenDeskBaseURL && zendesk_updates == 'true'}"> 
        <div class="span4">
           <table class="table table-bordered dashboard-widget">
              <thead>
                <th>
                  <h5 class="pull-left">Latest Discussions</h5>
                  <img src="${resource(dir: 'images', file: 'icon_discuss.png')}" alt="Discussions" class="pull-right" />
                </th>
              </thead>
              <tbody>
            <g:if test="${forumActivity}">
                <g:each in="${forumActivity}" var="fa">
                  <tr>
                    <td>
                      <div class="pull-left icon">
                        <img src="${resource(dir: 'images', file: 'icon_discuss.png')}" alt="Discussion" />
                      </div>
                      <div class="pull-right message">
                        <p><strong>${fa.title}</strong></p>
                        <p>
                        <g:if test="${fa.result_type=='topic'}">
                          <g:formatDate date="${fa.updated_at}" format="yyyy-MM-dd hh:mm a"/>
                          <a href="${grailsApplication.config.ZenDeskBaseURL}/entries/${fa.id}">View Topic</a>
                          <a href="${grailsApplication.config.ZenDeskBaseURL}/entries/${fa.id}" title="View Topic (new Window)" target="_blank"><i class="icon-share-alt"></i></a>
                        </g:if>
                        <g:else>
                          <a href="${fa.url}">View ${fa.result_type}</a>
                        </g:else>
                        </p>
                      </div>
                    </td>
                  </tr>
                </g:each>
            </g:if>
            <g:else>
            <tr>
              <td>
                <p>Recent forum activity not available. Please retry later.</p>
              </td>
            </tr>
            </g:else>
            <tr>
              <td>
                <a href="${grailsApplication.config.ZenDeskBaseURL}/forums" class="btn btn-primary pull-right">Visit Discussion Forum</a>
              </td>
            </tr>
          </tbody>
          </table>
        </div>
        </g:if>
      </div>
    </div>

    <asset:javascript src="dash.js"/>

  </body>
</html>
