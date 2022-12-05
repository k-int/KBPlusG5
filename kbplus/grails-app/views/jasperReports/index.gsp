<%--
  Created by IntelliJ IDEA.
  User: ioannis
  Date: 30/06/2014
  Time: 16:22
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <parameter name="pagetitle" value="Jasper Reports" />
    <parameter name="pagestyle" value="data-manager" />
    <parameter name="actionrow" value="none" />
    <title>KB+ Jasper Reports</title>
    <meta name="layout" content="base"/>
</head>

<body class="data-manager">

<!--page title start-->
<div class="row">
    <div class="col s12 l12">
        <h1 class="page-title left">Jasper Reports</h1>
    </div>
</div>
<!--page title end-->

<g:if test="${flash.message}">
    <div class="row">
        <div class="col s12">
            <div class="card-panel blue lighten-1">
                <span class="white-text"> ${flash.message}</span>
            </div>
        </div>
    </div>
</g:if>

<g:if test="${flash.error}">
    <div class="row">
        <div class="col s12">
            <div class="card-panel red lighten-1">
                <span class="white-text"> ${flash.error}</span>
            </div>
        </div>
    </div>
</g:if>


<!--page intro and error start-->
<div class="row">
    <div class="col s12">
        <div class="row strip-table z-depth-1">
            <g:form action="titleMerge" method="get">
                <div class="row admin-form">
                    <div class="input-field col s6">
                        <g:select id="available_reports" name="report_name" from="${available_reports}"/>
                        <label>Selected Reports:</label>
                    </div>
                    <div class="input-field col s6">
                        <g:select id="selectRepFormat" name="rep_format" from="${available_formats}"/>
                        <label>Download Format:</label>
                    </div>
                </div>

            </g:form>
        </div>
    </div>
</div>


<!--page intro and error start-->
<div class="row">
    <div class="col s12">
        <div class="row tab-table z-depth-1">
            <div id="report_details">
                <g:render template="report_details" model="params"/>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    function runJasperJS(){
        copyReportVals();
        activateDatepicker();
    }
    function copyReportVals() {
        $("#hiddenReportName").val($("#available_reports").val())
        $('#hiddenReportFormat').val($("#selectRepFormat").val())

    }
    function createSelect2Search(objectId, className) {
        $(objectId).select2({
            width: "90%",
            placeholder: "Type name...",
            minimumInputLength: 1,
            ajax: {
                url: '<g:createLink controller='ajax' action='lookup'/>',
                dataType: 'json',
                data: function (term, page) {
                    return {
                        hideIdent: true,
                        q: term, // search term
                        page_limit: 10,
                        baseClass:className
                    };
                },
                results: function (data, page) {
                    return {results: data.values};
                }
            }
        });

    }
    function activateDatepicker(){

        var element = $("div.date").children('input');
        var id = $(element).attr('id');
        console.log(element);
        if(id){
            element.parent().append('<div class="datepickericon" data-field="'+id+'"><i class="material-icons">event</i></div>')
        }

    }

    setTimeout(
        function(){
            $(function () {
                var repname = $('#available_reports option:selected').text();
                jQuery.ajax({type:'POST',data:{'report_name': repname}, url:'${createLink(controller: 'jasperReports', action: 'index')}'
                    ,success:function(data,textStatus){jQuery('#report_details').html(data);}
                    ,error:function(XMLHttpRequest,textStatus,errorThrown){}
                    ,complete:function(XMLHttpRequest,textStatus){runJasperJS()}});
            });

            $(function () {
                $('#available_reports').change(function() {
                    var repname = $('#available_reports option:selected').text();
                    jQuery.ajax({type:'POST',data:{'report_name': repname}, url:'${createLink(controller: 'jasperReports', action: 'index')}'
                        ,success:function(data,textStatus){jQuery('#report_details').html(data);}
                        ,error:function(XMLHttpRequest,textStatus,errorThrown){}
                        ,complete:function(XMLHttpRequest,textStatus){runJasperJS()}});
                });
            });

            $(function () {
                $('#selectRepFormat').change(function() {
                    $('#hiddenReportFormat').val($("#selectRepFormat").val())
                });
            });

            document.onload = runJasperJS();
        }, 100
    );

</script>
</body>

</html>
