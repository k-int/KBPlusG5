<!DOCTYPE html>
<html>
<head>
<meta name="layout" content="base"/>
<parameter name="pagetitle" value="Log Viewer" />
<title>KB+ Log Viewer</title>
<script type="JavaScript" >
  var initScroll = false;
  (function($){
    $(document).ready(function(){
      var availableSpace = $( window ).innerHeight();
      availableSpace = availableSpace - $("h1.page-header").outerHeight(true);
      availableSpace = availableSpace - $('#page-wrapper').siblings('.navbar').outerHeight(true);
      $('#log-wrapper')
        .css('height', (availableSpace -10) + 'px');

      // Listen to the ajax event.
      $(document).on("ajaxStop", function () {
        if (!initScroll) {
          var height = $('#log-wrapper')[0].scrollHeight;
          $('#log-wrapper').scrollTop(height);
          initScroll = true;
        }
      });
    });

  })(jQuery);
</script>
</head>

<body class="admin">


  <!--page title start-->
  <div class="row">
      <div class="col s12 l12">
          <h1 class="page-title left">Log Viewer</h1>
      </div>
  </div>
  <!--page title end-->


  <!--page intro and error start-->
  <div class="row">
      <div class="col s12">
          <div class="row strip-table z-depth-1">
              <div id="log-wrapper">
                <g:link class="display-inline" controller="file" params="[filePath: (file)]" data-auto-refresh="1000" data-content-selector=".fileContents" />
              </div>
          </div>
      </div>
   </div>

<!--Legacy-->
<!--   <h1 class="page-header">Log Viewer</h1>
  <div id="log-wrapper">
    <g:link class="display-inline" controller="file" params="[filePath: (file)]" data-auto-refresh="1000" data-content-selector=".fileContents" />
  </div>
 -->
</body>
</html>
<!--Legacy end-->
