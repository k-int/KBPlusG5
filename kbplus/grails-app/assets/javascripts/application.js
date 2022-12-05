// This is a manifest file that'll be compiled into application.js.
//
// Any JavaScript file within this directory can be referenced here using a relative path.
//
// You're free to add application-wide JavaScript to this file, but it's generally better
// to create separate JavaScript files as needed.
//
//= require jquery-2.2.0.min
//= require modernizr-custom.js
//= require thirdparty/materialize/materialize
//= require thirdparty/jquery.nanoscroller.min.js
//= require thirdparty/jquery.jscroll.min.js
//= require thirdparty/jquery-ui-autocomplete.min.js
//= require thirdparty/select2/select2.min.js
//= require dash.js
//= require jquery.dataTables.min.js
//= require jquery-2.2.0.min.js
//= require jstree.min.js
//= require modal-ajax-calls.js
//= require modernizr-custom.js
//= require label-editor.js
//= require_self

if (typeof jQuery !== 'undefined') {
    (function($) {

      var app_base_url = $('#appCfgElement').data('baseurl');
      console.log("using %s as app_base_url",app_base_url);

      if (!Modernizr.hiddenscroll && (navigator.userAgent.toLowerCase().indexOf('firefox') > -1 || navigator.userAgent.toLowerCase().indexOf('edge') > -1 || navigator.userAgent.indexOf('MSIE')!==-1 || navigator.appVersion.indexOf('Trident/') > 0)) {
         $("html").addClass("hide-scrollbar");
         $(".hide-scrollbar .jisc-left-sidebar .sidebar-elements > li > ul > .nav-items .content.nano-content").height(window.innerHeight - 80);
      }

        $(document).ajaxStart(function() {
            $('#spinner').fadeIn();
        }).ajaxStop(function() {
            $('#spinner').fadeOut();
        });


     $("#trigger-navbar-toggle").click(function() {
       $('body').toggleClass("open-left-sidebar");
       $('.icon-bar').toggleClass('open');
     });

     $(".close-menu").click(function() {
        $('body').toggleClass("open-left-sidebar");
        $('.icon-bar').toggleClass('open');
     });

     var menuCloseTimer = null;
     $(".sidebar-elements>li").hover(function(){
       // if(window.innerWidth >767) {
       //   $(this).children(".sub-menu").addClass("open");
       // }
       window.clearTimeout(menuCloseTimer);
     }, function(){
       if(window.innerWidth >767) {
         // $(this).children(".sub-menu").removeClass("open");
         menuCloseTimer = window.setTimeout(function(){
            $(".sub-menu").removeClass("open");
         }, 3000);
       }
     });

     $(".sidebar-elements>li").click(function(e){
       if(window.innerWidth >767) {
        //e.preventDefault();
        $(".sub-menu").removeClass("open");
        $(this).children(".sub-menu").addClass("open");
       }
     });

     $(document).click(function(e){
        if (!$('.sidebar-elements').find(e.target).length) {
          $(".sub-menu").removeClass("open");
        }
     })


     $(".sidebar-elements>li li").hover(function(e){
        scrollableObject = $(this).parents(".nano-content").first()[0];
        scrollClass = "";
        if(scrollableObject.offsetHeight < scrollableObject.scrollHeight) {
          scrollClass = "with-scroll";
        }
        if(window.innerWidth >767) {
            if(e.screenY > (window.innerHeight / 2)) {
              $(this).children(".sub-sub-menu").addClass("open open-bottom " + scrollClass);
            } else {
              $(this).children(".sub-sub-menu").addClass("open");
            }
        }
     }, function(){
        if(window.innerWidth >767) {
            $(this).children(".sub-sub-menu").removeClass("open open-bottom with-scroll");
        }
     });

     //firefix submenu fix
    if(!Modernizr.hiddenscroll && (navigator.userAgent.toLowerCase().indexOf('firefox') > -1)) {
      $(".jisc-left-sidebar .sidebar-elements > li > ul > .nav-items").each(function(index, element){
        //remove table thing, calculate height of element for unsupported browser
        $(this).css({
          'height': $(window).height(),
          'display': 'block'
        });
      });
    }


     $(".sidebar-elements>li").click(function(){
       if(window.innerWidth <=767) {
         $(".sidebar-elements>li").not($(this)).children(".sub-menu").removeClass("open");
         $(this).children(".sub-menu").toggleClass("open");
       }
     });
     
     $(".add-anchor").click(function(e){
    	 var anchor = $(this).attr("href");
    	 var loc = window.location.href;
    	 if (loc.indexOf("#") !== -1) {
    		 loc = loc.substring(0, loc.indexOf("#"));
    	 }
    	 loc += anchor;
    	 window.history.pushState('nullValue', 'tab', loc);
     });

      $('.modal').modal({
          dismissible: true, // Modal can be dismissed by clicking outside of the modal
          opacity: .5, // Opacity of modal background
          inDuration: 500, // Transition in duration
          outDuration: 400, // Transition out duration
          startingTop: '10%', // Starting top style attribute
          endingTop: '0%', // Ending top style attribute
          ready: function(modal, trigger) { // Callback for Modal open. Modal and trigger parameters available.
            console.log(modal, trigger);
            $('select').material_select(); //required to render dynamic selects
          },
          complete: function() {
            console.log("closed");

          } // Callback for Modal close
        }
      );

      $(".modal-close-all").click(function(){
        $('.modal-overlay').trigger("click");
      });

      $('a.modalButton').click(function(){
        var ajax_url = $(this).attr("ajax-url");
        var reload = false;
        if ($(this).attr("reload") != null && $(this).attr("reload") == "true") {
        	reload = true;
        }
        openModal(ajax_url, reload);
      });

    if (document.querySelector('#pendingchanges')) {
        var path = window.location.hash;
        if (path.indexOf('pendingchanges') > -1){
            $('#pendingchanges').trigger('click');
            history.pushState("", document.title, window.location.pathname
                + window.location.search);
        }
    }
      
      //this is a special case and needs its own method,
      //as will the batch delete issue ents more than likely now it has been moved due to the design and no longer works as it did
      $('a[id=batchEditIssueEnts]').click(function(e){
    	  var n = $('input:checkbox[name^="_bulkflag."]:checked').length;
    	  if (n == 0) {
    		  alert("Please select at least one title, before using the Batch Task Selected Titles.");
    		  e.stopPropagation();
    	  }
    	  else {
    		  var urlQueryString = "?";
    		  $('input:checkbox[name^="_bulkflag."]:checked').each(function(){
    			  if (urlQueryString.length > 1) {
    				  urlQueryString += "&";
    			  }
    			  urlQueryString += $(this).attr("name");
    			  urlQueryString += "=on";
    		  });
    		  var ajax_url = $(this).attr("ajax-url");
    		  ajax_url += urlQueryString;
    		  console.log("opening modal for batch editing titles");
    		  console.log(ajax_url);
    		  openModal(ajax_url, false);
    	  }
	  });
      
      //this is a special case and needs its own method,
      $('a[id=title_batchEditTipps]').click(function(e){
    	  var n = $('input:checkbox[name^="_bulkflag."]:checked').length;
    	  if (n == 0) {
    		  alert("Please select at least one TIPP, before using the Batch TIPP button.");
    		  e.stopPropagation();
    	  }
    	  else {
    		  var urlQueryString = "?";
    		  $('input:checkbox[name^="_bulkflag."]:checked').each(function(){
    			  if (urlQueryString.length > 1) {
    				  urlQueryString += "&";
    			  }
    			  urlQueryString += $(this).attr("name");
    			  urlQueryString += "=on";
    		  });
    		  var ajax_url = $(this).attr("ajax-url");
    		  ajax_url += urlQueryString;
    		  console.log("opening modal for batch editing tipps from title details page");
    		  console.log(ajax_url);
    		  openModal(ajax_url, false);
    	  }
	  });
      
      //this is a special case and needs its own method,
      $('a[id=batchEditPackageTitles]').click(function(e){
    	  var n = $('input:checkbox[name^="_bulkflag."]:checked').length;
    	  if (n == 0) {
    		  alert("Please select at least one title, before using the Batch Action.");
    		  e.stopPropagation();
    	  }
    	  else {
    		  var urlQueryString = "?";
    		  $('input:checkbox[name^="_bulkflag."]:checked').each(function(){
    			  if (urlQueryString.length > 1) {
    				  urlQueryString += "&";
    			  }
    			  urlQueryString += $(this).attr("name");
    			  urlQueryString += "=on";
    		  });
    		  var ajax_url = $(this).attr("ajax-url");
    		  ajax_url += urlQueryString;
    		  console.log("opening modal for batch editing package titles from package details page");
    		  console.log(ajax_url);
    		  openModal(ajax_url, false);
    	  }
	  });
      
      //this is a special case and needs its own method
      $('a[id=manageTitlesSelected]').click(function(e){
    	  var n = $('input:checkbox[name^="_tip."]:checked').length;
    	  if (n == 0) {
    		  alert("Please select at least one title, before using the Mark Core To Selected Titles.");
    		  e.stopPropagation();
    	  }
    	  else {
    		  var urlQueryString = "";
    		  $('input:checkbox[name^="_tip."]:checked').each(function(){
                  urlQueryString += "&";    			   
    			  urlQueryString += $(this).attr("name");
    			  urlQueryString += "=on";
    		  });
    		  var ajax_url = $(this).attr("ajax-url");
    		  ajax_url += urlQueryString;
    		  console.log("opening modal for adding core dates to selected titles");
    		  console.log(ajax_url);
    		  openModal(ajax_url, false);
    	  }
	  });
      
      $('.no-js').click(function(e){
    	  e.stopPropagation();
      });

      function openModal(ajax_url, reload_page) {
        $.ajax({
          type: "GET",
          url: ajax_url,
          error: function(jqXHR, textStatus, errorThrown) {
            console.log('error making ajax call');
            console.log(textStatus);
            console.log(errorThrown);
          }
        }).done(function(data) {

          $content = $(data);
          $('.modal-content').html(data);
          
          var theme = $content[0].getAttribute("data-theme");
          if(theme) {
            $(".modal.open").removeClass().addClass("modal bottom-sheet open").addClass(theme);
          }
          $('select').material_select();
        });
        
        function onOpen() {
        	console.log('Modal open, loading');
        }

        $('.this-modal').modal({
              dismissible: true, // Modal can be dismissed by clicking outside of the modal
              opacity: .5, // Opacity of modal background
              inDuration: 500, // Transition in duration
              outDuration: 400, // Transition out duration
              startingTop: '10%', // Starting top style attribute
              endingTop: '0%', // Ending top style attribute
              //onOpenEnd: onOpen(), // Function triggered when modal opens before content loads
              ready: function(modal, trigger) { // Callback for Modal open. Modal and trigger parameters available.
                console.log('Modal loaded');
                console.log(modal, trigger);
                $('select').material_select();//required to initialise ajax modals that has selects
              },
              complete: function() {
                console.log("closed");
                if (reload_page) {
                  console.log('reloading page');
                  window.location.reload(true);
                }
                $('.modal-content').empty(); // In case another modal is opened without page refresh
              } // Callback for Modal close
            }
          );
      }

      $('#clearSearch').click(function(){
          console.log('clear search clicked');
          var searchid = $(this).attr('search-id');
          console.log(searchid);
          $('input[id='+searchid+']').val('');
      });

      $('i[id=clearSearchSideNav]').click(function(){
          console.log('clear search clicked');
          var searchid = $(this).attr('search-id');
          console.log(searchid);
          $('input[id='+searchid+']').val('');
      });
      
      //change institution on instdash page code
      $('#changeDefaultInst').on('change', function(){
    	  window.location.replace($(this).val());
      });
      
      //batch check all
      $('#batchCheckAll').on('change', function(){
    	  if ($(this).is(':checked')) {
    		  $('.bulkcheck').prop('checked', true);
    	  }
    	  else {
    		  $('.bulkcheck').prop('checked', false);
    	  }
      });
      
      function availableTypesSelectUpdated(optionSelected, lookupUrl, propFilter){
    	  var selectedOption = $( "#availablePropertyTypes option:selected" );
    	  var selectedValue = selectedOption.val();
    	  //Set the value of the hidden input, to be passed on controller
    	  $('#propertyFilterType').val(selectedOption.text());
    	  updateInputType(selectedValue, lookupUrl, propFilter);
      }
      
      function updateInputType(selectedValue, lookupUrl, propFilter){
    	  //If we are working with RefdataValue, grab the values and create select box
    	  if(selectedValue.indexOf("RefdataValue") != -1){
    		  var refdataType = selectedValue.split("&&")[1];
    		  $.ajax({
    			  url:lookupUrl+'/'+refdataType+'?format=json',
    			  success: function(data) {
    				  var select = ' <select id="selectVal" name="propertyFilter" style="display: block;"> ';
    				  //we need empty when we dont want to search by property
    				  select += ' <option></option> ';
    				  for(var index=0; index < data.length; index++ ){
    					  var option = data[index];
    					  if ((propFilter != null) && (propFilter == option.text)){
    						  select += ' <option value="'+option.text+'" selected>'+option.text+'</option> ';
    					  }
    					  else {
    						  select += ' <option value="'+option.text+'">'+option.text+'</option> ';
    					  }
    				  }
    				  select += '</select>';
    				  $('#selectVal').replaceWith(select)
    			  }
    		  });
    	  }
    	  else{
    		  //If we dont have RefdataValues,create a simple text input
    		  if (propFilter != null) {
    			  $('#selectVal').replaceWith('<input id="selectVal" type="text" name="propertyFilter" placeholder="Property value" value="'+ propFilter +'" />');
    		  }
    		  else {
    			  $('#selectVal').replaceWith('<input id="selectVal" type="text" name="propertyFilter" placeholder="Property value" />');
    		  }
    	  }
      }
      
      function setTypeAndSearch(){
    	  var selectedType = $("#propertyFilterType").val();
    	  //Iterate the options, find the one with the text we want and select it
    	  var selectedOption = $("#availablePropertyTypes option").filter(function() {
    		  return $(this).text() == selectedType;
    	  }).prop('selected', true); //This will trigger a change event as well.
    	  
    	  //get params value of propertyFilter
    	  var propFilter = $("#propFilter").val();
    	  console.log("params value for prop filter: " + propFilter);
    	  
    	  //Generate the correct select box
    	  //this now sets the selected option in the availableTypesSelectUpdated function, which is additional to how it worked in KB+6
    	  var lookupUrl = $("#availablePropertyTypes").attr('lookupurl');
    	  availableTypesSelectUpdated(selectedOption, lookupUrl, propFilter);
    	  
    	  //Set selected value for the actual search
    	  //commenting out as this code does not seem to work as intended from KB+ v6
    	  /*var paramPropertyFilter = propFilter;
    	  var propertyFilterElement = $("#selectVal");
    	  console.log(propertyFilterElement);
    	  if(propertyFilterElement.is("input")){
    		  console.log("is input");
    		  propertyFilterElement.val(paramPropertyFilter);
    	  }
    	  else{
    		  console.log("is select");
    		  $("#selectVal option").filter(function() {
    			  console.log($(this).text());
    			  console.log(paramPropertyFilter);
    			  return $(this).text() == paramPropertyFilter ;
    		  }).prop('selected', true);
    	  }*/
      }
      
      $('#availablePropertyTypes').change(function(e) {
    	  var optionSelected = $("option:selected", this);
    	  var lookupUrl = $(this).attr('lookupurl');
    	  availableTypesSelectUpdated(optionSelected, lookupUrl, null);
      });
      
      var available_property_types = $('#availablePropertyTypes');
      if (available_property_types.length > 0) {
    	  console.log("prop types:");
    	  console.log(available_property_types);
    	  window.onload = setTypeAndSearch();
      }
      
      /*
      * Tooltip Usage:
      * A regular tooltop can be upgraded to a html card tooltip by adding the class card-tooltip to the element that triggers it.
      * You will need to add a "data-src" attribute to the trigger element to reference where the html is located. This data-src
      * attribute acts like an id and will need to be unique.
      *
      * Somewhere on the page, there needs to be a script tag like <script type="text/html" id=""> where the id refers to 
      * data-src on the trigger. This tag will contain the HTML content
      */

     $(document).ready(function(){
      $('.tooltipped.card-tooltip').each(function(index, value){
        refid = $(this).attr("data-src");
        html = $("#" + refid).html();
        //$('.card-tooltip').tooltip({
        $("span[data-src='" + refid + "'], div[data-src='" + refid + "'], i[data-src='" + refid + "']").tooltip({
          delay: 50,
          tooltip: html,
          position:'bottom',
          html:true
        });

      });

      var next_pag_obj = $('div[class=pagination] a[class=nextLink]');
      var prev_pag_obj = $('div[class=pagination] a[class=prevLink]');
      console.log('next: ' + next_pag_obj.html());
      console.log('prev: ' + prev_pag_obj.html());

      if ((next_pag_obj.html() != null) && (next_pag_obj.html() == 'chevron_right')) {
        next_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_right</i>");
      }

      if ((prev_pag_obj.html() != null) && (prev_pag_obj.html() == 'chevron_left')) {
        prev_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_left</i>");
      }
     });

     /*$('a[id=modalCoreStatus]').click(function(){
       var tipId = $(this).attr("tipid");
       var tiptitle = $(this).attr("tiptitle");
       var tipurl = "/ajax/getTipCoreDates?tipID="+tipId+"&title="+tiptitle;

       $.ajax({
            type: "GET",
            url: "/ajax/getTipCoreDates?tipID="+tipId+"&title="+tiptitle,
            success: function(data, textStatus){
              console.log(data);
               $('div[id=magicArea]').html(data);
            },
            error: function(jqXHR, textStatus, errorThrown){

            },
            complete: function(jqXHR, textStatus){
              showCoreAssertionModal();
            }
         //}).done(function(data) {
         //   console.log(data);
         //    $('div[id=magicArea]').html(data);
         });

       return false;
     });*/

     $(".collapsible-header").click(function(e){
    	 var clicked = $(e.target);
    	 if(!e.target.classList.contains('trigger-accordian')) {
    		 //Nearest checks "this" and then all parents.
    		 if ( clicked.closest('a').length ) {
    			 if (clicked.is('a')) {
    				 //An anchor tag that has an open in modal operator should not follow it's href.
    				 //e.preventDefault();
    			 }
    			 //If this is a child of the anchor tag we do nothing. Wait for the actual a click to hit home...
    			 return;
    		 }
    		 e.stopPropagation();
    	 }
     });

     //infinate scroll
     $('.scroll-container').jscroll({
          loadingHtml: '<div class="progress"><div class="indeterminate"></div></div>',
          padding: 20,
          nextSelector: '.pagination a:last',
          contentSelector: '.scroll-container .jisc_collapsible',
          callback: function(){
            console.log('attempting to load new page');
            //foreach new page, run this
            $('.collapsible').collapsible();
          }
      });



     //accorians
     $(document).ready(function(){
         $('.collapsible').collapsible();
         $('select').material_select();

         //parent card will have overflow visible so that you can see the select options if they are large
         $(".select-dropdown").focus(function(){
          $(this).closest(".card-content").addClass("allowOverflow");
         });

          $(".select-dropdown").blur(function(){
            var $this = $(this);
            //requires timer so that buttom values are selected before the overflow class is removed
            window.setTimeout(function(){
              $this.closest(".card-content").removeClass("allowOverflow");
            }, 250);
          });
         
       });


     //itemediate checboxes
     $('input[type="checkbox"]').change(function(e) {

        var checked = $(this).prop("checked"),
            container = $(this).parent(),
            siblings = container.siblings();

        container.find('input[type="checkbox"]').prop({
          indeterminate: false,
          checked: checked
        });

        function checkSiblings(el) {

          var parent = el.parent().parent(),
              all = true;

          el.siblings().each(function() {
            return all = ($(this).children('input[type="checkbox"]').prop("checked") === checked);
          });

          if (all && checked) {

            parent.children('input[type="checkbox"]').prop({
              indeterminate: false,
              checked: checked
            });

            checkSiblings(parent);

          } else if (all && !checked) {

            parent.children('input[type="checkbox"]').prop("checked", checked);
            parent.children('input[type="checkbox"]').prop("indeterminate", (parent.find('input[type="checkbox"]:checked').length > 0));
            checkSiblings(parent);

          } else {

            el.parents("li").children('input[type="checkbox"]').prop({
              indeterminate: true,
              checked: false
            });

          }

        }

        checkSiblings(container);
      });


     //datepicker
    var currentDate = new Date();
    $('.datepicker').pickadate({
        format: 'yyyy.mm.d',
        selectMonths: true, // Creates a dropdown to control month
        selectYears: 200, // Creates a dropdown of 15 years to control year
        format: 'yyyy-mm-dd',
        min:[1900,1,1], // II pushed back to 1900, not sure this is sufficient -- given links to things like JHT
        max:[9999, 12, 31], // II Commenting this out, with PCA deals etc it's very hard to set a sensible upper date. Added 9999 as its sometimes used as a nonce to mean forever.
        today: '',
        clear: 'Clear',
        close: 'Confirm'
      });


    //autocomplete form fields
    //causes error if autocomplete is not defined
    if(typeof autocomplete != 'undefined') {
      $('input.autocomplete').autocomplete({
        data: {
          "Apple": null,
          "Microsoft": null,
          "Google": 'http://placehold.it/250x250'
        },
        limit: 20, // The max amount of results that can be shown at once. Default: Infinity.
        onAutocomplete: function(val) {
          // Callback function when value is autcompleted.
        },
        minLength: 1, // The minimum length of the input for the autocomplete to start. Default: 1.
      });
    }
    //$('.tooltipped').tooltip({delay: 50});


    // find any controls with type KBPlusTypeDown and convert them into typedowns. 
    // THIS CODE MUST BE KEPT GENERIC
    $('.KBPlusTypeDown').select2({
      placeholder: "Start typing...",
      initSelection : function (element, callback) {
        if(element.data('defaulttext')) //If defaulttext has been set in the markup!
        {
          var data = {id: element.val(), text: element.data('defaulttext')};
          callback(data);
        }
      },
      width: '100%',
      minimumInputLength: 1,
      global: false,
      ajax: {
        url: app_base_url+'ajax/lookup',
        dataType: 'json',
        data: function (term, page) {
          // Add all data('qp-') values to the request
          var s2_params = {
            hideDeleted: 'true',
            hideIdent: 'true',
            inclSubStartDate: 'false',
            inst_shortcode: $(this).data('inst-shortcode'),
            q: term,
            subFilter: $(this).data('subfilter'),
            page_limit: 20,
            baseClass:$(this).data('base-class')
          };
          console.log("OK %o",$(this).data());

          // Here be dragons -- data-qp-subFilter is converted to qpSubfilter, data-qpsub-filter comes through as subFilter, which is what
          // we really want. Be wary of how you set qp parameters you want passed to the lookup method.
          $.each($(this).data(), function(i, v) {
           if ( i.startsWith('qp') ) {
             console.log("Consider "+i+":"+v);
             s2_params[i.substring(2,i.length)] = v;
	   }
          });

	  return s2_params;
        },
        results: function (data, page) {
          return {results: data.values};
        }
      },
      allowClear: true,
      formatSelection: function(data) {
        return data.text;
      }
    });

  })(jQuery);
}

