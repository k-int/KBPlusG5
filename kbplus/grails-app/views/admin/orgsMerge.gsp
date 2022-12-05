<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <title>KB+ Admin::Organisations Merge</title>
    <parameter name="pagetitle" value="Organisations Merge" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
  </head>

  <body class="admin">

          <!--page title start-->
    <div class="row">
         <div class="col s12 l12">
            <h1 class="page-title left">Organisations Merge</h1>
         </div>
    </div>
      <!--page title end-->
  <g:form action="orgsMerge" method="get">
    <div class="row">
        <div class="col s12">
          <div class="row strip-table z-depth-1">

              <p class="title">Add the appropriate ID's below. Detailed information and confirmation will be presented before proceeding</p>

              <div class="row admin-form">
                  <div class="input-field col s6">
                    <input id="d-id-dep" placeholder="ID of Organisation To Deprecate" type="text" class="validate" name="orgIdToDeprecate" value="${params.orgIdToDeprecate}">
                    <label for="d-id-dep">Organisation to Deprecate</label>
                  </div>
                  <div class="input-field col s6">
                    <input id="d-id-cor" placeholder="ID of Correct Organisation" type="text" class="validate" name="correctOrgId" value="${params.correctOrgId}">
                    <label for="last_name">Authorized Organisation</label>
                  </div>
              </div>

              <button name="LookupButton" type="submit" value="Go" class="waves-effect waves-light btn">Look Up Org Info...</button>


          </div>
        </div>
    </div>

    <g:if test="${org_to_deprecate != null}">
      <div class="row">
        <div class="col s12">
            <div class="row strip-table z-depth-1 admin-orgs-merge mergedatareturn">
              <div class="col s12">
                <g:if test="${correct_org != null && org_to_deprecate != null}">
                  <button name="MergeButton" type="submit" value="Go" class="waves-effect waves-light btn">MERGE</button>
                </g:if>
              </div>

                <!--left column-->
                <div class="col s12 l6">
                  <div class="admin-table-title-section">
                    <h2>${org_to_deprecate.name}</h2>
                    <h4>Status: ${org_to_deprecate.status?.value}</h4>
                  </div>
                  
                  <div class="admin-table-collection-section">
                    <h4>Identifiers:</h4>
                    <ul class="collection">
                      <g:each in="${org_to_deprecate.ids}" var="i">
                        <li class="collection-item"><g:link controller="identifier" action="show" id="${i.identifier.id}">${i?.identifier?.ns?.ns?.encodeAsHTML()} : ${i?.identifier?.value?.encodeAsHTML()}</g:link></li>
                      </g:each>
                    </ul>
                  </div>
                  
                  <div class="admin-table-collection-section">
                    <h4>Varient Names:</h4>

                    <ul class="collection">
                      <g:each in="${org_to_deprecate.variantNames}" var="i">
                        <li class="collection-item">${i.variantName}</li>
                      </g:each>
                    </ul>
                  </div>
                  
                  <div class="admin-table-collection-section">
                    <h4>Links:</h4>

                    <ul class="collection">
                    <g:each in="${org_to_deprecate.links}" var="i">
                      <li class="collection-item">
                        <g:if test="${i.pkg}"><g:link controller="packageDetails" action="show" id="${i.pkg.id}">Package: ${i.pkg.name} (${i.pkg?.packageStatus?.value})</g:link></g:if>
                        <g:if test="${i.sub}"><g:link controller="subscriptionDetails" action="index" id="${i.sub.id}">Subscription: ${i.sub.name} (${i.sub.status?.value})</g:link></g:if>
                        <g:if test="${i.lic}">Licence: ${i.lic.id} (${i.lic.status?.value})</g:if>
                        <g:if test="${i.title}"><g:link controller="titleDetails" action="show" id="${i.title.id}">Title: ${i.title.title} (${i.title.status?.value})</g:link></g:if>
                        (${i.roleType?.value})
                      </li>
                    </g:each>
                    </ul>
                  </div>

                </div>

                <!-- right column-->
                <div class="col s12 l6">
                  
                  <div class="admin-table-title-section">
                    <h2>${correct_org.name}</h2>
                    <h4>Status: ${correct_org.status?.value}</h4>
                  </div>  
                  
                  <div class="admin-table-collection-section">
                    <h4>Identifiers:</h4>
                    <ul class="collection">
                      <g:each in="${org_to_deprecate.ids}" var="i">
                        <li class="collection-item"><g:link controller="identifier" action="show" id="${i.identifier.id}">${i?.identifier?.ns?.ns?.encodeAsHTML()} : ${i?.identifier?.value?.encodeAsHTML()}</g:link></li>
                      </g:each>
                    </ul>
                  </div>  
                  
                  <div class="admin-table-collection-section">
                    <h4>Varient Names:</h4>
                    <ul class="collection">
                      <g:each in="${correct_org.variantNames}" var="i">
                        <li class="collection-item">${i.variantName}</li>
                      </g:each>
                    </ul>
                  </div>  
                  
                  <div class="admin-table-collection-section">
                    <h4>Links:</h4>
                    <ul class="collection">
                      <g:each in="${correct_org.links}" var="i">
                      <li class="collection-item">
                        <g:if test="${i.pkg}"><g:link controller="packageDetails" action="show" id="${i.pkg.id}">Package: ${i.pkg.name} (${i.pkg?.packageStatus?.value})</g:link></g:if>
                        <g:if test="${i.sub}"><g:link controller="subscriptionDetails" action="index" id="${i.sub.id}">Subscription: ${i.sub.name} (${i.sub.status?.value})</g:link></g:if>
                        <g:if test="${i.lic}">Licence: ${i.lic.id} (${i.lic.status?.value})</g:if>
                        <g:if test="${i.title}"><g:link controller="titleDetails" action="show" id="${i.title.id}">Title: ${i.title.title} (${i.title.status?.value})</g:link></g:if>
                        (${i.roleType?.value})
                      </li>
                      </g:each>
                    </ul>
                  </div>
                  
                </div>


            </div>
        </div>
      </div>
    </g:if>
  </g:form>


    <!--legacy-->

    <!-- <div class="container">
      <div class="span12">
        <h1>Organisations Merge</h1>
        <p>Add the appropriate ID's below. Detailed information and confirmation will be presented before proceeding</p>
        <table class="table table-striped">
          <thead>
            <tr>
              <th>
                Organisation to Deprecate
              </th>
              <th>
                Authorized Organisation
              </th>
            </tr>
          </thead>
          <tbody>
            <g:form action="orgsMerge" method="get">
              <tr>
                <td>
                  <div class="control-group">
                    <dt>ID of Organisation To Deprecate</dt>
                    <dd>
                      <input type="text" name="orgIdToDeprecate" value="${params.orgIdToDeprecate}" />
                    </dd>
                  </div>
                </td>
                <td>
                  <div class="control-group">
                    <dt>ID of Correct Organisation </dt>
                    <dd>
                      <input type="text" name="correctOrgId" value="${params.correctOrgId}"/>
                    </dd>
                  </div>
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <g:if test="${correct_org != null && org_to_deprecate != null}">
                    <button name="MergeButton" type="submit" value="Go">**MERGE**</button>
                  </g:if>
                  <button name="LookupButton" type="submit" value="Go">Look Up Org Info...</button>
                </td>
              </tr>
            </g:form>

            <tr>
              <td> 
                <g:if test="${org_to_deprecate != null}">
                  <h3><strong>${org_to_deprecate.name}</strong></h3>
                  Status: ${org_to_deprecate.status?.value} <br/>
                  Identifiers:
                  <ul>
                    <g:each in="${org_to_deprecate.ids}" var="i">
                      <g:link controller="identifier" action="show" id="${i.identifier.id}">${i?.identifier?.ns?.ns?.encodeAsHTML()} : ${i?.identifier?.value?.encodeAsHTML()}</g:link><br/>
                    </g:each>
                  </ul>
                  Variant Names
                  <ul>
                    <g:each in="${org_to_deprecate.variantNames}" var="i">
                      <li> 
                        ${i.variantName}
                      </li>
                    </g:each>
                  </ul>
                  Links
                  <ul>
                    <g:each in="${org_to_deprecate.links}" var="i">
                      <li>
                        <g:if test="${i.pkg}"><g:link controller="packageDetails" action="show" id="${i.pkg.id}">Package: ${i.pkg.name} (${i.pkg?.packageStatus?.value})</g:link></g:if>
                        <g:if test="${i.sub}"><g:link controller="subscriptionDetails" action="index" id="${i.sub.id}">Subscription: ${i.sub.name} (${i.sub.status?.value})</g:link></g:if>
                        <g:if test="${i.lic}">Licence: ${i.lic.id} (${i.lic.status?.value})</g:if>
                        <g:if test="${i.title}"><g:link controller="titleInstance" action="show" id="${i.title.id}">Title: ${i.title.title} (${i.title.status?.value})</g:link></g:if>
                        (${i.roleType?.value}) </li>
                    </g:each>
                  </ul>
                </g:if>
              </td>
              <td>
                <g:if test="${correct_org != null}">
                  <h3>${correct_org.name}</h3>
                  Status: ${correct_org.status?.value} <br/>
                  Identifiers:
                  <g:each in="${correct_org.ids}" var="i">
                    <g:link controller="identifier" action="show" id="${i.identifier.id}">${i?.identifier?.ns?.ns?.encodeAsHTML()} : ${i?.identifier?.value?.encodeAsHTML()}</g:link><br/>
                  </g:each>
                  Variant Names
                  <ul>
                    <g:each in="${correct_org.variantNames}" var="i">
                      <li> 
                        ${i.variantName}
                      </li>
                    </g:each>
                  </ul>
                  Links
                  <ul>
                    <g:each in="${correct_org.links}" var="i">
                      <li>
                        <g:if test="${i.pkg}"><g:link controller="packageDetails" action="show" id="${i.pkg.id}">Package: ${i.pkg.name} (${i.pkg?.packageStatus?.value})</g:link></g:if>
                        <g:if test="${i.sub}"><g:link controller="subscriptionDetails" action="index" id="${i.sub.id}">Subscription: ${i.sub.name} (${i.sub.status?.value})</g:link></g:if>
                        <g:if test="${i.lic}">Licence: ${i.lic.id} (${i.lic.status?.value})</g:if>
                        <g:if test="${i.title}"><g:link controller="titleInstance" action="show" id="${i.title.id}">Title: ${i.title.title} (${i.title.status?.value})</g:link></g:if>
                        (${i.roleType?.value}) </li>
                    </g:each>
                  </ul>
                </g:if>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div> -->
  </body>
</html>
