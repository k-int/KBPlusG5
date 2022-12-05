<!doctype html>
<html>
	<head>
		<meta name="layout" content="base">
		<parameter name="actionrow" value="licences-compare" />
		<parameter name="pagetitle" value="${message(code:'menu.institutions.comp_lic')}" />
		<parameter name="pagestyle" value="licences" />
		<title>KB+ Licence Compare</title>
	</head>
	<body class="licences">
		<div class="row">
			<div class="col s12">
				<div class="tab-table z-depth-1">
					<table class="highlight bordered responsive-table">
						<thead>
							<tr>
								<th class="pd-35 br">Licence Property</th>
								<g:each in="${licences}" var="licence" status="counter">
      								<th class="pd-35 ${(counter + 1) < licences.size() ? 'br' : ''}"><p>${licence.reference}</p></th>
      							</g:each>
							</tr>
						</thead>
						<tbody>
							<g:each in="${map}" var="entry">
								<tr>
									<td class="text-navy titled pd-35 br"><p>${entry.getKey()}</p></td>
									<g:each in="${licences}" var="lic" status="counter">
										<g:if test="${entry.getValue().containsKey(lic.reference)}">
											<td class="pd-35 ${(counter + 1) < licences.size() ? 'br' : ''}">
												<ul class="flex-row">
													<g:set var="point" value="${entry.getValue().get(lic.reference)}"/>
													<li>
														<g:if test="${['stringValue','intValue','decValue'].contains(point.getValueType())}">
															${point.getValue()}
														</g:if>
														<g:else>
															<g:set var="val" value="${point.getValue()}"/>
															<g:if test="${val == 'Y' || val=='Yes'}">
																<i title="${val}" class="material-icons icon-green">done</i>
															</g:if>
															<g:elseif test="${val=='N' || val=='No'}">
																<i title="${val}" class="material-icons icon-red">clear</i>
															</g:elseif>
															<g:elseif test="${['O','Other','Specified'].contains(val)}">
																<i title="${val}" class="material-icons icon-blue">info_outline</i>
															</g:elseif>
															<g:elseif test="${['U','Unknown','Not applicable','Not Specified'].contains(val)}">
																<i title="${val}" class="material-icons icon-grey">help_outline</i>
															</g:elseif>
															<g:else>
																${point.getValue()}
															</g:else>
														</g:else>
													</li>
													
													<g:if test="${point.getNote() && point.getNote().trim().length()>0}">
														<li>
															<span>
																<span class="tooltipped card-tooltip" data-position="left" data-delay="50" data-src="${point.id}-${lic.id}">
																	<i class="material-icons">remove_red_eye</i>
																</span>
																<script type="text/html" id="${point.id}-${lic.id}">
																<div class="kb-tooltip">
					      											<div class="tooltip-title">Annotations</div>
					      												<ul class="tooltip-list">
		                  													<li>
		                  														${ point.getNote() }
		                  													</li>
																		</ul>
																	</div>
																</div>
																</script>
															</span>
														</li>
													</g:if>
												</ul>
											</td>
										</g:if>
										<g:else>
											<td class="pd-35 ${(counter + 1) < licences.size() ? 'br' : ''}">
												<ul class="flex-row">
													<li><i title="Not Set" class="material-icons icon-blue">not_interested</i></li>
												</ul>
											</td>
										</g:else>
									</g:each>
								</tr>
							</g:each>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</body>
</html>
