<!doctype html>
<html lang="en" class="no-js">
<head>
   <meta name="layout" content="base"/>
    <parameter name="actionrow" value="packagesdetail" />
</head>
<body class="packages">

<!--page title-->
<div class="row">
   <div class="col s12 l12">
      <h1 class="page-title left">Wiley:NESLI2:Online Library STM Collection:2012-2014:Year 3</h1>
   </div>
   <div class="col s12 l12">
      <h2 class="page-subtitle">Snapshot of package as at 2014-12-31</h2>
   </div>
</div>
<!--page title end-->
<div class="row row-content">
<div class="col s12 m6 l3">
   <div class="card-panel">
      <p class="card-label">Start Date: <span class="card-response right">01.11.2017</span></p>
        <p class="card-label">End Date: <span class="card-response right">01.11.2017</span></p>
   </div>
   <div class="card-panel">
       <div class="launch-out">
         <a class="btn-floating bordered"><i class="material-icons">open_in_new</i></a>
       </div>
       <p class="card-title">Expected Titles</p>
       <p class="card-caption"><span>32</span> number of titles</p>
   </div>
</div>
<div class="col s12 m6 l3">
   <div class="card-panel">
    <div class="launch-out">
      <a class="btn-floating bordered"><i class="material-icons">open_in_new</i></a>
    </div>
    <p class="card-title">Package History</p>
    <p class="card-caption"><span>32</span> instances listed</p>
</div>
<div class="card-panel">
    <div class="launch-out">
      <a class="btn-floating bordered"><i class="material-icons">open_in_new</i></a>
    </div>
    <p class="card-title">Previous Titles</p>
    <p class="card-caption"><span>32</span> number of titles</p>
</div>

</div>

<div class="col s12 l6">
    <div class="card jisc_card small white">
        <div class="card-content text-navy">
   <span class="card-title pack-detail">Add this package to institutional subscription:</span>
   <div class="card-detail">

      <div class="col s12 m12 l12 mt-10">
         <div class="input-field mar-min">
            <select>
              <option value="1">Option 1</option>
              <option value="2">Option 2</option>
              <option value="3">Option 3</option>
              <option value="4">Option 4</option>
              <option value="5">Option 5</option>
              <option value="6">Option 6</option>
              <option value="7">Option 7</option>
              <option value="8">Option 8</option>
              <option value="9">Option 9</option>
            </select>
            <label>Packages</label>
         </div>
      </div>

      <div class="col s12 l12">
         <div class="input-field mar-min">
           <p>
             <input type="checkbox" id="test5" />
             <label for="test5">Create Entitlements in Subscription</label>
        </p>
         </div>
      </div>

      <div class="col s12 m12 l12 mt-20">
         <a class="waves-effect waves-teal btn left mar-search">Submit</a>
      </div>

    </div>

 </div>

  </div>

</div>

