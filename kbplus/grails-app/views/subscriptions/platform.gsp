<!doctype html>
<html lang="en" class="no-js">
<head>
  <parameter name="pagetitle" value="Subscriptions" />
  <parameter name="pagestyle" value="subscriptions" />
  <parameter name="actionrow" value="subscriptions" />
  <meta name="layout" content="base"/>
</head>
<body class="subscriptions">

  <!--page title-->
  <div class="row">
     <div class="col s12 l10">
        <h1 class="page-title">Platform List</h1>
     </div>
  </div>
  <!--page title end-->

	<!-- search-section start-->
	<div class="row">
		<div class="col s12">
			<div class="mobile-collapsible-header" data-collapsible="subscription-platform-collapsible">Search <i class="material-icons">expand_more</i></div>
			<div class="search-section z-depth-1 mobile-collapsible-body" id="subscription-platform-collapsible">
				<form>
					<div class="col s12 mt-10">
						<h3 class="page-title left">Search Your Platform</h3>
					</div>
				<div class="col s12 m12 l5">
			        <div class="input-field search-main">
				          <input id="search" placeholder="Enter your search term..." type="search" required>
				          <label class="label-icon" for="search"><i class="material-icons">search</i></label>
				          <i class="material-icons">close</i>
			        </div>
				</div>
        <div class="col s12 m12 l5 mt-10">
           <div class="input-field mar-min">
              <select>
                 <option value="1">Option 1</option>
                 <option value="2">Option 2</option>
                 <option value="3">Option 3</option>
              </select>
              <label>Deleted Records</label>
           </div>
         </div>
         <div class="col s6 m6 l1">
			<a class="waves-effect waves-teal btn">Search</a>
		</div>
			<div class="col s6 m6 l1">
				<a href="#" class="resetsearch">Reset</a>
			</div>



				</form>
			</div>

		</div>
	</div>
	<!-- search-section end-->

<!-- platform tables-->
<div class="row">
  <div class="col s12">
    <div class="tab-table z-depth-1">
          <h2>Platforms</h2>

        <!--***table***-->
      <div id="licence-properties">

      <!--***tab card section***-->
           <div class="row table-responsive-scroll">
                <table class="highlight bordered">
                    <thead>
                      <tr>
                          <th data-field="organisation">Name</th>
                          <th data-field="roles">Status</th>
                          <th data-field="note">Action</th>
                      </tr>
                    </thead>

                    <tbody>
						<tr>
						  <td>American Physiological Society</td>
						  <td></td>
						  <td> </td>
						</tr>
						<tr>
						  <td>American Psychosomatic Society</td>
						  <td></td>
						  <td> </td>
						</tr>
						<tr>
						  <td>American Society for Biochemistry and Molecular Biology</td>
						  <td></td>
						  <td> </td>
						</tr>
					</tbody>
			  </table>
		   </div>

	  </div>
      <!--***table end***-->
	<!-- platform table end-->



<!-- example upload Modal form -->
	  <div id="modal-upload" class="modal bottom-sheet">
	 	<div class="fixed-action-btn-top">
			<a href="#!" class="z-depth-0 modal-action modal-close-all btn-floating btn-large waves-effect"><i class="material-icons">close</i></a>
	    </div>
	    <div class="modal-content">
	    	<div class="container">
	    		<div class="row">
	    		    <div class="col s12 l8 offset-l2">
	    		    	<h1 class="form-title flow-text navy-text">Import Renewals Worksheet</h1>
	    		    	<p class="form-caption flow-text grey-text">Upload worksheet will create a new subscription taken for JISC Collections based on the following rows</p>
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

  								<div class="row">
  									<div class="input-field col s12">
		  								<div class="tab-table z-depth-1">


					  						<table class="highlight bordered responsive-table">
						            	        <thead>
						            	          <tr>
						            	              <th>Select</th>
						            	              <th>Subscription Properties</th>
						            	              <th>Value</th>
						            	          </tr>
						            	        </thead>

						            	        <tbody>
													<tr>
														<td>
															<input type="checkbox" id="test91">
															<label for="test91">&nbsp;</label>
														</td>
														<td>Start date</td>
														<td></td>
													</tr>
													<tr>
														<td>
															<input type="checkbox" id="test92">
															<label for="test92">&nbsp;</label>
														</td>
														<td>End date</td>
														<td></td>
													</tr>
													<tr>
														<td>
															<input type="checkbox" id="test93">
															<label for="test93">&nbsp;</label>
														</td>
														<td>Copy Documents and Notes from Subscription</td>
														<td></td>
													</tr>
						            	        </tbody>
			        	      				</table>


		  								</div>
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
