<!doctype html>
<html lang="en" class="no-js">
<head>
  <parameter name="pagetitle" value="Subscriptions" />
  <parameter name="pagestyle" value="subscriptions" />
  <parameter name="actionrow" value="subscriptions" />
  <meta name="layout" content="base"/>
</head>
<body class="subscriptions">

	<div class="row">
		<div class="col s12">

			<div class="mobile-collapsible-header" data-collapsible="subscription-list-collapsible">Search <i class="material-icons">expand_more</i></div>
			<div class="search-section z-depth-1 mobile-collapsible-body" id="subscription-list-collapsible">
				<div class="col s12 mt-10">
					<h3 class="page-title left">Search Your Subscriptions</h3>
				</div>
				<form>
				<div class="col s12 l4">
			        <div class="input-field search-main">
				          <input id="search" placeholder="enter your search term..." type="search" required>
				          <label class="label-icon" for="search"><i class="material-icons">search</i></label>
				          <i class="material-icons close">close</i>
			        </div>

				</div>
				<div class="col s12 l3 mt-10">
					<div class="input-field">
						<select>
					      <option value="" disabled selected>Choose from list</option>
					      <option value="1">Valid</option>
					      <option value="2">Renewal</option>
					      <option value="3">End Date</option>
					      <option value="3">Start Date</option>
					    </select>
					    <label>Date Type</label>
					</div>
				</div>
				<div class="col s12 l3 mt-10">
					<div class="input-field">
						<input placeholder="YYYY-MM-DD"  id="date_input_start" type="text">
						<div class="datepickericon" data-field="date_input_start"><i class="material-icons">event</i></div>
            			<label>Will update as per first choice (valid on)</label>
					</div>
				</div>

				<div class="col s6 m3 l1">
					<a href="#" class="btn">Search</a>
				</div>
				<div class="col s6 m3 l1">
					<a href="#" class="resetsearch">Reset</a>
				</div>


				<!--search filter -->
				<div class="col s12">
					<ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
					    <li>
					      	<div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter Search</div>
					      	<div class="collapsible-body">
									<ul class="checkbox-collection">
										<li>Relationship:</li>
										<li>
											<input type="checkbox" name="chkbx-1" id="chkbx-1">
											<label for="chkbx-1">Manual</label>
										</li>
										<li>
											<input type="checkbox" name="chkbx-2" id="chkbx-2">
											<label for="chkbx-2">Auto</label>
										</li>
										<li>
											<input type="checkbox" name="chkbx-3" id="chkbx-3">
											<label for="chkbx-3">Independent</label>
										</li>
									</ul>

					      	</div>
					    </li>
					</ul>
				</div>
				<!--search filter end -->

				</form>
			</div>

		</div>
	</div>
	<!-- search-section end-->


	<!-- list returning/results-->
	<div class="row">

		<div class="col s12 page-response">
			<h2 class="list-response text-navy">You have <span>12 Current</span> Subscriptions: <span>Ordered by 'A-Z'</span></h2>
		</div>
	</div>

	<div class="row">
		<div class="col s12">
			<div class="filter-section z-depth-1">

				<div class="col s12 l6">
					<div class="input-field">
					    <select>
					      <option value="1" selected>A-Z</option>
					      <option value="2">Z-A</option>
					      <option value="3">Start Date</option>
			              <option value="4">End Date</option>
			              <option value="5">Renewal Date</option>
					    </select>
					    <label>Sort Subscriptions by: A-Z (default)</label>
					 </div>
				</div>

			</div>
		</div>
	</div>
	<!-- list returning/results end-->


	<!-- list accordian start-->
	<div class="row">

		<div class="col s12 l9 scroll-container">

			<ul class="collapsible jisc_collapsible" data-collapsible="accordion">

			    <!--accordian item-->
			    <li>
			    	<!--accordian header-->
			      	<div class="collapsible-header">
			      		<div class="col s12 m10">
			      			<i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Click to toggle"></i>
			      			<ul class="collection">
			      				<li class="collection-item"><h2 class="first navy-text"><a href="/subscriptions/detail">Annual Review 2015</a></h2></li>
			      				<li class="collection-item">Duration: From <span>01.01.2017</span> until <span>31.12.2018</span></li>
			      				<li class="collection-item">ISSN: <span>1324-5436</span></li>
			      				<li class="collection-item">License: <span><a href="#">Damyanti demo Nature Publishing Group/Jisc Collections/NPG Journals/2016</a></span></li>
			      				<li class="collection-item">Associated Packages: <span class="inline-badge tooltipped card-tooltip" data-position="right" data-src="temp-ref-id">14</span> </li>
                    			<li class="collection-item">
                    				Associated:
                    				<span class="indicator"><i class="material-icons left">view_list</i> Notes (4)</span>
                    				<span class="indicator"><i class="material-icons left">description</i> Documents (2)</span>
			      				</li>
			      				<script type="text/html" id="temp-ref-id">
			      				<div class="kb-tooltip">
			      					<div class="tooltip-title">Packages</div>
			      					<ul class="tooltip-list">
			      						<li>Some text that will go here that will replace this html </li>
			      						<li>Some text</li>
			      						<li>Some text</li>
			      					</ul>
			      				</div>
			      				</script>
			      			</ul>
			      		</div>
			      		<div class="col s12 m2 full-height-divider">
			      			<ul class="collection">
			      				<li class="collection-item first">
			      					<div class="label centered-label expired current tooltipped" data-position="right" data-delay="50" data-tooltip="Expired"><i class="material-icons">timer_off</i>Expired</div>
			      				</li>
			      				<li class="collection-item">
			      					<div class="label updatetype centered-label default tooltipped" data-position="right" data-delay="50" data-tooltip="Manual Update"><i class="material-icons">build</i>Manual Update</div>
			      				</li>
			      				<li class="collection-item actions first hide-on-small-and-down">
	      					       <div class="actions-container">
  										<a class="btn-floating"><i class="material-icons">create</i></a>
  										<!-- <a class="btn-floating right"><i class="material-icons">delete_forever</i></a> -->
	      					       </div>
			      				</li>
			      			</ul>
			      		</div>

			      	</div>
			      	<!-- accordian header end-->

			      	<!-- accordian body-->
			      	<div class="collapsible-body">

			      		<div class="row">
			      			<div class="col s6 l3">
			      				<h3>Associated Packages</h3>
			      				<p><a href="">American Society of Civil Engineers:Jisc Collections:Journals:2015​​​​​​​</a></p>
			      				<p><a href="">Elsevier:Jisc Collections:ScienceDirect:Mathematics Core Subject Collection:2012-2016</a></p>

			      			</div>

				      		<div class="col s6">
				      			<h3>Licences</h3>
				      			<p><a href="">Damyanti demo Nature Publishing Group/Jisc Collections/NPG Journals/2016</a></p>

			      				<ul class="licence-properties">
			      					<li>
			      						<i class="small material-icons tooltipped" data-position="top" data-delay="50" data-tooltip="Include in VLE">computer_black</i>
			      						<i class="small material-icons icon-offset-small yes">done</i>
			      					</li>
			      					<li>
			      						<i class="small material-icons tooltipped" data-position="top" data-delay="50" data-tooltip="Include in coursepacks">library_books</i>
			      						<i class="small material-icons icon-offset-small no">clear</i>
			      					</li>
			      					<li>
			      						<i class="small material-icons tooltipped" data-position="top" data-delay="50" data-tooltip="Inter-library loan">call_split_black</i>
			      						<i class="small material-icons icon-offset-small yes">done</i>
			      					</li>
			      					<li>
			      						<i class="small material-icons tooltipped" data-position="top" data-delay="50" data-tooltip="Walk-in access">directions_walk</i>
			      						<i class="small material-icons icon-offset-small no">clear</i>
			      					</li>
			      					<li>
			      						<i class="small material-icons tooltipped" data-position="top" data-delay="50" data-tooltip="Remove access">cast_connected_black</i>
			      						<i class="small material-icons icon-offset-small neither">info_outline</i>
			      					</li>
			      					<li>
			      						<i class="small material-icons tooltipped" data-position="top" data-delay="50" data-tooltip="Alumni access">group_black</i>
			      						<i class="small material-icons icon-offset-small neither">info_outline</i>
			      					</li>
			      				</ul>


								<!--
				      			<div class="issn-table">
				      				<table>
				      			        <tbody>
				      			          <tr>
				      			            <td>ISSN</td>
				      			            <td class="highlight">1532-3641</td>
				      			          </tr>
				      			          <tr>
				      			            <td>eISSN</td>
				      			            <td class="highlight">1943-5622</td>
				      			          </tr>
				      			          <tr>
				      			            <td>Access</td>
				      			            <td class="highlight">Current</td>
				      			          </tr>
				      			        </tbody>
				      			    </table>
				      			</div>
				      			-->
				      		</div>

				      		<div class="col s12 l3">
				      			<h3>Consortia</h3>
				      			<p>Pellentesque nec malesuada nisi, ut.</p>
				      			<h3>Platform</h3>
				      			<p>Pellentesque nec malesuada nisi, ut.</p>
				      			<h3>Cancellation Allowance</h3>
				      			<p>Pellentesque nec malesuada nisi, ut.</p>
				      		</div>
			      		</div>
			      		<div class="row">
			      			<div class="col s12">
					      		<div class="cta">
					      			<a href="/subscriptions/detail" class="waves-effect waves-light btn">View All</a>
					      			<a href="#modal1" class="waves-effect btn hide-on-med-and-down">Edit <i class="material-icons right">create</i></a>
					      			<a class="waves-effect btn hide-on-med-and-down">Delete <i class="material-icons right">clear</i></a>
					      		</div>
				      		</div>
			      		</div>

			      	</div>
			      	<!-- accordian body end-->
			    </li>
				<!-- accordian item end-->


			    <!--accordian item-->
			    <li>
			    	<!--accordian header-->
			      	<div class="collapsible-header">
			      		<div class="col s12 m10">
			      			<i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Click to toggle"></i>
			      			<ul class="collection">
			      				<li class="collection-item"><h2 class="first navy-text">Annual Review 2015</h2></li>
			      				<li class="collection-item">Duration: From <span>01.01.2017</span> until <span>31.12.2018</span></li>
			      				<li class="collection-item">ISSN: <span>1324-5436</span></li>
			      				<li class="collection-item">License: <span><a href="">Damyanti demo Nature Publishing Group/Jisc Collections/NPG Journals/2016</a></span></li>
			      				<li class="collection-item">Associated Packages: <a href="">Damyanti demo Nature Publishing Group</a></li>
			      			</ul>
			      		</div>
			      		<div class="col s12 m2 full-height-divider">
			      			<ul class="collection">
			      				<li class="collection-item first">
			      					<div class="label centered-label current tooltipped" data-position="right" data-delay="50" data-tooltip="Current"><i class="material-icons">alarm</i>Current</div>
			      				</li>
			      				<li class="collection-item">
			      					<div class="label updatetype centered-label default tooltipped" data-position="right" data-delay="50" data-tooltip="Automatic"><i class="material-icons">loop</i>Auto Update</div>
			      				</li>
                    <li class="collection-item actions first hide-on-small-and-down">
	      					       <div class="actions-container">
  										<a class="btn-floating btn-flat waves-effect waves-light"><i class="material-icons">create</i></a>
  										<!-- <a class="btn-floating btn-flat waves-effect waves-light"><i class="material-icons">delete_forever</i></a> -->
	      					       </div>
			      				</li>
			      			</ul>
			      		</div>

			      	</div>
			      	<!-- accordian header end-->

			      	<!-- accordian body-->
			      	<div class="collapsible-body">

			      		<div class="row">
				      		<div class="col s12 m12 l4">
				      			<h3>Licences</h3>
				      			<p><a href="">Damyanti demo Nature Publishing Group/Jisc Collections/NPG Journals/2016</a></p>
				      			<div class="issn-table">
				      				<table>
				      			        <tbody>
				      			          <tr>
				      			            <td>ISSN</td>
				      			            <td class="highlight">1532-3641</td>
				      			          </tr>
				      			          <tr>
				      			            <td>eISSN</td>
				      			            <td class="highlight">1943-5622</td>
				      			          </tr>
				      			          <tr>
				      			            <td>Access</td>
				      			            <td class="highlight">Current</td>
				      			          </tr>
				      			        </tbody>
				      			    </table>
				      			</div>

				      		</div>
				      		<div class="col s12 m12 l4">
				      			<h3>Associated Packages</h3>
				      			<p><a href="">American Society of Civil Engineers:Jisc Collections:Journals:2015​​​</a>​​​​</p>
				      			<p><a href="">Elsevier:Jisc Collections:ScienceDirect:Mathematics Core Subject Collection:2012-2016</a></p>
				      		</div>
				      		<div class="col s12 m12 l4">
				      			<h3>Consortia</h3>
				      			<p>Pellentesque nec malesuada nisi, ut.</p>
				      			<h3>Platform</h3>
				      			<p>Pellentesque nec malesuada nisi, ut.</p>
				      			<h3>Cancellation Allowance</h3>
				      			<p>Pellentesque nec malesuada nisi, ut.</p>
				      		</div>
			      		</div>
			      		<div class="row">
			      			<div class="col s12">
					      		<div class="cta">
					      			<a class="waves-effect waves-light btn">View Additional Metrics</a>
					      			<a href="#modal1" class="waves-effect btn hide-on-med-and-down">Edit <i class="material-icons right">create</i></a>
					      			<a class="waves-effect btn hide-on-med-and-down">Delete <i class="material-icons right">clear</i></a>
					      		</div>
				      		</div>
			      		</div>

			      	</div>
			      	<!-- accordian body end-->
			    </li>
				<!-- accordian item end-->


		    <!--accordian item-->
		    <li>
		    	<!--accordian header-->
		      	<div class="collapsible-header">
		      		<div class="col s12 m10">
		      			<i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Click to toggle"></i>
		      			<ul class="collection">
		      				<li class="collection-item"><h2 class="first navy-text">Annual Review 2015</h2></li>
		      				<li class="collection-item">Duration: From<span>01.01.2017</span> until <span>31.12.2018</span></li>
		      				<li class="collection-item">ISSN: <span>1324-5436</span></li>
		      				<li class="collection-item">License: <span>Damyanti demo Nature Publishing Group/Jisc Collections/NPG Journals/2016</span></li>
		      				<li class="collection-item">Associated Packages: Jisc Collections/NPG Journals</li>
		      			</ul>
		      		</div>
		      		<div class="col s12 m2 full-height-divider">
		      			<ul class="collection">
		      				<li class="collection-item first">
		      					<div class="label centered-label expired"><i class="material-icons">timer_off</i>Expired</div>
		      				</li>
		      				<li class="collection-item">
		      					<div class="label updatetype centered-label default tooltipped" data-position="right" data-delay="50" data-tooltip="Independent Updates"><i class="material-icons">code</i>Indep Updates</div>
		      				</li>
                  <li class="collection-item actions first hide-on-small-and-down">
                       <div class="actions-container">
                    <a class="btn-floating btn-flat waves-effect waves-light"><i class="material-icons">create</i></a>
                    <!-- <a class="btn-floating btn-flat waves-effect waves-light"><i class="material-icons">delete_forever</i></a> -->
                       </div>
                  </li>
		      			</ul>
		      		</div>

		      	</div>
		      	<!-- accordian header end-->

		      	<!-- accordian body-->
		      	<div class="collapsible-body">

		      		<div class="row">
			      		<div class="col s12 m12 l4">
			      			<h3>Licences</h3>
			      			<p>Damyanti demo Nature Publishing Group/Jisc Collections/NPG Journals/2016</p>
			      			<div class="issn-table">
			      				<table>
			      			        <tbody>
			      			          <tr>
			      			            <td>ISSN</td>
			      			            <td class="highlight">1532-3641</td>
			      			          </tr>
			      			          <tr>
			      			            <td>eISSN</td>
			      			            <td class="highlight">1943-5622</td>
			      			          </tr>
			      			          <tr>
			      			            <td>Access</td>
			      			            <td class="highlight">Current</td>
			      			          </tr>
			      			        </tbody>
			      			    </table>
			      			</div>

			      		</div>
			      		<div class="col s12 m12 l4">
			      			<h3>Associated Packages</h3>
			      			<p>American Society of Civil Engineers:Jisc Collections:Journals:2015​​​​​​​</p>
			      			<p>Elsevier:Jisc Collections:ScienceDirect:Mathematics Core Subject Collection:2012-2016</p>
			      		</div>
			      		<div class="col s12 m12 l4">
			      			<h3>Consortia</h3>
			      			<p>Pellentesque nec malesuada nisi, ut.</p>
			      			<h3>Platform</h3>
			      			<p>Pellentesque nec malesuada nisi, ut.</p>
			      			<h3>Cancellation Allowance</h3>
			      			<p>Pellentesque nec malesuada nisi, ut.</p>
			      		</div>
		      		</div>
		      		<div class="row">
		      			<div class="col s12">
				      		<div class="cta">
				      			<a class="waves-effect waves-light btn">View Additional Metrics</a>
				      			<a href="#modal1" class="waves-effect btn">Edit <i class="material-icons right">create</i></a>
				      			<a class="waves-effect btn">Delete <i class="material-icons right">clear</i></a>
				      		</div>
			      		</div>
		      		</div>

		      	</div>
		      	<!-- accordian body end-->
		    </li>
			<!-- accordian item end-->


			</ul>

			<!--
			READ ME ABOUT INFINATE SCROLLING
			- You would need apply disabled class to the first li element if you are on the first page.
			- You would need apply disabled class to the last li element if you are on the last page.
			- All other li elements will have the waves-effect class
			- You would apply te active class to the li element that corrisponds to the page taht is active
			-->
			<div id="paginator" class="hidden">
			  <ul class="pagination">
			    <li class="disabled"><a href="#!"><i class="material-icons">chevron_left</i></a></li>
			    <!-- Start of for loop -->
			    <li class="active"><a href="/subscriptions/list">1</a></li>
			    <!-- End of loop -->
			    <li class="waves-effect"><a href="/subscriptions/listtwo">2</a></li>
			    <li class="waves-effect"><a href="/subscriptions/listtwo"><i class="material-icons">chevron_right</i></a></li>
			  </ul>
			</div>

		</div>
		<!-- list accordian end-->


		<!-- cards start-->
		<div class="col s12 l3">

				<div class="card jisc_card">
					<div class="card-content">
						<span class="card-title">Pending Changes</span>
						<div class="launch-out">
							<a class="btn-floating bordered left-space"><i class="material-icons">open_in_new</i></a>
						</div>
						<div class="card-detail">
							<p>Currently Bangor have:</p>
							<p class="giga-size">123</p>
							<p>changes for <span>36</span> Subscription</p>
						</div>
						<div class="card-meta">
							<a class="btn"><i class="material-icons right">list</i>Review All</a>
							<a class="btn"><i class="material-icons right">list</i>Approve All</a>
						</div>
						<div class="card-detail scrollable-content mt-20">
							<h3>Selected Subscriptions</h3>
              				<ul class="collection coloured with-actions">

  				              <li class="collection-item">
  				              	<div class="col s12">
  				                  	<a href="#">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015</a>
  				                  	<p class="meta">Associated Changes: <span>24</span></p>
  				                </div>
  				              </li>

  				              <li class="collection-item">
  				              	<div class="col s12">
  				                  	<a href="#">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015</a>
  				                  	<p class="meta">Associated Changes: <span>24</span></p>
  				                </div>
  				              </li>



  				            </ul>
						</div>
					</div>
				</div>


				<a href="#modal2" class="waves-effect btn">Export <i class="material-icons right">create</i></a>
				<a href="#modal-upload" class="waves-effect btn">Upload Example <i class="material-icons right">create</i></a>

			<!-- cards end-->

		</div>
	</div>
	<!-- list accordian end-->





	  <!-- example Modal form -->
	  <div id="modal1" class="modal bottom-sheet">
	 	<div class="fixed-action-btn-top">
			<a href="#!" class="z-depth-0 modal-action modal-close btn-floating btn-large waves-effect back-sub"><i class="material-icons">close</i></a>
	    </div>
	    <div class="modal-content">
	    	<div class="container">
	    		<div class="row">
	    		    <div class="col s12 l10 offset-l1">
	    		    	<h1 class="form-title flow-text navy-text">This div is 12-columns wide on all screen sizes</h1>
	    		    	<p class="form-caption flow-text grey-text">Enhancement for future. Add explanatory text on the subs add screen to mitigate</p>
	    		    	<!--form-->
	    		    	<div class="row">
						    <form class="col s12">

						    	<div class="row">
					    	        <div class="input-field col s6">
					    	          <input id="first_name" type="text" class="validate">
					    	          <label for="first_name">First Name</label>
					    	        </div>
					    	        <div class="input-field col s6">
					    	          <input id="last_name" type="text" class="validate">
					    	          <label for="last_name">Last Name</label>
					    	        </div>
				    	        </div>

						    	<div class="row">
							    	<div class="input-field col s12">
									    <select>
									      <option value="" disabled selected>Choose your option</option>
									      <option value="1">Option 1</option>
									      <option value="2">Option 2</option>
									      <option value="3">Option 3</option>
									    </select>
									    <label>Licence</label>
	  								</div>
  								</div>

								<div class="row">
								  <div class="input-field col s12">
								    <select multiple>
								      <option value="" disabled selected>Choose your option</option>
								      <option value="1">Option 1</option>
								      <option value="2">Option 2</option>
								      <option value="3">Option 3</option>
								    </select>
								    <label>Subscription Identifiers</label>
								  </div>
								</div>

								<div class="row">
								  	<div class="input-field col s12 m6">
								    	<input placeholder="Click to add date"  id="start_date" type="date" class="datepicker">
                      <label>Start Date</label>
								  	</div>
								  	<div class="input-field col s12 m6">
                      <label>End Date</label>
									    <input placeholder="Click to add date" id="end_date" type="date" class="datepicker">
								  	</div>
								</div>

								<div class="row">
								  <div class="input-field col s12">
                    <label>Manual Review Date</label>
								    	<input placeholder="Click to add date"  id="end_date" type="date" class="datepicker">
								  </div>
								</div>

						    	<div class="row">
							    	<div class="input-field col s12">
									    <select>
									      <option value="" disabled selected>Choose your option</option>
									      <option value="1">Option 1</option>
									      <option value="2">Option 2</option>
									      <option value="3">Option 3</option>
									    </select>
									    <label>Child</label>
	  								</div>
  								</div>

						    	<div class="row">
							    	<div class="input-field col s12">
									    <select>
									      <option value="" disabled selected>Choose your option</option>
									      <option value="1">Option 1</option>
									      <option value="2">Option 2</option>
									      <option value="3">Option 3</option>
									    </select>
									    <label>Role</label>
	  								</div>
  								</div>

  								<div class="row">
  									<div class="input-field col s12">
  										<a class="waves-effect waves-light btn">Submit</a>
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


	  <!-- example Modal form -->
	  <div id="modal2" class="modal bottom-sheet">
	 	<div class="fixed-action-btn-top">
			<a href="#!" class="z-depth-0 modal-action modal-close-all btn-floating btn-large waves-effect back-sub"><i class="material-icons">close</i></a>
	    </div>
	    <div class="modal-content">
	    	<div class="container">
	    		<div class="row">
	    		    <div class="col s12 l10 offset-l1">
	    		    	<h1 class="form-title flow-text navy-text center">Choose Export Type</h1>
	    		    	<!--form-->
	    		    	<div class="row">
						  <div class="launch-item-container">
						  	<a class="launch-item" href="#modal1">
							  	<div class="content">
							  		<i class="large material-icons">add</i>
							  		<div class="title">Add</div>
						  		</div>
						  	</a>
					      </div>
					      <div class="launch-item-container">
					      	<a class="launch-item" href="#modal1">
							  	<div class="content">
							  		<i class="large material-icons">mode_edit</i>
							  		<div class="title">Edit</div>
						  		</div>
						  	</a>
					      </div>
					      <div class="launch-item-container">
					      	<a class="launch-item" href="#modal1">
							  	<div class="content">
							  		<i class="large material-icons">file_download</i>
							  		<div class="title">Download</div>
						  		</div>
						  	</a>
					      </div>

					      <div class="launch-item-container">
					      	<a class="launch-item" href="#modal1">
							  	<div class="content">
							  		<i class="large material-icons">insert_chart</i>
							  		<div class="title">Export type 1</div>
						  		</div>
						  	</a>
					      </div>

					      <div class="launch-item-container">
					      	<a class="launch-item" href="#modal1">
							  	<div class="content">
							  		<i class="large material-icons">insert_chart</i>
							  		<div class="title">Export type 1</div>
						  		</div>
						  	</a>
					      </div>

  						</div>
  						<!--form end-->

	    		    </div>
	    		</div>
			</div>
	    </div>
	  </div>
	  <!-- Modal end -->


	  <!-- example upload Modal form -->
	  <div id="modal-upload" class="modal bottom-sheet">
	 	<div class="fixed-action-btn-top">
			<a href="#!" class="z-depth-0 modal-action modal-close-all btn-floating btn-large waves-effect back-sub"><i class="material-icons">close</i></a>
	    </div>
	    <div class="modal-content">
	    	<div class="container">
	    		<div class="row">
	    		    <div class="col s12 l10 offset-l1">
	    		    	<h1 class="form-title flow-text navy-text">Import Subscription Worksheet</h1>
	    		    	<p class="form-caption flow-text grey-text">Add context discription here.</p>
	    		    	<!--form-->
	    		    	<div class="row">
						    <form class="col s12">


						    	<div class="row">
							    	<div class="file-field input-field col s12">
									    <div class="btn">
									        <span>File <i class="material-icons">add_circle_outline</i></span>
									        <input type="file" multiple>
									    </div>
									    <div class="file-path-wrapper">
									    	<input class="file-path validate" type="text" placeholder="Upload one or more files">
									    </div>
	  								</div>
  								</div>


  								<div class="row">
  									<div class="input-field col s12">
  										<a class="waves-effect waves-light btn">Upload new subscription taken worksheet</a>
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
