$( function() {
    $('select').uniform();
    $( "#tabs" ).tabs();

    $('.datepicker').datepicker({
        dateFormat: "yy-mm-dd",
        altFormat: "yy-mm-dd",
        formatDate: "yy-mm-dd"
    });
} );