function changeLink(elem,msg) {
  var selectedOrg = $('#orgShortcode').val();
  var edited_link =  $("a[name="+elem.name+"]").attr("href",function(i,val) {
    return val.replace("replaceme",selectedOrg)
    });

  return confirm(msg);
}

function applySelect2(filter, subid, subvalue, inst_sc) {
  var app_base_url = $('#appCfgElement').data('baseurl');
  //var sub0 = $('input[name=subInsts0]');
  //var sub1 = $('input[name=subInsts1]');
  //var inst_sc = $('input[name=defaultInstShortcode]').val();
  console.log('inst sc: ' + inst_sc);
    var subObj = {id:subid,text:subvalue};
    //var subB = {id:sub1.attr('id'),text:sub1.attr('value')};
    $("#subSelect"+filter).select2({
      width: '100%',
      placeholder: "Type subscription name...",
      minimumInputLength: 1,
      ajax: {
          url: app_base_url+'ajax/lookup',
          dataType: 'json',
          data: function (term, page) {
              return {
                hasDate: 'true',
                hideIdent: 'true',
                inclSubStartDate: 'true',
                startDate: $("#start"+filter).val(),
                endDate: $("#end"+filter).val(),
                hideDeleted: 'true',
                inst_shortcode: inst_sc,//should be from params.defaultInstShortcode
                  q: term , // search term
                  page_limit: 10,
                  baseClass:'com.k_int.kbplus.Subscription'
              };
          },
          results: function (data, page) {
              return {results: data.values};
          }
      },
       allowClear: true,
       formatSelection: function(data) {
          return data.text;
      },
      initSelection : function (element, callback) {
         var obj
         //if(filter == "A"){
         //  obj = subA;
         //}else{
         //  obj = subB;
         //}
         obj = subObj;
         callback(obj);
      }
      }).select2('val',':');

  }

