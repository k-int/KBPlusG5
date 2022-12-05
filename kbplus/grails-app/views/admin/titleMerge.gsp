<!doctype html>
<html>
<head>
  <parameter name="pagetitle" value="Title Merge" />
  <parameter name="pagestyle" value="Admin" />
  <parameter name="actionrow" value="none" />
  <meta name="layout" content="base"/>
</head>

  <body class="admin">


    <!--page title start-->
    <div class="row">
        <div class="col s12 l12">
            <h1 class="page-title left">Title Merge</h1>
        </div>
    </div>
    <!--page title end-->
  <g:form action="titleMerge" method="get">
    <!--page intro and error start-->
    <div class="row">
        <div class="col s12">
            <div class="row strip-table z-depth-1">

                    <p class="title">Add the appropriate ID's below. Detailed information and confirmation will be presented before proceeding</p>

                    <div class="row admin-form">
                        <div class="input-field col s6">
                          <input id="d-id-dep" type="text" class="validate" name="titleIdToDeprecate" value="${params.titleIdToDeprecate}">
                          <label for="d-id-dep">Database ID of Title To Deprecate</label>
                          <g:if test="${title_to_deprecate != null}">
                            <div class="admin-table-title-section">
                              <p>Title To Deprecate: <span>${title_to_deprecate.title}</span></p>
                            </div>
                          </g:if>
                        </div>
                        <div class="input-field col s6">
                          <input id="d-id-cor" type="text" class="validate" name="correctTitleId" value="${params.correctTitleId}">
                          <label for="last_name">Database ID of Correct Title</label>
                          <g:if test="${title_to_deprecate != null}">
                            <div class="admin-table-title-section">
                               <p>Authorized Title: <span>correct title</span></p>
                            </div>
                          </g:if>
                        </div>
                    </div>


                    <button name="LookupButton" type="submit" value="Go" class="waves-effect waves-light btn">Look Up Title Info...</button>


            </div>
        </div>
    </div>

  <g:if test="${title_to_deprecate != null}">
    <div class="row">
        <div class="col s12">
            <div class="row tab-table z-depth-1 ">

                <div class="admin-table-title-section">
                    <g:if test="${correct_title != null && title_to_deprecate != null}">
                        <button name="MergeButton" type="submit" value="Go" class="waves-effect waves-light btn">MERGE</button>
                    </g:if>
                  <h3>Title To Deprecate: <span>title to depreciate 'title'</span></h3>
                  <p>The following TIPPs will be updated to point at the authorized title</p>
                </div>

                <!--***table***-->
                  <div class="tab-content">

                       <div class="row table-responsive-scroll">

                            <table class="highlight bordered ">
                                <thead>
                                  <tr>
                                      <th>Internal Id</th>
                                      <th>Package</th>
                                      <th>Platform</th>
                                      <th>Start Date</th>
                                      <th>End Date</th>
                                      <th>Coverage</th>
                                  </tr>
                                </thead>

                                <tbody>
                                  <g:each in="${title_to_deprecate.tipps}" var="tipp">
                                   <tr>
                                     <td>${tipp.id}</td>
                                     <td><g:link controller="packageDetails" action="show" id="${tipp.pkg.id}">${tipp.pkg.name}</g:link></td>
                                     <td>${tipp.platform.name}</td>

                                     <td style="white-space: nowrap">
                                       Date: <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp.startDate}"/><br/>
                                       Volume: ${tipp.startVolume}<br/>
                                       Issue: ${tipp.startIssue}
                                     </td>

                                     <td style="white-space: nowrap">
                                        Date: <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp.endDate}"/><br/>
                                        Volume: ${tipp.endVolume}<br/>
                                        Issue: ${tipp.endIssue}
                                     </td>
                                     <td>${tipp.coverageDepth}</td>
                                   </tr>
                                 </g:each>
                                </tbody>
                          </table>

                    </div>

                  </div>
                  <!--***table end***-->

            </div>
        </div>
    </div>

  </g:if>
  </g:form>


    <!--legacy -->
    <!-- <div class="container">
      <div class="span12">
        <h1>Title Merge</h1>
        <g:form action="titleMerge" method="get">
          <p>Add the appropriate ID's below. Detailed information and confirmation will be presented before proceeding</p>
          <dl>
            <div class="control-group">
              <dt>Database ID of Title To Deprecate</dt>
              <dd>
                <input type="text" name="titleIdToDeprecate" value="${params.titleIdToDeprecate}" />
                <g:if test="${title_to_deprecate != null}">
                   <h3>Title To Deprecate: <strong>${title_to_deprecate.title}</strong></h3>
                   <p>The following TIPPs will be updated to point at the authorized title</p>
                   <table class="table table-striped">
                     <thead>
                       <th>Internal Id</th>
                       <th>Package</th>
                       <th>Platform</th>
                       <th>Start</th>
                       <th>End</th>
                       <th>Coverage</th>
                     </thead>
                     <tbody>
                       <g:each in="${title_to_deprecate.tipps}" var="tipp">
                         <tr>
                           <td>${tipp.id}</td>
                           <td><g:link controller="packageDetails" action="show" id="${tipp.pkg.id}">${tipp.pkg.name}</g:link></td>
                           <td>${tipp.platform.name}</td>

                           <td style="white-space: nowrap">
                             Date: <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp.startDate}"/><br/>
                             Volume: ${tipp.startVolume}<br/>
                             Issue: ${tipp.startIssue}
                           </td>

                           <td style="white-space: nowrap">
                              Date: <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${tipp.endDate}"/><br/>
                              Volume: ${tipp.endVolume}<br/>
                              Issue: ${tipp.endIssue}
                           </td>
                           <td>${tipp.coverageDepth}
                         </tr>
                       </g:each>
                     </tbody>
                   </table>
                </g:if>
              </dd>
            </div>

            <div class="control-group">
              <dt>Database ID of Correct Title </dt>
              <dd>
                <input type="text" name="correctTitleId" value="${params.correctTitleId}"/>
                <g:if test="${correct_title != null}">
                   <br/>Authorized Title:${correct_title.title}
                </g:if>
              </dd>
            </div>

            <g:if test="${correct_title != null && title_to_deprecate != null}">
              <button name="MergeButton" type="submit" value="Go">**MERGE**</button>
            </g:if>
            <button name="LookupButton" type="submit" value="Go">Look Up Title Info...</button>
          </dl>
        </g:form>
      </div>
    </div> -->
    <!-- legacy end -->

  </body>
</html>
