<!doctype html>
<html>
<head>
  <parameter name="pagetitle" value="Licence Property Merge" />
  <parameter name="pagestyle" value="Admin" />
  <parameter name="actionrow" value="none" />
  <meta name="layout" content="base"/>
</head>

  <body class="admin">


    <!--page title start-->
    <div class="row">
        <div class="col s12 l12">
            <h1 class="page-title left">Licence Property Merge</h1>
        </div>
    </div>
    <!--page title end-->
  <g:form action="propertyMerge" method="get">
    <!--page intro and error start-->
    <g:if test="${flash.message}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel blue lighten-1">
            <span class="white-text"> ${flash.message}</span>
          </div>
        </div>
      </div>
    </g:if>
    <div class="row">
        <div class="col s12">
            <div class="row strip-table z-depth-1">

                    <p class="title">Add the appropriate ID's below. Detailed information and confirmation will be presented before proceeding</p>

                    <div class="row admin-form">
                        <div class="input-field col s6">
                          <input id="d-id-dep" type="text" class="validate" name="propertyIdToDeprecate" value="${params.propertyIdToDeprecate}">
                          <label for="d-id-dep">Database ID of Licence Property To Deprecate</label>
                          <g:if test="${property_to_deprecate != null}">
                            <div class="admin-table-title-section">
                              <p>Licence Property To Deprecate: <span>${property_to_deprecate.name}</span></p>
                            </div>
                          </g:if>
                        </div>
                        <div class="input-field col s6">
                          <input id="d-id-cor" type="text" class="validate" name="correctPropertyId" value="${params.correctPropertyId}">
                          <label for="d-id-cor">Database ID of Correct Licence Property</label>
                          <g:if test="${correct_property != null}">
                            <div class="admin-table-title-section">
                               <p>Authorized Licence Property: <span>${correct_property.name}</span></p>
                            </div>
                          </g:if>
                        </div>
                    </div>


                    <button name="LookupButton" type="submit" value="Go" class="waves-effect waves-light btn">Look Up Licence Property Info...</button>


            </div>
        </div>
    </div>

  <g:if test="${property_to_deprecate != null}">
    <g:set var="occurenceAmount" value="${property_to_deprecate.countOccurrences('com.k_int.kbplus.LicenseCustomProperty','com.k_int.kbplus.SystemAdminCustomProperty','com.k_int.kbplus.OrgCustomProperty')}" />
    <g:set var="propertyOwners" value="${property_to_deprecate.getOccurrencesOwner('com.k_int.kbplus.LicenseCustomProperty','com.k_int.kbplus.SystemAdminCustomProperty','com.k_int.kbplus.OrgCustomProperty')}" />
    <div class="row">
        <div class="col s12">
            <div class="row tab-table z-depth-1 ">

                <div class="admin-table-title-section">
                    <g:if test="${correct_property != null && property_to_deprecate != null}">
                        <button name="MergeButton" type="submit" value="Go" class="waves-effect waves-light btn">MERGE</button>
                    </g:if>
                  <h3>Property To Deprecate: <span>Licences to deprecate 'property'</span></h3>
                  <p>The following <span>${occurenceAmount}</span> Licences will be updated to have the authorized licence property</p>
                </div>

                <!--***table***-->
                  <div class="tab-content">

                       <div class="row table-responsive-scroll">

                            <table class="highlight bordered ">
                                <thead>
                                  <tr>
                                      <th>Internal Id</th>
                                      <th>Licence Name</th>
                                  </tr>
                                </thead>

                                <tbody>
                                  <g:each in="${propertyOwners}" var="${cls}">
                                    <g:each in="${cls}" var="${ownerInstance}">
                                      <tr>
                                        <td>${ownerInstance.id}</td>
                                        <td><g:link controller="licenceDetails" action="show" id="${ownerInstance.id}">${ownerInstance.getClass().getName()}</g:link></td>
                                      </tr>
                                    </g:each>
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
  </body>
</html>
