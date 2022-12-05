<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <title>KB+ Manage Global Sorces</title>
    <parameter name="pagetitle" value="Title Merge" />
    <parameter name="pagestyle" value="Admin" />
    <parameter name="actionrow" value="none" />
  </head>

  <body class="admin">
    

    <!--page title start-->
    <div class="row">
        <div class="col s12 l12">
            <h1 class="page-title left">Title Merge</h1>
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


  <!--this is just here to trigger the modal, should be removed in production-->
  <div class="row">
      <div class="col s1">
            <a href="#modal-manageGlobal" class="waves-effect btn">Add <i class="material-icons right">add_circle_outline</i></a>
       </div>
   </div>     
   <!--remove end-->  

  <!--page intro-->
  <div class="row">
      <div class="col s12">
          <div class="row tab-table z-depth-1">
            <!--***table***-->
            <div class="tab-content">
              <div class="row table-responsive-scroll">

                  <table class="highlight bordered ">
                      <thead>
                        <tr>
                          <td>Identifier</td>
                          <td>Name</td>
                          <td>Type</td>
                          <td>Up To</td>
                          <td>URL</td>
                          <td>List Prefix</td>
                          <td>Full Prefix</td>
                          <td>Principal</td>
                          <td>Credentials</td>
                          <td>RecType</td>
                          <td># Local Copies</td>
                          <td>Actions</td>
                        </tr>
                      </thead>

                      <tbody>
                        <g:each in="${sources}" var="source">
                          <tr>
                            <td>${source.identifier}</td>
                            <td>${source.name}</td>
                            <td>${source.type}</td>
                            <td>${source.haveUpTo}</td>
                            <td>${source.uri}</td>
                            <td>${source.listPrefix}</td>
                            <td>${source.fullPrefix}</td>
                            <td>${source.principal}</td>
                            <td>${source.credentials}</td>
                            <td>${source.rectype==0?'Package':'Title'}</td>
                            <td>${source.getNumberLocalPackages()}</td>
                            <td>
                              <g:link class="waves-effect waves-light btn" 
                                      controller="admin" 
                                      onclick="return confirm('Deleting this package will remove all tracking info and unlink any local packages - Are you sure?')"
                                      action="deleteGlobalSource" 
                                      id="${source.id}">Delete</g:link>
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


<!--modal form-->
    <!-- example Modal form -->
    <div id="modal-manageGlobal" class="modal bottom-sheet">
    <div class="fixed-action-btn-top">
      <a href="#!" class="z-depth-0 modal-action modal-close btn-floating btn-large waves-effect"><i class="material-icons">close</i></a>
      </div>
      <div class="modal-content">
        <div class="container">
          <div class="row">
              <div class="col s12">
                <h1 class="form-title flow-text navy-text">Mange Global Sources</h1>
                <p class="form-caption flow-text grey-text">Phasellus sit amet purus a enim aliquet blandit quis a quam. Cras suscipit eros in.</p>
                <!--form-->
                <div class="row">
                <g:form action="newGlobalSource" class="col s12">
                
                  <div class="row">
                    <div class="input-field col s6">
                      <input placeholder="eg GOKbLive" type="text" class="validate">
                      <label for="">Global Source Identifier</label>
                    </div>
                    <div class="input-field col s6">
                      <input placeholder="eg GOKb Live Server" type="text" class="validate">
                      <label for="">GLobal Source Name</label>
                    </div>
                  </div>

                  <div class="row">
                    <div class="input-field col s6">
                      <select>
                        <option value="1" selected>GOKb OAI Source</option>
                        <option value="2">Option 2</option>
                        <option value="3">Option 3</option>
                        <option value="4">Option 4</option>
                      </select>
                      <label>GLobal Source Type</label>
                    </div>
                    <div class="input-field col s6">
                      <select>
                        <option value="0" selected>Package</option>
                        <option value="1">Title</option>
                      </select>
                      <label>Record Type</label>
                    </div>
                  </div>

                  <div class="row">
                    <div class="input-field col s6">
                      <input placeholder="eg https://gokb.kuali.org/gokb/oai/packages" type="text" class="validate">
                      <label for="">Global Source URI</label>
                    </div>
                    <div class="input-field col s6">
                      <input placeholder="oai_dc" type="text" class="validate">
                      <label for="">List Records Prefix</label>
                    </div>
                  </div>


                  <div class="row">
                    <div class="input-field col s12">
                      <input placeholder="gokb"  type="text" class="validate">
                      <label for="">Full Record Prefix</label>
                    </div>
                  </div>

                  <div class="row">
                    <div class="input-field col s6">
                      <input placeholder="" type="text" class="validate">
                      <label for="">Principal (Username)</label>
                    </div>
                    <div class="input-field col s6">
                      <input placeholder="" type="text" class="validate">
                      <label for="">Credentials (Password)</label>
                    </div>
                  </div>

                  <div class="row">
                    <div class="input-field col s12">
                      <input class="waves-effect waves-light btn" type="submit" value="Submit" class="btn btn-primary"/>
                    </div>
                  </div>

                </g:form>
              </div>
              <!--form end-->

              </div>
          </div>
      </div>
      </div>
    </div>
    <!-- Modal end -->










    <!--legacy-->
