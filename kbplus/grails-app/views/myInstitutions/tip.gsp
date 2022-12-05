<!doctype html>
<html lang="en" class="no-js">
  <head>
    <parameter name="pagetitle" value="JUSP Usage statistics" />
    <parameter name="pagestyle" value="core" />
    <parameter name="actionrow" value="tip" />
    <meta name="layout" content="base"/>
    <title>JUSP Usage Statistics</title>
  </head>
  <body class="titles">
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">JUSP Usage Statistics for ${tip?.title?.title} via ${tip?.provider?.name}</h1>
      </div>
    </div>
    
    <div class="row">
      <div class="col s12">
        <div class="card-panel">
          <p class="car-title">Core Dates</p>
          <ul class="collection">
            <g:each in="${tip.coreDates}" var="cd">
              <li class="collection-item">${cd}</li>
            </g:each>
            <g:if test="${tip.coreDates == null || tip.coreDates.size() == 0}">
              <li class="collection-item">No Core Dates Currently</li>
            </g:if>
          </ul>
        </div>
      </div>
    </div>
    
    <!--***table data***-->
    <div class="row">
      <div class="col s12">
        <div class="tab-table z-depth-1">
          <h1 class="table-title">Usage Records</h1>
          <!--***table***-->
          <div id="title">
            <!--***tab card section***-->
            <div class="row table-responsive-scroll">
              <table class="highlight bordered">
                <thead>
                  <tr>
                    <th data-field="title">Start</th>
                    <th data-field="tip">End</th>
                    <th data-field="access">Reporting Year</th>
                    <th data-field="platform">Reporting Month</th>
                    <th data-field="coveragedepth">Type</th>
                    <th data-field="identifiers">Value</th>
                  </tr>
                </thead>
                
                <tbody>
                  <g:if test="${usage && usage.size() > 0 }">
                    <g:each in="${usage}" var="u">
                      <tr>
                        <td>${u.factFrom}</td>
                        <td>${u.factTo}</td>
                        <td>${u.reportingYear}</td>
                        <td>${u.reportingMonth}</td>
                        <td>${u.factType?.value}</td>
                        <td>${u.factValue}</td>
                      </tr>
                    </g:each>
                  </g:if>
                  <g:else>
                    <tr><td colspan="6">No usage currently</td></tr>
                  </g:else>
                </tbody>
              </table>
            </div>
          </div>
          <!--***table end***-->
        </div>
      </div>
    </div>
  </body>
</html>
