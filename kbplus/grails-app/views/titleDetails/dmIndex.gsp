<!doctype html>
<html>
  <head>
    <parameter name="pagetitle" value="Data Manager Titles - Search" />
    <parameter name="pagestyle" value="data-manager" />
    <parameter name="actionrow" value="none" />
    <meta name="layout" content="base"/>
    <title>Data Manager Titles - Search</title>
  </head>

  <body class="admin">
    <div class="row">
      <div class="col s12">
        <div class="mobile-collapsible-header" data-collapsible="subscription-list-collapsible">Search <i class="material-icons">expand_more</i></div>
        <div class="search-section z-depth-1 mobile-collapsible-body" id="subscription-list-collapsible">
          <g:form action="dmIndex" method="get" params="${params}" role="form" class="form-inline">
            <input type="hidden" name="offset" value="${params.offset}"/>
            <div class="col s12 l7">
              <div class="input-field search-main">
                <input name="q" id="dmtitles" placeholder="Search Title..." value="${params.q}" type="search">
                <label class="label-icon" for="dmtitles"><i class="material-icons">search</i></label>
                <i class="material-icons close" id="clearSearch" search-id="dmtitles">close</i>
              </div>
            </div>
            <div class="col s12 l4 mt-10">
              <div class="input-field">
                <g:select name="status" from="${availableStatuses}" noSelection="${['null':'-Any Status-']}" value="${params.status}"/>
                <label>Status</label>
              </div>
            </div>
            <div class="col s12 l1">
              <button class="btn" type="submit" name="search" value="yes">Search</button>
            </div>
          </g:form>
        </div>
      </div>
    </div>
    <!-- search-section end-->
    
    <g:if test="${hits}">
      <!--page intro and error start-->
      <div class="row">
        <div class="col s12">
          <div class="row tab-table z-depth-1">
            <g:if test="${params.int('offset')}">
              <h2>Showing Results ${params.int('offset') + 1} - ${totalHits < max + params.int('offset') ? totalHits : (max + params.int('offset'))} of ${totalHits}</h2>
            </g:if>
            <g:elseif test="${totalHits && totalHits > 0}">
              <h2>Showing Results 1 - ${totalHits < max ? totalHits : max} of ${totalHits}</h2>
            </g:elseif>
            <g:else>
              <h2>Showing ${totalHits} Results</h2>
            </g:else>
            <g:set var="counter" value="${params.int('offset')? params.int('offset')+1 : 1}" />
            <!--***table***-->
            <div class="tab-content">
              <div class="row table-responsive-scroll">
                <table class="highlight bordered">
                  <thead>
                    <tr>
                      <th>&nbsp;</th>
                      <th style="white-space:nowrap">Title</th>
                      <th style="white-space:nowrap">Publisher</th>
                      <th style="white-space:nowrap">Identifiers</th>
                      <th style="white-space:nowrap">Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <g:each in="${hits}" var="hit">
                      <tr>
                        <td style="white-space:nowrap">
                          ${counter++}
                        </td>
                        <td>
                          <g:link controller="titleDetails" action="show" id="${hit.id}">${hit.title}</g:link>
                          <g:if test="${editable}">
                            <g:link controller="titleDetails" action="edit" id="${hit.id}">(Edit)</g:link>
                          </g:if>
                        </td>
                        <td>
                          ${hit.publisher?.name}
                        </td>
                        <td>
                          <ul>
                            <g:each in="${hit.ids}" var="id">
                              <li>${id.identifier.ns.ns} ${id.identifier.value}</li>
                            </g:each>
                          </ul>
                        </td>
                        <td>
                          ${hit.status?.value}
                        </td>
                      </tr>
                    </g:each>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
          
          <div class="pagination">
            <g:paginate action="dmIndex" controller="titleDetails" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${totalHits}" />
          </div>
        </div>
      </div>
    </g:if>

<!--legacy-->
    <!-- <div class="container">
      <ul class="breadcrumb">
        <li><g:link controller="home" action="index">Home</g:link> <span class="divider">/</span></li>
        <li><g:link controller="titleDetails" action="dmIndex">Data Manager Titles View</g:link></li>
      </ul>
    </div>

    <div class="container">
      <g:form action="dmIndex" method="get" params="${params}" role="form" class="form-inline">
      <input type="hidden" name="offset" value="${params.offset}"/>

      <div class="row">
        <div class="span12">
          <div class="well container">
            Title : <input name="q" placeholder="Search title" value="${params.q}"/> (Search on title text and identifiers)
            Status : <g:select name="status" from="${availableStatuses}" noSelection="${['null':'-Any Status-']}" value="${params.status}"/>

            <button type="submit" name="search" value="yes">Search</button>
            <div class="pull-right">
            </div>
          </div>
        </div>
      </div>


      <div class="row">

        <div class="span12">
          <div class="well">
             <g:if test="${hits}" >
                <div class="paginateButtons" style="text-align:center">
                  <g:if test="${params.int('offset')}">
                   Showing Results ${params.int('offset') + 1} - ${totalHits < (params.int('max') + params.int('offset')) ? totalHits : (params.int('max') + params.int('offset'))} of ${totalHits}
                  </g:if>
                  <g:elseif test="${totalHits && totalHits > 0}">
                    Showing Results 1 - ${totalHits < params.int('max') ? totalHits : params.int('max')} of ${totalHits}
                  </g:elseif>
                  <g:else>
                    Showing ${totalHits} Results
                  </g:else>
                </div>

                <div id="resultsarea">
                  <table class="table table-bordered table-striped">
                    <thead>
                      <tr>
                      <th style="white-space:nowrap">Title</th>
                      <th style="white-space:nowrap">Publisher</th>
                      <th style="white-space:nowrap">Identifiers</th>
                      <th style="white-space:nowrap">Status</th>
                      </tr>
                    </thead>
                    <tbody>
                      <g:each in="${hits}" var="hit">
                        <tr>
                          <td>
                            <g:link controller="titleDetails" action="show" id="${hit.id}">${hit.title}</g:link>
                            <g:if test="${editable}">
                              <g:link controller="titleDetails" action="edit" id="${hit.id}">(Edit)</g:link>
                            </g:if>
                          </td>
                          <td>
                            ${hit.publisher?.name}
                          </td>
                          <td>
                            <ul>
                              <g:each in="${hit.ids}" var="id">
                                <li>${id.identifier.ns.ns} ${id.identifier.value}</li>
                              </g:each>
                            </ul>
                          </td>
                          <td>
                            ${hit.status?.value}
                          </td>
                        </tr>
                      </g:each>
                    </tbody>
                  </table>
                </div>
             </g:if>
             <div class="paginateButtons" style="text-align:center">
                <g:if test="${hits}" >
                  <span><g:paginate controller="titleDetails" action="dmIndex" params="${params}" next="Next" prev="Prev" maxsteps="10" total="${totalHits}" /></span>
                </g:if>
              </div>
          </div>
        </div>
      </div>
      </g:form>
    </div> -->
    <!-- ES Query: ${es_query} -->
  </body>
</html>
