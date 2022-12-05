<%@ page import="com.k_int.kbplus.Platform" %>

<div class="container" data-theme="subscriptions">
	<div class="row">
		<div class="col s12 l12">
			<h1 class="form-title flow-text navy-text">Platform URL Template for ${platformInstance.name}</h1>
			<g:if test="${demotipp}">
				<p class="form-caption flow-text text-grey">Using TIPP ${demotipp.id} for example URLS - Title is ${demotipp.title.title}, ISSN is ${demotipp.title.issn}</p>
			</g:if>
			<div class="row">
				<div class="col s12">
					<h3 class="indicator">Current URL Templates</h3>
				</div>
			</div>
			<div class="row">
				<div class="col s12">
					<form name="addPlatformURLTemplateForm">
						
						<table class="bordered highlight responsive-table modal-table fixed-table">
							<thead>
								<tr>
									<th></th>
									<th>Starts On</th>
									<th>Template</th>
									<th>Example</th>
									<th>Actions</th>
								</tr>
							</thead>
							<tbody>
								<g:each in="${platformInstance.urlTemplates}" var="t">
									<tr>
										<td>${t.id}</td>
										<td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.startsOn}"/></td>
										<td>${t.templateUrl}</td>
										<td>
											<g:if test="${demotipp}">
												${demotipp.evaluateTemplateURL(t.templateUrl)?:'ERROR'}
											</g:if>
											<g:else>
												No tipp available to use as a demo for the template
											</g:else>
										</td>
										<td><a id="removePlatformURLTemplate" ajax-url="${createLink(controller:'platform', action:'removeTemplate', id:t.id, params:[platformId:platformInstance.id, reload:'yes'])}" class="waves-effect waves-light btn">Remove</a></td>
									</tr>
								</g:each>
								<tr>
									<td style="vertical-align: middle;">Add:</td>
									<td style="vertical-align: middle;">
										<div class="input-field">
											<g:kbplusDatePicker inputid="startDate" name="startDate" value=""/>
										</div>
									</td>
									<td style="vertical-align: middle;">
										<div class="input-field">
											<input type="text" id="tmplate" name="tmplate"/>
										</div>
									</td>
									<td></td>
									<td style="vertical-align: middle;">
										<button type="submit" class="waves-effect waves-light btn"> Add <i class="material-icons">add_circle_outline</i></button>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
			</div>
			
			<div class="row">
				<div class="col s12">
					<h3 class="indicator">Example URL Templates</h3>
				</div>
			</div>
			<div class="row">
				<div class="col s12">
					<div class="tab-table z-depth-1  table-responsive-scroll">
						<table class="highlight bordered">
							<tr>
								<td>"&#36;{x.platform.primaryUrl}&#36;{(x.title.getIdentifierValue("issn"))?:"No ISSN"}"</td>
								<td>
									x is the tipp being displayed<br/>
									x.platform.primaryUrl is the platform primary URL <br/>
									Wrapping expressions in &#36;{..} causes them to be evaluated - otherwise the text would appear in the url<br/>
									Expressions are strings, so are normally enclosed in quotes
								</td>
							</tr>
							<tr>
								<td>"http://a.url/issn/&#36;{x.title.issn}"</td>
								<td>Hard code the path http://a.url/issn/ and then adds the ISSN by calling the method getISSN() on the title attached to the tipp</td>
							</tr>
						</table>
					</div>
				</div>

			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$('form[name=addPlatformURLTemplateForm]').submit(function() {
		var sd = $('input[name=startDate]').val();
		var tmpl = $('input[name=tmplate]').val();
		
		$.ajax({
			type: "post",
			url: "${createLink(controller:'platform', action:'template', id:platformInstance.id)}",
			data: {
			  startDate: sd,
			  tmplate: tmpl
			},
			error: function(jqXHR, textStatus, errorThrown) {
			  console.log('error adding platform url template');
			  console.log(textStatus);
			  console.log(errorThrown);
		  	}
		}).done(function(data) {
			console.log(data);
			$('.modal-content').html(data);
		});
	
		return false;
	});
	
	$('a[id=removePlatformURLTemplate]').click(function(e) {
		var ajaxUrl = $(this).attr("ajax-url");
		$.ajax({
			type: "get",
			url: ajaxUrl,
			error: function(jqXHR, textStatus, errorThrown) {
			  console.log('error adding platform url template');
			  console.log(textStatus);
			  console.log(errorThrown);
		  	}
		}).done(function(data) {
			console.log(data);
			$('.modal-content').html(data);
		});
	});
</script>
