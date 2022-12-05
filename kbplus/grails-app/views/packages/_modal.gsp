<!-- example Modal form -->
	  <div id="modal1" class="modal bottom-sheet">
	 	<div class="fixed-action-btn-top">
			<a href="#!" class="z-depth-0 transparent modal-action modal-close btn-floating btn-large waves-effect waves-dark back-pack"><i class="material-icons">close</i></a>
	    </div>
	    <div class="modal-content">
	    	<div class="container">
	    		<div class="row">
	    		    <div class="col s12 l8 offset-l2">
	    		    	<h1 class="form-title flow-text navy-text">Compare Two Packages</h1>
	    		    	<p class="form-caption flow-text grey-text">Phasellus sit amet purus a enim aliquet blandit quis a quam. Cras suscipit eros in.</p>
	    		    	<!--form-->
	    		    	<div class="row">
						    <form class="col s12">

								<!--row-->
								<div class="row">
									<div class="col s12">
										<h3 class="indicator">Package One</h3>
										<p class="grey-text">Phasellus sit amet purus a enim aliquet blandit quis a quam. Cras suscipit eros in.</p>
									</div>
								</div>

								<!--row-->
								<div class="row">
								  	<div class="input-field col s12 m6">
											<label for="">Starting After</label>	
								    	<input placeholder="Click to add dater"  id="start_date" type="date" class="datepicker">
								  	</div>
								  	<div class="input-field col s12 m6">
											<label for="">Ending Before</label>
									    <input placeholder="Click to add date"  id="end_date" type="date" class="datepicker">
								  	</div>
								</div>
								<!--end row-->

								<!--row-->
								<div class="row">
									<div class="input-field col s12">
										<input type="text" id="autocomplete-input" class="autocomplete">
										<label for="autocomplete-input">Type Packages</label>
										<!--refer to .autocomplete() function in application.js-->
									</div>
								</div>
								<!--end row-->

								<!--row-->
								<div class="row section">
									<div class="input-field col s12 m6">
										<label for="">Packages on Date</label>
								    	<input placeholder="Click to add date"  id="start_date" type="date" class="datepicker">
								  	</div>
								</div>
								<!--end row-->




								<!--row-->
								<div class="row">
									<div class="col s12">
										<h3 class="indicator">Package Two</h3>
										<p class="grey-text">Phasellus sit amet purus a enim aliquet blandit quis a quam. Cras suscipit eros in.</p>
									</div>
								</div>

								<!--row-->
								<div class="row">
								  	<div class="input-field col s12 m6">
											<label for="">Starting After</label>
								    	<input placeholder="Click to add dater"  id="start_date" type="date" class="datepicker">
								  	</div>
								  	<div class="input-field col s12 m6">
											<label for="">Ending Before</label>
									    <input placeholder="Click to add date"  id="end_date" type="date" class="datepicker">
								  	</div>
								</div>
								<!--end row-->

								<!--row-->
								<div class="row">
									<div class="input-field col s12">
										<input id="last_name" type="text" class="validate">
										<label for="last_name">Type Packages</label>
									</div>
								</div>
								<!--end row-->

								<!--row-->
								<div class="row section">
									<div class="input-field col s12 m6">
										<label for="">Packages on Date</label>
								    	<input placeholder="Click to add date"  id="start_date" type="date" class="datepicker">
								  	</div>
								</div>
								<!--end row-->







								<div class="row">
									<div class="col s12">
										<h3 class="indicator">Add Filter</h3>
									</div>
								</div>

								<div class="row">
									<div class="col s3">
										<input type="checkbox" id="test1" />
										<label for="test1">Insert</label>
									</div>
									<div class="col s3">
										<input type="checkbox" id="test2" />
										<label for="test2">Delete</label>
									</div>
									<div class="col s3">
										<input type="checkbox" id="test3" />
										<label for="test3">Update</label>
									</div>
									<div class="col s3">
										<input type="checkbox" id="test4" />
										<label for="test4">No Change</label>
									</div>
								</div>



  								<div class="row last">
  									<div class="input-field col s12">
  										<a class="waves-effect waves-light btn">Submit</a>
  									</div>
  								</div>



						    </form>
						    <!--form end-->
  						</div>
  						<!--parent row end-->

	    		    </div>
	    		</div>
			</div>
	    </div>
	  </div>
	  <!-- Modal end -->
