<!--***table***-->
<div class="tab-content">

     <div class="row table-responsive-scroll">
            <h1>Report Description: ${reportdesc}</h1>


            <g:form controller="jasperReports" action="generateReport">
                <input type="hidden" id="hiddenReportName" name="_file">
                <input type="hidden" id="hiddenReportFormat" name="_format">
                <table class="table table-striped table-bordered table-condensed">
            
            <table class="highlight bordered">
                <thead>
                <tr>
                    <th>Description</th>
                    <th>Value</th>
                </tr>
                <tbody>

                <g:each in="${report_parameters}" var="rparam">
                    <tr>
                    <td>${rparam.getDescription()}</td>
                    <td>
                        <g:if test="${rparam.getValueClass().equals(java.sql.Timestamp) || rparam.getValueClass().equals(java.sql.Date) }">
                            <div class="input-append date">
                                <input class="span2" size="16" type="text" id="id_${rparam.getName().toString().replace(" ","_")}" name="${rparam.getName()}">
                            </div>
                        </g:if>
                        <g:elseif test="${rparam.getName().contains("select")}">
                            <div class="input-field">
                                <g:select name="${rparam.getName()}"
                                          id="${rparam.getName().toString().replace("&","_")}"
                                          from="${rparam.getName().substring(rparam.getName().indexOf('&')+1).split('&')}"/>
                                <script type="text/javascript">
                                    $('#${rparam.getName().toString().replace("&","_")}').ready(function() {
                                        $('select').material_select();
                                    });
                                </script>
                            </div>
                        </g:elseif>
                        <g:else>
                            <g:if test="${rparam.getName().contains("search")}">

                               <input type="hidden" id="${rparam.getName()}" name="${rparam.getName()}"/>
                                <script type="text/javascript">
                                    createSelect2Search('#${rparam.getName()}', '${rparam.getValueClass().toString().replace("class ","")}');
                                </script>
                            </g:if>
                            <g:else>
                                <input type="text" name="${rparam.getName()}"/>
                            </g:else>
                        </g:else>
                    </td>
                </g:each>
                </tr>
                </tbody>
            </table>

            <div class="input-field mt-20">
                <g:submitButton name="submit" class="waves-effect waves-light btn" value="Generate Report"/>
            </div>
            </g:form>
        </div>        
</div>
