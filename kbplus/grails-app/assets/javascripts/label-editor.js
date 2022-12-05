if (showLabelEditor === true) {

  (function($) {
    
    var modal;
    var modalClasses = 'modal bottom-sheet';
    var buttonClick
    var refreshNeeded = false;
    
    var getModal = function () {
      if (!modal) {
        // Create the modal.
        modal = $('<div id="translation-modal" class="' + modalClasses + '" />').append(
          $('<div class="fixed-action-btn-top" />').append(
            '<a href="#!" class="z-depth-0 modal-action modal-close btn-floating btn-large waves-effect waves-dark back-sub"><i class="material-icons">close</i></a>'
          )
        ).append(
          $('<div class="modal-content" />').on('click', function(e) {
            
            // Grab the button so we can add it to the serialized data.
            buttonClick = $(e.target).closest('input, button');
          })        
          .on('submit', function(e) {
            // Submits of forms should happen in the background.
            
            // The clicked item. Get the closest matching form tag.
            var form = $(event.target).closest('form'); 
            
            if (form.length > 0) {
              
              // First thing to do is to stop the event default.
              event.preventDefault();
              
              var formData = form.serializeArray();
              formData.push({name: buttonClick.attr('name'), value: buttonClick.attr('value')})
              
              // Post serialized form in background and replace content.            
              $.ajax({
                url: '//' + location.host + form.attr('action'),
                method: form.attr('method') || 'POST',
                data: $.param(formData),
                success: function (data) {
                  refreshNeeded = true;
                  showEditor (data);
                }
              });
            }
          })
        ).modal({
          dismissible: true, // Modal can be dismissed by clicking outside of the modal
          opacity: .5, // Opacity of modal background
          inDuration: 500, // Transition in duration
          outDuration: 400, // Transition out duration
          startingTop: '10%', // Starting top style attribute
          endingTop: '0', // Ending top style attribute
          complete: function() {
            if (refreshNeeded) {
              window.location.reload(true);
            }
          }
        });
        
        // Append to the jisc frame element of the document.
        $('.jisc-frame').append(modal);
      }
      
      return modal;
    };
    
    var eventing = function (element) {
      element
    }
    
    var showEditor = function (data) {
      var content = $(data);
      
      // Grab only the bit we want.
      content = $('#content-item-forms', content);
      
      if (content.length > 0) {
        var theModal = getModal();
        
        // Replace the html with the parsed content.
        $('.modal-content', theModal).html("").append(content);
        
        theModal.modal('open');
        
        // Apply select styles to this content.
        $('select', content).material_select();
      }
    }
    
    var loadForm = function (key, data) {
      
      // If no key then error.
      if (!key) {
        throw "No key to load.";
      }
      
      var app_base_url = $('#appCfgElement').data('baseurl');

      // Grab the key def.
      $.ajax({
        url: app_base_url + 'dataManager/contentItem/' + key,
        method: data ? 'POST' : 'GET',
        data: data || {},
        success: showEditor
      });
    }
  
    $(document).ready(function() {
     
      // Firstly add an asterisk to the items.
      $('[data-kb-message-code]').each(function() {
        
        // grab me.
        var _me = $(this);
        
        // The key.
        var labelKey = _me.attr('data-kb-message-code');
        
        // Add a class to the element to style.
        _me.addClass('kb-plus-editable-label');
        
        // Now capture any clicks. This will kill any <a tag clicks and also
        // prevent the event from bubbling up the DOM.
        _me.click(function(e) {
          e.stopImmediatePropagation();
          e.preventDefault();
          loadForm (labelKey);
        });
      });
    });
    
  })(jQuery);
  
}
  
