<%@ page import="java.text.SimpleDateFormat"%>
<%
	def dateFormatter = new SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
%>

<div class="container" data-theme="titles">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Editing Title: ${ti.title}</h1>
			<p class="form-caption flow-text grey-text">&nbsp;</p>
			<!--form-->
			<div class="row">
				<g:form name="editTitleForm" controller="titleDetails" action="processEditTitle" params="${params.defaultInstShortcode?[id:params.id,defaultInstShortcode:params.defaultInstShortcode]:[id:params.id]}" class="col s12">
					<div class="row">
						<div class="input-field col s12 m12 l12">
							<input type="text" name="title" id="title" value="${ti.title}" required/>
							<label class="active">Title</label>
						</div>
					</div>

					<div class="row">
						<div class="input-field col s12 m6 l6">
							<g:kbplusDatePicker inputid="pub_from" name="publishedFrom" value="${ti.publishedFrom ? dateFormatter.format(ti.publishedFrom) : null}"/>
							<label class="active">Published From</label>
						</div>
						<div class="input-field col s12 m6 l6">
							<g:kbplusDatePicker inputid="pub_to" name="publishedTo" value="${ti.publishedTo ? dateFormatter.format(ti.publishedTo) : null}"/>
							<label class="active">Published To</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12 m6 l6">
							<input type="text" name="firstAuthor" id="first_author" value="${ti.firstAuthor}"/>
							<label class="active">First Author</label>
						</div>
						<div class="input-field col s12 m6 l6">
							<input type="text" name="publicationType" id="publication_type" value="${ti.publicationType}"/>
							<label class="active">Publication Type</label>
						</div>
					</div>


					<div class="row">
						<div class="input-field col s12 m6 l6">
							<g:kbplusDatePicker inputid="dateMonographPublishedPrint" name="dateMonographPublishedPrint" value="${ti.dateMonographPublishedPrint ? dateFormatter.format(ti.dateMonographPublishedPrint) : null}"/>
							<label class="active">Date Monograph Published Print</label>
						</div>
						<div class="input-field col s12 m6 l6">
							<g:kbplusDatePicker inputid="dateMonographPublishedOnline" name="dateMonographPublishedOnline" value="${ti.dateMonographPublishedOnline ? dateFormatter.format(ti.dateMonographPublishedOnline) : null}"/>
							<label class="active">Date Monograph Published Online</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12 m6 l6">
							<input type="text" name="monographVolume" id="monograph_volume" value="${ti.monographVolume}"/>
							<label class="active">Monograph Volume</label>
						</div>

						<div class="input-field col s12 m6 l6">
							<input type="text" name="monographEdition" id="monograph_edition" value="${ti.monographEdition}"/>
							<label class="active">Monograph Edition</label>
						</div>
					</div>
					
					<div class="row">
						<div class="input-field col s12">
							<input type="text" name="firstEditor" id="first_editor" value="${ti.firstEditor}"/>
							<label class="active">First Editor</label>
						</div>
					</div>

					<div class="row">
						<div class="input-field col s12 mb-30">
							<input type="submit" value="Save Changes" class="waves-effect waves-light btn mb-">
						</div>
					</div>

				</g:form>
				

				<div class="col s12">
					<h3 class="form-title flow-text navy-text mb-20">Title Identifiers:</h3>

					<div class="col s12 tab-table z-depth-1 table-responsive-scroll mb-30">
					<table class="highlight bordered responsive-table">
                    	<thead>
                     		<tr>
                       			<th>Authority</th>
								<th>Identifier</th>
                           		<th>Actions</th>
                         	</tr>
                       	</thead>
                       	<tbody>
                        	<g:each in="${ti.ids}" var="io">
                        		<tr>
                          			<td>${io.identifier.ns.ns}</td>
                           			<td>${io.identifier.value}</td>
                           			<td><a id="deleteTitleIdentifier" href="#!" ctxOid="${ti.class.name}:${ti.id}" ctxProp="ids" targetOid="${io.class.name}:${io.id}" class="btn-floating table-action" style="background-color: transparent !important;"><i class="material-icons">delete</i></a></td>
                        		</tr>
                        	</g:each>
                       	</tbody>
                     </table>
                	</div>
                     <br><br>
					<form class="form-inline" name="add_ident_submit">
                		<p>Select an existing identifier using the typedown, or create a new one by entering namespace:value (EG JC:66454) then clicking that value in the dropdown to confirm.</p>
                		<input type="hidden" name="__context" value="${ti.class.name}:${ti.id}"/>
                		<input type="hidden" name="__newObjectClass" value="com.k_int.kbplus.IdentifierOccurrence"/>
                		<input type="hidden" name="__recip" value="ti"/>
                		<input type="hidden" name="identifier" id="addIdentifierSelect"/>
						<button class="btn btn-primary btn-small mt-30" type="submit" id="addIdentBtn" >Add Identifier <i class="material-icons">add_circle_outline</i></button>
              		</form>
				</div>
			</div>
			<!--form end-->

		</div>
	</div>
</div>

<script type="text/javascript">

  $("[name='add_ident_submit']").submit(function() {
    $.ajax({
      url: "<g:createLink controller='ajax' action='validateIdentifierUniqueness'/>?identifier="+$("input[name='identifier']").val()+"&owner="+"${ti.class.name}:${ti.id}",
      success: function(data) {
        var proceed = false;
        if(data.unique){
          console.log('data unique');
          proceed = true;
          //$("[name='add_ident_submit']").unbind( "submit" )
          //$("[name='add_ident_submit']").submit();
        }else if(data.duplicates){
          console.log('data duplicates');
          var warning = "The following Titles are also associated with this identifier:\n";
          for(var ti of data.duplicates){
              warning+= ti.id +":"+ ti.title+"\n";
          }
          var accept = confirm(warning);
          if(accept){
            proceed = true;
            //$("[name='add_ident_submit']").unbind( "submit" )
            //$("[name='add_ident_submit']").submit();
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
                        	url: "<g:createLink controller='titleDetails' action='editTitle' params='${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode,id:params.id]:[id:params.id]}'/>"
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

    return false;
  });

  $('a[id=deleteTitleIdentifier]').click(function() {
	var ctxOid = $(this).attr('ctxOid');
	var ctxProp = $(this).attr('ctxProp');
	var targetOid = $(this).attr('targetOid');
	console.log('delete through for title ids clicked');
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
            	url: "<g:createLink controller='titleDetails' action='editTitle' params='${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode,id:params.id]:[id:params.id]}'/>"
      	  	}).done(function(data) {
				console.log(data);
      		  	$('.modal-content').html(data);
      	  	});
        }
	});
  });
  
  $("#addIdentifierSelect").select2({
    placeholder: "Search for an identifier...",
    width: "100%",
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