<!--     <div class="container">
        <ul class="breadcrumb">
           <li> <g:link controller="home">KBPlus</g:link> <span class="divider">/</span> </li>
           <li>Global Sources</li>
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


    <div class="container-fluid">
      <div class="row-fluid">
        <div class="span9">
          <table class="table table-bordered">
            <thead>
              <tr>
                <td>Identifier</td>
                <td>Name</td>
                <td>Type</td>
                <td>Up To</td>
                <td>URL</td>
                <td>List Prefix</td>
                <td>Full Prefix</td>
                <td>Principal</td>
                <td>Credentials</td>
                <td>RecType</td>
                <td># Local Copies</td>
                <td>Actions</td>
              </tr>
            </thead>
            <tbody>
              <g:each in="${sources}" var="source">
                <tr>
                  <td>${source.identifier}</td>
                  <td>${source.name}</td>
                  <td>${source.type}</td>
                  <td>${source.haveUpTo}</td>
                  <td>${source.uri}</td>
                  <td>${source.listPrefix}</td>
                  <td>${source.fullPrefix}</td>
                  <td>${source.principal}</td>
                  <td>${source.credentials}</td>
                  <td>${source.rectype==0?'Package':'Title'}</td>
                  <td>${source.getNumberLocalPackages()}</td>
                  <td>
                    <g:link class="btn btn-default" 
                            controller="admin" 
                            onclick="return confirm('Deleting this package will remove all tracking info and unlink any local packages - Are you sure?')"
                            action="deleteGlobalSource" 
                            id="${source.id}">Delete</g:link>
                  </td>
                </tr>
              </g:each>
            </tbody>
          </table>
        </div>

        <div class="span3">
          <g:form action="newGlobalSource">
            <dl>
              <dt>Global Source Identifier</dt>
              <dd><input type="text" name="identifier" placeholder="eg GOKbLive"/></dd>
              <dt>GLobal Source Name</dt>
              <dd><input type="text" name="name" placeholder="eg GOKb Live Server"/></dd>
              <dt>GLobal Source Type</dt>
              <dd><select name="type"><option value="OAI">GOKb OAI Source</option></select>
              <dt>Record Type</dt>
              <dd><select name="rectype">
                    <option value="0">Package</option>
                    <option value="1">Title</option>
                   </select>
              <dt>Global Source URI</dt>
              <dd><input type="text" name="uri" placeholder="eg https://gokb.kuali.org/gokb/oai/packages" value="https://some.host/gokb/oai/packages"/></dd>
              <dt>List Records Prefix</dt>
              <dd><input type="text" name="listPrefix" placeholder="oai_dc" value="oai_dc"/></dd>
              <dt>Full Record Prefix</dt>
              <dd><input type="text" name="fullPrefix" placeholder="gokb" value="gokb"/></dd>
              <dt>Principal (Username)</dt>
              <dd><input type="text" name="principal" placeholder=""/></dd>
              <dt>Credentials (Password)</dt>
              <dd><input type="text" name="credentials" placeholder=""/></dd>
            </dl>
            <input type="submit" value="Submit" class="btn btn-primary"/>
          </g:form>
        </div>
      </div>
    </div> -->
    <!--legacy end-->

    
  </body>
</html>

