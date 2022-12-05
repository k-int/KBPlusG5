<%@ page import="com.k_int.kbplus.Package" %>
<!doctype html>
<html>
  <head>
    <parameter name="pagetitle" value="Package - Review Upload" />
    <parameter name="pagestyle" value="data-manager" />
    <parameter name="actionrow" value="none" />
    <meta name="layout" content="base">
    <g:set var="entityName" value="${message(code: 'package.label', default: 'Package')}" />
    <title><g:message code="default.edit.label" args="[entityName]" /></title>
  </head>
  <body class="data-manager">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">Review Package Upload</h1>
      </div>
    </div>
    <!--page title end-->
    
    <!--error messages-->
    <g:if test="${flash.error}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel red lighten-1">
            <span class="white-text"> ${flash.error}</span>
          </div>
        </div>
      </div>
    </g:if>
    
    <!--error messages-->
    <g:if test="${flash.message}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel blue lighten-1">
            <span class="white-text"> ${flash.message}</span>
          </div>
        </div>
      </div>
    </g:if>
    
    <g:hasErrors bean="${packageInstance}">
      <div class="row">
        <div class="col s12">
          <div class="row tab-table z-depth-1">
            <ul>
              <g:eachError bean="${packageInstance}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if><g:message error="${error}"/></li>
              </g:eachError>
            </ul>
          </div>
        </div>
      </div>
    </g:hasErrors>
    
    <g:if test="${validationResult}">
      <div class="row">
        <div class="col s12">
          <div class="row tab-table z-depth-1">
            <g:if test="${validationResult.stats != null}">
              <h3>Stats</h3>
              <ul>
                <g:each in="${validationResult?.stats}" var="msg">
                  <li>${msg.key} = ${msg.value}</li>
                </g:each>
              </ul>
            </g:if>
            
            <g:each in="${validationResult?.messages}" var="msg">
              <div>${msg}</div>
            </g:each>
            
            <g:each in="${validationResult?.consortium?.messages}" var="msg">
              <div>${msg}</div>
            </g:each>
            
            <g:if test="${validationResult.processFile==false}">
              <div>
                File failed validation checks, details follow
                <g:form action="downloadBadfile" id="${params.id}">
                  <button id="load_package_button_bad_rows" type="submit" class="btn" name="loadPackage" value="downloadBadLines">Download BAD rows</button><br/>
                </g:form>
              </div>
            </g:if>
          </div>
        </div>
      </div>
      
      <g:form action="processPackage" id="${params.id}" onsubmit="return validateForm();">
        <div class="row">
          <div class="col s12">
            <div class="row tab-table z-depth-1">
              <g:if test="${validationResult.processFile==true}">
                <h3 class="page-title">File can be ingested</h3>
                <div>
                  <button id="load_package_button_valid" type="submit" class="btn" name="loadPackage" value="standardLoad">Load</button> &nbsp;
                  <button id="load_package_button_valid_repeat" type="submit" class="btn" name="loadPackage" value="repeat">Load and Repeat</button>
                </div>
              </g:if>
              <g:else>
                <h3 class="page-title">Attempt partial load</h3>
                <button id="load_package_button_partial" type="submit" class="btn" name="loadPackage" value="standardLoad">Partial Load</button> &nbsp;
                <button id="load_package_button_partial_repeat" type="submit" class="btn" name="loadPackage" value="repeat">Partial Load and Repeat</button>
              </g:else>
            </div>
          </div>
        </div>
        
        <div class="row">
          <div class="col s12">
            <div class="row tab-table z-depth-1">
              <g:if test="${validationResult.matchedExistingPackage}">
                <h3 class="page-title">Identifier in package file matched existing package <g:link controller="packageDetails" action="show" id="${validationResult.matchedExistingPackage.id}">${validationResult.matchedExistingPackage.name}</g:link>. How would you like to handle this?</h3>
                
                <div class="row">
                  <div class="input-field col s12">
                    <input id="r_update_matched" name="packageMatchAction" value="useExisting" checked="true" type="radio" />
                    <label for="r_update_matched">Update Matched Package:</label>
                  </div>
                </div>
                
                <div class="row">
                  <div class="input-field col s12 l6">
                    <input id="r_new_package" type="radio" name="packageMatchAction" value="newPackage" />
                    <label for="r_new_package">Create New Package named:</label>
                  </div>
                  
                  <div class="input-field col s12 l6">
                    <input id="new_package_name_2" type="text" name="newPackageName" class="validate">
                    <label for="newPackageName">New Package Name</label>
                  </div>
                </div>
                
                <div class="row">
                  <div class="input-field col s12 l6">
                    <input id="r_update_existing" type="radio" name="packageMatchAction" value="alternateExisting" />
                    <label for="r_update_existing">Select an existing package to update:</label>
                  </div>
                  
                  <div class="input-field col s12 l6">
                    <label class="property-label select2label" style="transform: translateY(-200%);">Package to update</label>
                    <input id="packageSelect" name="packageToUpdate" type="text" class="validate">
                  </div>
                </div>
              </g:if>
              <g:else>
                <h3 class="page-title">Unable to match this package. How would you like to handle this?</h3>
                
                <!--<div class="col l6 mt-10 no-padding">-->
                <div class="row">
                  <!--<div class="col s12">-->
                  <div class="input-field col s12 l6">
                    <input id="newPackage" name="packageMatchAction" value="newPackage" checked="true" type="radio" />
                    <label for="newPackage">Create New Package named:</label>
                  </div>
                  
                  <div class="input-field col s12 l6">
                    <input id="new_package_name" type="text" name="newPackageName" class="validate">
                    <label for="new_package_name">New Package Name</label>
                    <span id="pkgnamemsg"></span>
                  </div>
                </div>
                
                <div class="row">
                <!--<div class="col l6 mt-10 no-padding"> this does not display propertly with a select2 typedown box, reverting to how it was originally-->
                  <div class="input-field col s12 l6">
                  <!--<div class="col s12">-->
                    <input id="alternateExisting" name="packageMatchAction" value="alternateExisting" type="radio" />
                    <label for="alternateExisting">Select an existing package to update:</label>
                  </div>
                  
                  <div class="input-field col s12 l6">
                    <label class="property-label select2label">Enter Package Name</label>
                    <input id="packageSelect2" name="packageToUpdate" type="text" class="validate">
                  </div>
                </div>
              </g:else>
            </div>
          </div>
        </div>
        
        <div class="row">
          <div class="col s12">
            <div class="row tab-table z-depth-1">
              <h3 class="page-title">Package Properties</h3>
              
              <div class="row">
                <div class="input-field col s12 l6">
                  <g:kbplusDatePicker inputid="package_start_date" name="overrideStartDate" value="" required="${true}"/>
                  <label>Package Start Date</label>
                </div>
                <div class="input-field col s12 l6">
                  <g:kbplusDatePicker inputid="package_end_date" name="overrideEndDate" value="" required="${true}"/>
                  <label>Package End Date</label>
                </div>
              </div>
              
              <div class="row">
                <div class="input-field col s12 l6">
                  <label class="property-label select2label">Content Provider</label>
                  <input id="overrideContentProvider" name="overrideContentProvider" type="text" class="OrgLookup">
                </div>
                
                <div class="input-field col s12 l6">
                  <label class="property-label select2label">Consortium</label>
                  <input id="overrideConsortium" name="overrideConsortium" type="text" class="OrgLookup">
                </div>
              </div>
              
              <div class="row">
                <div class="input-field col s12">
                  <select id="pkgScopeCtrl" name="overridePackageScope" value="">
                    <option value="Aggregator">Aggregator</option>
                    <option value="Front File">Front File</option>
                    <option value="Back File">Back File</option>
                    <option value="Master File">Master File</option>
                    <option value="Scope Undefined">Scope Undefined</option>
                  </select>
                  <label>Package Scope</label>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!--***tabular data***-->
        <div class="row">
          <div class="col s12">
            <div class="tab-table z-depth-1">
              <h3>Titles in this package</h3>
              <div class="row table-responsive-scroll always">
                <table class="bordered highlight">
                  <thead>
                    <tr>
                      <th>Override</th>
                      <th>Line#</th>
                      <g:each in="${validationResult.soHeaderLine}" var="c">
                        <th>${c}</th>
                      </g:each>
                    </tr>
                  </thead>
                  <tbody>
                    <g:each in="${validationResult.tipps}" var="tipp" status="rc">
                      <tr>
                        <td style="vertical-align:middle;">
                          <input class="" type="checkbox" name="override_${rc}" id="override_${rc}" />
                          <label for="override_${rc}" class="align">&nbsp;</label>
                        </td>
                        <td> ${tipp.LINE_NO} </td>
                        <g:each in="${tipp.row}" var="c">
                          <td>${c}</td>
                        </g:each>
                      </tr>
                      <g:if test="${tipp.messages?.size() > 0}">
                        <tr>
                          <td colspan="${validationResult.soHeaderLine.size()+2}">
                            <ul>
                              <g:each in="${tipp.messages}" var="msg">
                                <g:if test="${msg instanceof java.lang.String || msg instanceof org.codehaus.groovy.runtime.GStringImpl}">
                                  <div>${msg}</div>
                                </g:if>
                                <g:else>
                                  <div>${msg.message}</div>
                                </g:else>
                              </g:each>
                            </ul>
                          </td>
                        </tr>
                      </g:if>
                    </g:each>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
        <!--***tabular data end***-->
      </g:form>
    </g:if>







