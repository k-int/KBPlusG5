<%@ page import="com.k_int.kbplus.RefdataValue; com.k_int.custprops.PropertyDefinition" %>
<!doctype html>
<html>
  <head>
    <meta name="layout" content="base">
    <g:set var="entityName" value="${message(code: 'propertyDefinition.label', default: 'Property Definition')}"/>
    <parameter name="pagetitle" value="Edit ${entityName}" />
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
    <parameter name="actionrow" value="none" />
  </head>
  <body class="admin">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">Edit ${entityName}</h1>
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
    
    <g:hasErrors bean="${propDefInstance}">
      <div class="row">
        <div class="col s12">
          <div class="card-panel red lighten-1">
            <span class="white-text">
              <ul>
                <g:eachError bean="${propDefInstance}" var="error">
                  <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                </g:eachError>
              </ul>
            </span>
          </div>
        </div>
      </div>
    </g:hasErrors>
    
    <div class="row">
      <div class="col s12">
        <div class="row strip-table z-depth-1">
          <g:set var="usages" value="${propDefInstance.countOccurrences('com.k_int.kbplus.LicenseCustomProperty','com.k_int.kbplus.SystemAdminCustomProperty','com.k_int.kbplus.OrgCustomProperty')}" />
          <g:set var="usageOwner" value="${propDefInstance.getOccurrencesOwner('com.k_int.kbplus.LicenseCustomProperty','com.k_int.kbplus.SystemAdminCustomProperty','com.k_int.kbplus.OrgCustomProperty')}" />
          <g:form controller="propertyDefinition" action="edit" id="${propDefInstance?.id}" class="col s12">
            <g:hiddenField name="version" value="${propDefInstance?.version}"/>
            <input type="hidden" name="redirect" value="yes"/>
            <input type="hidden" name="ownerClass" value="${this.class}"/>
            
            <div class="row">
              <div class="input-field col s12">
                <input class="validate" type="text"  <%= ( editable ) ? '' : 'disabled' %> name="name" value="${propDefInstance.name}" required="" id="name">
                <label for="name">Name</label>
              </div>
            </div>
            
            <div class="row">
              <div class="input-field col s6">
                <g:select name="type" disabled="${!editable}" value="${propDefInstance.type}"
                          from="${PropertyDefinition.validTypes.entrySet()}"
                          optionKey="value" optionValue="key" id="type"/>
                <label>Type</label>
              </div>
              <div class="input-field col s6">
                <g:select name="descr" disabled="${!editable}" value="${propDefInstance.descr}" from="${PropertyDefinition.AVAILABLE_DESCR}" />
                <label>Context</label>
              </div>
            </div>
            
            <div id="cust_prop_ref_data_name" style="display: none;">
              <div class="row">
                <div class="input-field col s6">
                  <label class="property-label select2label">Refdata Category</label>
                  <input type="hidden" <%= ( editable ) ? '' : 'disabled' %> name="refdataCategory" value="${propDefInstance.refdataCategory}" id="refDataCategory"/>
                </div>
              </div>
            </div>
            
            <div class="row">
              <div class="input-field col s6">
                <input placeholder="" type="text" disabled="" readonly class="validate" value="${usages}">
                <label for="">Occurrences</label>
              </div>
              <div class="input-field col s6">
                <div class="row">
                  <div class="col s12">
                    <div class="card-content">
                      <span class="card-title" style="font-size: 0.8rem;">Occurrence Owners</span>
                    </div>
                    <div class="card-panel white" style="max-height: 300px;overflow: scroll;">
                      <ul>
                        <g:each in="${usageOwner}" var="${cls}">
                          <g:each in="${cls}" var="${ownerInstance}">
                            <li>${ownerInstance.getClass().getName()}:${ownerInstance.id}</li>
                          </g:each>
                        </g:each>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="row">
              <div class="input-field col s6">
                <g:if test="${editable}">
                  <button type="submit" class="waves-effect waves-light btn">
                    Update Property
                  </button>
                </g:if>
                <g:else>
                  You do not have permission to edit properties
                </g:else>
              </div>

              <div class="input-field col s6 <%= ( ( usages == 0  ) ) ? '' : 'disabled' %>">
                <g:if test="${editable}">
                  <button type="submit" <%= ( ( usages == 0  ) ) ? '' : 'disabled' %> class="waves-effect waves-light btn" name="_action_delete" formnovalidate>
                    Delete Property
                  </button>
                </g:if>
                <g:else>
                  You do not have permission to delete properties
                </g:else>
              </div>
            </div>
          </g:form>
        </div>
      </div>
    </div>
    
