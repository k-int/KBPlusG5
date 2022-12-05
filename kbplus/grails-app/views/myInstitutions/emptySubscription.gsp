<div class="container" data-theme="subscriptions">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Add a Subscription</h1>
			<p class="form-caption flow-text grey-text">This form will create a new subscription. To add titles to your subscription use "Associated Packages" tab on the subscription details page.</p>
			<div class="row">
				<g:form class="col s12" name="emptySubscription" action="processEmptySubscription" params="[defaultInstShortcode:params.defaultInstShortcode]" controller="myInstitutions" method="post">
					<div class="row">
						<div class="input-field col s12 m6">
							<input type="text" name="newEmptySubName" placeholder="New Subscription Name" required/>
							<label class="active">Subscription Name</label>
						</div>
						<div class="input-field col s12 m6">
							<input type="text" name="newEmptySubId" value="${defaultSubIdentifier}" placeholder="New Subscription Identifier" required/>
							<label class="active">Subscription Identifier</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="valid_from" name="valid_from" value="${defaultStartYear}" required="${true}"/>
							<label class="active">Start Date</label>
						</div>
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="valid_to" name="valid_to" value="${defaultEndYear}" required="${true}"/>
							<label class="active">End Date</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12">
							<input type="submit" class="waves-effect waves-light btn" value="Submit"/>
						</div>
					</div>
				</g:form>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$('form[name=emptySubscription]').submit(function() {
		var submitForm = true;
		var start = $('input[name=valid_from]').val();
		var end = $('input[name=valid_to]').val();
		
		if ((start == null) || (start.length == 0)) {
			submitForm = false;
			alert("Please select a date for Valid From");
		}
		
		if ((end == null) || (end.length == 0)) {
			submitForm = false;
			alert("Please select a date for Valid To");
		}
		
		return submitForm;
	});
</script>