<!--LEGACY-->
<!--
      <div class="container-fluid">
        <h1>Review Package Upload</h1>

        <g:if test="${flash.message}">
        <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
        </g:if>

        <g:if test="${flash.error}">
        <bootstrap:alert class="alert-info">${flash.error}</bootstrap:alert>
        </g:if>

        <g:hasErrors bean="${packageInstance}">
        <bootstrap:alert class="alert-error">
        <ul>
          <g:eachError bean="${packageInstance}" var="error">
          <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
          </g:eachError>
        </ul>
        </bootstrap:alert>
        </g:hasErrors>

        <g:if test="${validationResult}">
          <g:if test="${validationResult.stats != null}">
            <h3>Stats</h3>
            <ul>
              <g:each in="${validationResult?.stats}" var="msg">
                <li>${msg.key} = ${msg.value}</li>
              </g:each>
            </ul>
          </g:if>

          <g:each in="${validationResult?.messages}" var="msg">
            <div class="alert alert-error">${msg}</div>
          </g:each>

          <g:each in="${validationResult?.consortium?.messages}" var="msg">
            <div class="alert alert-error">${msg}</div>
          </g:each>

          <g:if test="${validationResult.processFile==false}">
            <div class="alert alert-error">
              File failed validation checks, details follow
              <g:form action="downloadBadfile" id="${params.id}">
                <button id="load_package_button_bad_rows" type="submit" class="btn btn-danger pull-right" name="loadPackage" value="downloadBadLines">Download BAD rows</button><br/>
              </g:form>
            </div>
          </g:if>


          <g:form action="processPackage" id="${params.id}" onsubmit="return validateForm();">

            <g:if test="${validationResult.processFile==true}">
              <bootstrap:alert class="alert-success">File can be ingested
                <button id="load_package_button_valid" type="submit" class="btn btn-success pull-right" name="loadPackage" value="standardLoad">Load</button> &nbsp;
                <button id="load_package_button_valid_repeat" type="submit" class="btn btn-success pull-right" name="loadPackage" value="repeat">Load and Repeat</button>
              </bootstrap:alert>
            </g:if>
            <g:else>
              <bootstrap:alert class="alert-success">Attempt partial load
                <button id="load_package_button_partial" type="submit" class="btn btn-danger pull-right" name="loadPackage" value="standardLoad">Partial Load</button> &nbsp;
                <button id="load_package_button_partial_repeat" type="submit" class="btn btn-danger pull-right" name="loadPackage" value="repeat">Partial Load and Repeat</button>
              </bootstrap:alert>
            </g:else>

            <g:if test="${validationResult.matchedExistingPackage}">
              <strong>Identifier in package file matched existing package <g:link controller="packageDetails" action="show" id="${validationResult.matchedExistingPackage.id}">${validationResult.matchedExistingPackage.name}</g:link>. How would you like to handle this?</strong>
              <table class="table">
                <tr>
                  <td>
                    <input id="r_update_matched" type="radio" name="packageMatchAction" value="useExisting" checked="true"/> Update Matched Package
                  </td>
                  <td>
                    <input id="r_new_package" type="radio" name="packageMatchAction" value="newPackage"/> Create New Package named <input id="new_package_name_2" type="text" name="newPackageName" placeholder="New Package Name"/><br/>
                  </td>
                  <td>
                    <input id="r_update_existing" type="radio" name="packageMatchAction" value="alternateExisting" /> Select an existing package to update :
                    <input type="text" id="packageSelect" name="packageToUpdate" width="600px"/>
                  </td>
                </tr>
              </table>
            </g:if><g:else>
              <strong>Unable to match this package. How would you like to handle this?</strong>
              <table class="table">
                <tr>
                  <td>
                    <input type="radio" name="packageMatchAction" value="newPackage" checked="true" /> Create New Package named <input id="new_package_name" type="text" name="newPackageName" placeholder="New Package Name"/><br/>
                    <span id="pkgnamemsg"></span>
                  </td>
                  <td>
                    <input type="radio" name="packageMatchAction" value="alternateExisting"/> Select an existing package to update :
                    <input type="text" id="packageSelect2" name="packageToUpdate" />
                  </td>
                </tr>
              </table>
            </g:else>

            <h3>Package Properties</h3>
            <table class="table">
              <tbody>
                <tr> <td>Package Start Date</td> <td> <input id="package_start_date" class="form-control" type="date" name="overrideStartDate" required/> </td> </tr>
                <tr> <td>Package End Date</td> <td> <input id="package_end_date" class="form-control" type="date" name="overrideEndDate"  required/> </td> </tr>
                <tr> <td>Content Provider</td> <td> <input type="text" name="overrideContentProvider" value="" class="OrgLookup form-control" /></td> </tr>
                <tr> <td>Consortium</td> <td> <input type="text" name="overrideConsortium" value="" class="OrgLookup form-control"/> </td> </tr>
                <tr> <td>Package Scope</td> <td> <select id="pkgScopeCtrl" name="overridePackageScope" value="" class="ScopeLookup form-control"/>
                         <option value="Aggregator">Aggregator</option>
                         <option value="Front File">Front File</option>
                         <option value="Back File">Back File</option>
                         <option value="Master File">Master File</option>
                         <option value="Scope Undefined">Scope Undefined</option>
                       </select>
                     </td> </tr>
              </tbody>
            </table>

            <h3>Titles in this package</h3>
            <table class="table">
              <thead>
                <tr>
                  <th>Override</th>
                  <g:each in="${validationResult.soHeaderLine}" var="c">
                    <th>${c}</th>
                  </g:each>
                </tr>
              </thead>
              <tbody>
                <g:each in="${validationResult.tipps}" var="tipp" status="rc">

                  <tr>
                    <td><input type="checkbox" name="override_${rc}"/></td>
                    <g:each in="${tipp.row}" var="c">
                      <td>${c}</td>
                    </g:each>
                  </tr>

                  <g:if test="${tipp.messages?.size() > 0}">
                    <tr>
                      <td colspan="${validationResult.soHeaderLine.size()}">
                        <ul>
                          <g:each in="${tipp.messages}" var="msg">
                            <g:if test="${msg instanceof java.lang.String || msg instanceof org.codehaus.groovy.runtime.GStringImpl}">
                              <div class="alert alert-error">${msg}</div>
                            </g:if>
                            <g:else>
                              <div class="alert ${msg.type}">${msg.message}</div>
                            </g:else>
                          </g:each>
                        </ul>
                      </td>
                    </tr>
                  </g:if>
                </g:each>
              </tbody>
            </table>
          </g:form>

        </g:if>

      </div>
      -->
