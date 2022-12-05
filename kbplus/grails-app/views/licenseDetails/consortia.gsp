<!doctype html>
<%@ page import="com.k_int.custprops.PropertyDefinition" %>
<%@ page import="com.k_int.kbplus.RefdataValue" %>
<%
  def workoutLicenceIcon = { icon, note ->
    def result = ["no", "clear"]
    if (icon.equals("greenTick")) {
      result = ["yes", "done", note]
    }
    else if (icon.equals("purpleQuestion"))
    {
      result = ["neither", "info_outline", note]
    }
    else if (icon.equals("redCross")) {
      result = ["no", "clear", note]
    }
    else {
      result = ["", "", note]
    }

    result
  }

  def keyPropsDisplay = { props ->
    def result = [:]
    def keyProps = ["Include in VLE", "Include In Coursepacks", "ILL - InterLibraryLoans", "Walk In Access", "Remote Access", "Alumni Access"]
    props.each { prop ->
      if ((prop?.type?.name) && (keyProps.contains(prop.type.name))) {
        result.put(prop.type.name, workoutLicenceIcon(prop?.refValue?.icon, prop?.note))
      }
    }

    if (result.size() < keyProps.size()) {
      keyProps.each { kp ->
        if (!result.containsKey(kp)) {
          result.put(kp, ["", "", null])
        }
      }
    }

    result
  }
%>

<html lang="en" class="no-js">
  <head>
    <meta name="layout" content="base"/>
    <parameter name="actionrow" value="licences-compare" />
    <parameter name="pagetitle" value="Licence Consortia" />
    <title>KB+ :: Licence Details</title>
  </head>
  <body class="licences">
	<div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">${license?.reference}</h1>
      </div>
    </div>
    <div class="row">
      <div class="col s12 l12">
    	<h2 class="list-response text-navy left">
    	  The following list displays all members of ${consortia.name} consortia. To create child licences select the desired checkboxes and click 'Create child licences'
    	</h2>
      </div>
    </div>
    <!--page title end-->
    
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
    <g:form action="generateSlaveLicences" controller="licenseDetails" method="POST">
      <input type="hidden" name="baselicense" value="${license.id}"/>
      <input type="hidden" name="id" value="${id}"/>
      <div class="row">
	    <div class="col s12">
	      <div class="row tab-table z-depth-1">
	        <!--***table***-->
	        <div class="tab-content">
	          <div class="row table-responsive-scroll">
	            <table class="highlight bordered">
                  <thead>
                    <tr>
                      <th>Organisation</th>
                      <th>Contains  Licence Copy </th>
                      <th>Create Child Licence</th>
                    </tr>
                  </thead>
                  <tbody>
                    <g:each in="${consortiaInstsWithStatus}" var="pair">
                      <tr>
                        <td>${pair.getKey().name}</td>
                        <td><g:refdataValue cat="YNO" val="${pair.getValue()}" /></td>
                        <td>
                          <g:if test="${editable}">
                            <input type="checkbox" name="_create.${pair.getKey().id}" id="_create.${pair.getKey().id}"/>
                            <label for="_create.${pair.getKey().id}">&nbsp;</label>
                          </g:if>
                        </td>
                      </tr>
                    </g:each>
                  </tbody>
                </table>
              </div>
			</div>
		  </div>
		</div>
	  </div>
	  <div class="row">
	    <div class="col s12">
	      <div class="col s12 m12 l8">
            <div class="input-field">
              <input type="text" name="lic_name" value="Child licence for ${license?.reference}"/>
              <label>Licence name</label>
            </div>
          </div>
          <div class="col s12 m12 l4">
            <div class="input-field">
              <input type="submit" class="btn btn-primary" value="Create child licences"/>
            </div>
          </div>
        </div>
      </div>
    </g:form>
  </body>
</html>