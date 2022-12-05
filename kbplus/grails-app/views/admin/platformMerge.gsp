<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <title>KB+ Admin::Platform Merge</title>
    <parameter name="pagetitle" value="Platform Merge" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
  </head>
  <body class="admin">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">Platform Merge</h1>
      </div>
    </div>
    <!--page title end-->
    
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
    
    <!--page intro and error start-->
    <g:form action="platformMerge" method="get">
      <div class="row">
        <div class="col s12">
          <div class="row strip-table z-depth-1">
            <p class="title">Add the appropriate ID's below. Detailed information and confirmation will be presented before proceeding. BOTH current and future IDs must be specified to proceed</p>
            <div class="row admin-form">
              <div class="input-field col s6">
                <input id="d-id-dep" type="text" class="validate" name="platformIdToDeprecate" value="${params.platformIdToDeprecate}" required>
                <label for="d-id-dep">Database ID of Platform To Deprecate</label>
              </div>
              <div class="input-field col s6">
                <input id="d-id-cor" type="text" class="validate" name="correctPlatformId" value="${params.correctPlatformId}" required>
                <label for="d-id-cor">Database ID of Correct Platform </label>
              </div>
            </div>
            <button name="LookupButton" type="submit" value="Go" class="waves-effect waves-light btn">Look Up Platform Info...</button>
          </div>
        </div>
      </div>
      
      <g:if test="${(platform_to_deprecate != null) || (correct_platform != null)}">
        <div class="row">
          <div class="col s12">
            <div class="row strip-table z-depth-1 admin-orgs-merge mergedatareturn">
              <div class="col s12">
                <g:if test="${correct_platform != null && platform_to_deprecate != null}">
                  <button name="MergeButton" type="submit" value="Go" class="waves-effect waves-light btn">MERGE</button>
                </g:if>
              </div>
              
              <!-- left column -->
              <div class="col s12 l6">
                <div class="admin-table-title-section">
                  <g:if test="${platform_to_deprecate != null}">
                    <h3>Platform To Deprecate: <strong>${platform_to_deprecate.name}</strong></h3>
                    <p>The following TIPPs will be updated to point at the authorized platform</p>
                    <p>Number of TIPPs: ${platform_to_deprecate.tipps.size()}</p>
                  </g:if>
                  <g:else>
                    <p>No Platform Found</p>
                  </g:else>
                </div>
              </div>
              <!-- end left -->
              
              <!-- right column -->
              <div class="col s12 l6">
                <div class="admin-table-title-section">
                  <g:if test="${correct_platform != null}">
                    <p>Authorized Platform: <strong>${correct_platform.name}</strong></p>
                  </g:if>
                  <g:else>
                    <p>No Platform Found</p>
                  </g:else>
                </div>
              </div>
              <!-- end right -->
            </div>
          </div>
        </div>
      </g:if>
    </g:form>
    
        <!--legacy -->

        <!-- <div class="container">
            <div class="span12">
                <h1>Platform Merge</h1>
                <g:form action="platformMerge" method="get">
                    <p>Add the appropriate ID's below. Detailed information and confirmation will be presented before proceeding. BOTH current and future IDs must be specified to proceed</p>
                    <dl>
                        <div class="control-group">
                            <dt>Database ID of Platform To Deprecate</dt>
                            <dd>
                                <input type="text" name="platformIdToDeprecate" value="${params.platformIdToDeprecate}" required />
                                <g:if test="${platform_to_deprecate != null}">
                                    <h3>Platform To Deprecate: <strong>${platform_to_deprecate.name}</strong></h3>
                                    <p>The following TIPPs will be updated to point at the authorized platform</p>
                                    <p>Number of TIPPs: ${platform_to_deprecate.tipps.size()}</p>
                                </g:if>
                            </dd>
                        </div>

                        <div class="control-group">
                            <dt>Database ID of Correct Platform </dt>
                            <dd>
                                <input type="text" name="correctPlatformId" value="${params.correctPlatformId}" required/>
                                <g:if test="${correct_platform != null}">
                                    <br/>Authorized Platform:${correct_platform.name}
                                </g:if>
                            </dd>
                        </div>

                        <g:if test="${correct_platform != null && platform_to_deprecate != null}">
                            <button name="MergeButton" type="submit" value="Go">**MERGE**</button>
                        </g:if>
                        <button name="LookupButton" type="submit" value="Go">Look Up Platform Info...</button>
                    </dl>
                </g:form>
            </div>
        </div> -->

        <!--legacy end -->
        
    </body>
</html>
