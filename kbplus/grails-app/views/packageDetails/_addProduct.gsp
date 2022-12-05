<div class="container" data-theme="${theme}">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Add Product</h1>
  			<div class="row">
				<div class="col s12">
					<div class="tab-table z-depth-1  table-responsive-scroll">
						<h3 class="form-title flow-text navy-text">Package Identifiers:</h3><br><br>
						<table class="highlight bordered responsive-table">
		            	    <thead>
								<tr>
									<th data-field="prd">Product Name</th>
									<th data-field="prdId">Product Id</th>
		            	            <th data-field="actions">Actions</th>
								</tr>
							</thead>
							
							<tbody>
								<g:if test="${packageInstance.products}">
									<g:each in="${packageInstance.products}" var="prod">
										<tr>
											<td>${prod.product.name}</td>
											<td>${prod.product.identifier}</td>
											<td>
												<g:link controller="ajax" action="deleteThrough" params='${[contextOid:"${packageInstance.class.name}:${packageInstance.id}",contextProperty:"products",targetOid:"${prod.class.name}:${prod.id}"]}' class="btn-floating table-action"><i class="material-icons">delete_forever</i></g:link>
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
				</div>
			</div>
					
			<div class="row">
				<g:form action="addToPrd" id="${packageInstance.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">
   					<span class="card-title pack-detail">Link this package to a product</span>
   					<div class="card-detail">
      					<div class="col s12 m12 l12 mt-10">
         					<div class="input-field mar-min">
								<g:select name="prdid"
										  id="product"
										  from="${productList}"
										  optionKey="${{it.prd.id}}"
										  optionValue="${{it.prd.name}}"
										  noSelection="['':'Your Products']" />
         					</div>
      					</div>

      					<div class="col s12 m12 l12 mt-20">
      						<input id="add_to_prd" type="submit" class="waves-effect waves-teal btn left mar-search" value="Submit">
      					</div>
   					</div>
   				</g:form>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
  $("[name='add_ident_submit']").submit(function() {
    $.ajax({
      url: "<g:createLink controller='ajax' action='validateIdentifierUniqueness'/>?identifier="+$("input[name='identifier']").val()+"&owner="+"${packageInstance.class.name}:${packageInstance.id}",
      success: function(data) {
        var proceed = false;
        if(data.unique){
          console.log('data unique');
          proceed = true;
        }else if(data.duplicates){
          console.log('data duplicates');
          var warning = "The following Packages are also associated with this identifier:\n";
          for(var ti of data.duplicates){
              warning+= ti.id +":"+ ti.title+"\n";
          }
          var accept = confirm(warning);
          if(accept){
            proceed = true;
          }
        }

        if (proceed) {
            console.log('we are proceeding...');
            $.ajax({
                url: "<g:createLink controller='ajax' action='addToCollection'/>?__context="+$("input[name='__context']").val()+"&__newObjectClass="+$("input[name='__newObjectClass']").val()+"&__recip="+$("input[name='__recip']").val()+"&identifier="+$("input[name='identifier']").val()+"&jsonreturn=true",
                success: function(data) {
                    if (data.confirm) {
                        console.log('confirmed from addToCollection, proceeding to reload modal');
                    	$.ajax({
                        	type: "GET",
                        	url: "<g:createLink controller='packageDetails' action='editPackage' id='${params.id}' params='${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}'/>"
                  	  	}).done(function(data) {
							console.log(data);
                  		  	$('.modal-content').html(data);
                  	  	});
                    }
                }    
        	});
      	}
      }
    });

    //if so we do another ajax call here to addToCollection, and on done reload the modal page for editPackage method

    return false;
  });

  $('a[id=deletePkgIdentifier]').click(function() {
	var ctxOid = $(this).attr('ctxOid');
	var ctxProp = $(this).attr('ctxProp');
	var targetOid = $(this).attr('targetOid');
	console.log('delete through for pkg ids clicked');
	console.log(ctxOid);
	console.log(ctxProp);
	console.log(targetOid);
	
	$.ajax({
	  type: "GET",
	  url: "<g:createLink controller='ajax' action='deleteThrough'/>?contextOid="+ctxOid+"&contextProperty="+ctxProp+"&targetOid="+targetOid+"&jsonreturn=true"
	}).done(function(data) {
		if (data.confirm) {
            console.log('confirmed from deleteThrough, proceeding to reload modal');
        	$.ajax({
            	type: "GET",
            	url: "<g:createLink controller='packageDetails' action='editPackage' id='${params.id}' params='${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}'/>"
      	  	}).done(function(data) {
				console.log(data);
      		  	$('.modal-content').html(data);
      	  	});
        }
	});
  });
  
  $("#addIdentifierSelect").select2({
    placeholder: "Search for an identifier...",
    minimumInputLength: 1,
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
      url: "<g:createLink controller='ajax' action='lookup'/>",
      dataType: 'json',
      data: function (term, page) {
          return {
              q: term, // search term
              page_limit: 10,
              baseClass:'com.k_int.kbplus.Identifier'
          };
      },
      results: function (data, page) {
        return {results: data.values};
      }
    },
    createSearchChoice:function(term, data) {
      return {id:'com.k_int.kbplus.Identifier:__new__:'+term,text:"New - "+term};
    }
  });
</script>