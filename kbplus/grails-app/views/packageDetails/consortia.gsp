<!doctype html>
<%@ page import="java.text.SimpleDateFormat"%>
<%
  def dateFormatter = new SimpleDateFormat("yy-MM-dd HH:mm:ss.SSS")
%>
<html lang="en" class="no-js">
  <head>
	<parameter name="pagetitle" value="Package Consortia" />
	<parameter name="pagestyle" value="Packages" />
	<parameter name="actionrow" value="packages-all" />
	<meta name="layout" content="base"/>
	<title>KB+ Packages</title>
  </head>
  <body class="packages">
	<div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">${packageInstance?.name}</h1>
      </div>
    </div>
    <div class="row">
      <div class="col s12 l12">
    	<h2 class="list-response text-navy left">
    	  The following list displays all members of ${consortia.name} consortia. To create child subscriptions select the desired checkboxes and click 'Create child subscriptions'
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
    <g:form action="generateSlaveSubscriptions" controller="packageDetails" method="POST">
	  <g:hiddenField name="id" value="${id}" />
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
					    <th>Contains Package</th>
					    <th>Create Child Subscription</th>
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
              <input type="text" name="genSubName" value="Child subscription for ${packageInstance?.name}"/>
              <label>Subscription name</label>
            </div>
          </div>
          <div class="col s12 m12 l4">
            <div class="input-field">
		      <input type="submit" class="btn btn-primary" value="Create child subscriptions"/>
		    </div>
		  </div>
        </div>
      </div>
	</g:form>
  </body>
</html>