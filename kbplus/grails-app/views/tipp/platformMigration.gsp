<!doctype html>
<html>
<head>
  <parameter name="pagetitle" value="Platform Migration" />
  <parameter name="pagestyle" value="Admin" />
  <parameter name="actionrow" value="none" />
  <meta name="layout" content="base"/>
  <title>Platform Migration</title>
</head>
  <body class="titles">
    <div class="row">
         <div class="col s12 l12">
            <h1 class="page-title left">Platform Migration</h1>
         </div>
      </div>

      <g:if test="${flash.message}">
        <div class="container">
          <div id="alert-info" class="alert-info">${flash.message}</div>
        </div>
      </g:if>


    <div class="row">
        <div class="col s12">
            <div class="row card-panel strip-table noborder z-depth-1">

                <g:if test="${explicitTipps}">
                    <div class="col m12 section">
                        <h2>Migrate the following explicit TIPPS</h2>
                    </div>
                    <div class="col s12">
                        <table class="table table-striped">
                            <thead>
                            <tr>
                                <th>TIPP ID</th>
                                <th>Title</th>
                                <th>Package</th>
                                <th>Platform</th>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${tipps}" var="t">
                                <tr>
                                    <td>${t.id}</td>
                                    <td>${t.title.title}</td>
                                    <td>${t.pkg.name}</td>
                                    <td>${t.platform.name}</td>
                                </tr>
                            </g:each>
                            </tbody>
                        </table>
                    </div>
                    <div class="col m12 section">
                        <h2>THIS ACTION WILL UPDATE ${tipps.size()} TIPPS</h2>
                    </div>
                </g:if>
                <g:else>
                    <!-- if section -->
                    <div class="col m12 section">
                        <h2>Migrate all tipps where....</h2>
                    </div>

                    <div class="col m12 section">
                        <div class="col m5 title noleft">
                            The title is like
                        </div>
                        <div class="col m7 result">
                            ${params.h_title?:'**Any title**'}
                        </div>
                    </div>
                    <g:if test="${platforms.size() > 0}">
                        <div class="col m12 section">
                            <div class="col m5 title noleft">
                                AND The package is one of
                            </div>
                            <div class="col m7 result">
                                <ul>
                                    <g:each in="${platforms}" var="p">
                                        <li>${p.name}</li>
                                    </g:each>
                                </ul>
                            </div>
                        </div>
                    </g:if>
                    <g:if test="${packages.size() > 0}">
                        <div class="col m12 section">
                            <div class="col m5 title noleft">
                                AND The package is one o
                            </div>
                            <div class="col m7 result">
                                <ul>
                                    <g:each in="${packages}" var="p">
                                        <li>${p.name}</li>
                                    </g:each>
                                </ul>
                            </div>
                        </div>
                    </g:if>
                    <!-- end if -->
                </g:else>
            </div>
        </div>
    </div>


  <div class="row row-content">
      <div class="col s12 section">
          <div class="card jisc_card small white fullheight">
              <div class="card-content text-navy">
                  <h2>New Platform Information</h2>
              </div>
              <div class="card-content text-navy">
                  <g:form action="platformMigration" method="get" onsubmit="return confirm('This action will update ${explicitTipps ? tipps.size() : params.h_count} TIPP records. Are you sure you want to proceed?');">
                      <input type="hidden" name="h_platforms" value="${params.h_platforms}"/>
                      <input type="hidden" name="h_count" value="${params.h_count}"/>
                      <input type="hidden" name="h_title" value="${params.h_title}"/>
                      <input type="hidden" name="h_pkgs" value="${params.h_pkgs}"/>
                      <input type="hidden" name="selectAll" value="${explicitTipps?:'on'}"/>
                      <g:each in="${tipps}" var="t">
                          <input type="hidden" name="tipp_${t.id}" value="on"/>
                      </g:each>


                      <div class="input-field padding col s12 l6 mt-10">
                          <input type="hidden" id="newPlatform" name="newPlatform" required placeholder="Type platform here" class="top10">
                          <label class="top10">New platform</label>
                      </div>

                      <div class="input-field padding col s12 l6 mt-10">
                          <input placeholder="YYYY-MM-DD"  id="platformMigrationDate" name="platformMigrationDate" type="text">
                          <div class="datepickericon" data-field="platformMigrationDate"><i class="material-icons">event</i></div>
                          <label>Package Start Date</label>
                      </div>


                      <div class="input-field col s12">
                          <button type="submit" value="Merge" name="migact"class="btn btn-primary"/>MIGRATE</button>
                      </div>
                  </g:form>
              </div>

              </div>
          </div>
      </div>
  </div>

