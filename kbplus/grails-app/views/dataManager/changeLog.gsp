<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <parameter name="pagetitle" value="Data Manager Change Log" />
    <parameter name="pagestyle" value="data-manager" />
    <parameter name="actionrow" value="data-manager-change-log" />
    <title>KB+ Data Manager Change Log</title>
  </head>

  <body class="data-manager">

  <!--page title start-->
  <div class="row">
      <div class="col s12 l12">
          <h1 class="page-title left">Data Manager Change Log</h1>
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

    <div class="row">
      <div class="col s12">

  
        <div class="tab-table z-depth-1">

          <div class="tab-content">

          <g:form action="changeLog" controller="dataManager" method="get">
        
          <div class="col s12 l6 mt-10">
            <div class="input-field">
              <g:kbplusDatePicker inputid="start_date" name="startDate" value="${params.startDate}"/>
              <label class="active">From Date</label>
            </div>
          </div>
          <div class="col s12 l6 mt-10">
            <div class="input-field">
              <g:kbplusDatePicker inputid="end_date" name="endDate" value="${params.endDate}"/>
              <label class="active">To Date</label>
            </div>
          </div>
          
          <div class="col s12 l6 mt-10">
            <label>Select Actors</label>
            <div class="input-field">
                <div class="col s12">
                  <input type="checkbox" id="test5" name="change_actor_PEOPLE" value="Y" ${params.change_actor_PEOPLE == "Y" ? 'checked' : ''} />
                  <label for="test5">ALL (Real Users)</label>
                </div>
                <div class="col s12">
                  <input type="checkbox" id="test6" name="change_actor_ALL" value="Y" ${params.change_actor_ALL == "Y" ? 'checked' : ''} />
                  <label for="test6">ALL (Including system)</label>
                </div>
            </div>
          </div>

          <div class="col s12 l6 mt-10">
            <div class="input-field">
              <select name="change_actor[]" multiple>
                  <option value="" disabled selected>Choose from list</option>
                  <g:each in="${actors}" var="a">
                     <option value="change_actor_${a[0]}" ${params."change_actor_${a[0]}" == "Y" ? 'selected' : ''} >${a[1]}</option>
                  </g:each>
                </select>
            </div>
          </div>

          <div class="col s12 mt-30">
            <label>What's Changed:</label>
            <div class="input-field">
                <div class="col s6 m3">
                  <input id="_packages" type="checkbox" name="packages" value="Y" ${params.packages=='Y'?'checked':''} />
                  <label for="_packages">Packages</label>
                </div>
                <div class="col s6 m3">
                  <input type="checkbox" id="_licence" value="Y" name="licenses" ${params.licenses=='Y'?'checked':''} />
                  <label for="_licence"><g:message code="licence" default="Licence"/>s</label>
                </div>
                <div class="col s6 m3">
                  <input type="checkbox" id="_titles" value="Y" name="titles" ${params.titles=='Y'?'checked':''} />
                  <label for="_titles">Titles</label>
                </div>
                <div class="col s6 m3">
                  <input type="checkbox" id="_TIPPS" value="Y" name="tipps" ${params.tipps=='Y'?'checked':''} />
                  <label for="_TIPPS">TIPPS</label>
                </div>
            
            </div>
          </div>    


          <div class="col s12 mt-30">
            <label>How has it changed:</label>
            <div class="input-field">
               <div class="col s6 m3">
                  <input type="checkbox" id="_newitems"  name="creates" value="Y" ${params.creates=='Y'?'checked':''} />
                  <label for="_newitems">New Items</label>
                </div>
                <div class="col s6 m3">
                  <input type="checkbox" id="_updates" name="updates" value="Y" ${params.updates=='Y'?'checked':''} />
                  <label for="_updates">Updates to existing items</label>
                </div>
            
            </div>
          </div>    

          <div class="col s6 m6 l2 mt-30">
            <button type="submit" name="search" value="yes" class="waves-effect waves-teal btn">Submit</button>
          </div>

          </g:form>
        </div>

        </div>

      </div>
    </div>
    <!-- search-section end-->

    <g:set var="counter" value="${offset?:-1 +1}" />

    <g:if test="${formattedHistoryLines?.size() > 0}">

    <!-- list returning/results-->
    <div class="row">
      <div class="col s12 page-response">
        <h2 class="list-response text-navy"Change Log <span class="pull-right">${num_hl} changes</span></h2>
      </div>
    </div>


    
    <!--page intro and error start-->
    <div class="row">
        <div class="col s12">
            <div class="row tab-table z-depth-1">

              <g:set var="counter" value="${offset?:-1 +1}" />

              <g:if test="${formattedHistoryLines?.size() > 0}">

                <g:link action="changeLog"> 
                   <input type="button" value="Clear Search" class="btn btn-danger"/> 
                </g:link>

                <!--***table***-->
                  <div class="tab-content">

                       <div class="row table-responsive-scroll">
                            <table class="highlight bordered">
                                <thead>
                                  <tr>
                                    <td></td>
                                    <td>Name</td>
                                    <td>Actor</td>
                                    <td>Event name</td>
                                    <td>Property</td>
                                    <td>Old</td>
                                    <td>New</td>
                                    <td>Timestamp</td>
                                  </tr>
                                </thead>
                                <tbody>
                                  <g:each in="${formattedHistoryLines}" var="hl">
                                    <tr>
                                      <td>${counter++}</td>
                                      <td><a href="${hl.link}">${hl.name}</a></td>
                                      <td>
                                        <g:link controller="userDetails" action="edit" id="${hl.actor?.id}">${hl.actor?.displayName}</g:link>
                                      </td>
                                      <td>${hl.eventName}</td>
                                      <td>${hl.propertyName}</td>
                                      <td>${hl.oldValue}</td>
                                      <td>${hl.newValue}</td>
                                      <td>${hl.lastUpdated}</td>
                                    </tr>
                                  </g:each>
                                </tbody>
                            </table>
                        </div>
                  </div>
              </g:if>

            </div>
        </div>

        <div class="pagination" style="text-align:center">
          <g:if test="${historyLines != null}" >
            <g:paginate  action="changeLog" controller="dataManager" params="${params}" next="Next" prev="Prev" maxsteps="${max}" total="${num_hl}" />
          </g:if>
        </div>

    </div>        

    </g:if>