$("#addIdentifierSelect").select2({
	width: '100%',
	placeholder: "Search for an identifier...",
    minimumInputLength: 1,
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
      url: $('input[name=ajaxLookupURL]').val(),
      dataType: 'json',
      data: function (term, page) {
          return {
              q: term, // search term
              page_limit: 10,
              baseClass:'com.k_int.kbplus.Identifier'
          };
      },
      results: function (data, page) {
        return {results: data.values};
      }
    },
    createSearchChoice:function(term, data) {
      return {id:'com.k_int.kbplus.Identifier:__new__:'+term,text:term};
    }
});

$("#orgCustomPropSelect").select2({
	width: '100%',
    placeholder: "Search for a custom property...",
    minimumInputLength: 0,
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
        url: $('input[name=ajaxLookupURL]').val(),
        dataType: 'json',
        data: function (term, page) {
            return {
                q: term, // search term
                desc:$("#orgCustomPropSelect").attr('desc'),
                page_limit: 10,
                baseClass:'com.k_int.custprops.PropertyDefinition'
            };
        },
        results: function (data, page) {
            return {results: data.values};
        }
    },
    createSearchChoice:function(term, data) {
        return {id:-1, text:"New Property: "+term};
    }
});

$("#resetFilters").click(function() {
    $("input[name=filter]").val("");
    $("input[name=coverageNoteFilter]").val("");
    $("input[name=startsBefore]").val("");
    $("input[name=endsAfter]").val("");
    $(this).closest('form').submit();
});

  function showMore(ident) {
  $("#compare_details"+ident).modal('show')
  }
