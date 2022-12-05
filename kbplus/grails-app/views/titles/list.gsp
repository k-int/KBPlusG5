<!doctype html>
<html lang="en" class="no-js">
<head>
  <parameter name="pagetitle" value="Titles" />
  <parameter name="pagestyle" value="Titles" />
  <parameter name="actionrow" value="titles" />
  <meta name="layout" content="base"/>
</head>
<body class="titles">

	<div class="row">
		<div class="col s12">
			<ul class="tabs jisc_tabs mt-40m">
		    	<li class="tab col s2"><a href="#allTitles">All Titles</a></li>
		        <li class="tab col s2"><a href="#ourTitles">Our Titles</a></li>
		    </ul>
		</div>
	</div>

	<div id="allTitles" class="tab-content">

	<!-- search-section start-->
	<div class="row">
		<div class="col s12">



			<div class="search-section z-depth-1">
				<form>
				<div class="col s12 m12 l5">
			        <div class="input-field search-main">
				          <input id="search" placeholder="Enter your search term..." type="search" required>
				          <label class="label-icon" for="search"><i class="material-icons">search</i></label>
				          <i class="material-icons">close</i>
			        </div>
				</div>
				<div class="col s12 l3 mt-10">
					<div class="input-field">
						<input placeholder="click to add date"  id="start_date" type="date" class="datepicker">
            <label>Start Date</label>
					</div>
				</div>
				<div class="col s12 l3 mt-10">
					<div class="input-field">
						<input placeholder="click to add date" id="end_date" type="date" class="datepicker">
            			<label>End Date</label>
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

	  					      	<div class="col s12 m12 l6">
	  	      						<div class="input-field">
	  									<select>
	  										<option value="" disabled selected>- - - - - - - </option>
	  										<option value="1">Option 1</option>
	  										<option value="2">Option 2</option>
	  										<option value="3">Option 3</option>
	  									</select>
                      <label>Packages</label>
	  								</div>
	  	      					</div>

						      	<div class="col s12 l3">
		      						<a class="waves-effect btn">A/Z</a>
		      						<a class="waves-effect btn active right back-title">Recently Edited</a>
		      					</div>

		      					<div class="col s12 l3 mt-10">
		      						<div class="radio-container-float left">
      									<input type="checkbox" id="test5" />
								      	<label class"pt-10" for="test5">Titles subscribed to via two or more Packages</label>
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
	</div>
	<!-- search-section end-->


	<!-- list returning/results-->
	<div class="row">

		<div class="col s12 page-response">
			<h2 class="list-response text-navy">Entitlements showing: <span>1</span> to <span>10</span> of <span>276</span></h2>
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
						    <label>Sort titles by: A-Z (default)</label>
						 </div>
					</div>

					<div class="col s12 l6 filter-actions button-area-line">


					</div>

				</div>
			</div>
		</div>


	</div>
	<!-- list returning/results end-->


	<!-- list accordian start-->
	<div class="row">

		<div class="col s12 l12">

			<ul class="collapsible jisc_collapsible" data-collapsible="accordion">

			    <!--accordian item-->
			    <li>
			    	<!--accordian header-->
			      	<div class="collapsible-header">
			      		<div class="col s9">
			      			<i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Click to toggle"></i>
			      			<ul class="collection">
			      				<li class="collection-item">
			      					<h2 class="first navy-text"><a href="/titles/detail">Ports '01:America's Ports: Gateway to the Global Economy Ports Conference 2001</a> <i class="material-icons theme-icon flag">flag</i></h2>
			      				</li>
			      				<li class="collection-item">Publishers: <span>Society for Advancement of Management</span></li>
                    <li class="collection-item">
                      Associated:
                      <span class="indicator"><i class="material-icons">library_books</i> Subscriptions (4)</span>
                      <span class="indicator"><i class="material-icons left">description</i> Licences (2)</span>
                    </li>
                    <li class="collection-item">
			      					isbn: <span>9780784405550</span><br>
			      					eissn: <span>9780784405550</span><br>
			      					jusp: <span>9780784405550</span>
			      				</li>
                   
			      			</ul>
			      		</div>
                <div class="col s2 full-height-divider">
                  <ul class="collection">
                    <li class="collection-item terms">
                  <a class="btn-floating btn-large waves-effect terms centered tooltipped" data-position="left" data-delay="50" data-tooltip="Since 2017"><i class="material-icons">collections_bookmark</i></a><br/>
                  <p class="center-align"><a href="#">Licence Terms</a></p>
                </li>
                <li class="collection-item status">
                  <a class="btn-floating btn-large waves-effect with-core centered tooltipped" data-position="left" data-delay="50" data-tooltip="Since 2017"><i class="material-icons"></i></a><br/>
                  <p class="center-align"><a href="#">Core Status</a></p>
                </li>
                  </ul>
                </div>
                <div class="col s1 full-height-divider">
                  <ul class="collection">
                    <li class="collection-item actions first">
                      <div class="actions-container">
                        <a href="" class="btn-floating btn-flat"><i class="material-icons theme-icon">delete_forever</i></a>
                      </div>
                    </li>
                  </ul>
                </div>

			      	</div>
			      	<!-- accordian header end-->

			      	<!-- accordian body-->
			      	<div class="collapsible-body">

			      		<div class="row">

			      			<div class="col s12 m3">
			      				<h3>Included Subscriptions</h3>
                    <ul class="content-list">
                      <li><a href="">ASCE 2015</a> <a href="">Issue Format</a></li>
                      <li><a href="">Annual review 2015</a> <a href="">Issue Format</a></li>
                      <li><a href="">EDP 2016</a> <a href="">Issue Format</a></li>
                      <li><a href="">Elsevier Open Access</a> <a href="">Issue Format</a></li>
                    </ul>
			      			</div>

			      			<div class="col s12 m3">
			      				<h3>Licences</h3>
                    <p><a href="">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015</a></p>
                    <p><a href="">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015</a></p>
			      			</div>

			      		<!--row end-->
                <div class="row">
			      			<div class="col s12">
			      				<h3>Licences Key Properties: {liecence #1}</h3>
			      				<div class="properties-container center-graphic">
			      					<div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">computer_black</i><i class="material-icons icon-offset yes">done</i></div>
                        Include in VLE
			      					</div>
			      					<div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">library_books</i><i class="material-icons icon-offset no">clear</i></div>
                        Include in Coursepacks
			      					</div>
			      					<div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">call_split_black</i><i class="material-icons icon-offset yes">done</i></div>
                        Inter-library Loan
			      					</div>
			      					<div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">directions_walk</i><i class="material-icons icon-offset neither">info_outline</i></div>
                        Walk-in  access
			      					</div>
			      					<div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">cast_connected_black</i><i class="material-icons icon-offset yes">done</i></div>
                        Remote access
			      					</div>
			      					<div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">group_black</i><i class="material-icons icon-offset no">clear</i></div>
                        Alumni Access
			      					</div>
			      				</div>

			      			</div>
			      		</div>

                <div class="row">
			      			<div class="col s12">
			      				<h3>Licences Key Properties : {liecence #2}</h3>
			      				<div class="properties-container center-graphic">
			      					<div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">computer_black</i><i class="material-icons icon-offset yes">done</i></div>
                        Include in VLE
			      					</div>
			      					<div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">library_books</i><i class="material-icons icon-offset no">clear</i></div>
                        Include in Coursepacks
			      					</div>
			      					<div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">call_split_black</i><i class="material-icons icon-offset yes">done</i></div>
                        Inter-library Loan
			      					</div>
			      					<div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">directions_walk</i><i class="material-icons icon-offset neither">info_outline</i></div>
                        Walk-in  access
			      					</div>
			      					<div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">cast_connected_black</i><i class="material-icons icon-offset yes">done</i></div>
                        Remote access
			      					</div>
			      					<div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">group_black</i><i class="material-icons icon-offset no">clear</i></div>
                        Alumni Access
			      					</div>
			      				</div>

			      			</div>
			      		</div>

			      		<div class="row">
			      			<div class="col s12">
					      		<div class="cta">
					      			<a href="/titles/detail" class="waves-effect waves-light btn">View All</a>
                      <a href="#" class="waves-effect btn">Delete <i class="material-icons right">delete_forever</i></a>
					      		</div>
				      		</div>
			      		</div>
			      		<!--row end-->

			      	</div>
			      	<!-- accordian body end-->
			    </li>
				<!-- accordian item end-->



				    <!--accordian item-->
				    <li>
				    	<!--accordian header-->
				      	<div class="collapsible-header">
				      		<div class="col s9">
				      			<i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Click to toggle"></i>
				      			<ul class="collection">
				      				<li class="collection-item"><h2 class="first navy-text"><a href="/titles/detail">Ports '01:America's Ports: Gateway to the Global Economy Ports Conference 2001</a></h2></li>
				      				<li class="collection-item">Publishers: <span>Society for Advancement of Management</span></li>
				      				<li class="collection-item">
				                        Associated:
				                        <span class="indicator"><i class="material-icons">library_books</i> Subscriptions (4)</span>
				                        <span class="indicator"><i class="material-icons left">description</i> Licences (2)</span>
				                      </li>
				      				<li class="collection-item">
				      				isbn: <span>9780784405550</span><br>
				      				eissn: <span>9780784405550</span><br>
				      				jusp: <span>9780784405550</span>
				      				</li>
                      
				      			</ul>
				      		</div>
				      		<div class="col s2 full-height-divider">
				      			<ul class="collection">
                      <li class="collection-item terms">
                    <a class="btn-floating btn-large waves-effect terms centered tooltipped" data-position="left" data-delay="50" data-tooltip="Since 2017"><i class="material-icons">collections_bookmark</i></a><br/>
                    <p class="center-align"><a href="#">Licence Terms</a></p>
                  </li>
                  <li class="collection-item status">
                    <a class="btn-floating btn-large waves-effect not-core centered tooltipped" data-position="left" data-delay="50" data-tooltip="Since 2017"><i class="material-icons"></i></a><br/>
                    <p class="center-align"><a href="#">Core Status</a></p>
                  </li>
				      			</ul>
				      		</div>
                  <div class="col s1 full-height-divider">
				      			<ul class="collection">
				      				<li class="collection-item actions first">
				      					<div class="actions-container">
					      					<a href="" class="btn-floating btn-flat"><i class="material-icons theme-icon">add</i></a>
				      					</div>
				      				</li>
				      			</ul>
				      		</div>

				      	</div>
				      	<!-- accordian header end-->

				      	<!-- accordian body-->
				      	<div class="collapsible-body">

				      		<div class="row">
				      			<div class="col s12 m3">
				      				<h3>Included Subscriptions</h3>
                      <ul class="content-list">
                        <li><a href="">ASCE 2015</a> <a href="">Issue Format</a></li>
                        <li><a href="">Annual review 2015</a> <a href="">Issue Format</a></li>
                        <li><a href="">EDP 2016</a> <a href="">Issue Format</a></li>
                        <li><a href="">Elsevier Open Access</a> <a href="">Issue Format</a></li>
                      </ul>

				      			</div>
				      			<div class="col s12 m3">
				      				<h3>Licences</h3>
				      				<p><a href="">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015</a></p>
				      				<p><a href="">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015</a></p>

				      			</div>

                    <div class="row">
    			      			<div class="col s12">
    			      				<h3>Licences Key Properties: {liecence #1}</h3>
    			      				<div class="properties-container center-graphic">
    			      					<div class="col s6 l2 property">
                            <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">computer_black</i><i class="material-icons icon-offset yes">done</i></div>
                            Include in VLE
    			      					</div>
    			      					<div class="col s6 l2 property">
                            <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">library_books</i><i class="material-icons icon-offset no">clear</i></div>
                            Include in Coursepacks
    			      					</div>
    			      					<div class="col s6 l2 property">
                            <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">call_split_black</i><i class="material-icons icon-offset yes">done</i></div>
                            Inter-library Loan
    			      					</div>
    			      					<div class="col s6 l2 property">
                            <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">directions_walk</i><i class="material-icons icon-offset neither">info_outline</i></div>
                            Walk-in  access
    			      					</div>
    			      					<div class="col s6 l2 property">
                            <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">cast_connected_black</i><i class="material-icons icon-offset yes">done</i></div>
                            Remote access
    			      					</div>
    			      					<div class="col s6 l2 property">
                            <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">group_black</i><i class="material-icons icon-offset no">clear</i></div>
                            Alumni Access
    			      					</div>
    			      				</div>

    			      			</div>
    			      		</div>

                    <div class="row">
    			      			<div class="col s12">
    			      				<h3>Licences Key Properties : {liecence #2}</h3>
    			      				<div class="properties-container center-graphic">
    			      					<div class="col s6 l2 property">
                            <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">computer_black</i><i class="material-icons icon-offset yes">done</i></div>
                            Include in VLE
    			      					</div>
    			      					<div class="col s6 l2 property">
                            <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">library_books</i><i class="material-icons icon-offset no">clear</i></div>
                            Include in Coursepacks
    			      					</div>
    			      					<div class="col s6 l2 property">
                            <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">call_split_black</i><i class="material-icons icon-offset yes">done</i></div>
                            Inter-library Loan
    			      					</div>
    			      					<div class="col s6 l2 property">
                            <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">directions_walk</i><i class="material-icons icon-offset neither">info_outline</i></div>
                            Walk-in  access
    			      					</div>
    			      					<div class="col s6 l2 property">
                            <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">cast_connected_black</i><i class="material-icons icon-offset yes">done</i></div>
                            Remote access
    			      					</div>
    			      					<div class="col s6 l2 property">
                            <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">group_black</i><i class="material-icons icon-offset no">clear</i></div>
                            Alumni Access
    			      					</div>
    			      				</div>

    			      			</div>
    			      		</div>


				      		<div class="row">
				      			<div class="col s12">
						      		<div class="cta">
						      			<a href="/titles/detail" class="waves-effect waves-light btn">View Alls</a>
                        <a href="#" class="waves-effect btn">Add <i class="material-icons right">add_circle_outline</i></a>
						      		</div>
					      		</div>
				      		</div>

				      	</div>
				      	<!-- accordian body end-->

				    </li>
					<!-- accordian item end-->








			</ul>

			  <!-- pagination without infinate scroll (removal of scroll class and paginator div) -->
			  <ul class="pagination">
			    <li class="disabled"><a href="#!"><i class="material-icons">chevron_left</i></a></li>
			    <!-- Start of for loop -->
			    <li class="active"><a href="/licences/list">1</a></li>
			    <!-- End of loop -->
			    <li class="waves-effect"><a href="/licences/listtwo">2</a></li>
			    <li class="waves-effect"><a href="/licences/listtwo"><i class="material-icons">chevron_right</i></a></li>
			  </ul>


		</div>
		<!-- list accordian end-->
	</div>
	<!-- list accordian end-->


	</div>
	<!-- end of first tab -->

	<div id="ourTitles" class="tab-content">

	<!-- search-section start-->
	<div class="row">
		<div class="col s12">



			<div class="search-section z-depth-1">
				<form>
				<div class="col s12 m12 l6">
			        <div class="input-field search-main">
				          <input id="search" placeholder="Enter your search term..." type="search" required>
				          <label class="label-icon" for="search"><i class="material-icons">search</i></label>
				          <i class="material-icons">close</i>
			        </div>
				</div>
        <div class="col s6 m6 l2 mt-10">
					<div class="input-field">
						<input placeholder="click to add date"  id="start_date" type="date" class="datepicker">
            <label>Start Date</label>
					</div>
				</div>
				<div class="col s6 m6 l2 mt-10">
					<div class="input-field">
						<input placeholder="click to add date" id="end_date" type="date" class="datepicker">
            <label>End Date</label>
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
	  										<option value="" disabled selected>- - - - - - -   </option>
	  										<option value="1">Option 1</option>
	  										<option value="2">Option 2</option>
	  										<option value="3">Option 3</option>
	  									</select>
                      <label>Packages</label>
	  								</div>
	  	      					</div>

						      	<div class="col s6 m6 l3">
		      						<a class="waves-effect btn">A/Z</a>
		      						<a class="waves-effect btn active back-title">Recently Edited</a>
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
			<h2 class="list-response text-navy">Entitlements showing: <span>1</span> to <span>10</span> of <span>276</span></h2>
			<div class="input-field">
			    <select>
			      <option value="1">A-Z</option>
			      <option value="2">Option 2</option>
			      <option value="3">Option 3</option>
			    </select>
          <label>Sort by</label>
			 </div>
		</div>

	    <div class="col s12 page-response">
	    	<div class="right">
	    		<a href="#" class="waves-effect waves-light btn"><i class="material-icons right">add_circle_outline</i>Batch Task all current search</a>
	    		<a href="#" class="waves-effect waves-light btn"><i class="material-icons right">add_circle_outline</i>Batch Task</a>
	    	</div>

	    </div>

	</div>
	<!-- list returning/results end-->


	<!-- list accordian start-->
	<div class="row">

		<div class="col s12 l9">

			<ul class="collapsible jisc_collapsible" data-collapsible="accordion">

			    <!--accordian item-->
			    <li>
			    	<!--accordian header-->
			      	<div class="collapsible-header">
			      		<div class="col s10">
			      			<div class="icon-collection">
			      				<i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Click to toggle"></i>
				      			<input type="checkbox" id="test1" />
	                        	<label for="test1">&nbsp;</label>
                  			</div>

			      			<ul class="collection">
			      				<li class="collection-item"><h2 class="first navy-text"><a href="/titles/yours">Ports '01:America's Ports: Gateway to the Global Economy Ports Conference 2001</a></h2></li>
			      				<li class="collection-item">Earlist date: <span>01.01.2017</span> Latest Date: <span>31.12.2018</span></li>
			      				<li class="collection-item">Publishers: <span>Society for Advancement of Management</span></li>
			      				<li class="collection-item">
			      				isbn: <span>9780784405550</span><br>
			      				eissn: <span>9780784405550</span><br>
			      				jusp: <span>9780784405550</span>
			      				</li>
                    <li class="collection-item">
			      					<div class="btn simple-btn"><i class="material-icons left">create</i> Subscriptions (4)</div>
			      					<div class="btn simple-btn"><i class="material-icons left">create</i> Licences (2)</div>
			      				</li>
			      			</ul>
			      		</div>
			      		<div class="col s2 full-height-divider">
  			      			<ul class="collection">
  			      				<li class="collection-item actions first">
  			      					<div class="actions-container">
  				      					<a href="" class="btn-floating btn-flat"><i class="material-icons theme-icon">delete_forever</i></a>
  			      					</div>
  			      				</li>
  			      				<li class="collection-item terms">
									<a class="btn-floating btn-large waves-effect terms centered tooltipped" data-position="left" data-delay="50" data-tooltip="Since 2017"><i class="material-icons">collections_bookmark</i></a><br/>
									<p class="center-align"><a href="">Licence Terms</a></p>
								</li>
								<li class="collection-item status">
									<a class="btn-floating btn-large waves-effect not-core centered tooltipped" data-position="left" data-delay="50" data-tooltip="Since 2017"><i class="material-icons">clear</i></a><br/>
									<p class="center-align"><a href="">Core Status</a></p>
								</li>
  			      			</ul>
			      		</div>

			      	</div>
			      	<!-- accordian header end-->

			      	<!-- accordian body-->
			      	<div class="collapsible-body">

			      		<div class="row">
			      			<div class="col s12 m3">
			      				<h3>Included Subscriptions</h3>
                    <ul class="content-list">
                      <li><a href="">ASCE 2015</a> <a href="">Issue Format</a></li>
                      <li><a href="">Annual review 2015</a> <a href="">Issue Format</a></li>
                      <li><a href="">EDP 2016</a> <a href="">Issue Format</a></li>
                      <li><a href="">Elsevier Open Access</a> <a href="">Issue Format</a></li>
                    </ul>

			      			</div>
			      			<div class="col s12 m3">
			      				<h3>Licences</h3>
                    <ul class="content-list">
                      <li><a href="">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015</a></li>
                      <li><a href="">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015</a></li>
                    </ul>


			      			</div>
			      			<div class="col s12 m6">
			      				<h3>Title URL</h3>
                    <ul class="content-list">
                      <li><a href="">link to external site</a></li>
                      <li>Core Medium <span>Yes/no</span></li>
                    </ul>
			      			</div>
			      		</div>

                <div class="row">
                  <div class="col s12">
                    <h3>Licences Key Properties : {liecence #1}</h3>
                    <div class="properties-container center-graphic">
                      <div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">computer_black</i><i class="material-icons icon-offset yes">done</i></div>
                        Include in VLE
                      </div>
                      <div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">chrome_reader_mode_black</i><i class="material-icons icon-offset no">clear</i></div>
                        Include in Coursepacks
                      </div>
                      <div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">call_split_black</i><i class="material-icons icon-offset yes">done</i></div>
                        Inter-library Loan
                      </div>
                      <div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">local_library_black</i><i class="material-icons icon-offset neither">info_outline</i></div>
                        Walk-in  access
                      </div>
                      <div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">cast_connected_black</i><i class="material-icons icon-offset yes">done</i></div>
                        Remote access
                      </div>
                      <div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">group_black</i><i class="material-icons icon-offset no">clear</i></div>
                        Alumni Access
                      </div>
                    </div>

                  </div>
                </div>

                <div class="row">
                  <div class="col s12">
                    <h3>Licences Key Properties : {liecence #2}</h3>
                    <div class="properties-container center-graphic">
                      <div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">computer_black</i><i class="material-icons icon-offset yes">done</i></div>
                        Include in VLE
                      </div>
                      <div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">chrome_reader_mode_black</i><i class="material-icons icon-offset no">clear</i></div>
                        Include in Coursepacks
                      </div>
                      <div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">call_split_black</i><i class="material-icons icon-offset yes">done</i></div>
                        Inter-library Loan
                      </div>
                      <div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">local_library_black</i><i class="material-icons icon-offset neither">info_outline</i></div>
                        Walk-in  access
                      </div>
                      <div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">cast_connected_black</i><i class="material-icons icon-offset yes">done</i></div>
                        Remote access
                      </div>
                      <div class="col s6 l2 property">
                        <div class="circular-image tooltipped card-tooltip" data-delay="50" data-position="right" data-tooltip="Current"><i class="medium material-icons icon-grey">group_black</i><i class="material-icons icon-offset no">clear</i></div>
                        Alumni Access
                      </div>
                    </div>

                  </div>
                </div>

			      		<div class="row">
			      			<div class="col s12">
					      		<div class="cta">
					      			<a href="/titles/detail" class="waves-effect waves-light btn">View Additional Metrics</a>
					      			<a href="" class="waves-effect btn">Delete <i class="material-icons right">delete_forever</i></a>
					      		</div>
				      		</div>
			      		</div>

			      	</div>
			      	<!-- accordian body end-->
			    </li>
				<!-- accordian item end-->








			</ul>

			  <!-- pagination without infinate scroll (removal of scroll class and paginator div) -->
			  <ul class="pagination">
			    <li class="disabled"><a href="#!"><i class="material-icons">chevron_left</i></a></li>
			    <!-- Start of for loop -->
			    <li class="active"><a href="/licences/list">1</a></li>
			    <!-- End of loop -->
			    <li class="waves-effect"><a href="/licences/listtwo">2</a></li>
			    <li class="waves-effect"><a href="/licences/listtwo"><i class="material-icons">chevron_right</i></a></li>
			  </ul>


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


	</div>

	<!-- end of tabs -->



	  <!-- example Modal form -->
	  <div id="modal1" class="modal bottom-sheet">
	 	<div class="fixed-action-btn-top">
			<a href="#!" class="z-depth-0 transparent modal-action modal-close btn-floating btn-large waves-effect waves-dark back-title"><i class="material-icons">close</i></a>
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
			<a href="#!" class="z-depth-0 modal-action modal-close-all btn-floating btn-large waves-effect back-title"><i class="material-icons">close</i></a>
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
