<!doctype html>
<html lang="en" class="no-js">
<head>
  <parameter name="pagetitle" value="Home" />
  <parameter name="pagestyle" value="Dashboard" />
  <parameter name="actionrow" value="dashboard" />

  <meta name="layout" content="base"/>
</head>
<body class="profile">

<div class="row">
    <div class="col s12 hide-on-large-only" id="sizewarning">
        <div class="col s12">
            <div class="row strip-table z-depth-1 blue lighten-1">
                <div class="actions-container">
                    <a class="btn-floating right white-text" id="removesizewarning"><i class="material-icons white-text">delete_forever</i></a>
                </div>
                <div class="col m11 section">
                    <div class="col s12 title white-text">
                        Please be aware that your browser window is smaller than the minimum size required for using KB+ (1024 pixels across and smaller). KB+ will work on your screen, but some advanced editing functions will be unavailable
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<div class="row">
	<div class="col s12 m12 l4">
    <div class="col s12">
            <div class="card-panel clearfix">
                <p class="card-title">Select Institutions</p>
                <p class="">Select from dropdown an instititue to work from.</p>
                <div class="input-field">
                    <select>
                        <option value="1">Bangor University</option>
                        <option value="2">Option 2</option>
                        <option value="3">Option 3</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="col s12">
            <div class="card-panel clearfix">
                <div class="launch-out">
                    <a class="btn-floating"><i class="material-icons tooltipped card-tooltip" data-position="right" data-src="search-ref-id" >error_outline</i></a>
                </div>
                <p class="card-title">Search</p>
                <p>Use the search below to see any aspect of your account</p>
                <div class="input-field search-main">
                    <input id="search" placeholder="Enter your search term..." type="search" required>
                    <label class="label-icon" for="search"><i class="material-icons">search</i></label>
                    <i class="material-icons close">close</i>
                </div>
                <p>Refine your results by selecting specific type of records</p>

                <div class="row">

                    <div class="col m6 s12">
                      <input type="checkbox" name="chkbx-1" id="chkbx-1">
                      <label for="chkbx-1">Subscriptions</label>
                    </div>
                    <div class="col m6 s12">
                      <input type="checkbox" name="chkbx-2" id="chkbx-2">
                      <label for="chkbx-2">Licences</label>
                    </div>
                    <div class="col m6 s12">
                      <input type="checkbox" name="chkbx-3" id="chkbx-3">
                      <label for="chkbx-3">Titles</label>
                    </div>
                    <div class="col m6 s12">
                      <input type="checkbox" name="chkbx-4" id="chkbx-4">
                      <label for="chkbx-4">Packages</label>
                    </div>

                </div>
                <script type="text/html" id="search-ref-id">
                <div class="kb-tooltip">
                    <div class="tooltip-title">Search</div>
                    <ul class="tooltip-list">
                        <li>Search through Title Instances ($t), Organisations($o), Subscriptions($s), Packages($pa), Platforms($pl), Licences ($l), and Actions($a). Use $ and category shortcut to filter results, Searching $a Pages will take you to actions management screen.</li>
                    </ul>
                </div>
                </script>

            </div>
        </div>

        <div class="col s12  hide-on-med-and-down">
            <div class="card-panel xsmall clearfix tile">
                <p class="card-title"><a href="#">Titles</a></p>
                <a href="#"><span>You currently have {x} </span> <span> titles</span></a>
                <div class="action-set text">
                    <a href="#"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Export Subscriptions">file_download</i><p>Export</p></a>
                </div>

            </div>
        </div>


        <div class="col s12  hide-on-med-and-down">
            <div class="card-panel xsmall clearfix pacs">
                <p class="card-title"><a href="#">Packages</a></p>
                <a href="#">You current have {x} packages</a>
                <div class="action-set text">
                    <a href="#"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Export your Licences">file_download</i><p>Export</p></a>
                    <a href="#"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Compare Licences">layers</i><p>Compare</p></a>
                </div>
            </div>
        </div>

    </div>

    <div class="col s12 m12 l4">

            <div class="col s12">
                <div class="card-panel clearfix subs">
                    <p class="card-title"><a href="/subscriptions/list">Subscriptions</a></p>
                    <a href="#">You currently have {x} Subscriptions</a>
                    <div class="action-set text">
                        <a href="#"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Add new Subscription">add_circle_outline</i><p>Add</p></a>
                        <a href="#"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Export Subscriptions">file_download</i><p>Export</p></a>
                        <a href="#"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Compare Subscriptions">layers</i><p>Compare</p></a>
                    </div>
                </div>
            </div>

        <div class="col s12">
            <div class="card jisc_card small white">
                <div class="card-content text-navy">
                    <span class="card-title"><a href="#">Recently edited Subscriptions</a></span>
                    <div class="card-detail no-card-action full">
                        <ul class="collection with-actions">
                            <li class="collection-item">
                                <div class="col s12">
                                    <a href="#">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015 <i class="date">Last edited: 2017-03-27</i></a>
                                </div>

                            </li>
                            <li class="collection-item">
                                <div class="col s12">
                                    <a href="#">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015 <i class="date">Last edited: 2017-03-27</i></a>
                                </div>

                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>


        <div class="col s12">
            <div class="card jisc_card small white">
                <div class="card-content text-navy">
                    <span class="card-title"><a href="#">Pending Changes (5)</a></span>
                    <div class="card-detail no-card-action full">
                        <ul class="collection with-actions">
                            <li class="collection-item">
                                <div class="col s10">
                                    <ul>
                                        <li><a href="#">Subscription 3748 - DS Subscription</a></li>
                                        <li>Changes between 2015-12-14 03:26 â€¨PM and 2017-04-05 03:31 PM</li>
                                        <li>Total changes <span class="inline-badge">2035</span> </li>
                                    </ul>
                                </div>
                                <div class="col s2">
                                    <a href="#!" class="bordered right"><i class="material-icons">done_all</i></a>
                                </div>
                            </li>
                            <li class="collection-item">
                                <div class="col s10">
                                    <ul>
                                        <li><a href="#">Subscription 9794 - Walter De Gruyter:NESLI2:Complete Package â€¨STM and SSH titles:2015</a></li>
                                        <li>Changes between 2015-12-14 03:26 â€¨PM and 2017-04-05 03:31 PM</li>
                                        <li>Total changes <span class="inline-badge">5</span> </li>
                                    </ul>
                                </div>
                                <div class="col s2">
                                    <a href="#!" class="right"><i class="material-icons">done_all</i></a>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>


        <div class="col s12">
            <div class="card jisc_card small white">
                <div class="card-content text-navy">
                    <span class="card-title"><a href="">Announcement (42)</a></span>
                    <div class="card-detail no-card-action full">
                        <ul class="collection with-actions">
                            <li class="collection-item">
                                <div class="col s10">
                                    <p><a href="#">ASTIN Bulletin via Cambridge â€¨University Press</a></p>
                                    <ul>
                                        <li>Changes between 2015-12-14 03:26 â€¨PM and 2017-04-05 03:31 PM</li>
                                    </ul>
                                </div>
                                <div class="col s2">
                                    <a href="#!" class="right"><i class="material-icons">delete_forever</i></a>
                                </div>
                            </li>
                            <li class="collection-item">
                                <div class="col s10">
                                    <p><a href="#">Accounting, Organizations and â€¨Society via Elsevier</a></p>
                                    <p>Changes between 2015-12-14 03:26 â€¨pm and 2017-04-05 03:31 PM</p>
                                </div>
                                <div class="col s2">
                                    <a href="#!" class="right"><i class="material-icons">delete_forever</i></a>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>


    </div>

    <div class="col s12 m12 l4">

        <div class="col s12">
            <div class="card-panel clearfix lice">
                <p class="card-title"><a href="/licences/list">Licences</a></p>
                <a href="#">You currently have {x} Licences</a>
                <div class="action-set text">
                    <a href="#"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Add new Licence">add_circle_outline</i><p>Add</p></a>
                    <a href="#"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Export your Licences">file_download</i><p>Export</p></a>
                    <a href="#"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Compare Licences">layers</i><p>Compare</p></a>
                </div>
            </div>
        </div>


        <div class="col s12">
            <div class="card jisc_card small white">
                <div class="card-content text-navy">
                    <span class="card-title"><a href="">Recently used Licences</a></span>
                    <div class="card-detail no-card-action full">
                        <ul class="collection with-actions">
                            <li class="collection-item">
                                <div class="col s12">
                                    <a href="#">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015 <i class="date">Last edited: 2017-03-27</i></a>
                                </div>
                            </li>
                            <li class="collection-item">
                                <div class="col s12">
                                    <a href="#">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015 <i class="date">Last edited: 2017-03-27</i></a>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="col s12">
            <div class="card jisc_card small white">
                <div class="card-content text-navy">
                    <span class="card-title"><a href="">Upcoming renewals (21)</a>  </span>
                    <div class="card-detail no-card-action full">
                        <ul class="collection with-actions">
                            <li class="collection-item">
                                <div class="col s10">
                                    <a href="#">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015</a>
                                </div>
                                <div class="col s2">
                                    <a href="#!" class="right"><i class="material-icons">autorenew</i></a>
                                </div>
                            </li>
                            <li class="collection-item">
                                <div class="col s10">
                                    <a href="#">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015</a>
                                </div>
                                <div class="col s2">
                                    <a href="#!" class="right"><i class="material-icons">autorenew</i></a>
                                </div>
                            </li>
                            <li class="collection-item">
                                <div class="col s10">
                                    <a href="#">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015</a>
                                </div>
                                <div class="col s2">
                                    <a href="#!" class="right"><i class="material-icons">autorenew</i></a>
                                </div>
                            </li>
                            <li class="collection-item">
                                <div class="col s10">
                                    <a href="#">123Doc Limited/Jisc Collections/123Library e-book collection/2012-2015</a>
                                </div>
                                <div class="col s2">
                                    <a href="#!" class="right"><i class="material-icons">autorenew</i></a>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>


        <div class="col s12">
            <div class="card jisc_card small white">
                <div class="card-content text-navy">
                    <span class="card-title"><a href="#">Help</a></span>
                    <div class="card-detail no-card-action full">
                        <div class="help-item">
                            <p>This section helps you get around the Knowledge Base Plus site.</p>
                            <p>If you have any further queries, please â€¨do not hesitate to <a href="#">contact the team</a>.</p>
                        </div>
                        <div class="card-action">
                            <a href="#modal1">Video screencasts</a>
                            <a href="#">User guide</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col s12 hide-on-large-only">
            <div class="card-panel xsmall clearfix tile">
                <p class="card-title">Titles</p>
                <a href="#"><span>Our titles {x} active</span> <span>All titles</span></a>
                <div class="action-set text">
                    <a href="#"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Export your Licences">file_download</i><p>Export</p></a>
                </div>
            </div>
        </div>


        <div class="col s12 hide-on-large-only">
            <div class="card-panel xsmall clearfix pacs">
                <p class="card-title">Packages</p>
                <a href="#">You current have {x} active packages</a>
                <div class="action-set text">
                    <a href="#"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Export your Licences">file_download</i><p>Export</p></a>
                    <a href="#"><i class="material-icons tooltipped" data-position="bottom" data-delay="50" data-tooltip="Compare Licences">layers</i><p>Compare</p></a>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- example Modal form -->
<div id="modal1" class="modal bottom-sheet">
   <div class="fixed-action-btn-top">
      <a href="#!" class="z-depth-0 modal-action modal-close btn-floating btn-large waves-effect waves-dark"><i class="material-icons">close</i></a>
   </div>
   <div class="modal-content">
      <div class="container">
         <div class="row">
            <div class="col s12 l10 offset-l1">
               <h1 class="form-title flow-text text-navy">Video title goes here</h1>
               <p class="form-caption flow-text text-grey">This is a subline please add copy</p>
               <!--youtube video-->
               <div class="row">
                 <div class="input-field col s12">
                   <iframe width="560" height="315" src="https://www.youtube.com/embed/2OtmHtyLbXk?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe>
                 </div>
               </div>
               <!--youtube video-->
            </div>
         </div>
      </div>
   </div>
</div>
<!-- Modal end -->

</body>
</html>
