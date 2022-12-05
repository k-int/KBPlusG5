<div class="container" data-theme="${theme}">
	<div class="row">
	    <div class="col s12">
	    	<h1 class="form-title flow-text navy-text">Add Organisation Link</h1>
	    	<g:if test="${descText}">
	    		<p class="form-caption flow-text text-grey">${descText}</p>
	    	</g:if>
	    	<div class="row">
	    		<div class="col s12">
				    <g:form name="createOrgRoleLink" id="create_org_role_link" url="[controller:'ajax',action:'addOrgRole']" method="post">
				        <input type="hidden" name="parent" value="${parent}"/>
				        <input type="hidden" name="property" value="${property}"/>
				        <input type="hidden" name="recip_prop" value="${recip_prop}"/>
				        
				        <h3 class="indicator" style="margin-bottom: 30px;">Organisations</h3>
						<div class="row">
							<div class="col s12">
								<div class="tab-table z-depth-1  table-responsive-scroll">
									<table id="org_role_tab" class="highlight bordered">
										<thead>
											<tr id="add_org_head_row">
											</tr>
										</thead>
									</table>
								</div>
							</div>
						</div>
						
						<div class="row top40">
							<div class="input-field col s12">
				                <g:if test="${linkType}">
				                    <g:select name="orm_orgRole"
				                          noSelection="${['':'Select A Role...']}" 
				                          from="${com.k_int.kbplus.RefdataValue.findAllByOwnerAndGroup(com.k_int.kbplus.RefdataCategory.findByDesc('Organisational Role'),linkType)}" 
				                          optionKey="id" 
				                          optionValue="value"
				                          />
				                </g:if>
				                <g:else>
				                    <g:select name="orm_orgRole"
				                          noSelection="${['':'Select A Role...']}"
				                          from="${com.k_int.kbplus.RefdataValue.findAllByOwner(com.k_int.kbplus.RefdataCategory.findByDesc('Organisational Role'))}"
				                          optionKey="id"
				                          optionValue="value"
				                          />
				                </g:else>
				                <label class="active" style="transform: translateY(-40%);">Role</label>
							</div>
						</div>
						
				        <div class="row">
				        	<div class="input-field col s12">
								<button class="btn btn-primary" id="org_role_add_btn" type="submit">Add Organisation <i class="material-icons">add_circle_outline</i></button>
				            </div>
				        </div>
				    </g:form>
		    	</div>
		    </div>
		</div>
	</div>
</div>

<g:render template="/templates/anchorJavascript" model="${['formName': 'createOrgRoleLink']}"/>

<script type="text/javascript">
    var oOrTable;
    $(document).ready(function(){
        $('#add_org_head_row').empty();
        $('#add_org_head_row').append("<td>Org Name</td>");
        $('#add_org_head_row').append("<td>Select</td>");
        oOrTable = $('#org_role_tab').dataTable( {
            'bAutoWidth': true,
            "sScrollY": "200px",
            paging: false,
            "sAjaxSource": "${createLink(controller:'ajax', action:'refdataSearch', id:'ContentProvider', params:[format:'json'])}",
            "bServerSide": true,
            "bProcessing": true,
            "bDestroy":true,
            "bSort":false,
            "sDom": "frtiS",
            "oScroller": {
                "loadingIndicator": false
            },
            "aoColumnDefs": [ {
                    "aTargets": [ 1 ],
                    "mData": "DT_RowId",
                    "mRender": function ( data, type, full ) {
                        return '<input type="checkbox" name="orm_orgoid" id="org.'+data+'" value="'+data+'"/><label for="org.'+data+'"></label>';
                    }
                } ]
        } );
        oOrTable.fnAdjustColumnSizing();
    });
    $('form[name=createOrgRoleLink]').submit(function() {
      var ischecked = $('input[name=orm_orgoid]').is(':checked');
      if (!ischecked) {
        alert("Please select at least one organisation.");
        return false;
      }
      
      if ( $('#orm_orgRole').val() == '' ) {
        // alert('hello "'+ $('#orm_orgRole').val()+'"'); 
        return confirm('No role specified. Are you sure you want to link an Organisation without a role?');
      }
      return true;
    });
</script>