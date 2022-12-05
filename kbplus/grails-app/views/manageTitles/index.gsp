<html lang="en" class="no-js">
  <head>
    <parameter name="pagetitle" value="Manage Titles" />
    <parameter name="pagestyle" value="Titles" />
    <meta name="layout" content="base"/>
  </head>
  <body class="titles">
    
    <g:set var="params_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
    
    <g:if test="${flash.message}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel blue lighten-1">
            <span class="white-text"> ${flash.message}</span>
          </div>
        </div>
      </div>
    </g:if>

    <g:if test="${flash.error}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel red lighten-1">
            <span class="white-text"> ${flash.error}</span>
          </div>
        </div>
      </div>
    </g:if>
    
    <!-- search-section start-->
    <div class="row">
      <div class="col s12">
        <div class="mobile-collapsible-header" data-collapsible="title-our-collapsible">Search <i class="material-icons">expand_more</i></div>
        <div class="search-section z-depth-1 mobile-collapsible-body" id="title-our-collapsible">
          <g:form controller="manageTitles" action="index" params="${params_sc}" method="post">
            <input type="hidden" name="sort" value="${params.sort}">
            <div class="col s12 mt-10">
              <h3 class="page-title left">Search Your Titles</h3>
            </div>
            <div class="col s12 m12 l8 mt-20">
              <div class="input-field">
                <!-- this needs to change to a typedown select2 box that searches on subscriptions, all for dm's, and limit to insts if inst focused -->
                <input type="hidden" name="sub" class="KBPlusTypeDown"
                       id="sub" 
                       data-base-class="com.k_int.kbplus.Subscription" 
                       data-inst-shortcode="${params.defaultInstShortcode?:''}"
                       value="${params.sub}"
                       data-defaulttext="${subtext?:''}"/>
                <label class="active" style="transform: translateY(-200%);">Subscription</label>
              </div>
            </div>
            <div class="col s12 l1">
              <input type="submit" class="waves-effect waves-teal btn" value="Search">
            </div>
            <div class="col s12 l1">
              <g:link controller="manageTitles" action="index" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="resetsearch">Reset</g:link>
            </div>
          </g:form>
        </div>
      </div>
    </div>
    <!-- search-section end-->
    
    <div class="row">
      <div class="col s12 page-response">
        <h2 class="list-response text-navy">
          <g:if test="${tips?.size() > 0}">
            Showing Titles: <span>${offset + 1}</span> to <span>${offset+(tips?.size())}</span> of <span>${total_tips}</span> titles
          </g:if>
          <g:else>
            No Titles Found
          </g:else>
        </h2>
      </div>
      
      <div class="row">
        <div class="col s12">
          <div class="filter-section z-depth-1">
            <g:form controller="manageTitles" action="index" params="${params_sc}" method="get">
              <g:hiddenField name="sub" value="${params.sub}" />
              <g:hiddenField name="offset" value="${params.offset}" />
              <g:hiddenField name="max" value="${params.max}" />
              <div class="col s12 m12 l6">
                <div class="input-field">
                  <g:select name="sort"
                            value="${params.sort}"
                            keys="['title.title:asc','title.title:desc']"
                            from="${['Title A-Z','Title Z-A']}" onchange="this.form.submit();" />
                  <label>Sort Titles By:</label>
                </div>
              </div>
            </g:form>
            <g:if test="${editable}">
              <div class="col s12 m12 l6 filter-actions button-area-line hide-on-med-and-down">
                <!-- TODO: change these when functionality is done and views are done -->
                <a href="#kbmodal" class="btn truncate modalButton" ajax-url="${createLink(controller:'manageTitles', action:'addCoreDate', params:[sort:params.sort,sub:params.sub,allinsub:'yes']+params_sc)}" ${params.sub?'':'disabled'}><i class="material-icons right">add_circle_outline</i>Mark Core To All In Subscription</a>
                <a href="#kbmodal" id="manageTitlesSelected" class="btn truncate" ajax-url="${createLink(controller:'manageTitles', action:'addCoreDate', params:[sort:params.sort,sub:params.sub]+params_sc)}">Mark Core To Selected Titles</a>
              </div>
            </g:if>
          </div>
        </div>
      </div>
    </div>
    
    <div class="row">
      <div class="col s12">
        <div class="tab-table z-depth-1">
          <div id="tips" class="tab-content">
            <div class="row">
              <table class="highlight bordered responsive-table">
                <thead>
                  <tr>
                    <g:if test="${editable}">
                      <th></th>
                    </g:if>
                    <th>Title</th>
                    <th>ISSN</th>
                    <th>eISSN</th>
                    <g:if test="${!params.defaultInstShortcode}">
                      <th>Institution</th>
                    </g:if>
                    <th>Provider</th>
                    <th>Subscription(s)</th>
                  </tr>
                </thead>
                <tbody>
                  <g:each in="${tips}" var="tip">
                    <g:set var="title_coverage_info" value="${tip.title.getInstitutionalCoverageSummary(tip.institution, session.sessionPreferences?.globalDateFormat)}" />
                    <tr>
                      <g:if test="${editable}">
                        <td>
                          <input type="checkbox" name="_tip.${tip.id}" id="_tip.${tip.id}"/>
                          <label for="_tip.${tip.id}">&nbsp;</label>
                        </td>
                      </g:if>
                      <td>${tip.title.title}</td>
                      <td>${tip.title.getIdentifierValue('ISSN')}</td>
                      <td>${tip.title.getIdentifierValue('eISSN')}</td>
                      <g:if test="${!params.defaultInstShortcode}">
                        <td>${tip.institution.name}</td>
                      </g:if>
                      <td>${tip.provider.name}</td>
                      <td>
                        <g:each in="${title_coverage_info?.ies}" var="ie">
                          <g:if test="${ie.subscription}">
                            <g:link controller="subscriptionDetails" action="index" params="${params_sc}" id="${ie.subscription.id}">${ie.subscription.name}</g:link><br>
                          </g:if>
                        </g:each>
                      </td>
                    </tr>
                  </g:each>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
      
      <div class="col s12">
        <div class="pagination">
          <g:if test="${tips}">
            <g:paginate action="index" controller="manageTitles" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${total_tips}" class="showme" />
          </g:if>
        </div>
      </div>
    </div>
  </body>
</html>
