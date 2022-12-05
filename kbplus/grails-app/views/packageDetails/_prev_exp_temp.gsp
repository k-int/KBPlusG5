<%@ page import="com.k_int.kbplus.Package" %>

<g:if test="${flash.message}">
	<div class="row">${flash.message}</div>
</g:if>

<g:if test="${flash.error}">
	<div class="row">${flash.error}</div>
</g:if>

<div class="container" data-theme="packages">
	<div class="row">
		<div class="col s12 l12">
			<h1 class="form-title flow-text text-navy">
				${packageInstance.name} -
				<g:if test="${screen=='previous'}">
					Previous
				</g:if>
				<g:else>
					Expected
				</g:else>
				Titles
			</h1>
			<g:if test="${num_tipp_rows > 0}">
		    	<p class="form-caption flow-text text-grey">Titles (<span>${offset+1}</span> to <span>${lasttipp}</span><g:if test="${num_tipp_rows > max}"> of <span>${num_tipp_rows}</span></g:if>)</p>
		    </g:if>
		    <g:else>
		    	<p class="form-caption flow-text text-grey">No Titles</p>
		    </g:else>

			<g:if test="${titlesList}">
				<g:each in="${titlesList}" var="t">
					<div class="row">
						<div class="col s12">
							<!--flex layout-->
							<div class="flex-parent z-depth-1">
								<div class="content title">
									<g:link controller="titleDetails" action="show" id="${t.title.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${t.title.title}</g:link>
									 &mdash;
									<g:link controller="tipp" action="show" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" id="${t.id}" target="_blank">TIPP</g:link>
								</div>
							</div>

							<!--
							<div class="flex-parent">
								<div class="content"><span>ISSN:</span> ${t?.title?.getIdentifierValue('ISSN')?:'No data'}</div>
								<div class="content bdr"><span>eISSN:</span> ${t?.title?.getIdentifierValue('eISSN')?:'No data'}</div>
							</div>
							-->

							<div class="flex-parent z-depth-1">
								<div class="content">
									<span>Identifiers:</span><br/>
									<g:each in="${t.title.ids}" var="id" status="counter">
										<g:if test="${counter > 0}">, </g:if>${id.identifier.ns.ns}: ${id.identifier.value}
									</g:each>
								</div>
							</div>

							<div class="flex-parent z-depth-1">
								<div class="content">
									<span>Access:</span><br/>
									${t.availabilityStatus?.value}
									<g:if test="${t.availabilityStatus?.value=='Expected'}">
	                                    on <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.accessStartDate}"/>>
	                                </g:if>
	                                <g:if test="${t.availabilityStatus?.value=='Expired'}">
	                                    on <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.accessEndDate}"/>
	                                </g:if>
								</div>
								<div class="content bdr">
									<span>Record Status:</span><br/>
									${t.status}
								</div>
								<div class="content bdr">
									<span>Access Start:</span><br/>
									<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.accessStartDate}"/>
								</div>
								<div class="content bdr">
									<span>Access End:</span><br/>
									<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.accessEndDate}"/>
								</div>
							</div>

							<div class="flex-parent z-depth-1">
								<div class="content">
									<span>Platform:</span><br/>
									<g:if test="${t.hostPlatformURL != null}">
										<a href="${t.hostPlatformURL}" target="_blank">${t.platform?.name}</a>
									</g:if>
									<g:else>
										${t.platform?.name}
									</g:else>
								</div>
								<div class="content bdr">
									<span>Coverage Start:</span><br/>
									Date: <g:if test="${t.startDate}"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.startDate}"/></g:if><g:else>No date</g:else><br/>
									Volume: ${t?.startVolume?:'No data'}<br/>
									Issue: ${t?.startIssue?:'No data'}<br/>
								</div>
								<div class="content bdr">
									<span>Coverage End:</span><br/>
									Date: <g:if test="${t.endDate}"><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.endDate}"/></g:if><g:else>No date</g:else><br/>
									Volume: ${t?.endVolume?:'No data'}<br/>
									Issue: ${t?.endIssue?:'No data'}<br/>
								</div>
								<div class="content bdr">
									<span>Coverage Depth:</span><br/>
									${t?.coverageDepth?:'No data'}
								</div>
							</div>

							<g:if test="${t.coverageNote?.length() > 0}">
								<div class="flex-parent z-depth-1">
									<div class="content">
										<span>Coverage Note:</span><br/>
										${t.coverageNote}
									</div>
								</div>
							</g:if>
							<!-- flex end -->
						</div>
					</div>
				</g:each>
			</g:if>

			<div class="pagination" id="prevExpPaginate">
				<g:if test="${titlesList}">
					<g:paginate action="${screen}" controller="packageDetails" params="${params}" next="chevron_right" prev="chevron_left" maxsteps="${max}" total="${num_tipp_rows}" />
				</g:if>
			</div>
		</div>
	</div>
</div>


<script type="text/javascript">
	$('div[id=prevExpPaginate]').on('click', function(event) {
		var clicked = $(event.target).closest('#prevExpPaginate a');
		if (clicked.length > 0) {
			event.preventDefault();
			var loc = clicked.attr('href');

			$.ajax({
				type: "GET",
				url: loc,
				error: function(jqXHR, textStatus, errorThrown) {
					console.log('error making ajax call');
					console.log(textStatus);
					console.log(errorThrown);
				}
			}).done(function(data) {
				console.log(data);
				$('.modal-content').html(data);
			});
		}
	});

	$(document).ready(function(){
		var next_pag_obj = $('div[id=prevExpPaginate] a[class=nextLink]');
		var prev_pag_obj = $('div[id=prevExpPaginate] a[class=prevLink]');

		if ((next_pag_obj.html() != null) && (next_pag_obj.html() == 'chevron_right')) {
			next_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_right</i>");
		}

		if ((prev_pag_obj.html() != null) && (prev_pag_obj.html() == 'chevron_left')) {
			prev_pag_obj.html("<i class='material-icons small pagination-icon'>chevron_left</i>");
		}
	});
</script>
