<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.k_int.kbplus.onixpl.OnixPLService" %>

<div class="container" data-theme="licences">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">${message(code:'menu.institutions.comp_onix')}</h1>
			<p class="form-caption flow-text grey-text">You can use this tool to compare up to three licences</p>

			<div class="row">
				<g:form controller="onixplLicenseCompare" name="compare" action="matrix" method="post">
					<g:if test="${params.defaultInstShortcode}">
						<input type="hidden" name="defaultInstShortcode" value="${params.defaultInstShortcode}"/>
					</g:if>
					<div class="row">
						<div class="input-field col s12">
							<input type="hidden" name="selectedIdentifier" id="addIdentifierSelect"/>
						</div>
					</div>

					<div class="row">
						<div class="input-field col s12">
							<button type="button" class="waves-effect waves-light btn" id="addToList">Add License<i class="material-icons">add_circle_outline</i> </button>
						</div>
					</div>

					<div class="row"><!--This is purposely empty to provide a nice break between elements on the page--></div>

					<div class="row">
						<div class="input-field col s12">
							<g:select style="width:100%; height: auto; word-wrap: break-word; display:block;" id="selectedLicences" name="selectedLicences" class="compare-license browser-default" from="${[]}" multiple="true" />
							<label class="active" style="transform: translateY(-200%);">Licences selected for comparison</label>
						</div>
					</div>

					<g:if test="${termList && termList.size()>0}">
						<div class="row">
							<div class="input-field col s12">
								<div class="jstree-convert">
									<g:treeSelect name="sections" class="compare-section" options="${termList}" selected="true" multiple="true" style="display:block; height:auto;" />
								</div>
								<label class="active" style="transform: translateY(-200%);">Compare section</label>
							</div>
						</div>
					</g:if>

					<div class="row">
						<div class="input-field col s12">
							<input id="submitButton" disabled='true' type="submit" value="Compare" name="Compare" class="waves-effect waves-light btn" />
						</div>
					</div>
				</g:form>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$(function() {
		var main = $('#selectedLicences');

		// Now add the onchange.
		main.change(function() {
			var conceptName = main.find(":selected");
			if (conceptName != null && conceptName.length >= 2) {
				$('#submitButton').removeAttr('disabled');
			}
		});

		$('#addToList').click(function() {
			var option = $("input[name='selectedIdentifier']").val();
			var option_name = option.split("||")[0];
			var option_id = option.split("||")[1];
			var list_option = "<option selected='selected' value='"+option_id+"''>"+option_name+"</option>";
			$("#selectedLicences").append(list_option);
			$('#selectedLicences').trigger( "change" );
		});

		$("#addIdentifierSelect").select2({
			width: '100%',
			minimumInputLength: 1,
			ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
				url: "<g:createLink controller='ajax' action='lookup'/>",
				dataType: 'json',
				data: function (term, page) {
					return {
						q: "%" + term + "%", // search term
						page_limit: 10,
						baseClass:'com.k_int.kbplus.OnixplLicense'
					};
				},
				results: function (data, page) {
					return {results: data.values};
				},
			}
		});

		var sName = "sections";
		var hidden_prefix = "tree-hidden-";
		var tree_div = $('.jstree-convert');
		tree_div.jstree({
			'core' : {
				'multiple' : true
			},
			"checkbox" : {
				"keep_selected_style" : false
			},
			"types" : {
				"default" : {
					"valid_children" : ["default"],
					"icon" : "icon-code"
				},
			},
			"state" : {
				"key" : "elcatTree"
			},
			"plugins" : [ "checkbox", "types", "state"]
		});

		var addHiddenField = function (attr, after) {
			//console.log("adding hidden field for: " + attr);
			//console.log(after);
			// Only insert if not already present.
			if ($('hidden#' + attr['id']).length === 0) {
				var field = $("<input type='hidden' />").attr(attr);
				// Append after the div.
				$(after).after(field);
			}
		}

		tree_div.on("select_node.jstree", function (e, data) {
			// Get the jstree instance.
			var jstree = $(this).jstree(true);

			// Build the list of ids that we need to remove.
			var ids = [];

			var actOnChildren = function (children) {
				$.each (children, function (index, child_id) {
					// Add the id of each child and check it's children.
					var child = jstree.get_node(child_id);

					if (child.children.length > 0) {
						// Act on the children of this element too.
						actOnChildren (child.children);
					} else {
						// This is a leaf. Let's add a hidden field.
						addHiddenField ({
							"name"  : sName,
							"value" : child.li_attr['data-value'],
							"id"    : hidden_prefix + child_id
						}, tree_div);
					}
				});
			};

			if (data.node.children.length > 0) {
				// Act on the children of this element too.
				actOnChildren (data.node.children);
			} else {
				// Add a hidden element.
				addHiddenField ({
					"name"  : sName,
					"value" : data.node['li_attr']['data-value'],
					"id"    : hidden_prefix + data.node['id']
				}, tree_div);
			}
		}).on("deselect_node.jstree", function (e, data) {
			// Get the jstreee instance.
			var jstree = $(this).jstree(true);

			// Method to act on the children of this element.
			var actOnChildren = function (children) {
				$.each (children, function (index, child_id) {
					var child = jstree.get_node(child_id);

					// Add the hidden field.
					ids.push ("#" + hidden_prefix + child_id);

					// Act on the children of this element too.
					actOnChildren (child.children);
				});
			};

			// Build the list of ids that we need to remove.
			var ids = ["#" + hidden_prefix + data.node.id];

			// Add the parent ids.
			$.each (data.node.parents, function (i, p) {
				if (p != '#') ids.push("#" + hidden_prefix + p);
			});

			// Act on all children too.
			actOnChildren(data.node.children)

			// Remove all the linked hidden elements.
			$("" + ids).remove();
		});
	});
</script>
