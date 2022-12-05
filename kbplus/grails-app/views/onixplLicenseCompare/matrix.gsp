<!doctype html>
<%@ page import="com.k_int.kbplus.onixpl.OnixPLService;grails.converters.JSON" %>
<g:set var="onixPLService" bean="onixPLService"/>

<html lang="en" class="no-js">
<head>
  <parameter name="actionrow" value="licences-elcat" />
  <parameter name="pagetitle" value="${message(code:'menu.institutions.comp_onix')}"/>
  <meta name="layout" content="base"/>
  <title>KB+ :: Licence Comparison Tool (ONIX-PL)</title>
</head>
<body class="licences">
  <!--page title-->
  <div class="row">
    <div class="col s12 l10">
      <h1 class="page-title">Licence Comparison Tool (ONIX-PL)</h1>
    </div>
  </div>
  <!--page title end-->

  <!--map keys-->
  <g:set var="authUsersKey" value="authorisedUsers"/>
  <g:set var="contAccessKey" value="continuingAccessTerms"/>
  <g:set var="genTermsKey" value="generalTerms"/>
  <g:set var="licGrantsKey" value="licenceGrants"/>
  <g:set var="paymentTermsKey" value="paymentTerms"/>
  <g:set var="supplyTermsKey" value="supplyTerms"/>
  <g:set var="usageTermsKey" value="usageTerms"/>

  <!--map data-->
  <g:set var="authUsersData" value="${data?.get(authUsersKey)}"/>
  <g:set var="contAccessData" value="${data?.get(contAccessKey)}"/>
  <g:set var="genTermsData" value="${data?.get(genTermsKey)}"/>
  <g:set var="licGrantsData" value="${data?.get(licGrantsKey)}"/>
  <g:set var="paymentTermsData" value="${data?.get(paymentTermsKey)}"/>
  <g:set var="supplyTermsData" value="${data?.get(supplyTermsKey)}"/>
  <g:set var="usageTermsData" value="${data?.get(usageTermsKey)}"/>

  <g:if test="${authUsersData}">
    <g:set var="au_table_name" value="${ authUsersData.remove("_title") }" />
  </g:if>
  <g:if test="${contAccessData}">
    <g:set var="ca_table_name" value="${ contAccessData.remove("_title") }" />
  </g:if>
  <g:if test="${genTermsData}">
    <g:set var="gt_table_name" value="${ genTermsData.remove("_title") }" />
  </g:if>
  <g:if test="${licGrantsData}">
    <g:set var="lg_table_name" value="${ licGrantsData.remove("_title") }" />
  </g:if>
  <g:if test="${paymentTermsData}">
    <g:set var="pt_table_name" value="${ paymentTermsData.remove("_title") }" />
  </g:if>
  <g:if test="${supplyTermsData}">
    <g:set var="st_table_name" value="${ supplyTermsData.remove("_title") }" />
  </g:if>
  <g:if test="${usageTermsData}">
    <g:set var="ut_table_name" value="${ usageTermsData.remove("_title") }" />
  </g:if>

  <div class="row">
    <div class="col s12">
      <ul class="tabs jisc_tabs">
        <li class="tab"><a href="#authorised-users">Authorised Users<i class="material-icons">chevron_right</i></a></li>
        <li class="tab"><a href="#licence-grants">Licence Grants<i class="material-icons">chevron_right</i></a></li>
        <li class="tab"><a href="#usage-terms">Usage Terms<i class="material-icons">chevron_right</i></a></li>
        <li class="tab"><a href="#supply-terms">Supply Terms<i class="material-icons">chevron_right</i></a></li>
        <li class="tab"><a href="#access-terms">Access Terms<i class="material-icons">chevron_right</i></a></li>
        <li class="tab"><a href="#payment-terms">Payment Terms<i class="material-icons">chevron_right</i></a></li>
        <li class="tab"><a href="#general-terms">General Terms<i class="material-icons">chevron_right</i></a></li>
      </ul>
    </div>
  </div>

  <!--***tab authorised users content start***-->
  <div id="authorised-users" class="tab-content">
    <!--tab section start-->
    <!--***tabular data***-->
    <div class="row">
      <div class="col s12">
        <div class="tab-table z-depth-1">
          <!--***table***-->
          <table class="highlight bordered responsive-table ">
            <thead>
              <tr>
                <th class="pd-35 w250 br" data-field="elements">Elements</th>
                <g:each var="heading" in="${headings}" status="counter">
                  <th class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}"><p>${heading}</p></th>
                </g:each>
              </tr>
            </thead>
            <tbody>
              <g:set var="au_row" value="${0}"/>
              <g:each var="row_key,row" in="${authUsersData}">
                <g:set var="au_row" value="${au_row + 1}"/>
                <g:set var="rth" value="${service.getRowHeadingData(row)}" />
                <g:if test="${onixPLService.getSingleValue(rth, 'RelatedAgent')}">
                  <tr>
                    <th class="pd-35 br">${ raw(onixPLService.getSingleValue(rth, 'RelatedAgent')) }</th>
                    <g:set var="au_lic" value="${0}"/>
                    <g:each var="heading" in="${headings}" status="counter">
                      <td class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}">
                        <g:set var="au_lic" value="${au_lic + 1}"/>
                        <g:set var="entry" value="${ row[heading] }" />
                        <ul class="flex-row">
                          <g:if test="${ entry }" >
                            <li><i class="material-icons green tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Detailed by license">done</i></li>
                            <g:if test="${ entry['TextElement'] }" >
                              <g:set var="textTooltipId" value="au-text-row${au_row}-lic${au_lic}"/>
                              <g:render template="text" model="${ ["data" : entry['TextElement'], "tooltipid": textTooltipId] }" />
                            </g:if>
                            <g:if test="${ entry['Annotation'] }" >
                              <g:set var="annoTooltipId" value="au-anno-row${au_row}-lic${au_lic}"/>
                              <g:render template="annotation" model="${ ["data" : entry['Annotation'], "tooltipid": annoTooltipId] }" />
                            </g:if>
                          </g:if>
                          <g:else>
                            <li><i class="material-icons info tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Not defined by the license">not_interested</i></li>
                          </g:else>
                        </ul>
                      </td>
                    </g:each>
                  </tr>
                </g:if>
              </g:each>
            </tbody>
          </table>
          <!--***table end***-->
        </div>
      </div>
    </div>
    <!--***tabular data end***-->
  </div>
  <!--tab section end-->

  <!--***tab licence grants content start***-->
  <div id="licence-grants" class="tab-content">
    <!--tab section start-->
    <!--***tabular data***-->
    <div class="row">
      <div class="col s12">
        <div class="tab-table z-depth-1">
          <!--***table***-->
          <table class="highlight bordered responsive-table ">
            <thead>
              <tr>
                <th class="pd-35 w250 br" data-field="elements">Elements</th>
                <g:each var="heading" in="${headings}" status="counter">
                  <th class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}">${heading}</th>
                </g:each>
              </tr>
            </thead>
            <tbody>
              <g:set var="lg_row" value="${0}"/>
              <g:each var="row_key,row" in="${licGrantsData}">
                <g:set var="lg_row" value="${lg_row + 1}"/>
                <g:set var="rth" value="${service.getRowHeadingData(row)}" />
                <g:if test="${onixPLService.getAllValues(rth, 'LicenseGrantType', ', ')}">
                  <tr>
                    <th class="pd-35 br">Grants ${ raw(onixPLService.getAllValues(rth, 'LicenseGrantType', ', ')) } licence for ${ raw(onixPLService.getSingleValue(rth, 'LicenseGrantPurpose')) }</th>
                    <g:set var="lg_lic" value="${0}"/>
                    <g:each var="heading" in="${headings}" status="counter">
                      <td class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}">
                        <g:set var="lg_lic" value="${lg_lic + 1}"/>
                        <g:set var="entry" value="${ row[heading] }" />
                        <ul class="flex-row">
                          <g:if test="${ entry }" >
                            <li><i class="material-icons green tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Granted by license">done</i></li>
                            <g:if test="${ entry['TextElement'] }" >
                              <g:set var="textTooltipId" value="lg-text-row${lg_row}-lic${lg_lic}"/>
                              <g:render template="text" model="${ ["data" : entry['TextElement'], "tooltipid": textTooltipId] }" />
                            </g:if>
                            <g:if test="${ entry['Annotation'] }" >
                              <g:set var="annoTooltipId" value="lg-anno-row${lg_row}-lic${lg_lic}"/>
                              <g:render template="annotation" model="${ ["data" : entry['Annotation'], "tooltipid": annoTooltipId] }" />
                            </g:if>
                          </g:if>
                          <g:else>
                            <li><i class="material-icons info tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Not defined by the license">not_interested</i></li>
                          </g:else>
                        </ul>
                      </td>
                    </g:each>
                  </tr>
                </g:if>
              </g:each>
            </tbody>
          </table>
          <!--***table end***-->
        </div>
      </div>
    </div>
    <!--***tabular data end***-->
  </div>
  <!--tab section end-->

  <!--***tab usage terms content start***-->
  <div id="usage-terms" class="tab-content">
    <!--tab section start-->
    <!--***tabular data***-->
    <div class="row">
      <div class="col s12">
        <div class="tab-table z-depth-1">
          <!--***table***-->
          <table class="highlight bordered responsive-table ">
            <thead>
              <tr>
                <th class="pd-35 w250 br" data-field="elements">Elements</th>
                <g:each var="heading" in="${headings}" status="counter">
                  <th class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}">${heading}</th>
                </g:each>
              </tr>
            </thead>
            <tbody>
              <g:set var="active_user" value=""/>
              <!-- Set the usage status class names that can be found in the results -->
              <g:set var="usage_status_prohibited_interpreted" value="onix-pl-interpreted-as-prohibited"/>
              <g:set var="usage_status_prohibited" value="onix-pl-prohibited"/>
              <g:set var="usage_status_permitted" value="onix-pl-permitted"/>
              <g:set var="usage_status_permitted_interpreted" value="onix-pl-interpreted-as-permitted"/>
              <!-- end of usage status class names -->
              <g:set var="ut_row" value="${0}"/>
              <g:each var="row_key,row" in="${usageTermsData}">
                <g:set var="ut_row" value="${ut_row + 1}"/>
                <g:set var="rth" value="${service.getRowHeadingData(row)}" />
                <g:if test="${ onixPLService.getSingleValue(rth, 'UsageType')}">
                  <g:set var="hasPlaceOfReceivingAgent" value="${rth.'UsageRelatedPlace'?.'UsagePlaceRelator'?.'_content'?.contains(['onixPL:PlaceOfReceivingAgent'])}"/>
                  <g:set var="current_user" value="${row_key.substring(1,row_key.indexOf(']'))}"/>
                  <g:if test="${active_user != current_user}">
                    <tr style="text-align: left;font-size: 150%;">
                      <th class="pd-35 br">${ raw(onixPLService.getAllValues(rth, 'User', ', ', ' or ')) }</th>
                      <!-- This is needed or the annotations break -->
                      <g:each var="heading" in="${headings}" status="counter">
                        <td class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}"></td>
                      </g:each>
                    </tr>
                    <g:set var="active_user" value="${current_user}"/>
                  </g:if>
                  <tr>
                    <th class="pd-35 br">
                      <g:if test="${ onixPLService.getSingleValue(rth, 'UsageType').contains('Supply Copy') }">

                      </g:if>

                      ${ raw(onixPLService.getSingleValue(rth, 'UsageType')) }
                      the ${ raw(onixPLService.getAllValues(rth, 'UsedResource',',')) }

                      <g:if test="${rth['UsagePurpose']}">
                        for ${ raw(onixPLService.getSingleValue(rth, 'UsagePurpose')) }
                      </g:if>
                      <g:if test="${rth['UsageRelatedResource']}">
                        in ${ raw(onixPLService.getSingleValue(rth['UsageRelatedResource'][0], 'RelatedResource')) }
                      </g:if>
                      <g:if test="${ rth['UsageRelatedPlace'] && !hasPlaceOfReceivingAgent }" >
                        using ${ raw(onixPLService.getAllValues(rth['UsageRelatedPlace'][0], 'RelatedPlace', ', ', ' or ')) }
                        as ${ raw(onixPLService.getSingleValue(rth['UsageRelatedPlace'][0], 'UsagePlaceRelator')) }
                      </g:if>

                      <g:if test="${rth['UsageRelatedAgent']}">
                        to ${ raw(onixPLService.getSingleValue(rth['UsageRelatedAgent'][0], 'RelatedAgent')) }
                      </g:if>
                    </th>
                    <g:set var="ut_lic" value="${0}"/>
                    <g:each var="heading" in="${headings}" status="counter">
                      <td class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}">
                        <g:set var="ut_lic" value="${ut_lic + 1}"/>
                        <g:set var="rth" value="${service.getRowHeadingData(row,heading)}" />
                        <g:set var="entry" value="${ row[heading] }" />
                        <g:if test="${ entry }" >
                          <ul class="flex-row">
                            <!--this section needs to be checked for status and then needs to show right material icon-->
                            <!--four different states as far as I can tell in this part-->
                            <!--onix-pl-interpreted-as-prohibited,onix-pl-permitted,onix-pl-prohibited,onix-pl-interpreted-as-permitted-->
                            <!-- work out the css class and material icon to use based on the usage status class value -->
                            <g:set var="usage_status" value="${ entry?.'UsageStatus'?.getAt(0)?.'_content' }" />
                            <g:set var="class_usage_status" value="${ onixPLService.getClassValue(usage_status) }"/>
                            <g:set var="im_class_name" value="green"/>
                            <g:set var="im_value" value="done"/>
                            <g:set var="im_interpreted" value=""/>

                            <g:if test="${class_usage_status.equals(usage_status_prohibited_interpreted)}">
                              <g:set var="im_class_name" value="red"/>
                              <g:set var="im_value" value="close"/>
                              <g:set var="im_interpreted" value="#ff7676"/>
                            </g:if>
                            <g:elseif test="${class_usage_status.equals(usage_status_prohibited)}">
                              <g:set var="im_class_name" value="red"/>
                              <g:set var="im_value" value="close"/>
                            </g:elseif>
                            <g:elseif test="${class_usage_status.equals(usage_status_permitted_interpreted)}">
                              <g:set var="im_class_name" value="green"/>
                              <g:set var="im_value" value="done"/>
                              <g:set var="im_interpreted" value="#6ddd75"/>
                            </g:elseif>
                            <!--TODO: a lighter shade of the colours needed for the interpreted by statuses!-->
                            <li>
                              <g:if test="${im_interpreted}">
                                <i class="material-icons ${im_class_name} tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="${ onixPLService.getOnixValueAnnotation(usage_status) }" style="color: ${im_interpreted};">${im_value}</i>
                              </g:if>
                              <g:else>
                                <i class="material-icons ${im_class_name} tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="${ onixPLService.getOnixValueAnnotation(usage_status) }">${im_value}</i>
                              </g:else>
                            </li>
                            <!--end-->
                            <g:if test="${ entry['TextElement'] }" >
                              <g:set var="textTooltipId" value="ut-text-row${ut_row}-lic${ut_lic}"/>
                              <g:render template="text" model="${ ["data" : entry['TextElement'], "tooltipid": textTooltipId] }" />
                            </g:if>
                            <g:if test="${ entry['Annotation'] }" >
                              <g:set var="annoTooltipId" value="ut-anno-row${ut_row}-lic${ut_lic}"/>
                              <g:render template="annotation" model="${ ["data" : entry['Annotation'], "tooltipid": annoTooltipId] }" />
                            </g:if>
                          </ul>

                          <!--TODO: need to check this segment of code works at some point -->
                          <g:if test="${ entry['UsageException'] }" >
                            <ul class="flex-row">
                              <li><span class='exceptions' ><i class='icon-exclamation-sign' title='Exceptions' data-content='${
                                onixPLService.formatOnixValue(
                                  entry['UsageException']['UsageExceptionType']['_content']*.get(0).join(", ")
                                )
                              }'></i></span></li>
                            </ul>
                          </g:if>

                          %{-- List all the extra matrix details. --}%
                            <g:if test="${entry['UsageMethod'] }">
                               via ${ raw(onixPLService.getAllValues(entry, 'UsageMethod',', ')) }
                            </g:if>
                            <g:set var="hasPlaceOfReceivingAgent" value="${rth.'UsageRelatedPlace'?.'UsagePlaceRelator'?.'_content'?.contains(['onixPL:PlaceOfReceivingAgent'])}"/>

                            <g:if test="${hasPlaceOfReceivingAgent}">
                               In ${ raw(onixPLService.getSingleValue(rth.'UsageRelatedPlace'?.get(0),'RelatedPlace')) }
                            </g:if>
                            <g:if test="${rth['UsageQuantity']}">
                               ${ raw(onixPLService.getUsageQuantity(rth['UsageQuantity'][0])) }
                            </g:if>
                            <g:if test= "${rth['UsageCondition']}">
                              ${ raw(onixPLService.getSingleValue(rth,'UsageCondition')) }
                            </g:if>
                            <g:if test="${rth['UsageRelatedResource'] }">
                              <g:each var="clause" in="${rth['UsageRelatedResource']}">
                                <g:if test="${clause.'UsageResourceRelator'.'_content' != ['onixPL:TargetResource']}">
                                   ${ raw(onixPLService.getSingleValue(clause,'UsageResourceRelator')) } ${ raw(onixPLService.getAllValues(clause, 'RelatedResource', ', ', ' or ')) }
                                </g:if>
                              </g:each>
                            </g:if>
                            <g:if test="${rth.'UsageType'?.getAt(0)?.'_content'?.getAt(0) == 'onixPL:SupplyCopy'}">
                              <g:set var="hasVal" value="${onixPLService.getAllValues(rth, 'UsageMethod', ', ', ' or ')}"/>
                              <g:if test="${hasVal}">
                                ${hasVal}<!--do we need to wrap hasVal in raw(hasVal)??-->
                              </g:if>
                            </g:if>
                        </g:if>
                        <g:else>
                          <ul class="flex-row">
                            <li><i class="material-icons info tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Not defined by the license">not_interested</i></li>
                          </ul>
                        </g:else>
                      </td>
                    </g:each>
                  </tr>
                </g:if>
              </g:each>
            </tbody>
          </table>
          <!--***table end***-->
        </div>
      </div>
    </div>
    <!--***tabular data end***-->
  </div>
  <!--tab section end-->

  <!--***tab supply terms content start***-->
  <div id="supply-terms" class="tab-content">
    <!--tab section start-->
    <!--***tabular data***-->
    <div class="row">
      <div class="col s12">
        <div class="tab-table z-depth-1">
          <!--***table***-->
          <table class="highlight bordered responsive-table ">
            <thead>
              <tr>
                <th class="pd-35 w250 br" data-field="elements">Elements</th>
                <g:each var="heading" in="${headings}" status="counter">
                  <th class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}">${heading}</th>
                </g:each>
              </tr>
            </thead>
            <tbody>
              <g:set var="st_row" value="${0}"/>
              <g:each var="row_key,row" in="${supplyTermsData}">
                <g:set var="st_row" value="${st_row + 1}"/>
                <g:set var="rth" value="${service.getRowHeadingData(row)}" />
                <g:if test="${ onixPLService.getSingleValue(rth, 'SupplyTermType') }">
                  <tr>
                    <th class="pd-35 br">${ raw(onixPLService.getSingleValue(rth, 'SupplyTermType')) }</th>
                    <g:set var="st_lic" value="${0}"/>
                    <g:each var="heading" in="${headings}" status="counter">
                      <td class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}">
                        <g:set var="st_lic" value="${st_lic + 1}"/>
                        <g:set var="entry" value="${ row[heading] }" />
                        <ul class="flex-row">
                          <g:if test="${ entry }" >
                            <li><i class="material-icons info tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Detailed by license">info_outline</i></li>
                            <g:if test="${ entry['TextElement'] }" >
                              <g:set var="textTooltipId" value="st-text-row${st_row}-lic${st_lic}"/>
                              <g:render template="text" model="${ ["data" : entry['TextElement'], "tooltipid": textTooltipId] }" />
                            </g:if>
                            <g:if test="${ entry['Annotation'] }" >
                              <g:set var="annoTooltipId" value="st-anno-row${st_row}-lic${st_lic}"/>
                              <g:render template="annotation" model="${ ["data" : entry['Annotation'], "tooltipid": annoTooltipId] }" />
                            </g:if>
                          </g:if>
                          <g:else>
                            <li><i class="material-icons info tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Not defined by the license">not_interested</i></li>
                          </g:else>
                        </ul>
                      </td>
                    </g:each>
                  </tr>
                </g:if>
              </g:each>
            </tbody>
          </table>
          <!--***table end***-->
        </div>
      </div>
    </div>
    <!--***tabular data end***-->
  </div>
  <!--tab section end-->

  <!--***tab access terms content start***-->
  <div id="access-terms" class="tab-content">
    <!--tab section start-->
    <!--***tabular data***-->
    <div class="row">
      <div class="col s12">
        <div class="tab-table z-depth-1">
          <!--***table***-->
          <table class="highlight bordered responsive-table ">
            <thead>
              <tr>
                <th class="pd-35 w250 br" data-field="elements">Elements</th>
                <g:each var="heading" in="${headings}" status="counter">
                  <th class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}">${heading}</th>
                </g:each>
              </tr>
            </thead>
            <tbody>
              <g:set var="ca_row" value="${0}"/>
              <g:each var="row_key,row" in="${contAccessData}">
                <g:set var="ca_row" value="${ca_row + 1}"/>
                <g:set var="rth" value="${service.getRowHeadingData(row)}" />
                <g:if test="${ service.getSingleValue(rth, 'ContinuingAccessTermType') }">
                  <tr>
                    <th class="pd-35 br">
                      <g:set var="access_resource" value="${service.getSingleValue(rth['ContinuingAccessTermRelatedResource']?.getAt(0),'RelatedResource') }"/>
                      <g:set var="access_provider" value="${service.getSingleValue(rth['ContinuingAccessTermRelatedAgent']?.getAt(0),'RelatedAgent')}"/>
                      ${ raw(service.getSingleValue(rth, 'ContinuingAccessTermType')) }
                      <g:if test="${access_resource}">
                        of ${raw(access_resource)} provided by
                      </g:if>
                      <g:if test="${access_provider}">
                        <g:if test="${!access_resource}">
                          for
                        </g:if>
                        ${raw(access_provider)}
                      </g:if>
                    </th>
                    <g:set var="ca_lic" value="${0}"/>
                    <g:each var="heading" in="${headings}" status="counter">
                      <td class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}">
                        <g:set var="ca_lic" value="${ca_lic + 1}"/>
                        <g:set var="entry" value="${ row[heading] }" />
                        <ul class="flex-row">
                          <g:if test="${ entry }" >
                            <li>
                              <g:if test="${ entry['Annotation'] }" >
                                <i class="material-icons info tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Detailed by license">info_outline</i>
                              </g:if>
                              <g:else>
                                <i class="material-icons green tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Detailed by license">done</i>
                              </g:else>
                            </li>
                            <g:if test="${ entry['TextElement'] }" >
                              <g:set var="textTooltipId" value="ca-text-row${ca_row}-lic${ca_lic}"/>
                              <g:render template="text" model="${ ["data" : entry['TextElement'], "tooltipid": textTooltipId] }" />
                            </g:if>
                            <g:if test="${ entry['Annotation'] }" >
                              <g:set var="annoTooltipId" value="ca-anno-row${ca_row}-lic${ca_lic}"/>
                              <g:render template="annotation" model="${ ["data" : entry['Annotation'], "tooltipid": annoTooltipId] }" />
                            </g:if>
                          </g:if>
                          <g:else>
                            <li><i class="material-icons info tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Not defined by the license">not_interested</i></li>
                          </g:else>
                        </ul>
                      </td>
                    </g:each>
                  </tr>
                </g:if>
              </g:each>
            </tbody>
          </table>
          <!--***table end***-->
        </div>
      </div>
    </div>
    <!--***tabular data end***-->
  </div>
  <!--tab section end-->

  <!--***tab payment terms content start***-->
  <div id="payment-terms" class="tab-content">
    <!--tab section start-->
    <!--***tabular data***-->
    <div class="row">
      <div class="col s12">
        <div class="tab-table z-depth-1">
          <!--***table***-->
          <table class="highlight bordered responsive-table ">
            <thead>
              <tr>
                <th class="pd-35 w250 br" data-field="elements">Elements</th>
                <g:each var="heading" in="${headings}" status="counter">
                  <th class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}">${heading}</th>
                </g:each>
              </tr>
            </thead>
            <tbody>
              <g:set var="pt_row" value="${0}"/>
              <g:each var="row_key,row" in="${paymentTermsData}">
                <g:set var="pt_row" value="${pt_row + 1}"/>
                <g:set var="rth" value="${service.getRowHeadingData(row)}" />
                <g:if test="${ onixPLService.getSingleValue(rth, 'PaymentTermType') }">
                  <tr>
                    <th class="pd-35 br">${ raw(onixPLService.getSingleValue(rth, 'PaymentTermType')) }</th>
                    <g:set var="pt_lic" value="${0}"/>
                    <g:each var="heading" in="${headings}" status="counter">
                      <td class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}">
                        <g:set var="pt_lic" value="${pt_lic + 1}"/>
                        <g:set var="entry" value="${ row[heading] }" />
                        <ul class="flex-row">
                          <g:if test="${ entry }" >
                            <li><i class="material-icons info tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Detailed by license">info_outline</i></li>
                            <g:if test="${ entry['TextElement'] }" >
                              <g:set var="textTooltipId" value="pt-text-row${pt_row}-lic${pt_lic}"/>
                              <g:render template="text" model="${ ["data" : entry['TextElement'], "tooltipid": textTooltipId] }" />
                            </g:if>
                            <g:if test="${ entry['Annotation'] }" >
                              <g:set var="annoTooltipId" value="pt-anno-row${pt_row}-lic${pt_lic}"/>
                              <g:render template="annotation" model="${ ["data" : entry['Annotation'], "tooltipid": annoTooltipId] }" />
                            </g:if>
                          </g:if>
                          <g:else>
                            <li><i class="material-icons info tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Not defined by the license">not_interested</i></li>
                          </g:else>
                        </ul>
                      </td>
                    </g:each>
                  </tr>
                </g:if>
              </g:each>
            </tbody>
          </table>
          <!--***table end***-->
        </div>
      </div>
    </div>
    <!--***tabular data end***-->
  </div>
  <!--tab section end-->

  <!--***tab general terms content start***-->
  <div id="general-terms" class="tab-content">
    <!--tab section start-->
    <!--***tabular data***-->
    <div class="row">
      <div class="col s12">
        <div class="tab-table z-depth-1">
          <!--***table***-->
          <table class="highlight bordered responsive-table ">
            <thead>
              <tr>
                <th class="pd-35 w250 br" data-field="elements">Elements</th>
                <g:each var="heading" in="${headings}" status="counter">
                  <th class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}">${heading}</th>
                </g:each>
              </tr>
            </thead>
            <tbody>
              <g:set var="gt_row" value="${0}"/>
              <g:each var="row_key,row" in="${genTermsData}">
                <g:set var="gt_row" value="${gt_row + 1}"/>
                <g:set var="rth" value="${service.getRowHeadingData(row)}" />
                <g:if test="${ onixPLService.getSingleValue(rth, 'GeneralTermType') }">
                  <tr>
                    <th class="pd-35 br">
                      <g:if test="${ rth['TermStatus'] }" >
                        ${ raw(onixPLService.getSingleValue(rth, 'TermStatus')) }
                      </g:if>
                      ${ raw(onixPLService.getSingleValue(rth, 'GeneralTermType')) }
                    </th>
                    <g:set var="gt_lic" value="${0}"/>
                    <g:each var="heading" in="${headings}" status="counter">
                      <td class="pd-35 ${(counter + 1) < headings.size() ? 'br' : ''}">
                        <g:set var="gt_lic" value="${gt_lic + 1}"/>
                        <g:set var="entry" value="${ row[heading] }" />
                        <g:if test="${ entry }" >
                          <ul class="flex-row">
                            <li><i class="material-icons info tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Detailed by license">info_outline</i></li>
                            <g:if test="${ entry['TextElement'] }" >
                              <g:set var="textTooltipId" value="gt-text-row${gt_row}-lic${gt_lic}"/>
                              <g:render template="text" model="${ ["data" : entry['TextElement'], "tooltipid": textTooltipId] }" />
                            </g:if>
                            <g:if test="${ entry['Annotation'] }" >
                              <g:set var="annoTooltipId" value="gt-anno-row${gt_row}-lic${gt_lic}"/>
                              <g:render template="annotation" model="${ ["data" : entry['Annotation'], "tooltipid": annoTooltipId] }" />
                            </g:if>
                          </ul>

                          <g:if test="${entry['GeneralTermRelatedPlace'] }">
                           <g:each var="clause" in="${entry['GeneralTermRelatedPlace']}">
                              via ${ raw(onixPLService.getAllValues(clause, 'GeneralTermPlaceRelator',', ')) }
                            </g:each>
                          </g:if>
                        </g:if>
                        <g:else>
                          <ul class="flex-row">
                            <li><i class="material-icons info tooltipped card-tooltip" data-delay="50" data-position="bottom" data-tooltip="Not defined by the license">not_interested</i></li>
                          </ul>
                        </g:else>
                      </td>
                    </g:each>
                  </tr>
                </g:if>
              </g:each>
            </tbody>
          </table>
          <!--***table end***-->
        </div>
      </div>
    </div>
    <!--***tabular data end***-->
  </div>
  <!--tab section end-->
</body>
</html>
