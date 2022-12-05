<!doctype html>
<html lang="en" class="no-js">
<head>
   <meta name="layout" content="base"/>
</head>
<body>
	
	<!-- search-section start-->
	<div class="row">
		<div class="col s12">
			
			<div class="search-section z-depth-1">
				<form>
				<div class="col s12 mt-10">
					<h3 class="page-title left">Search</h3>
				</div>
				<div class="col s12 m12 l6">
			        <div class="input-field search-main">
				          <input id="search" placeholder="Enter your search term..." type="search" required>
				          <label class="label-icon" for="search"><i class="material-icons">search</i></label>
				          <i class="material-icons close">close</i>
			        </div>
				</div>
				<div class="col s6 m6 l2">
					<div class="input-field">
						<i class="material-icons prefix" style="margin-top: 10px; margin-left: 15px;">today</i>
						<input placeholder="Start Date"  id="start_date" type="date" class="datepicker">
					</div>
				</div>
				<div class="col s6 m6 l2">
					<div class="input-field">
						<i class="material-icons prefix" style="margin-top: 10px; margin-left: 15px;">today</i>
						<input placeholder="End Date" id="end_date" type="date" class="datepicker">
					</div>
				</div>
				<div class="col s6 m3 l1">
					<a class="waves-effect waves-teal btn">Search</a>
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
					      	
	  					      	<div class="col s12 m12 l6">
	  	      						<div class="input-field">
	  									<select>
	  										<option value="" disabled selected>Packages</option>
	  										<option value="1">Option 1</option>
	  										<option value="2">Option 2</option>
	  										<option value="3">Option 3</option>
	  									</select>
	  								</div>
	  	      					</div>

						      	<div class="col s6 m6 l3">
		      						<a class="waves-effect btn">A/Z</a>
		      						<a class="waves-effect btn active">Recently Edited</a>
		      					</div>


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
			<h2 class="list-reponce green-text">Returning 12 Subscriptions</h2>
			<div class="input-field">
			    <select>
			      <option value="" disabled selected>Sort By</option>
			      <option value="1">Option 1</option>
			      <option value="2">Option 2</option>
			      <option value="3">Option 3</option>
			    </select>
			 </div>
		</div>
	
	</div>
	<!-- list returning/results end-->
	

	<!-- list accordian start-->
	<div class="row">

		<div class="col s12 l9">

			<ul class="collapsible jisc_collapsible subscriptions" data-collapsible="accordion">
			    
			    <!--accordian item-->
			    <li>
			    	<!--accordian header-->
			      	<div class="collapsible-header">
			      		<div class="col s10">
			      			<i class="icon-accordian"></i>
			      			<ul class="collection">
			      				<li class="collection-item"><h2 class="first navy-text">Annual Review 2015</h2></li>
			      				<li class="collection-item">Duration: <span>01.01.2017</span> until <span>31.12.2018</span></li>
			      				<li class="collection-item">ISSN: <span>1324-5436</span></li>
			      				<li class="collection-item">License: <span>Damyanti demo Nature Publishing Group/Jisc Collections/NPG Journals/2016</span></li>
			      				<li class="collection-item">Associated Packages: <span class="inline-badge tooltipped card-tooltip" data-src="temp-ref-id">14</span> </li>
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
			      		<div class="col s2 full-height-divider">
			      			<ul class="collection">
			      				<li class="collection-item first">
			      					<div class="label expired"><i class="material-icons">timer_off</i>Expired</div>
			      				</li>
			      				<li class="collection-item">
			      					<div class="label default"><i class="material-icons">settings</i>Manual</div>
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
			      			      <div class="host-link-launch">
			      			      	<a class="btn-floating btn-large waves-effect waves-light green"><i class="material-icons">launch</i></a><br/>
			      			      	<p>Host Link</p>
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


			    <!--accordian item-->
			    <li>
			    	<!--accordian header-->
			      	<div class="collapsible-header">
			      		<div class="col s10">
			      			<i class="icon-accordian"></i>
			      			<ul class="collection">
			      				<li class="collection-item"><h2 class="first navy-text">Annual Review 2015</h2></li>
			      				<li class="collection-item">From Duration: <span>01.01.2017</span> until <span>31.12.2018</span></li>
			      				<li class="collection-item">ISSN: <span>1324-5436</span></li>
			      				<li class="collection-item">License: <span>Damyanti demo Nature Publishing Group/Jisc Collections/NPG Journals/2016</span></li>
			      				<li class="collection-item">Associated Packages: Damyanti demo Nature Publishing Group</li>
			      			</ul>
			      		</div>
			      		<div class="col s2 full-height-divider">
			      			<ul class="collection">
			      				<li class="collection-item first">
			      					<div class="label current"><i class="material-icons">access_time</i>Current</div>
			      				</li>
			      				<li class="collection-item">
			      					<div class="label default"><i class="material-icons">loop</i>Auto</div>
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
			      			      <div class="host-link-launch">
			      			      	<a class="btn-floating btn-large waves-effect waves-light green"><i class="material-icons">launch</i></a><br/>
			      			      	<p>Host Link</p>
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


		    <!--accordian item-->
		    <li>
		    	<!--accordian header-->
		      	<div class="collapsible-header">
		      		<div class="col s10">
		      			<i class="icon-accordian"></i>
		      			<ul class="collection">
		      				<li class="collection-item"><h2 class="first navy-text">Annual Review 2015</h2></li>
		      				<li class="collection-item">Duration: From <span>01.01.2017</span> until <span>31.12.2018</span></li>
		      				<li class="collection-item">ISSN: <span>1324-5436</span></li>
		      				<li class="collection-item">License: <span>Damyanti demo Nature Publishing Group/Jisc Collections/NPG Journals/2016</span></li>
		      				<li class="collection-item">Associated Packages: Jisc Collections/NPG Journals</li>
		      			</ul>
		      		</div>
		      		<div class="col s2 full-height-divider">
		      			<ul class="collection">
		      				<li class="collection-item first">
		      					<div class="label expired"><i class="material-icons">timer_off</i>Expired</div>
		      				</li>
		      				<li class="collection-item">
		      					<div class="label default"><i class="material-icons">code</i>Independent</div>
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
		      			      <div class="host-link-launch">
		      			      	<a class="btn-floating btn-large waves-effect waves-light green"><i class="material-icons">launch</i></a><br/>
		      			      	<p>Host Link</p>
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
		</div>	
		<!-- list accordian end-->

		
		<!-- cards start-->
		<div class="col s12 l3">
			
				<div class="card jisc_card subscriptions">
					<div class="card-content white-text">
						<span class="card-title">Pending Changes</span>
						<div class="launch-out">
							<a class="btn-floating waves-effect waves-light white"><i class="material-icons">open_in_new</i></a>
						</div>
						<div class="card-detail">
							<p>you have:</p>
							<p class="giga-size">12</p>
							<p>changes for this Subscription</p>
						</div>
						<div class="card-meta">
							<a class="waves-effect waves-light btn white"><i class="material-icons right">list</i>Approve All</a>
						</div>
					</div>
				</div>
	
			
				<div class="card jisc_card subscriptions">
					<div class="card-content white-text">
						<span class="card-title">Announcements</span>
						<div class="launch-out">
							<a class="btn-floating waves-effect waves-light white"><i class="material-icons">open_in_new</i></a>
						</div>
						<div class="card-detail">
							<p>you have:</p>
							<p class="giga-size">16</p>
							<p>announcements</p>
						</div>
					</div>
				</div>
				
			
				<!-- <div class="card jisc_card white navy-text">
					<div class="card-content">
						<span class="card-title">Useful links</span>
						<ul class="collection">
							<li class="collection-item"><a href="">Generate New Subscription Worksheet</a></li>
							<li class="collection-item"><a href="">Import New Subscription Worksheet</a></li>
							<li class="collection-item"><a href="">Create New Empty Subscription </a></li>
						</ul>
					</div>
				</div> -->
			<!-- cards end-->

		</div>	  
	</div>
	<!-- list accordian end-->





	  <!-- example Modal form -->
	  <div id="modal1" class="modal bottom-sheet">
	 	<div class="fixed-action-btn-top">
			<a href="#!" class="z-depth-0 transparent modal-action modal-close btn-floating btn-large waves-effect waves-dark"><i class="material-icons">close</i></a>
	    </div>
	    <div class="modal-content">
	    	<div class="container">
	    		<div class="row">
	    		    <div class="col s12 l8 offset-l2">
	    		    	<h1 class="form-title flow-text navy-text">This div is 12-columns wide on all screen sizes</h1>
	    		    	<p class="form-caption flow-text grey-text">Phasellus sit amet purus a enim aliquet blandit quis a quam. Cras suscipit eros in.</p>
	    		    	<!--form-->
	    		    	<div class="row">
						    <form class="col s12">

						    	<div class="row">
					    	        <div class="input-field col s6">
					    	          <input placeholder="Placeholder" id="first_name" type="text" class="validate">
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
								    	<input placeholder="Start Date"  id="start_date" type="date" class="datepicker">
								  	</div>
								  	<div class="input-field col s12 m6">
									    <input placeholder="End Date"  id="end_date" type="date" class="datepicker">
								  	</div>
								</div>  

								<div class="row">
								  <div class="input-field col s12">
								    	<input placeholder="Manual Review Date"  id="end_date" type="date" class="datepicker">
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




</body>
</html>
