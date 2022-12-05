<%@ page import="com.k_int.kbplus.Org; com.k_int.custprops.PropertyDefinition" %>

<!doctype html>
<html>
  <head>
    <meta name="layout" content="base">
    <parameter name="pagetitle" value="App Configuration" />
    <title>KB+ App Config</title>
  </head>
  <body class="admin">
    <!--page title start-->
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">App Configuration</h1>
      </div>
    </div>
    <!--page title end-->
    
    <!--page intro and error start-->
    <div class="row">
      <div class="col s12">
        <div class="tab-table z-depth-1">
          <h4 class="mb-20">${message(code:'sys.properties')}</h4>
          <div class="row table-responsive-scroll">
            <table class="highlight bordered">
              <thead>
                <tr>
                  <th>Properties</th>
                  <th>Values</th>
                  <th>Note</th>
                  <th>Actions</th>
                  <th><a href="#kbmodal" ajax-url="${createLink(controller:'ajax', action:'addCustomPropertyModal', params:[prop_desc:PropertyDefinition.SYS_CONF, ownerId:adminObj.id, ownerClass:adminObj.class.name, editable:editable, propBaseClass:'com.k_int.custprops.PropertyDefinition', theme:'admin'])}" class="btn right modalButton"><i class="material-icons right">add_circle_outline</i>Add Properties</a></th>
                </tr>
              </thead>
              <tbody>
                <g:if test="${adminObj.customProperties}">
                  <g:each in="${adminObj.customProperties}" var="prop">
                    <tr>
                      <td>${prop.type.name}</td>
                      <td>
                        <g:if test="${prop.type.type == Integer.toString()}">
                          ${prop.intValue}
                        </g:if>
                        <g:elseif test="${prop.type.type == String.toString()}">
                          ${prop.stringValue}
                        </g:elseif>
                        <g:elseif test="${prop.type.type == BigDecimal.toString()}">
                          ${prop.decValue}
                        </g:elseif>
                        <g:elseif test="${prop.type.type == RefdataValue.toString()}">
                          ${prop?.refValue?.value}
                        </g:elseif>
                      </td>
                      <td>${prop.note}</td>
                      <td>
                        <g:if test="${editable == true}">
                          <a href="#kbmodal" ajax-url="${createLink(controller:'ajax', action:'editCustomProperty', id:prop.id, params:[propclass:prop.getClass(), ownerId:adminObj.id, ownerClass:adminObj.class.name, editable:editable, referer:'Y', theme:'admin'])}" class="btn-floating table-action hide-on-small-and-down modalButton"><i class="material-icons">create</i></a>
                          <g:link controller="ajax"
                                  action="delCustomProperty"
                                  id="${prop.id}"
                                  params="${[propclass: prop.getClass(),ownerId:adminObj.id,ownerClass:adminObj.class.name, editable:editable, referer:'Y']}"
                                  onclick="return confirm('Delete the property ${prop.type.name}?')"
                                  class="btn-floating table-action">
                            <i class="material-icons">delete_forever</i>
                          </g:link>
                        </g:if>
                      </td>
                      <td></td>
                    </tr>
                  </g:each>
                </g:if>
                <g:else>
                  <tr><td colspan="5">No Data Currently Added</td></tr>
                </g:else>
              </tbody>
            </table>
          </div>
          
          <g:form action="appConfig" method="POST">
            <input type="submit" name="one"class="btn"value="Refresh"  />
          </g:form>
        </div>
      </div>
    </div>
          
    <div class="row">
      <div class="col s12">
        <div class="tab-table z-depth-1">
          <h3>Current output for Holders.config</h3>
          <div class="row table-responsive-scroll">
            <table class="highlight bordered">
              <thead>
                <th>Key</th>
                <th>Content</th>
              </thead>
              <tbody>
                <g:each in="${currentconf.keySet().sort()}" var="key">
                  <tr>
                    <td width="20%">${key}</td>
                    <td>${currentconf.get(key)}</td>
                  </tr>
                </g:each>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    
<!--legacy-->

<!-- <div class="container">

    <h6>${message(code:'sys.properties')}</h6>
    <div id="custom_props_div" class="span12">
        <g:render template="/templates/custom_props" model="${[ prop_desc:PropertyDefinition.SYS_CONF,ownobj:adminObj ]}"/>
    </div>
    <g:form action="appConfig" method="POST">
        <input type="submit" name="one"class="btn"value="Refresh"  />
    </g:form>
    <h3> Current output for Holders.config</h3>
    <ul>
        <g:each in="${currentconf.keySet().sort()}" var="key">
            <li>${key}: &nbsp; &nbsp; <input readonly="" name="key" value="${currentconf.get(key)}"/> </li>
        </g:each>
        <ul>
</div> -->
<!--legacy end-->

  </body>
</html>
