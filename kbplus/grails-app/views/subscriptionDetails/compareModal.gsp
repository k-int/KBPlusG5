<div class="container" data-theme="subscriptions">
  <div class="row">
    <div class="col s12">
      <h1 class="form-title flow-text navy-text">Compare Subscriptions</h1>
      <!--form-->
      <div class="row">
        <g:form class="col s12" action="compare" controller="subscriptionDetails" method="GET" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="col s12">
          <!--row-->
          <div class="row">
            <div class="col s12">
              <h3 class="indicator">Choose Subscription One</h3>
            </div>
          </div>
          
          <!--row-->
          <div class="row">
            <div class="input-field col s12">
                    <input type="hidden" name="subA" id="subSelectA" value="${subA}"/>
                    <label class="active" style="transform: translateY(-200%);">Use '%' as wildcard.</label>
            </div>
          </div>
          <!--end row-->
          
          <!--row-->
          <div class="row ">
            <div class="input-field col s12 m6">
              <g:kbplusDatePicker inputid="dateA" name="dateA" value="${params.dateA}"/>
              <label class="active">Subscriptions on Date (Dates before the subscription start date will use first day of subscription. Dates after end will use the last day)</label>
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
              <h3 class="indicator">Choose Subscription Two</h3>
            </div>
          </div>
          
          <!--row-->
          <div class="row">
            <div class="input-field col s12">
                    <input type="hidden" name="subB" id="subSelectB" value="${subB}" />
                    <label class="active" style="transform: translateY(-200%);">Use '%' as wildcard.</label>
            </div>
          </div>
          <!--end row-->
          
          <!--row-->
          <div class="row ">
            <div class="input-field col s12 m6">
              <g:kbplusDatePicker inputid="dateB" name="dateB" value="${params.dateB}"/>
                <label class="active">Subscriptions on Date (Dates before the subscription start date will use first day of subscription. Dates after end will use the last day)</label>
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

<input type="hidden" name="subInst0" id="${subInsts?.get(0)?.id}" value="${subInsts?.get(0)?.name}" />
<input type="hidden" name="subInst1" id="${subInsts?.get(1)?.id}" value="${subInsts?.get(1)?.name}" />

<script type="text/javascript">
  $(function(){
    var sub0 = $('input[name=subInst0]');
    var sub1 = $('input[name=subInst1]');
    var inst_sc = "${params.dm?'':(params.defaultInstShortcode?:'')}";
      applySelect2("A", sub0.attr('id'), sub0.attr('value'), inst_sc);
    applySelect2("B", sub1.attr('id'), sub1.attr('value'), inst_sc);
  });
</script>