//change to be force jenkins to pick this up
//2

$(".mobile-collapsible-header").click(function(){
   var datacollapsibel = $(this).data('collapsible');
   if(datacollapsibel.length > 0){
       $('#'+datacollapsibel).toggleClass('active');
   }
});


// Compare pages rows same size
function rowFixHeigth(select){
    var maxHeight = 0;
    $(select +' li').css('height','initial');
    $(select + ' ul.options li').each(function(index){
        if(parseInt($(this).css('height')) > maxHeight){
            maxHeight = parseInt($(this).css('height'));
        }
    });
    $(select + ' ul.options li').css('height',''+maxHeight+'px');
    $(select + ':first li').each(function(index){
        index = index + 1;
        $(select).children('li:nth-child('+index+')').each(function(){
            if(parseInt($(this).css('height')) > maxHeight){
                maxHeight = parseInt($(this).css('height'));
            }
        });
        $(select).children('li:nth-child('+index+')').css('height',''+maxHeight+'px');
    });
}

$('.compareheight').ready(function(){
    rowFixHeigth('.compareheight');
}).on('resize', function () {
    rowFixHeigth('.compareheight');
});

(function($){
    $.fn.hasScrollbar = function(){
        return this.get(0).scrollWidth > this.width();
    }
})(jQuery);

