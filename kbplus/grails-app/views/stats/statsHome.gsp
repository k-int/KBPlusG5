<!doctype html>
<html>
<head>
  <meta name="layout" content="base"/>
  <title>KB+ Data import explorer</title>
    <parameter name="pagetitle" value="Statistics" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="stats" />
    <r:require module='annotations' />
</head>

  <body class="admin">
        <!--page title start-->
  <div class="row">
       <div class="col s12 l12">
          <h1 class="page-title left">Statistics</h1>
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
                            <th>Institution</th>
                            <th>Affiliated Users</th>
                            <th>Total subscriptions</th>
                            <th>Current subscriptions</th>
                            <th>Total licenses</th>
                            <th>Current licenses</th>
                          </tr>
                        </thead>

                        <tbody>
                          <g:each in="${orginfo}" var="is">
                            <tr>
                              <td>${is.key.name}</td>
                              <td>${is.value['userCount']}</td>
                              <td>${is.value['subCount']}</td>
                              <td>${is.value['currentSoCount']}</td>
                              <td>${is.value['licCount']}</td>
                              <td>${is.value['currentLicCount']}</td>
                            </tr>
                          </g:each>

                        </tbody>
                  </table>


                  </div>

          </div>
          <!--***table end***-->
</body>
</html>