<!-- legacy -->
<!--
<div class="row-fluid">
    <div class="span3">
        <div class="well">
            <ul class="nav nav-list">
                <li class="nav-header">${entityName}</li>
                <li>
                    <g:link class="list" action="list">
                        <i class="icon-list"></i>
                        <g:message code="default.list.label" args="[entityName]"/>
                    </g:link>
                </li>
                <li>
                	<g:if test="${editable}">
                    	<g:link class="create" action="create">
                        	<i class="icon-plus"></i>
                        	<g:message code="default.create.label" args="[entityName]"/>
                    	</g:link>
                    </g:if>
                </li>
            </ul>
        </div>
    </div>

    <div class="container">
        <div class="page-header">
            <h1><g:message code="default.edit.label" args="[entityName]"/></h1>
        </div>

        <g:if test="${flash.message}">
            <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
        </g:if>

        <g:hasErrors bean="${propDefInstance}">
            <bootstrap:alert class="alert-error">
                <ul>
                    <g:eachError bean="${propDefInstance}" var="error">
                        <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                                error="${error}"/></li>
                    </g:eachError>
                </ul>
            </bootstrap:alert>
        </g:hasErrors>

        <fieldset>
              <g:set var="usages" value="${propDefInstance.countOccurrences('com.k_int.kbplus.LicenseCustomProperty','com.k_int.kbplus.SystemAdminCustomProperty','com.k_int.kbplus.OrgCustomProperty')}" />
              <g:set var="usageOwner" value="${propDefInstance.getOccurrencesOwner('com.k_int.kbplus.LicenseCustomProperty','com.k_int.kbplus.SystemAdminCustomProperty','com.k_int.kbplus.OrgCustomProperty')}" />
            <g:form class="form-horizontal" action="edit" id="${propDefInstance?.id}">
                <g:hiddenField name="version" value="${propDefInstance?.version}"/>
                <fieldset>
                    <div class="control-group ">
                        <label class="control-label" for="name">Name</label>
                        <div class="controls">
                            <input type="text"  <%= ( editable ) ? '' : 'disabled' %> name="name" value="${propDefInstance.name}" required="" id="name">

                        </div>
                    </div>
                    <div class="control-group ">
                        <label class="control-label" for="descr">Context</label>
                        <div class="controls">
                        	<g:select name="descr" disabled="${!editable}" value="${propDefInstance.descr}" from="${PropertyDefinition.AVAILABLE_DESCR}" />
                        </div>
                    </div>
                    <div class="control-group ">
                        <label class="control-label" for="type">Type</label>
                        <div class="controls">
                            <g:select name="type" disabled="${!editable}" value="${propDefInstance.type}"
                                      from="${PropertyDefinition.validTypes.entrySet()}"
                                      optionKey="value" optionValue="key" id="type"/>
                        </div>
                    </div>
                    <div class="control-group hide" id="cust_prop_ref_data_namea">
                        <label class="control-label" for="refDataCategory">RefdataCategory</label>
                        <div class="controls">
                            <input type="hidden" <%= ( editable ) ? '' : 'disabled' %> name="refdataCategory" value="${propDefInstance.refdataCategory}"  id="refDataCategory"/>
                        </div>
                    </div>
                    <div class="control-group ">
                        <label class="control-label" for="name">Occurrences</label>
                        <div class="controls">
                            <input type="text" disabled="" value="${usages}"/>

                        </div>
                    </div>
                    <div class="control-group ">
                        <label class="control-label" for="name">Occurrence Owners</label>
                        <div class="controls">
                            <div class="well" style="width: 300px">
                            <ul class="overflow-y-scroll" style="overflow:auto; max-height: 300px;">
                                <g:each in="${usageOwner}" var="${cls}">
                                    <g:each in="${cls}" var="${ownerInstance}">
                                        <li>${ownerInstance.getClass().getName()}:${ownerInstance.id}</li>
                                    </g:each>
                                </g:each>
                            </ul>
                            </div>
                        </div>
                    </div>
                    <div class="form-actions">
                        <g:if test="${editable}">
                          <button type="submit" <%= ( ( usages == 0  ) ) ? '' : 'disabled' %> class="btn btn-danger" name="_action_delete" formnovalidate>
                              <i class="icon-trash icon-white"></i>
                              <g:message code="default.button.delete.label" default="Delete"/>
                          </button>
                        </g:if>
                        <g:else>
                          You do not have permission to delete properties
                        </g:else>
                    </div>
                </fieldset>
            </g:form>
        </fieldset>
    </div>

</div>
-->
<!-- end of legacy -->

    <script>
      console.log("${propDefInstance.refdataCategory}");
      function setupPage(){
      //Runs if type edited is Refdata
      if( $("#type option:selected").val() == "com.k_int.kbplus.RefdataValue") {
        $("#cust_prop_ref_data_name").removeAttr("style");
      }
        
      //Runs everytime type is changed
      $('#type').change(function() {
        var selectedText = $("#type option:selected").val();
        if( selectedText == "com.k_int.kbplus.RefdataValue") {
          $("#cust_prop_ref_data_name").removeAttr("style");
        }else{
          $("#cust_prop_ref_data_name").css({"display": "none"});
        }
      });
      
      $("#refDataCategory").select2({
        placeholder: "Type category...",
        width: "100%",
        initSelection : function (element, callback) {
          <g:if test="${propDefInstance.refdataCategory}">
            var data = {id: -1, text: "${propDefInstance.refdataCategory}"};
            callback(data);
          </g:if>
        },
        minimumInputLength: 1,
        ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
          url: '${createLink(controller:'ajax', action:'lookup')}',
          dataType: 'json',
          data: function (term, page) {
            return {
              q: term, // search term
              page_limit: 10,
              baseClass:'com.k_int.kbplus.RefdataCategory'
            };
          },
          results: function (data, page) {
            return {results: data.values};
          }
        }
      });
      }
      
      setTimeout(function(){ setupPage(); }, 1000);
    </script>
  </body>
</html>
