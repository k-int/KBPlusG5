<!doctype html>
<html>
<head>
  <meta name="layout" content="base"/>
  <title>KB+ Admin::System settings</title>
    <parameter name="pagetitle" value="System settings" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
    <r:require module='annotations' />
</head>

  <body class="admin">
        <!--page title start-->
  <div class="row">
       <div class="col s12 l12">
          <h1 class="page-title left">System settings</h1>
       </div>
    </div>
    <!--page title end-->
    <!--***tabular data***-->
    <div class="row">

      <div class="col s12">
        <div class="tab-table z-depth-1">

        <!--***table***-->
          <div id="financials" class="tab-content">

               <div class="row table-responsive-scroll">

                    <table class="highlight bordered ">
                        <thead>
                          <tr>
                            <td>Setting</td>
                            <td>Value</td>
                          </tr>
                        </thead>

                        <tbody>
                          <g:each in="${settings}" var="s">
                            <tr>
                              <td>${s.name}</td>
                              <td>
                                <g:if test="${s.tp==1}">
                                  <g:link controller="admin" action="toggleBoolSetting" params="${[setting:s.name]}">${s.value}</g:link>
                                </g:if>
                              </td>
                            </tr>
                          </g:each>

                        </tbody>
                  </table>


                  </div>

          </div>
          <!--***table end***-->

  </body>
</html>
