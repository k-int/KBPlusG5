<%@ page import="com.k_int.kbplus.Subscription" %>

<g:if test="${flash.message}">
    <div class="row">${flash.message}</div>
</g:if>

<g:if test="${flash.error}">
    <div class="row">${flash.error}</div>
</g:if>

<div class=container data-theme="subscriptions">
	<div class="row">
		<div class="col s12 l12">
    		<h1 class="form-title flow-text text-navy">
		    	${subscriptionInstance.name} -
		    	<g:if test="${screen=='previous'}">
		    		Previous Titles
		    	</g:if>
		    	<g:else>
		    		Expected Titles
		    	</g:else>
		    </h1>
		    <g:if test="${num_ie_rows > 0}">
		    	<p class="form-caption flow-text text-grey">Titles (<span>${offset+1}</span> to <span>${lastie}</span><g:if test="${num_ie_rows > max}"> of <span>${num_ie_rows}</span></g:if>)</p>
		    </g:if>
		    <g:else>
		    	<p class="form-caption flow-text text-grey">No Titles</p>
		    </g:else>

			<g:if test="${titlesList}">
				<g:each in="${titlesList}" var="ie">
					<div class="row">
						<div class="col s12">
							<!--flex layout-->
							<div class="flex-parent z-depth-1">
								<div class="content title">
									<g:link controller="issueEntitlement" id="${ie.id}" action="show" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">${ie.tipp.title.title}</g:link>
									 &mdash;
									<g:if test="${grailsApplication.config.feature.v61}">
										<a href="${ie.tipp?.getComputedTemplateURL()}" target="_blank">Host Link</a>
									</g:if>
									<g:else>
										<a href="${ie.tipp?.hostPlatformURL}" target="_blank">Host Link</a>
									</g:else>
								</div>
							</div>

							<div class="flex-parent z-depth-1">
								<div class="content"><span>ISSN:</span> ${ie?.tipp?.title?.getIdentifierValue('ISSN')?:'No data'}</div>
								<div class="content bdr"><span>eISSN:</span> ${ie?.tipp?.title?.getIdentifierValue('eISSN')?:'No data'}</div>
							</div>

							<div class="flex-parent z-depth-1">
								<div class="content">
									<span>Access:</span><br/>
									${ie.availabilityStatus?.value}
									<g:if test="${ie.availabilityStatus?.value=='Expected'}">
	                                    on <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.accessStartDate}"/>
	                                </g:if>
	                                <g:if test="${ie.availabilityStatus?.value=='Expired'}">
	                                    on <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.accessEndDate}"/>
	                                </g:if>
								</div>
								<div class="content bdr">
									<span>Record Status:</span><br/>
									${ie.status}
								</div>
								<div class="content bdr">
									<span>Access Start:</span><br/>
									<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.accessStartDate}"/>
								</div>
								<div class="content bdr">
									<span>Access End:</span><br/>
									<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.accessEndDate}"/>
								</div>
							</div>

							<div class="flex-parent z-depth-1">
								<div class="content">
									<span>Coverage Start:</span><br/>
									<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.startDate}"/>
								</div>
								<div class="content bdr">
									<span>Coverage End:</span><br/>
									<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.endDate}"/>
								</div>
								<div class="content bdr">
									<span>Core Start:</span><br/>
									<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.coreStatusStart}"/>
								</div>
								<div class="content bdr">
									<span>Core End:</span><br/>
									<g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.coreStatusEnd}"/>
								</div>
							</div>
							<!-- flex end -->
	                        <!-- Need to figure out where these go in new design
	                        ie.coreStatus
							<g:if test="${institutional_usage_identifier}">
								<g:if test="${ie?.tipp?.title?.getIdentifierValue('ISSN')}">
									| <a href="https://www.jusp.mimas.ac.uk/secure/v2/ijsu/?id=${institutional_usage_identifier.value}&issn=${ie?.tipp?.title?.getIdentifierValue('ISSN')}">ISSN Usage</a>
								</g:if>
								<g:if test="${ie?.tipp?.title?.getIdentifierValue('eISSN')}">
									| <a href="https://www.jusp.mimas.ac.uk/secure/v2/ijsu/?id=${institutional_usage_identifier.value}&issn=${ie?.tipp?.title?.getIdentifierValue('eISSN')}">eISSN Usage</a>
								</g:if>
							</g:if>-->
						</div>
					</div>
				</g:each>
			</g:if>

			<div class="pagination" id="prevExpPaginate">
				<g:if test="${titlesList}">
					<g:paginate action="${screen}" controller="subscriptionDetails" params="${params}" next="chevron_right" prev="chevron_left" maxsteps="${max}" total="${num_ie_rows}" />
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