<!--legacy-->
  <!--   <div class="container">
      <ul class="breadcrumb">
        <li> <g:link controller="home" action="index">Home</g:link> <span class="divider">/</span> </li>
        <li> <g:link controller="dataManager" action="index">Data Manager Change Log</g:link> <span class="divider">/</span> </li>
        <li> <g:link controller="dataManager" action="changeLog">DM Change log</g:link> </li>

        <li class="dropdown pull-right">
          <a class="dropdown-toggle badge" id="export-menu" role="button" data-toggle="dropdown" data-target="#" href="">Exports<b class="caret"></b></a>
          <ul class="dropdown-menu filtering-dropdown-menu" role="menu" aria-labelledby="export-menu">
            <li><g:link controller="dataManager" action="changeLog" params="${params+[format:'csv']}">CSV Export</g:link></li>
          </ul>
        </li>

      </ul>
    </div>

    <g:if test="${flash.message}">
      <div class="container">
        <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
      </div>
    </g:if>

    <g:if test="${flash.error}">
      <div class="container">
        <bootstrap:alert class="alert-error">${flash.error}</bootstrap:alert>
      </div>
    </g:if>

    <div class="container">
      <h2>Data Manager Change Log</h2>
      <h6>Change Log <span class="pull-right">${num_hl} changes</span></h6>
      <g:form action="changeLog" controller="dataManager" method="get">
        From Date:
            <div class="input-append date">
              <input class="span2 datepicker-class" size="16" type="text" 
              name="startDate" value="${params.startDate}">
              <span class="add-on"><i class="icon-th"></i></span> 
            </div>

        To Date:
            <div class="input-append date">
              <input class="span2 datepicker-class" size="16" type="text" 
              name="endDate" value="${params.endDate}">
              <span class="add-on"><i class="icon-th"></i></span> 
            </div>
        <div class="dropdown">
        Actor : 
        <a class="dropdown-toggle btn" data-toggle="dropdown" href="#">
            Select Actors
            <b class="caret"></b>
        </a>
        <ul class="dropdown-checkboxes dropdown-menu" role="menu">
            <li>
                <label class="checkbox">
                    <input type="checkbox" name="change_actor_PEOPLE" value="Y" ${params.change_actor_PEOPLE == "Y" ? 'checked' : ''} >
                    ALL (Real Users)
                </label>
            </li>
            <li>
                <label class="checkbox">
                    <input type="checkbox" name="change_actor_ALL" value="Y" ${params.change_actor_ALL == "Y" ? 'checked' : ''} >
                    ALL (Including system)
                </label>
            </li>
            <g:each in="${actors}" var="a">

               <li>
                  <label class="checkbox">
                      <input type="checkbox" name="change_actor_${a[0]}" value="Y"
                        ${params."change_actor_${a[0]}" == "Y" ? 'checked' : ''} >
                        ${a[1]}
                  </label>                
              </li>
            </g:each>
        </ul>
      </div>

        <br/>

        Whats Changed :
        <input type="checkbox" name="packages" value="Y" ${params.packages=='Y'?'checked':''}/> Packages &nbsp;
        <input type="checkbox" name="licenses" value="Y" ${params.licenses=='Y'?'checked':''}/> <g:message code="licence" default="Licence"/>s &nbsp;
        <input type="checkbox" name="titles" value="Y" ${params.titles=='Y'?'checked':''}/> Titles &nbsp;
        <input type="checkbox" name="tipps" value="Y" ${params.tipps=='Y'?'checked':''}/> TIPPs &nbsp; <br/>
        How has it changed :
        <input type="checkbox" name="creates" value="Y" ${params.creates=='Y'?'checked':''}/> New Items &nbsp;
        <input type="checkbox" name="updates" value="Y" ${params.updates=='Y'?'checked':''}/> Updates to existing items&nbsp;
        <input  class="btn btn-primary" type="submit"/>
      </g:form>

    </div>

    <g:set var="counter" value="${offset?:-1 +1}" />

    <g:if test="${formattedHistoryLines?.size() > 0}">

      <div class="container alert-warn">

      <g:link action="changeLog"> 
         <input type="button" value="Clear Search" class="btn btn-danger"/> 
      </g:link>

        <table class="table table-bordered">
          <thead>
            <tr>
              <td></td>
              <td>Name</td>
              <td>Actor</td>
              <td>Event name</td>
              <td>Property</td>
              <td>Old</td>
              <td>New</td>
              <td>Timestamp</td>
            </tr>
          </thead>
          <tbody>
            <g:each in="${formattedHistoryLines}" var="hl">
              <tr>
                <td>${counter++}</td>
                <td><a href="${hl.link}">${hl.name}</a></td>
                <td>
                  <g:link controller="userDetails" action="edit" id="${hl.actor?.id}">${hl.actor?.displayName}</g:link>
                </td>
                <td>${hl.eventName}</td>
                <td>${hl.propertyName}</td>
                <td>${hl.oldValue}</td>
                <td>${hl.newValue}</td>
                <td>${hl.lastUpdated}</td>
              </tr>
            </g:each>
          </tbody>
        </table>
      </div>

      <div class="pagination" style="text-align:center">
        <g:if test="${historyLines != null}" >
          <bootstrap:paginate  action="changeLog" controller="dataManager" params="${params}" next="Next" prev="Prev" maxsteps="${max}" total="${num_hl}" />
        </g:if>
      </div>

    </g:if>
    <g:else>
      <div class="container alert-warn">
      </div>
    </g:else>


     -->
    <script language="JavaScript">
    window.setTimeout(function(){
      $('.dropdown-menu').on('click', function(e) {
      if($(this).hasClass('dropdown-checkboxes')) {
          e.stopPropagation();
      }});

      // $(".datepicker-class").datepicker({
      //   format: "yyyy-mm-dd"
      // });
      }, 100)
  </script>


  
  </body>
</html>