<!--tab section start-->
<div class="row">

    <div class="col s12">
      <ul class="tabs jisc_tabs">
        <li class="tab col s2"><a href="#titles">Titles<i class="material-icons">chevron_right</i></a></li>
        <li class="tab col s2"><a href="#details">Details<i class="material-icons">chevron_right</i></a></li>
      </ul>
    </div>




    <!--***tab Details content start***-->
    <div id="titles" class="tab-content">

     <!-- search-section start-->
     <div class="row">
      <div class="col s12">

        <div class="search-section z-depth-1">
          <form>
          <!--search filter -->
          <div class="col s12">
            <ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
                <li>
                    <div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter Titles Search</div>
                    <div class="collapsible-body">

                      <div class="col s6">
                        <div class="col s6">
                          <div class="input-field">
                            <input type="text" name="">
                            <label>Title</label>
                          </div>
                        </div>
                        <div class="col s6">
                          <div class="input-field">
                            <input type="text" name="">
                            <label>Coverage note</label>
                          </div>
                        </div>
                      </div>
                      <div class="col s6">
                        <div class="col s4">
                        <div class="input-field">
                          <input placeholder="click to add date"  id="start_date" type="date" class="datepicker">
                          <label>Start Date</label>
                        </div>
                        </div>
                        <div class="col s4">
                        <div class="input-field">
                          <input placeholder="click to add date" id="end_date" type="date" class="datepicker">
                          <label>End Date</label>
                        </div>
                        </div>
                        <div class="col s2">
                        <a class="waves-effect waves-teal btn">Search</a>
                        </div>
                      <div class="col s2">
                          <a href="#" class="resetsearch">Reset</a>
                      </div>
                      </div>

                      </div>
                </li>
            </ul>
          </div>
          <!--search filter end -->
          </form>
        </div>

      </div>
      <!-- only for admin view-->

        <!-- end admin view-->
     </div>
     <!-- search-section end-->

     <div class="row">
       <div class="col s12">
         <div class="col s12 m10 l10">
          <a href="#modal1" class="waves-effect btn right">Batch action Tiltes<i class="material-icons right">add_circle_outline</i></a>
         </div>
         <div class="col s12 m2 l2 ">
          <a href="#modal1" class="waves-effect btn right ">Add title<i class="material-icons right">add_circle_outline</i></a>
         </div>
      </div>
     </div>

    <!--***table data***-->
    <div class="row">
      <div class="col s12">
        <div class="tab-table z-depth-1">

              <h1 class="table-title">Title goes here</h1>


            <!--***table***-->
          <div id="title">

          <!--***tab card section***-->
               <div class="row table-responsive-scroll">
                    <table class="highlight bordered">
                        <thead>
                          <tr>
                              <!-- this is only for DM --> <th data-field="title">Batch</th>
                              <th data-field="title">Title</th>
                              <th data-field="tip">TIPP</th>
                              <th data-field="access">Access</th>
                              <th data-field="platform">Platform</th>
                              <th data-field="coveragedepth">Coverage Depth</th>
                              <th data-field="identifiers">Identifiers</th>
                              <th data-field="coverage-start">Coverage Start</th>
                              <th data-field="coverage-end">Coverage End</th>
                              <th data-field="note">Note</th>
                              <th data-field="action">Action</th>
                          </tr>
                        </thead>

                        <tbody>
                          <tr>
                            <!-- this is only for DM -->
                            <td style="vertical-align:middle;">
                              <input type="checkbox" id="test1" />
                              <label for="test1" class="align">&nbsp;</label>
                            </td>
                            <!-- this is only for DM -->
                            <td>
                              <ul>
                                <li class="collection-item"><a href="#">Proceedings of the Institution of Mechanical Engineers, Part J:</a><br>Journal of Engineering Tribology</li>
                                <li class="collection-item">SAGE Journals</li>
                              </ul>
                            </td>
                            <td><a href="#">Link</a></td>
                            <td>Expired</td>
                            <td>SAGE Journals </td>
                            <td>Full Text</td>
                            <td>jusp:7108<br>eissn:2041-305X<br>issn:1350-6501</td>
                            <td>Date: 1994-01-01<br>Volume: 208<br>Issue: 1</td>
                            <td>Date: 1994-01-01<br>Volume: 208<br>Issue: 1</td>
                            <td>
                            <ul class="flex-row">
                              <li><i class="material-icons theme-icon tooltipped card-tooltip" data-position="left" data-src="temp-ref-id1">info</i></li>
                            </ul>
                            <script type="text/html" id="temp-ref-id1">
                              <div class="kb-tooltip">
                                <div class="tooltip-title">Note</div>
                                <ul class="tooltip-list">
                                  <li>Some text that will go here that will replace this html. Some text that will go here that will replace this html </li>
                                </ul>
                              </div>
                              </script>
                            </td>
                              <!--this is only for DM -->
                              <td>
                                <div class="actions-container center"><a href="#modal1" class="action-btn"><i class="material-icons theme-icon">create</i></a></div>
                              </td>
                              <!--this is only for DM -->
                          </tr>

                        </tbody>
                  </table>
               </div>

          </div>
          <!--***table end***-->





        </div>

      </div>

    </div>
    </div>
    <!--tab section end-->


   <!--***tab Details content start***-->
    <div id="details" class="tab-content">

      <div class="row">
        <div class="col s12 m6 no-padding">


        <div class="row">

           <div class="col s12">
          <div class="row card-panel strip-table-alt z-depth-1">

            <div class="col m12 section">
              <div class="col m5 title">
                Package Persistent Identifier
              </div>
              <div class="col m7 result">
                uri://kbplus/kbplus/package/507
              </div>
            </div>


            <div class="col m12 section">
              <div class="col m5 title">
               Public?
              </div>
              <div class="col m7 result">
                Yes
              </div>
            </div>

            <div class="col m12 section">
              <div class="col m5 title">
               Licence
              </div>
              <div class="col m7 result">
                -
              </div>
            </div>

            <div class="col m12 section">
              <div class="col m5 title">
               Vendor URL
              </div>
              <div class="col m7 result">
                -
              </div>
            </div>

            <div class="col m12 section">
              <div class="col m5 title">
               List Status
              </div>
              <div class="col m7 result">
                -
              </div>
            </div>

            <div class="col m12 section">
              <div class="col m5 title">
               Breakable
              </div>
              <div class="col m7 result">
                -
              </div>
            </div>

            <div class="col m12 section">
              <div class="col m5 title">
               Consistent
              </div>
              <div class="col m7 result">
                -
              </div>
            </div>


            <div class="col m12 section">
              <div class="col m5 title">
               Fixed
              </div>
              <div class="col m7 result">
                -
              </div>
            </div>

            <div class="col m12 section">
              <div class="col m5 title">
               Package Scope
              </div>
              <div class="col m7 result">
                -
              </div>
            </div>




          </div>

      </div>

        </div>


        </div>
        <div class="col s12 m6 no-padding">





            <div class="col s12 m6">
                 <div class="card jisc_card large xlarge white">
                     <div class="card-content text-navy">
                <div class="launch-out">
                <a class="btn-floating bordered"><i class="material-icons">add_circle_outline</i></a>
                <a class="btn-floating bordered left-space"><i class="material-icons">open_in_new</i></a>
              </div>
              <p class="card-title">Notes</p>
                <div class="card-detail no-card-action documents">
                  <ul class="collection">
                      <li class="collection-item">
                        <p>123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015</p>
                        <p class="text-grey">created: 28.10.2015 (Not Shared)</p>
                      </li>
                    </ul>
                </div>
              </div>
                 </div>
            </div>

            <div class="col s12 m6">
                 <div class="card jisc_card large xlarge white">
                     <div class="card-content text-navy">
                <div class="launch-out">
                <a class="btn-floating bordered"><i class="material-icons">add_circle_outline</i></a>
              </div>
              <p class="card-title">Documents</p>
                <div class="card-detail no-card-action documents">
                  <ul class="collection">
                      <li class="collection-item avatar">
                        <i class="material-icons circle">description</i>
                        <span class="title">Elsevier:Jisc</span>
                        <p class="text-grey">created: 28.10.2015 (Not Shared)<br>
                           File Type: PDF
                        </p>
                      </li>
                      <li class="collection-item avatar">
                        <i class="material-icons circle">description</i>
                      <span class="title">Elsevier:Jisc</span>
                      <p class="text-grey">created: 28.10.2015 (Not Shared)<br>
                         File Type: PDF
                      </p>
                      </li>
                      <li class="collection-item avatar">
                        <i class="material-icons circle">description</i>
                        <span class="title">Elsevier:Jisc</span>
                        <p class="text-grey">created: 28.10.2015 (Not Shared)<br>
                           File Type: PDF
                        </p>
                      </li>
                    </ul>
                  <ul class="collection">
                    <li class="collection-item avatar">
                       <i class="material-icons circle">description</i>
                      <span class="title">Elsevier:Jisc</span>
                      <p class="text-grey">created: 28.10.2015 (Not Shared)<br>
                         File Type: PDF
                      </p>
                    </li>
                  </ul>
                </div>
              </div>
                 </div>
            </div>



          </div>



        </div>


        <!--***tabular data***-->
    <div class="row">

      <div class="col s12">
        <div class="tab-table z-depth-1">

            <ul class="tabs jisc_content_tabs">
              <li class="tab"><a href="#organisation-links">Organisation Links</a></li>
              <li class="tab"><a href="#subscription-id">Other Identifiers</a></li>
            </ul>



      <!--***table***-->
        <div id="organisation-links" class="tab-content">

        <!--***tab card section***-->
             <div class="row table-responsive-scroll">
                  <table class="highlight bordered">
                        <thead>
                          <tr>
                              <th data-field="organisation">Organisation</th>
                              <th data-field="role">Role</th>
                              <th data-field="actions" class="hide-on-small-and-down">Actions</th>
                          </tr>
                        </thead>

                        <tbody>
                          <tr>
                            <td>Jisc Collections</td>
                            <td>Subscriber</td>
                            <td class="hide-on-small-and-down">
                              <a href="" class="btn-floating table-action"><i class="material-icons">create</i></a>
                              <a href="" class="btn-floating table-action"><i class="material-icons">clear</i></a>
                            </td>
                          </tr>
                        </tbody>
                  </table>
             </div>

        </div>
        <!--***table end***-->

        <!--***table***-->
          <div id="subscription-id" class="tab-content">

          <!--***tab card section***-->
               <div class="row table-responsive-scroll">
                    <table class="highlight bordered">
                      <thead>
                        <tr>
                            <th data-field="authority">ID</th>
                            <th data-field="identifier-namespache">Identifier Namespace</th>
                            <th data-field="identifier">Identifier</th>
                        </tr>
                      </thead>

                      <tbody>
                        <tr>
                          <td>sage:2012 sage premier</td>
                          <td>Addiction Research &amp; Theory</td>
                          <td>
                            xyz
                          </td>
                        </tr>
                      </tbody>
                  </table>
               </div>

          </div>
          <!--***table end***-->


      </div>
      <!--***tabular data end***-->

      </div>


    </div>
   <!--***tab Details content end***-->


      </div>









