<%@ page import="com.k_int.kbplus.*" %>
<%@ page import="com.k_int.custprops.PropertyDefinition" %>
<!doctype html>
<html lang="en" class="no-js">
<head>
	<parameter name="pagetitle" value="Organisation info: ${orgInstance.name}" />
	<parameter name="pagestyle" value="organisations" />
	<meta name="layout" content="base"/>
	<title>KB+ Organisation: ${orgInstance.name}</title>
</head>
<body class="data-manager">
	<g:if test="${flash.message}">
		${flash.message}
	</g:if>
	
	<div class="row">
		<div class="col s12">
			<div class="row">
				<div class="col s12">
					<ul class="tabs jisc_tabs">
						<li class="tab"><a href="#details" class="add-anchor">Details<i class="material-icons">chevron_right</i></i></a></li>
						<li class="tab"><a href="#users" class="add-anchor">Users<i class="material-icons">chevron_right</i></a></li>
						<li class="tab"><a href="#options" class="add-anchor">Options<i class="material-icons">chevron_right</i></a></li>
					</ul>
				</div>
			</div>
			
			<!-- Start of details tab -->
			<div id="details">
				<g:form controller="organisations" action="updateOrgDetails" id="${orgInstance.id}" method="post" accept-charset="utf-8">
					<div class="row row-content">
						<div class="col s12">
							<div class="card jisc_card small white fullheight">
								<div class="card-content text-navy">
									<div class="input-field padding col s12 m12">
										<!-- this div is here to provide some spacing between elements on the page -->
									</div>
									<div class="input-field padding col s12 m6">
										<input id="organisation_name" name="name" type="text" value="${orgInstance.name}">
										<label for="organisation_name">Organisation Name</label>
									</div>
									<div class="input-field padding col s12 m6">
										<input id="address" type="text" name="address" value="${orgInstance.address}">
										<label for="address">Address</label>
									</div>
									<div class="input-field padding col s12 m6">
										<g:select name="orgType"
												  noSelection="${['':'Select one']}"
												  from="${RefdataValue.findAllByOwner(RefdataCategory.findByDesc('OrgType'))}"
									  			  optionKey="id"
									  			  optionValue="value"
									  			  value="${orgInstance.orgType?.id}"/>
										<label>Organisation Type</label>
									</div>
									<div class="input-field padding col s12 m6">
										<input id="ip_range" type="text" name="ipRange" value="${orgInstance.ipRange}">
										<label for="ip_range">IP Range</label>
									</div>
									<div class="input-field padding col s12 m6">
										<input id="shibboleth_scope" type="text" name="scope" value="${orgInstance.scope}">
										<label for="shibboleth_scope">Shibboleth Scope</label>
									</div>
									<div class="input-field padding col s12 m6">
										<select name="membershipOrganisation">
											<option value="" selected>Select one</option>
											<option value="Yes" ${orgInstance.membershipOrganisation=='Yes'?'selected':''}>Yes</option>
											<option value="No" ${orgInstance.membershipOrganisation=='No'?'selected':''}>No</option>
										</select>
										<label>Membership Org (Yes/No)</label>
									</div>
									<div class="input-field padding col s12 m6">
										<input id="sector" type="text" name="sector" value="${orgInstance.sector}" ${editable==false?'disabled':''}>
										<label for="sector">Sector</label>
									</div>
									<g:if test="${editable}">
										<div class="input-field padding col s12 m12">
											<input type="submit" class="waves-effect waves-light btn" value="Update organisation"/>
										</div>
									</g:if>
								</div>
							</div>
						</div>
					</div>
				</g:form>
				
				<g:form controller="ajax" action="addToCollection">
					<div class="row row-content">
						<div class="col s12">
							<div class="card jisc_card small white fullheight">
								<div class="card-content text-navy">
									<p class="card-title pack-detail">Variant Names</p>
									<div class="col s12 m6">
										<g:if test="${orgInstance.variantNames}">
											<g:each in="${orgInstance.variantNames}" var="vn">
												<div class="input-field padding col s12">
													<div class="col s6">
														<p>${vn.variantName}</p>
													</div> 
		          									<g:if test="${editable}">
		          										<div class="actions-container">
		          											<g:link id="${params.id}" controller="organisations" action="removeVariant" params="${[v:vn.id]}" class="btn-floating btn-flat waves-effect waves-light"><i class="material-icons">delete_forever</i><</g:link>
														</div>
		          									</g:if>
		          									<g:else>
		          										<div class="col s6"></div>
		          									</g:else>
	          									</div>
	        								</g:each>
	        							</g:if>
	        							<g:else>
	        								<div class="input-field padding col s12">
	        									None
	        								</div>
	        							</g:else>
	        						</div>
	        						<div class="input-field padding col s12 m6">
	        							<g:if test="${editable}">
	        								<input type="hidden" name="__context" value="${orgInstance.class.name}:${orgInstance.id}"/>
	        								<input type="hidden" name="__newObjectClass" value="com.k_int.kbplus.OrgVariantName"/>
	        								<input type="hidden" name="__recip" value="owner"/>
	        								<input type="text" name="variantName" id="addVariantName" required/>
	        								<label for="addVariantName">Add Variant Name</label>
	        								<i class="waves-effect waves-light btn waves-input-wrapper" style=""><input type="submit" value="Submit" class="waves-button-input"/></i>
	        							</g:if>
									</div>
								</div>
							</div>
						</div>
					</div>
				</g:form>
				
				<div class="row row-content">
					<div class="col s12">
						<div class="card jisc_card small white fullheight">
							<div class="card-content text-navy">
								<p class="card-title pack-detail">Identifiers</p>
								<div class="card-detail"></div>
								<div class="card-form">
									<div class="tab-table table-responsive-scroll">
										<table class="highlight bordered responsive-table">
											<thead>
												<tr>
													<th data-field="authority">Authority</th>
													<th data-field="identifier">Identifier</th>
													<th data-field="actions">Actions</th>
												</tr>
											</thead>
											
											<tbody>
												<g:if test="${orgInstance.ids}">
													<g:each in="${orgInstance.ids}" var="io">
														<tr>
															<td>${io.identifier.ns.ns}</td>
															<td>${io.identifier.value}</td>
															<td>
																<!--<a href="" class="table-action"><i class="material-icons">create</i></a>--> 
																<g:link controller="ajax" action="deleteThrough" params='${[contextOid:"${orgInstance.class.name}:${orgInstance.id}",contextProperty:"ids",targetOid:"${io.class.name}:${io.id}"]}' class="btn-floating table-action"><i class="material-icons">delete_forever</i></g:link>
															</td>
														</tr>
													</g:each>
												</g:if>
												<g:else>
													<tr><td colspan="3">No Data Currently Added</td></tr>
												</g:else>
											</tbody>
										</table>
						             </div>
									
									<g:if test="${editable}">
										<div class="input-field col s12">
											<a href="#kbmodal" ajax-url="${createLink(controller:'organisations', action:'addOrgIdentifier', id:orgInstance.id)}" class="waves-effect waves-light btn right modalButton">Add Identifier <i class="material-icons">add_circle_outline</i></a>
										</div>
									</g:if>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row mt-20">
					<div class="col s12 ">
						<h2>Administrative Membership</h2>
					</div>
				</div>
				
				<div class="row">
					<div class="col s12">
						<div class="tab-table z-depth-1">
							<ul class="tabs jisc_content_tabs">
								<li class="tab"><a href="#outgoing">Outgoing Combos</a></li>
								<li class="tab"><a href="#incoming">Incoming Combos</a></li>
								<li class="tab"><a href="#other">Other Organisation Link</a></li>
							</ul>

							<div id="outgoing" class="tab-content">
								<ul class="collection">
									<!--<li class="collection-item clearfix"><div class="launch-out"><a class="btn-floating bordered right"><i class="material-icons">open_in_new</i></a></div></li>-->
									<g:if test="${orgInstance?.outgoingCombos}">
										<g:each in="${orgInstance.outgoingCombos}" var="i">
											<li class="collection-item">
												${i.type?.value} - <g:link controller="organisations" action="show" id="${i.toOrg.id}">${i.toOrg?.name}</g:link>
												<g:if test="${i.toOrg?.ids}">
													(<g:each in="${i.toOrg.ids}" var="id">
														${id.identifier.ns.ns}:${id.identifier.value} 
													</g:each>)
												</g:if>
											</li>
										</g:each>
									</g:if>
									<g:else>
										<li class="collection-item">No Outgoing Combos</li>
									</g:else>
								</ul>
							</div>
							
							<div id="incoming" class="tab-content">
								<ul class="collection">
									<g:if test="${orgInstance?.incomingCombos}">
										<!--<li class="collection-item clearfix"><div class="launch-out"><a class="btn-floating bordered right"><i class="material-icons">open_in_new</i></a></div></li>-->
										<g:each in="${orgInstance.incomingCombos}" var="i">
											<li class="collection-item">
												${i.type?.value} - <g:link controller="org" action="show" id="${i.toOrg.id}">${i.fromOrg?.name}</g:link>
												<g:if test="${i.fromOrg?.ids}">
													(<g:each in="${i.fromOrg.ids}" var="id">
														${id.identifier.ns.ns}:${id.identifier.value} 
													</g:each>)
												</g:if>
											</li>
										</g:each>
									</g:if>
									<g:else>
										<li class="collection-item">No Incoming Combos</li>
									</g:else>
								</ul>
							</div>
							
							<div id="other" class="tab-content">
								<ul class="collection">
									<g:if test="${orgInstance?.links}">
										<!--<li class="collection-item clearfix"><div class="launch-out"><a class="btn-floating bordered right"><i class="material-icons">open_in_new</i></a></div></li>-->
										<g:each in="${orgInstance.links}" var="i">
											<li class="collection-item">
												<g:if test="${i.pkg}"><g:link controller="packageDetails" action="show" id="${i.pkg.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Package: ${i.pkg.name} (${i.pkg?.packageStatus?.value})</g:link></g:if>
												<g:if test="${i.sub}">
													<g:if test="${params.defaultInstShortcode}">
														<g:link controller="subscriptionDetails" action="index" id="${i.sub.id}" params="${[defaultInstShortcode:params.defaultInstShortcode]}">Subscription: ${i.sub.name} (${i.sub.status?.value})</g:link>
													</g:if>
													<g:else>
														Subscription: ${i.sub.name} (${i.sub.status?.value})
													</g:else>
												</g:if>
												<g:if test="${i.lic}">Licence: ${i.lic.id} (${i.lic.status?.value})</g:if>
												<g:if test="${i.title}"><g:link controller="titleInstance" action="show" id="${i.title.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Title: ${i.title.title} (${i.title.status?.value})</g:link></g:if>
												<g:if test="${i.roleType?.value}">
													(${i.roleType.value})
												</g:if>
											</li>
										</g:each>
									</g:if>
									<g:else>
										<li class="collection-item">No Other Organisation Links</li>
									</g:else>
								</ul>
							</div>
						</div>
					</div>
				</div>
				
			</div>
			<!-- End of details tab -->
			
			<!-- Start of users tab -->
			<div id="users">
				<div class="row">
					<div class="col s12">
						<div class="tab-table z-depth-1  table-responsive-scroll">
							<table class="highlight bordered">
								<thead>
									<tr>
										<th>User</th>
										<th>Email</th>
										<th>System Role</th>
										<th>Inst Role</th>
										<th>Status</th>
										<th>Actions</th>
									</tr>
								</thead>
								<tbody>
									<g:if test="${users}">
										<g:each in="${users}" var="userOrg">
											<tr>
												<td class="w250"><g:link controller="userDetails" action="edit" id="${userOrg[0].user.id}">${userOrg[0].user.displayName} ${userOrg[0].user.defaultDash?.name?"(${userOrg[0].user.defaultDash.name})":""}</g:link></td>
												<td class="w200">${userOrg[0].user.email}</td>
												<td class="w100">
													<g:if test="${userOrg[1]}">
														<ul>
															<g:each in="${userOrg[1]}" var="admRole">
																<li>${admRole}</li>
															</g:each>
														</ul>
													</g:if>
												</td>
												<td class="w150">${userOrg[0].formalRole?.authority}</td>
												<td class="w150">
													<g:if test="${userOrg[0].status==0}">Pending</g:if>
													<g:if test="${userOrg[0].status==1}">Approved</g:if>
													<g:if test="${userOrg[0].status==2}">Rejected</g:if>
													<g:if test="${userOrg[0].status==3}">Auto Approved</g:if>
												</td>
												<td class="w100">
													<g:if test="${editable}">
														<g:if test="${((userOrg[0].status==1 ) || (userOrg[0].status==3)) }">
															<g:link controller="organisations" action="revokeRole" params="${[grant:userOrg[0].id, id:params.id, anchor:'#users']}" class="btn-floating table-action"><i class="material-icons tooltipped" data-position="right" data-delay="50" data-tooltip="Revoke">undo</i></g:link>
														</g:if>
														<g:else>
															<g:link controller="organisations" action="enableRole" params="${[grant:userOrg[0].id, id:params.id, anchor:'#users']}" class="btn-floating table-action"><i class="material-icons tooltipped" data-position="right" data-delay="50" data-tooltip="Approve">redo</i></g:link>
														</g:else>
														<g:link controller="organisations" action="deleteRole" params="${[grant:userOrg[0].id, id:params.id, anchor:'#users']}" class="btn-floating table-action"><i class="material-icons tooltipped" data-position="right" data-delay="50" data-tooltip="Delete">delete_forever</i></g:link>
													</g:if>
												</td>
											</tr>
										</g:each>
									</g:if>
									<g:else>
										<tr><td colspan="6">No Users</td></tr>
									</g:else>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<!-- End of users tab -->
			
			<!-- Start of options tab -->
		    <div id="options">
		    	 <g:if test="${flash.error}">
		    	 	<div class="row">
		    	 		<div class="col s12">
							${flash.message}
						</div>
					</div>
				</g:if>
				
				<div class="row">
					<div class="col s12">
						<div class="modal-search-container z-depth-1 search-section notop">
							<ul class="collection no-border">
								<li class="collection-item">
									<h2>Add Existing Property</h2>
									<a href="#kbmodal" ajax-url="${createLink(controller:'ajax', action:'addCustomPropertyModal', params:[prop_desc:PropertyDefinition.ORG_CONF, ownerId:orgInstance.id, ownerClass:orgInstance.class, editable:editable, propBaseClass:'com.k_int.custprops.PropertyDefinition', theme:'organisations', anchor:'#options'])}" class="waves-effect waves-teal btn modalButton">Add Existing Property</a>
								</li>
							</ul>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col s12">
			    		<div class="tab-table z-depth-1 table-responsive-scroll">
							<table class="highlight bordered">
								<thead>
									<tr>
										<th>Property</th>
										<th>Value</th>
										<th>Notes</th>
										<th>Actions</th>
									</tr>
								</thead>
								<tbody>
									<g:if test="${orgInstance.customProperties}">
										<g:each in="${orgInstance.customProperties}" var="prop">
											<tr>
												<td class="w200">${prop.type.name}</td>
												<td class="w200">
													<g:if test="${prop.type.type == Integer.toString()}">
														${prop.intValue}
													</g:if>
													<g:elseif test="${prop.type.type == String.toString()}">
														${prop.stringValue}
													</g:elseif>
													<g:elseif test="${prop.type.type == BigDecimal.toString()}">
														${prop.decValue}
													</g:elseif>
													<g:elseif test="${prop.type.type == RefdataValue.toString()}">
														${prop?.refValue?.value}
													</g:elseif>
												</td>
												<td>${prop.note}</td>
												<td class="w100">
													<g:if test="${editable == true}">
														<g:link controller="ajax"
																action="delCustomProperty"
																id="${prop.id}"
																params="${[propclass: prop.getClass(),ownerId:orgInstance.id,ownerClass:orgInstance.class, editable:editable, referer:'Y', anchor:'#options']}"
																onclick="return confirm('Delete the property ${prop.type.name}?')"
																class="btn-floating table-action">
															<i class="material-icons">delete_forever</i>
														</g:link>
													</g:if>
												</td>
											</tr>
										</g:each>
									</g:if>
									<g:else>
										<tr><td colspan="4">No Properties Currently Added</td></tr>
									</g:else>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<!-- End of options tab -->
		</div>
	</div>
</body>
</html>
