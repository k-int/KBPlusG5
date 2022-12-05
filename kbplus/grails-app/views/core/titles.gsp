<!doctype html>
<html lang="en" class="no-js">
<head>
  <parameter name="pagetitle" value="Core" />
  <parameter name="pagestyle" value="core" />
  <parameter name="actionrow" value="core" />
  <meta name="layout" content="base"/>
</head>
<body class="titles">

	<div class="row">
    <div class="col s12 m10 offset-m1">

				<div class="row">
					<div class="col s12">
						<ul class="tabs jisc_tabs">
			        <li class="tab col s2"><a href="#core">Core<i class="material-icons">chevron_right</i></a></li>
				    	<li class="tab col s2"><a href="#not-core">Not Core<i class="material-icons">chevron_right</i></a></li>
				    	<li class="tab col s2"><a href="#all">All<i class="material-icons">chevron_right</i></a></li>
				    </ul>
				   </div>
			   </div>

        <!-- tab 1-->
        <div class="row" id="core">
          <div class="col s12">
            <div class="mobile-collapsible-header" data-collapsible="core-collapsible">Search <i class="material-icons">expand_more</i></div>
            <div class="search-section z-depth-1 mobile-collapsible-body" id="core-collapsible">
                <div class="col s12 mt-10">
                    <h3 class="page-title left">Search Your Core Titles</h3>
                </div>
            <div class="col s12 l4">
              <div class="input-field search-main">
                  <input id="search" placeholder="Enter Search Term" type="search" required="">
                  <label class="label-icon active" for="search"><i class="material-icons">search</i></label>
                  <i class="material-icons input-close-icon">close</i>
              </div>
            </div>

            <div class="col s12 l4 mt-10">
              <div class="input-field">
              <select>
              <option value="1">Option 1</option>
              <option value="2">Option 2</option>
              <option value="3">Option 3</option>
              </select>
              <label>Search for</label>
              </div>
            </div>

            <div class="col s12 l2">
              <a class="waves-effect waves-light btn ">Search</a>
            </div>
            <div class="col s6 m3 l2">
                <a href="#" class="resetsearch">Reset</a>
            </div>

            <div class="row">
              <div class="col s12 l6 colpadnine">
              <div class="page-response">
                <div class="input-field">
                    <select>
                        <option value="1">A-Z</option>
                        <option value="2">Z-A</option>
                        <option value="3">Start Date</option>
                        <option value="4">End Date</option>
                        <option value="5">Last Modified</option>
                      </select>
                      <label>Sort By</label>
                 </div>
              </div>
            </div><!-- end col-->
          </div><!-- end row-->

          </div><!-- end col-->
        </div><!-- end row-->

          <div class="row">
            <div class="col s12">
          <div class="tab-table z-depth-1 table-responsive-scroll">
            <table class="highlight bordered">
                <thead>
                  <tr>
                      <th>Title in Package</th>
                      <th>Title Details</th>
                      <th>Provider</th>
                      <th class="center-align">Status</th>
                  </tr>
                </thead>

                <tbody>
                  <tr>
                    <td><a href="#">ASCE via ASCE</a></td>
                    <td><a href="#">Link to title details</a></td>
                    <td><a href="#">ASCE</a></td>
                    <td>
                      <i class="btn-floating btn-large not-core centered"><i class="material-icons"></i></i>
                      <p class="center-align light mt-10">Core Since 2017</p>
                      <!-- this link should open the same modal as per subsdetail on the edit core status-->
                      <p class="center-align light mt-10"><a href="#">Edit core status</a></p>
                    </td>
                  </tr>
                  <tr>
                    <td><a href="#">AB via project muse</a></td>
                    <td><a href="#">Link to title details</a></td>
                    <td><a href="#">Project Muse</a></td>
                    <td>
                      <i class="btn-floating btn-large waves-effect with-core centered"><i class="material-icons"></i></i>
                      <p class="center-align light mt-10">Core Since 2017</p>
                      <!-- this link should open the same modal as per subsdetail on the edit core status-->
                      <p class="center-align light mt-10"><a href="#">Edit core status</a></p>
                    </td>
                  </tr>
                </tbody>
              </table>
           </div>
         </div><!-- end col-->
       </div><!-- end row-->


        </div>
        <!-- end tab 1-->

        <!-- tab 2-->
        <div class="row" id="not-core">
          <div class="col s12">
            <div class="mobile-collapsible-header" data-collapsible="core-collapsible">Search <i class="material-icons">expand_more</i></div>
            <div class="search-section z-depth-1 mobile-collapsible-body" id="core-collapsible">
                <div class="col s12 mt-10">
                    <h3 class="page-title left">Search Your Not Core Titles</h3>
                </div>
            <div class="col s12 l4">
              <div class="input-field search-main">
                  <input id="search" placeholder="Enter Search Term" type="search" required="">
                  <label class="label-icon active" for="search"><i class="material-icons">search</i></label>
                  <i class="material-icons input-close-icon">close</i>
              </div>
            </div>

            <div class="col s12 l4 mt-10">
              <div class="input-field">
              <select>
              <option value="1">Option 1</option>
              <option value="2">Option 2</option>
              <option value="3">Option 3</option>
              </select>
              <label>Search for</label>
              </div>
            </div>

            <div class="col s12 l2">
                <a class="waves-effect waves-light btn ">Search</a>
            </div>
            <div class="col s6 m3 l2">
                <a href="#" class="resetsearch">Reset</a>
            </div>

            <div class="row">
              <div class="col s12 l6 colpadnine">
              <div class="page-response">
                <div class="input-field">
                    <select>
                        <option value="1">A-Z</option>
                        <option value="2">Z-A</option>
                        <option value="3">Start Date</option>
                        <option value="4">End Date</option>
                        <option value="5">Last Modified</option>
                      </select>
                      <label>Sort By</label>
                 </div>
              </div>
            </div><!-- end col-->
          </div><!-- end row-->

          </div><!-- end col-->
        </div><!-- end row-->

          <div class="row">
            <div class="col s12">
          <div class="tab-table z-depth-1 table-responsive-scroll">
            <table class="highlight bordered">
                <thead>
                  <tr>
                      <th>Title in Package; Title Details</th>
                      <th>Provider</th>
                      <th class="center-align">Status</th>
                  </tr>
                </thead>

                <tbody>
                  <tr>
                    <td>ASCE via ASCE; link to title details</td>
                    <td>ASCE</td>
                    <td><a class="btn-floating btn-large not-core centered tooltipped" data-position="left" data-delay="50" data-tooltip="Since 2017"><i class="material-icons">clear</i></a></td>
                  </tr>
                  <tr>
                    <td>AB via project muse; link to title details</td>
                    <td>Project Muse</td>
                    <td><a class="btn-floating btn-large waves-effect with-core centered tooltipped" data-position="left" data-delay="50" data-tooltip="Since 2017"><i class="material-icons">done</i></a></td>
                  </tr>
                </tbody>
              </table>
           </div>
         </div><!-- end col-->
       </div><!-- end row-->


        </div>
        <!-- end tab 2-->

        <!-- tab 3-->
        <div class="row" id="all">
          <div class="col s12">
            <div class="mobile-collapsible-header" data-collapsible="core-collapsible">Search <i class="material-icons">expand_more</i></div>
            <div class="search-section z-depth-1 mobile-collapsible-body" id="core-collapsible">
            <div class="col s12 mt-10">
                <h3 class="page-title left">Search All Titles</h3>
            </div>

            <div class="col s12 l4">
              <div class="input-field search-main">
                  <input id="search" placeholder="Enter Search Term" type="search" required="">
                  <label class="label-icon active" for="search"><i class="material-icons">search</i></label>
                  <i class="material-icons input-close-icon">close</i>
              </div>
            </div>

            <div class="col s12 l4 mt-10">
              <div class="input-field">
              <select>
              <option value="1">Option 1</option>
              <option value="2">Option 2</option>
              <option value="3">Option 3</option>
              </select>
              <label>Search for</label>
              </div>
            </div>

            <div class="col s12 l2">
                <a class="waves-effect waves-light btn ">Search</a>
            </div>
            <div class="col s6 m3 l2">
                <a href="#" class="resetsearch">Reset</a>
            </div>

            <div class="row">
              <div class="col s12 l6 colpadnine">
              <div class="page-response">
                <div class="input-field">
                    <select>
                        <option value="1">A-Z</option>
                        <option value="2">Z-A</option>
                        <option value="3">Start Date</option>
                        <option value="4">End Date</option>
                        <option value="5">Last Modified</option>
                      </select>
                      <label>Sort By</label>
                 </div>
              </div>
            </div><!-- end col-->
          </div><!-- end row-->

          </div><!-- end col-->
        </div><!-- end row-->

          <div class="row">
            <div class="col s12">
          <div class="tab-table z-depth-1 table-responsive-scroll">
            <table class="highlight bordered">
                <thead>
                  <tr>
                      <th>Title in Package; Title Details</th>
                      <th>Provider</th>
                      <th class="center-align">Status</th>
                  </tr>
                </thead>

                <tbody>
                  <tr>
                    <td>ASCE via ASCE; link to title details</td>
                    <td>ASCE</td>
                    <td><a class="btn-floating btn-large not-core centered tooltipped" data-position="left" data-delay="50" data-tooltip="Since 2017"><i class="material-icons">clear</i></a></td>
                  </tr>
                  <tr>
                    <td>AB via project muse; link to title details</td>
                    <td>Project Muse</td>
                    <td><a class="btn-floating btn-large waves-effect with-core centered tooltipped" data-position="left" data-delay="50" data-tooltip="Since 2017"><i class="material-icons">done</i></a></td>
                  </tr>
                </tbody>
              </table>
           </div>
         </div><!-- end col-->
       </div><!-- end row-->


        </div>
        <!-- end tab 3-->
        <div class="pagination">
        <a href="#" class="prevLink"><i class="material-icons small pagination-icon">chevron_left</i></a>
        <a href="#" class="step">1</a>
        <a href="#" class="step">2</a>
        <span class="currentStep">3</span>
        <a href="#" class="step">4000</a>
        <a href="#" class="prevLink"> <i class="material-icons small pagination-icon">chevron_right</i></a>
        </div>
      </div>

  </div>


</body>
</html>
