<!doctype html>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="JUSP Usage statistics" />
	<parameter name="pagestyle" value="core" />
	<parameter name="actionrow" value="tipTemp" />
	<meta name="layout" content="base"/>
	<title>JUSP Usage statistics</title>
</head>
<body class="titles">
<div class="row">
   <div class="col s12 l12">
      <h1 class="page-title left">JUSP Usage statistics</h1>
  </div>
</div>

<div class="row">
	<div class="col s12">
		<div class="card-panel">
			<p class="car-title">Core Dates</p>
			<ul class="collection">
		 		<li class="collection-item">2015-11-01 :</li>
		 		<li class="collection-item">2010-01-01 : 2010-12-31</li>
	 		</ul>
 		</div>
 	</div>
</div>

<!--***table data***-->
<div class="row">
	<div class="col s12">
		<div class="tab-table z-depth-1">
			<h1 class="table-title">Usage Records</h1>
			<!--***table***-->
			<div id="title">
			<!--***tab card section***-->
					 <div class="row table-responsive-scroll">
								<table class="highlight bordered">
										<thead>
											<tr>
												<th data-field="title">Start</th>
												<th data-field="tip">End</th>
												<th data-field="access">Reporting Year</th>
												<th data-field="platform">Reporting Month</th>
												<th data-field="coveragedepth">Type</th>
												<th data-field="identifiers">Value</th>
											</tr>
										</thead>

										<tbody>
											<tr>
												<td>Thu Sep 21 00:00:00 BST 2017</td>
												<td>Thu Sep 21 00:00:00 BST 2017</td>
												<td>2017</td>
												<td>8</td>
												<td>JUSP:JR1</td>
												<td>1234</td>
											</tr>
										</tbody>
							</table>
					 </div>
				</div>
			<!--***table end***-->
			<!-- to be triggered in the action menu add function not button in the page -->
				<a href="#modal1" class="waves-effect btn">Add <i class="material-icons right">create</i></a>
			<!-- to be triggered in the action menu add function not button in the page -->

			<!-- example Modal form -->
		  <div id="modal1" class="modal bottom-sheet">
		  <div class="fixed-action-btn-top">
		 	 <a href="#!" class="z-depth-0 modal-action modal-close btn-floating btn-large waves-effect"><i class="material-icons">close</i></a>
		 	 </div>
		 	 <div class="modal-content">
		 		 <div class="container">
		 			 <div class="row">
		 					 <div class="col s12 l10 offset-l1">
		 						 <h1 class="form-title flow-text navy-text">Add usage information</h1>
		 						 <p class="form-caption flow-text grey-text">Subline here if required</p>
		 						 <!--form-->
		 						 <div class="row">
		 						 <form class="col s12">

		 							 <div class="row">
										 <div class="input-field col s12 m6">
											 <input placeholder="Click to add date"  id="start_date" type="date" class="datepicker">
											 <label>Usage Date</label>
										 </div>
		 										 <div class="input-field col s6">
		 											 <input id="last_name" type="text" class="validate">
		 											 <label for="last_name">Usage record</label>
		 										 </div>
		 									 </div>

		 							 <div class="row">
		 								 <div class="input-field col s12">
		 									 <select>
		 										 <option value="" disabled selected>Choose your option</option>
		 										 <option value="1">JUSP:JR1</option>
		 										 <option value="2">JUSP:JR1a</option>
		 										 <option value="3">JUSP:JR1-JR1a</option>
												 <option value="3">JUSP:JR1GOA</option>

		 									 </select>
		 									 <label>Licence</label>
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
