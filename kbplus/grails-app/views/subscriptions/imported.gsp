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
   <div class="col s12 l10">
      <h1 class="page-title">Imported Subscriptions Worksheet</h1>
   </div>
   <div class="col s12 l2">
      <a href="#modal-upload" class="waves-effect waves-light btn right">Change Worksheet</a>
   </div>
</div>


<div class="row">
	<div class="col s12">


		<div class="tab-table z-depth-1 table-responsive-scroll">


			<table class="highlight bordered">
	        <thead>
	          <tr>
	              <th>Title</th>
	              <th>From Pkg</th>
	              <th>ISSN</th>
	              <th>eISSN</th>
	              <th>Start Date</th>
	              <th>Start Volume</th>
	              <th>Start Issue</th>
	              <th>End Date</th>
	              <th>End Volume</th>
	              <th>End Issue</th>
	              <th>Core Medium</th>
	          </tr>
	        </thead>

	        <tbody>
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
	        </tbody>
			</table>


		</div>



	</div>
</div>


<div class="row">

	<div class="col s12 page-response">
  	   <a href="#" class="waves-effect waves-light btn">Accept and Process</a>
  	</div>

</div>

<!-- example upload Modal form -->
	  <div id="modal-upload" class="modal bottom-sheet">
	 	<div class="fixed-action-btn-top">
			<a href="#!" class="z-depth-0 modal-action modal-close-all btn-floating btn-large waves-effect"><i class="material-icons">close</i></a>
	    </div>
	    <div class="modal-content">
	    	<div class="container">
	    		<div class="row">
	    		    <div class="col s12 l8 offset-l2">
	    		    	<h1 class="form-title flow-text navy-text">Imported Subscriptions Worksheet</h1>
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
