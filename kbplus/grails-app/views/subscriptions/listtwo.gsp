<!doctype html>
<html lang="en" class="no-js">
<head>
  <parameter name="pagetitle" value="Subscriptions" />
  <parameter name="pagestyle" value="subscriptions" />
  <meta name="layout" content="base"/>
</head>
<body class="subscriptions">

	<!-- search-section start-->
	<div class="row">
		<div class="col s12">
			
			<div class="search-section z-depth-1">
				<form>
					<div class="col s12 mt-10">
						<h3 class="page-title left">Search Your Subscriptions</h3>
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
			<h2 class="list-response text-navy">Returning <span>12</span> Subscriptions</h2>
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

		<div class="col s12 l9 scroll-container">

			<ul class="collapsible jisc_collapsible" data-collapsible="accordion">
			    
			    <!--accordian item-->

			</ul>


			<div id="paginator">
			  <ul class="pagination">
			    <li class="waves-effect"><a href="/subscriptions/list"><i class="material-icons">chevron_left</i></a></li>
			    <li class="waves-effect"><a href="/subscriptions/list">1</a></li>
			    <li class="active"><a href="/subscriptions/listtwo">2</a></li>
			    <li class="disabled"><a href="#!"><i class="material-icons">chevron_right</i></a></li>
			  </ul>
			</div>
			
		</div>	
		<!-- list accordian end-->

		
		<!-- cards start-->
		<div class="col s12 l3">
			
				<div class="card jisc_card">
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
	
			
				<div class="card jisc_card">
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
				
			
				<div class="card jisc_card white navy-text">
					<div class="card-content">
						<span class="card-title">Useful links</span>
						<ul class="collection">
							<li class="collection-item"><a href="">Generate New Subscription Worksheet</a></li>
							<li class="collection-item"><a href="">Import New Subscription Worksheet</a></li>
							<li class="collection-item"><a href="">Create New Empty Subscription </a></li>
						</ul>
					</div>
				</div>
				<a href="#modal2" class="waves-effect btn">Export <i class="material-icons right">create</i></a>

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


	  <!-- example Modal form -->
	  <div id="modal2" class="modal bottom-sheet">
	 	<div class="fixed-action-btn-top">
			<a href="#!" class="z-depth-0 modal-action modal-close-all btn-floating btn-large waves-effect"><i class="material-icons">close</i></a>
	    </div>
	    <div class="modal-content">
	    	<div class="container">
	    		<div class="row">
	    		    <div class="col s12">
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




</body>
</html>