</div>
<!--tab section end-->













<!-- example Modal form -->
<div id="modal1" class="modal bottom-sheet">
   <div class="fixed-action-btn-top">
      <a href="#!" class="z-depth-0 transparent modal-action modal-close btn-floating btn-large waves-effect waves-dark back-pack"><i class="material-icons">close</i></a>
   </div>
   <div class="modal-content">
      <div class="container">
         <div class="row">
            <div class="col s12 l8 offset-l2">
               <h1 class="form-title flow-text text-navy">Add title to {package name}</h1>
               <p class="form-caption flow-text text-grey">Add titles as required and save to update this package</p>
               <!--form-->
               <div class="row">
                  <form class="col s12">

                     <div class="row">
                        <div class="input-field col s12">
                           <select>
                              <option value="" disabled selected>Search</option>
                              <option value="1">Option 1</option>
                              <option value="2">Option 2</option>
                              <option value="3">Option 3</option>
                           </select>
                           <label>Title To Add</label>
                        </div>
                     </div>

                     <div class="row">
                        <div class="input-field col s12">
                           <select>
                              <option value="" disabled selected>Search</option>
                              <option value="1">Option 1</option>
                              <option value="2">Option 2</option>
                              <option value="3">Option 3</option>
                           </select>
                           <label>Platform For Added Title</label>
                        </div>
                     </div>

                     <div class="row">
                        <div class="input-field col s12">
                           <a class="waves-effect waves-light btn">Add title</a>
                        </div>
                     </div>

                  </form>
               </div>
               <!--form end-->

            </div>
         </div>
      </div>
   </div>
</div>
<!-- Modal end -->




</body>
</html>
