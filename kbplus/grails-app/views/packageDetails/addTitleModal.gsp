<div class="container" data-theme="packages">
  <div class="row">
    <div class="col s12">
      <h1 class="form-title flow-text text-navy">Add Title to ${pkg.name}</h1>
      <p class="form-caption flow-text text-grey">Add titles as required and save to update this package</p>
      <!--form-->
      <div class="row">
        <g:form controller="ajax" action="addToCollection" class="col s12">
          <input type="hidden" name="__context" value="${pkg.class.name}:${pkg.id}"/>
          <input type="hidden" name="__newObjectClass" value="com.k_int.kbplus.TitleInstancePackagePlatform"/>
          <input type="hidden" name="__recip" value="pkg"/>
          
          <!-- N.B. this should really be looked up in the controller and set, not hard coded here -->
          <input type="hidden" name="status" value="com.k_int.kbplus.RefdataValue:29"/>
          
          <div class="row">
            <div class="input-field col s12">
              <input type="hidden" name="title" id="titleSelect"/>
              <label class="active" style="transform: translateY(-200%);">Title To Add</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <input type="hidden" name="platform" id="platformSelect"/>
              <label class="active" style="transform: translateY(-200%);">Platform For Added Title</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
                <button class="waves-effect waves-light btn" type="submit" >Add Title <i class="material-icons">add_circle_outline</i></button>
            </div>
          </div>
        </g:form>
      </div>
      <!--form end-->
    </div>
  </div>
</div>

<script type="text/javascript">
	function applyTitleSelect2(inputid, baseClass) {
      $("input[id="+inputid+"]").select2({
      	width: "100%",
        placeholder: "Type name...",
        minimumInputLength: 1,
        ajax: { 
            url: '<g:createLink controller='ajax' action='lookup'/>',
            dataType: 'json',
            data: function (term, page) {
                return {
                	hideIdent: 'true',
                    q: term , // search term
                    page_limit: 10,
                    baseClass:baseClass
                };
            },
            
            results: function (data, page) {
                return {results: data.values};
            }
        },
	    allowClear: true,
         formatSelection: function(data) { 
            return data.text; 
        }
      });
    }
	
	$(function(){
    	applyTitleSelect2("titleSelect", 'com.k_int.kbplus.TitleInstance');
		applyTitleSelect2("platformSelect", 'com.k_int.kbplus.Platform');
	});
</script>