<script type="text/javascript">
    setTimeout(
        function(){
            $(function(){
              $("#newPlatform").select2({
                width: '90%',
                required: true,
                placeholder: "Type package name...",
                minimumInputLength: 1,
                ajax: {
                    url: '<g:createLink controller='ajax' action='lookup'/>',
                    dataType: 'json',
                    data: function (term, page) {
                        return {
                          q: term , // search term
                          page_limit: 10,
                          baseClass:'com.k_int.kbplus.Platform'
                        };
                    },
                    results: function (data, page) {
                        return {results: data.values};
                    }
                },
                 allowClear: true,
                 formatSelection: function(data) {
                    return data.text;
                }
              });


            });
        }, 100
    )
</script>
  </body>
</html>
<!-- Legend
<head>
    <meta name="layout" content="base">
    <title>Platform Migration</title>
</head>
<body>
<div class="container">
    <div class="span12">

        <div class="page-header">
            <h1>Platform Migration</h1>
        </div>

        <g:if test="${flash.message}">
            <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
        </g:if>

        <g:if test="${explicitTipps}">
            <h2>Migrate the following explicit TIPPS</h2>
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>TIPP ID</th>
                    <th>Title</th>
                    <th>Package</th>
                    <th>Platform</th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${tipps}" var="t">
                    <tr>
                        <td>${t.id}</td>
                        <td>${t.title.title}</td>
                        <td>${t.pkg.name}</td>
                        <td>${t.platform.name}</td>
                    </tr>
                </g:each>
                </tbody>
            </table>
            <h1>THIS ACTION WILL UPDATE ${tipps.size()} TIPPS</h1>
        </g:if>
        <g:else>
            <h2>Migrate all tipps where....</h2>
            <h3>The title is like</h3>
            ${params.h_title?:'**Any title**'}

            <g:if test="${platforms.size() > 0}">
                <h3>AND The package is one of</h3>

                <ul>
                    <g:each in="${platforms}" var="p">
                        <li>${p.name}</li>
                    </g:each>
                </ul>
            </g:if>
            <g:else>
            </g:else>

            <g:if test="${packages.size() > 0}">
                <h3>AND The package is one of</h3>
                <ul>
                    <g:each in="${packages}" var="p">
                        <li>${p.name}</li>
                    </g:each>
                </ul>
            </g:if>
            <g:else>
            </g:else>

        </g:else>

        <hr/>

        <h1>New Platform Information</h1>

        <g:form action="platformMigration" method="get" onsubmit="return confirm('This action will update ${explicitTipps ? tipps.size() : params.h_count} TIPP records. Are you sure you want to proceed?');">

            <input type="hidden" name="h_platforms" value="${params.h_platforms}"/>
            <input type="hidden" name="h_count" value="${params.h_count}"/>
            <input type="hidden" name="h_title" value="${params.h_title}"/>
            <input type="hidden" name="h_pkgs" value="${params.h_pkgs}"/>

            <input type="hidden" name="selectAll" value="${explicitTipps?:'on'}"/>
            <g:each in="${tipps}" var="t">
                <input type="hidden" name="tipp_${t.id}" value="on"/>
            </g:each>

            <fieldset class="inline-lists">

                <dl>
                    <dt><label>New platform</label></dt>
                    <dd>
                        <input type="hidden" id="newPlatform" name="newPlatform" required >
                    </dd>
                </dl>

                <dl>
                    <dt><label>Platform Migration Date</label></dt>
                    <dd>
                        <input type="text" id="platformMigrationDate" name="platformMigrationDate" required />
                    </dd>
                </dl>

                <dl>
                    <dt></dt>
                    <dd>
                        <button type="submit" name="migact" value="PROCESS" class="btn btn-warn">MIGRATE</button>
                    </dd>
                </dl>


            </fieldset>


        </g:form>


    </div>
</div>
 end -->