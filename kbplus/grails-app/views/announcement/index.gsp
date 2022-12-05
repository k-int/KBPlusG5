<!doctype html>
<html lang="en" class="no-js">
  <head>
    <parameter name="pagetitle" value="Announcements" />
    <parameter name="pagestyle" value="Announcements" />
    <parameter name="actionrow" value="todoannouncements" />
    <meta name="layout" content="base"/>
    <title>KB+ Announcements</title>
  </head>
  <body class="data-manager">
    <g:if test="${flash.message}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel blue lighten-1">
            <span class="white-text">${flash.message}</span>
          </div>
        </div>
      </div>
    </g:if>
    
    <g:if test="${flash.error}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel red lighten-1">
            <span class="white-text">${flash.error}</span>
          </div>
        </div>
      </div>
    </g:if>
    
    <g:if test="${editable}">
      <div class="row">
        <div class="col s12">
          <div class="mobile-collapsible-header" data-collapsible="createannouncement-list-collapsible">Create Announcement <i class="material-icons">expand_more</i></div>
          <div class="search-section z-depth-1 mobile-collapsible-body" id="createannouncement-list-collapsible">
            <div class="col s12 mb-20">
              <h3 class="page-title mt-20 ml-10">Create Announcement</h3>
            </div>
            
            <!--form-->
            <div class="row">
              <g:form action="createAnnouncement" class="col s12">    
                <div class="row">
                  <div class="input-field col s12">
                    <input id="subjectTxt" name="subjectTxt" type="text" value="${params.as}"/>
                    <label for="subjectTxt">Subject</label>
                  </div>
                </div>
                
                <div class="row">
                  <div class="input-field col s12">
                    <textarea name="annTxt" id="ann_text" class="materialize-textarea">${params.at}</textarea>
                    <label for="ann_text">Announcement Content</label>
                  </div>
                </div>
                
                <div class="row">
                  <div class="input-field col s12">
                    <input type="submit" value="Create Announcement" class="btn btn-primary"/>
                  </div>
                </div>
              </g:form>
            </div>
            <!--form end-->
          </div>
        </div>
      </div>
    </g:if>
    
    <div class="row">
      <div class="col s12 page-response">
        <h2 class="list-response text-navy">
          <g:if test="${params.int('offset')}">
            Showing <span>${params.int('offset') + 1}</span> to <span>${num_announcements < (max + params.int('offset')) ? num_announcements : (max + params.int('offset'))}</span> of <span>${num_announcements}</span> Announcements
          </g:if>
          <g:elseif test="${num_todos && num_todos > 0}">
            Showing <span>1</span> to <span>${num_announcements < max ? num_announcements : max}</span> of <span>${num_announcements}</span> Announcements
          </g:elseif>
          <g:else>
            Showing <span>${num_announcements}</span> Announcements
          </g:else>
        </h2>
      </div>
    </div>
    
    <!-- list accordian start-->
    <div class="row">
      <div class="col s12 l12">
        <ul class="collapsible jisc_collapsible" data-collapsible="accordion">
          <g:each in="${recentAnnouncements}" var="ra">
            <!--accordian item-->
            <li>
              <!--accordian header-->
              <div class="collapsible-header announcements">
                <div class="col s12 m12">
                  <i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Click to toggle"></i>
                  <ul class="collection">
                    <li class="collection-item"><h2 class="first navy-text">${raw(ra.title)}</h2></li>
                    <li class="collection-item">Date Posted: <span><g:formatDate date="${ra.dateCreated}" format="yyyy-MM-dd hh:mm a"/></span> &nbsp; <g:if test="${ra.user != null}">Posted by: <span><g:link controller="userDetails" action="pub" id="${ra.user?.id}" class="no-js">${ra.user?.displayName}</g:link></span></g:if></li>
                  </ul>
                </div>
              </div>
              <!-- accordian header end-->
              
              <!-- accordian body-->
              <div class="collapsible-body">
                <div class="row">
                  <div class="col s12">
                    ${raw(ra.content)}
                  </div>
                </div>
              </div>
              <!-- accordian body end-->
            </li>
            <!-- accordian item end-->
          </g:each>
        </ul>
      </div>
      
      <g:if test="${recentAnnouncements!=null}" >
        <div class="col s12 l12">
          <div class="pagination">
            <g:paginate action="index" controller="announcement" params="${params}" next="chevron_right" prev="chevron_left" maxsteps="10" total="${num_announcements}"/>
          </div>
        </div>
      </g:if>
    </div>
    <!-- list accordian end-->
  </body>
</html>
