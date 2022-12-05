<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <parameter name="pagetitle" value="Data Manager Dashboard" />
    <parameter name="pagestyle" value="data-manager" />
    <title>KB+ Data Manager Dashboard</title>
  </head>

  <body class="data-manager">


  <!--page title start-->
<div class="row">
    <div class="col s12 l12">
        <h1 class="page-title left">Data Manager Dashboard</h1>
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


  <g:if test="${pendingChanges?.size() > 0}">
    <div class="row">
     <div class="col s12">
      <div class="row tab-table z-depth-1">
      <h2>Packages with pending changes</h2>
      <table class="table bordered">
        <thead>
          <tr>
            <td>Info</td>
            <td>Action</td>
          </tr>
        </thead>
        <tbody>
          <g:each in="${pendingChanges}" var="pc">
            <tr>
              <td><g:link controller="packageDetails" action="show" id="${pc.pkg.id}">${pc.pkg.name}</g:link> <br/>${pc.desc}</td>
              <td>
                <g:link controller="pendingChange" action="accept" id="${pc.id}" class="btn btn-success"><i class="icon-white icon-ok"></i>Accept</g:link>
                <g:link controller="pendingChange" action="reject" id="${pc.id}" class="btn btn-danger"><i class="icon-white icon-remove"></i>Reject</g:link>
              </td>
            </tr>
          </g:each>
        </tbody>
      </table>
    </div>
    </div>
    </div>
  </g:if>
  <g:else>

   
    <div class="row">
      <div class="col s12">
        <div class="card-panel blue lighten-1">
          <span class="white-text">No pending package changes</span>
        </div>
      </div>
    </div>

  </g:else>




  <!-- legacy -->
    <!-- <div class="container">
      <ul class="breadcrumb">
        <li> <g:link controller="home" action="index">Home</g:link> <span class="divider">/</span> </li>
        <li> <g:link controller="dataManager" action="index">Data Manager Dashboard</g:link> </li>
      </ul>
    </div>

    <g:if test="${flash.message}">
      <div class="container">
        <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
      </div>
    </g:if>

    <g:if test="${flash.error}">
      <div class="container">
        <bootstrap:alert class="error-info">${flash.error}</bootstrap:alert>
      </div>
    </g:if>

    <div class="container">
      <h2>Data Manager Dashboard</h2>
    </div>

    <g:if test="${pendingChanges?.size() > 0}">
      <div class="container alert-warn">
        <h6>Packages with pending changes</h6>
        <table class="table table-bordered">
          <thead>
            <tr>
              <td>Info</td>
              <td>Action</td>
            </tr>
          </thead>
          <tbody>
            <g:each in="${pendingChanges}" var="pc">
              <tr>
                <td><g:link controller="packageDetails" action="show" id="${pc.pkg.id}">${pc.pkg.name}</g:link> <br/>${pc.desc}</td>
                <td>
                  <g:link controller="pendingChange" action="accept" id="${pc.id}" class="btn btn-success"><i class="icon-white icon-ok"></i>Accept</g:link>
                  <g:link controller="pendingChange" action="reject" id="${pc.id}" class="btn btn-danger"><i class="icon-white icon-remove"></i>Reject</g:link>
                </td>
              </tr>
            </g:each>
          </tbody>
        </table>
      </div>
    </g:if>
    <g:else>
      <div class="container alert-warn">
        <h6>No pending package changes</h6>
      </div class="container alert-warn">
    </g:else>
 -->
  </body>
</html>
