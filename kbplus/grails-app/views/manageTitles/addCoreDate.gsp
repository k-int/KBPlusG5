<%@ page import="java.text.SimpleDateFormat"%>
<%
	def dateFormatter = new SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
%>

<div class="container" data-theme="titles">
  <div class="row">
    <div class="col s12">
      <g:if test="${message}">
        <p>${message}</p>
      </g:if>
      <h1 class="form-title flow-text text-navy">Add Core Date for Selected Titles</h1>
      <p class="form-caption flow-text text-grey">Add a new core date range for the selected titles.</p>
      
      <div class="row">
        <div class="col s12">
          <h3 class="indicator">Add new core date range</h3>
          <p class="text-grey">Use this form to add new core date ranges to the selected titles. Set the start date and optionally an end date then click add. If the dates you specify overlap with existing core dates in the table above they will be merged into a single core statement, otherwise a new line will be added to the table.</p>
        </div>
      </div>
      
      <div class="row">
        <g:form controller="manageTitles" action="processCoreDate" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" method="post" class="col s12" name="addCoreDateForm">
          <g:each in="${params}" var="prm">
            <g:if test="${prm.key.startsWith('_tip.') && (prm.value=='on')}">
              <input type="hidden" name="${prm.key}" value="${prm.value}"/>
            </g:if>
            
            <g:if test="${prm.key=='allinsub'}">
              <input type="hidden" name="${prm.key}" value="${prm.value}"/>
            </g:if>
            
            <g:if test="${prm.key=='sub'}">
              <input type="hidden" name="${prm.key}" value="${prm.value}"/>
            </g:if>
          </g:each>
          <input type="hidden" name="sort" value="${params.sort}"/>
          
          <div class="row">
            <div class="input-field col s12 m6">
              <g:kbplusDatePicker inputid="start_date" name="coreStartDate" value="" required="${true}"/>
              <label class="active">Core Start Date</label>
            </div>
            <div class="input-field col s12 m6">
              <g:kbplusDatePicker inputid="end_date" name="coreEndDate" value="" required="${true}"/>
              <label class="active">Core End Date</label>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <button type="submit" class="waves-effect waves-light btn">Add <i class="material-icons">add_circle_outline</i></button>
            </div>
          </div>
        </g:form>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
$('form[name=addCoreDateForm]').submit(function() {
  var submitForm = true;
  var start = $('input[name=coreStartDate]').val();
  var end = $('input[name=coreEndDate]').val();
  
  if ((start == null) || (start.length == 0)) {
    submitForm = false;
    alert("Please select a date for Core Start Date");
  }
  
  if ((end == null) || (end.length == 0)) {
    submitForm = false;
    alert("Please select a date for Core End Date");
  }
  
  return submitForm;
});
</script>
