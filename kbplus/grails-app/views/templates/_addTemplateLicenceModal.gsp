<div class="container" data-theme="licences">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text center">Add a Licence</h1>
			<div class="row">
				<div class="launch-item-container">
						<g:link controller="licenseDetails" action="create" params="${params}" class="launch-item">
							<div class="content">
								<i class="large material-icons">add</i>
								<div class="title">Add new template</div>
							</div>
						</g:link>
				</div>
				<div class="launch-item-container">
					<a href="#" id="copyTemp" ajax-url="${createLink(controller:'dataManager', action:'addTemplateLicense', params:params)}" class="launch-item">
						<div class="content">
							<i class="large material-icons">content_copy</i>
							<div class="title">Copy existing template</div>
						</div>
					</a>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$('a[id=copyTemp]').click(function() {
		var ajax_url = $(this).attr("ajax-url");
		$.ajax({
			type: "GET",
			url: ajax_url,
			error: function(jqXHR, textStatus, errorThrown) {
				console.log('error copying new template');
				console.log(textStatus);
				console.log(errorThrown);
			}
		}).done(function(data) {
			console.log(data);
			$('.modal-content').html(data);
		});
	});
</script>
