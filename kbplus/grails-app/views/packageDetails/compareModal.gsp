<div class="container" data-theme="packages">
	<div class="row">
		<div class="col s12">
			<h1 class="form-title flow-text navy-text">Compare Packages</h1>
			<!--form-->
			<div class="row">
				<g:form class="col s12" action="compare" controller="packageDetails" method="GET" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="col s12">
					<!--row-->
					<div class="row">
						<div class="col s12">
							<h3 class="indicator">Choose package one</h3>
						</div>
					</div>



					<!--row-->
					<div class="row">
						<div class="input-field col s12">
							<input type="hidden" name="pkgA" id="packageSelectA" value="${pkgA}"/>
							<label class="active" style="transform: translateY(-200%);">Use '%' as wildcard.</label>
						</div>
					</div>
					<!--end row-->

					<!--row-->
					<div class="row">
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="dateA" name="dateA" value="${params.dateA}"/>
							<label class="active">Package on Date</label>
						</div>
					</div>
					<!--end row-->
					<!--row-->
					<div class="row section">
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="startA" name="startA" value="${params.startA}"/>
							<label class="active">Starting After (not required)</label>
						</div>
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="endA" name="endA" value="${params.endA}"/>
							<label class="active">Ending Before (not required)</label>
						</div>
					</div>
					<!--end row-->

					<!--row-->
					<div class="row">
						<div class="col s12">
							<h3 class="indicator">Choose package two</h3>
						</div>
					</div>



					<!--row-->
					<div class="row">
						<div class="input-field col s12">
							<input type="hidden" name="pkgB" id="packageSelectB" value="${pkgB}" />
							<label class="active" style="transform: translateY(-200%);">Use '%' as wildcard.</label>
						</div>
					</div>
					<!--end row-->

					<!--row-->
					<div class="row">
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="dateB" name="dateB" value="${params.dateB}"/>
							<label class="active">Package on Date</label>
						</div>
					</div>
					<!--end row-->
					<!--row-->
					<div class="row section">
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="startB" name="startB" value="${params.startB}"/>
							<label class="active">Starting After (not required)</label>
						</div>
						<div class="input-field col s12 m6">
							<g:kbplusDatePicker inputid="endB" name="endB" value="${params.endB}"/>
							<label class="active">Ending Before (not required)</label>
						</div>
					</div>
					<!--end row-->

					<div class="row">
						<div class="col s12">
							<h3 class="indicator">Add Filter</h3>
						</div>
					</div>

					<div class="row">
						<div class="col s3">
							<input type="checkbox" name="insrt" id="insrt" value="Y" ${params.insrt=='Y'?'checked':''}/>
							<label for="insrt">Insert</label>
						</div>
						<div class="col s3">
							<input type="checkbox" name="dlt" id="dlt" value="Y" ${params.dlt=='Y'?'checked':''}/>
							<label for="dlt">Delete</label>
						</div>
						<div class="col s3">
							<input type="checkbox" name="updt" id="updt" value="Y" ${params.updt=='Y'?'checked':''}/>
							<label for="updt">Update</label>
						</div>
						<div class="col s3">
							<input type="checkbox" name="nochng" id="nochng" value="Y" ${params.nochng=='Y'?'checked':''}/>
							<label for="nochng">No Change</label>
						</div>
					</div>

					<div class="row last">
						<div class="input-field col s12">
							<input type="submit"class="waves-effect waves-light btn" value="Compare"/>
						</div>
					</div>
				</g:form>
			<!--form end-->
			</div>
			<!--parent row end-->
		</div>
	</div>
</div>

<input type="hidden" name="pkgInst0" id="${pkgInsts?.get(0)?.id}" value="${pkgInsts?.get(0)?.name}" />
<input type="hidden" name="pkgInst1" id="${pkgInsts?.get(1)?.id}" value="${pkgInsts?.get(1)?.name}" />

<script type="text/javascript">
    function applyPackageSelect2(filter, pkgid, pkgvalue) {
        var pkgObj = {id:pkgid,text:pkgvalue};

        $("#packageSelect"+filter).select2({
            width: "100%",
            placeholder: "Type package name...",
            minimumInputLength: 1,
            ajax: {
                url: '<g:createLink controller='ajax' action='lookup'/>',
                dataType: 'json',
                data: function (term, page) {
                    return {
                        hideIdent: 'true',
                        hasDate: 'true',
                        inclPkgStartDate: 'true',
                        startDate: $("#start"+filter).val(),
                        endDate: $("#end"+filter).val(),
                        q: term , // search term
                        page_limit: 10,
                        baseClass:'com.k_int.kbplus.Package'
                    };
                },

                results: function (data, page) {
                    return {results: data.values};
                }
            },
            allowClear: true,
            formatSelection: function(data) {
                return data.text;
            },
            initSelection : function (element, callback) {
                var obj;
                obj = pkgObj;
                callback(obj);
            }
        }).select2('val',':');
    }

    $(function(){
        var pkg0 = $('input[name=pkgInst0]');
        var pkg1 = $('input[name=pkgInst1]');
        applyPackageSelect2("A", pkg0.attr('id'), pkg0.attr('value'));
        applyPackageSelect2("B", pkg1.attr('id'), pkg1.attr('value'));
    });
</script>