if($('.jisc_tabs').length) {
    $('.jisc_tabs').ready(function (a) {
        setTimeout(
            function () {
                if ($('.jisc_tabs').hasScrollbar()) {
                    $('.jisc_tabs').addClass('scrolloverflow');
                } else {
                    $('.jisc_tabs').removeClass('scrolloverflow');
                }
            }, 100
        );
    });
}

$(window).on('resize', function () {
    if($('.jisc_tabs').length){
        if ( $('.jisc_tabs').hasScrollbar()){
            $('.jisc_tabs').addClass('scrolloverflow');
        }else {
            $('.jisc_tabs').removeClass('scrolloverflow');
        }
    }

});

$(document).on('click','.datepickericon', function(e){
    // This creates the datepicker element on icon click and allows for text input add the class datepickericon and the
    // attribute data-field with the value of the text input field you want to use as the date input for it to work.
    var item = $(this).data('field');
    var picker = $('#'+item).pickadate('picker');
    var date = $('#'+item).val();
    if (picker ){
        picker.set('select', new Date(date));
        picker.open(false);
    }else{
        var picker = $('#'+item).pickadate({
            selectMonths: true, // Creates a dropdown to control month
            selectYears: 200, // Creates a dropdown of 15 years to control year
            format: 'yyyy-mm-dd',
            min:[1900,1,1], // II pushed back to 1900, not sure this is sufficient -- given links to things like JHT
            max:[9999, 12, 31], // II Commenting this out, with PCA deals etc it's very hard to set a sensible upper date. Added 9999 as its sometimes used as a nonce to mean forever.
            today: '',
            clear: 'Clear',
            close: 'Confirm',
            editable:true,
            closeOnSelect:false,
            onStart: function(){
                $(this)[0].open(false);
            },
            onRender: function() {
                console.log('Just rendered anew')
            }
        });
    }

}).on('click', '#removesizewarning', function(){
    // This is to remove the windows size warning element on element click.
    localStorage.setItem("sizewarning", 1);
    $('#sizewarning').addClass('hide');
}).ready(function(){
    // This checks the local storage to see if the element has been remove already if so removes it.
    var sizechacek = localStorage.getItem("sizewarning");
    if(sizechacek == 1){
        $('#sizewarning').addClass('hide');
    }
});

$(document).on('click', '.selecttab', function(e){
    var item = $(this).data('tabs');
    var href = $(this).attr('href');
    $('.'+item).tabs('select_tab',href.replace('#',''))
});
