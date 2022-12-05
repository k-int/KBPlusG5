<div class="container" data-theme="subscriptions">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Upload Renewals Worksheet</h1>
			<!--form-->
			<div class="row">
				<g:form action="renewalsUpload" method="post" enctype="multipart/form-data" params="${params}" class="col s12">
					<div class="row">
						<div class="file-field input-field col s12">
							<div class="btn">
								<span>Find file</span>
								<input type="file" id="renewalsWorksheet" name="renewalsWorksheet"/>
							</div>
							<div class="file-path-wrapper">
								<input class="file-path validate" type="text" placeholder="Upload a file">
							</div>
						</div>
					</div>
									
					<div class="row">
						<div class="input-field col s12">
							<button type="submit" class="waves-effect waves-light btn">Upload</button>
						</div>
					</div>
				</g:form>
			</div>
			<!--form end-->
		</div>
	</div>
</div>