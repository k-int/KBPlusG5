<%@ page import="java.text.SimpleDateFormat"%>
<%
	def dateFormatter = new SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
%>

<div class="container" data-theme="${theme}">
	<div class="row">
		<div class="col s12">
			<g:if test="${message}">
				<p>${message}</p>
			</g:if>
			<h1 class="form-title flow-text text-navy">Core Dates for ${tip?.title?.title}</h1>
			<p class="form-caption flow-text text-grey">Add a new core date range, or update/delete an existing one.</p>
			
			<div class="row">
				<div class="col s12">
					<h3 class="indicator">Add new core date range</h3>
					<p class="text-grey">Use this form to add new core date ranges. Set the start date and optionally an end date then click add. If the dates you specify overlap with existing core dates in the table above they will be merged into a single core statement, otherwise a new line will be added to the table.</p>
				</div>
			</div>
			
			<div class="row">
				<form class="col s12" name="coreExtendForm">
			    	<input type="hidden" name="tipID" value="${tipID}"/>
					<div class="row">
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="start_date" name="coreStartDate" value=""/>
							<label class="active">Core Start Date</label>
						</div>
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="end_date" name="coreEndDate" value=""/>
							<label class="active">Core End Date</label>
						</div>
					</div>
					<div class="row">
						<div class="input-field col s12">
							<button type="submit" class="waves-effect waves-light btn">Add <i class="material-icons">add_circle_outline</i></button>
						</div>
					</div>
				</form>
			</div>
			
			<g:if test="${coreDates}">
				<h1 class="form-title flow-text text-navy" style="padding-top: 0px;">Existing core date range</h1>
				<div class="row section">
					<div class="col s12">
						<div class="tab-table z-depth-1 table-responsive-scroll">
							<table class="bordered highlight modal-table fixed-table">
								<thead>
									<tr>
										<th>Core Start Date</th>
										<th>Core End Date</th>
										<th>Action</th>
									</tr>
								</thead>
								<tbody>
									<g:each in="${coreDates}" var="coreDate">
										<tr>
											<td>
												${coreDate.startDate ? dateFormatter.format(coreDate.startDate) : ''}
											</td>
											<td>
                                                                                          <g:if test="${coreDate.endDate != null}">
                                                                                            ${dateFormatter.format(coreDate.endDate)}
                                                                                          </g:if>
                                                                                          <g:else>
                                                                                            <g:form controller="manageTitles" action="closeOutCore" id="${tipID}">
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="end_date" name="coreEndDate" value=""/>
							<label class="active">Set end date</label>
						</div>
						<div class="input-field col s12">
							<button type="submit" class="waves-effect waves-light btn">Close core dates</button>
						</div>
                                                                                            </g:form>
                                                                                          </g:else>
											</td>
											<td>
												<g:if test="${editable == 'true' || editable == true}">
													<a id="deleteCoreDate" href="#" tipid="${tipID}" cdid="${coreDate.id}" class="btn-floating table-action"><i class="material-icons" style="background-color: #ffffff;">delete_forever</i></a>
												</g:if>
											</td>
										</tr>
									</g:each>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</g:if>
			
		</div>
	</div>
</div>

<script type="text/javascript">
$('form[name=coreExtendForm]').submit(function() {
	var tipId = $('input[name=tipID]').val();
	var csd = $('input[name=coreStartDate]').val();
	var ced = $('input[name=coreEndDate]').val();

	console.log(tipId);
	console.log(csd);
	console.log(ced);
	
	$.ajax({
		type: "GET",
		url: "<g:createLink controller='ajax' action='coreExtend'/>?tipID="+tipId+"&coreStartDate="+csd+"&coreEndDate="+ced
		//url: "/ajax/coreExtend?tipID="+tipId+"&coreStartDate="+csd+"&coreEndDate="+ced
	}).done(function(data) {
		console.log(data);
		$('.modal-content').html(data);
	});

	return false;
});

$('a[id=deleteCoreDate]').click(function() {
	var tipId = $(this).attr('tipid');
	var coreDateId = $(this).attr('cdid');

	$.ajax({
		type: "GET",
		url: "<g:createLink controller='ajax' action='deleteCoreDate'/>?tipID="+tipId+"&coreDateID="+coreDateId
		//url: "/ajax/deleteCoreDate?tipID="+tipId+"&coreDateID="+coreDateId
	}).done(function(data) {
		console.log(data);
		$('.modal-content').html(data);
	});
});
</script>