<!--LEGACY-->

    <script type="text/javascript">
      function setupPage() {
        $("#packageSelect").select2({
          placeholder: "Select an existing Package..",
          width: '100%',
          minimumInputLength: 1,
          ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
            url: "<g:createLink controller='ajax' action='lookup'/>",
            dataType: 'json',
            data: function (term, page) {
              return {
                format:'json',
                q: term,
                baseClass:'com.k_int.kbplus.Package'
              };
            },
            results: function (data, page) {
              return {results: data.values};
            }
          }
        });
        
        $("#packageSelect2").select2({
          placeholder: "Select an existing Package..",
          width: '100%',
          minimumInputLength: 1,
          ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
            url: "<g:createLink controller='ajax' action='lookup'/>",
            dataType: 'json',
            data: function (term, page) {
              return {
                format:'json',
                q: term,
                baseClass:'com.k_int.kbplus.Package'
              };
            },
            results: function (data, page) {
              return {results: data.values};
            }
          }
        });

        $("#new_package_name").attr( "autocomplete", "off" );
        $("#new_package_name").keyup(function() {
          var pkgname = $("#new_package_name").val();
          console.log("Looking up %o",pkgname);
          
          $.ajax({
            url: "<g:createLink controller='ajax' action='lookup'/>",
            dataType: 'json',
            data: {
              format:'json',
              q: pkgname,
              baseClass:'com.k_int.kbplus.Org'//should this not be package???? To check with II
            }
          }).done(function(data) {
            console.log("done %o",data);
            var ok = false;
            if ( data.values ) {
              if ( data.values.length == 0 ) {
                ok = true;
              }
            }
            
            if ( ok ) {
              $('#pkgnamemsg').html("Proposed Package Name OK");
              $("#new_package_name").removeClass('invalid');
              $("#new_package_name").addClass('valid');
            }
            else {
              $('#pkgnamemsg').html("<strong>ERROR - package already exists</strong>");
              $("#new_package_name").removeClass('valid');
              $("#new_package_name").addClass('invalid');
            }
          }).fail(function(e) {
            console.log("Problem %e",e);
          });
          
          console.log("Returning");
        });
        
        $(".OrgLookup").select2({
          placeholder: "Select an existing organisation..",
          width: '100%',
          minimumInputLength: 1,
          ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
            url: "<g:createLink controller='ajax' action='lookup'/>",
            dataType: 'json',
            data: function (term, page) {
              return {
                format:'json',
                q: term,
                baseClass:'com.k_int.kbplus.Org'
              };
            },
            results: function (data, page) {
              return {results: data.values};
            }
          },
          createSearchChoice:function(term, data) {
            return {id:'com.k_int.kbplus.Org:__new__:'+term,text:term};
          }
        });
      }

      //Timout increased from 1000 as workaround for page load time issue - Zendesk #3333
      setTimeout(function() {setupPage(); }, 5000);
      
      function validateForm() {
        console.log("validate");
        var actiontype = $('input:radio[name="packageMatchAction"]:checked').val();
        var result = true;
        
        if ( actiontype==='newPackage' ) {
          var pkgname = $('input:text[name="newPackageName"]').val();
          if ( ( pkgname === null ) || ( pkgname.length === 0 ) ) {
            console.log("No pkgname");
            result = false;
            // $('#new_package_name_2').setCustomValidity("Package name must be set for new packages.");
            alert("Package name required when creating a new package");
          }
        }
        else {
        }
        
        var cp = $('input:text[name="overrideContentProvider"]').val();
        if ( ( cp === null ) || ( cp.length === 0 ) ) {
          result = false;
          alert("Please specify a content provider");
        }
        
        return result;
      }
    </script>
  </body>
</html>
