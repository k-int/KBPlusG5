<div class="container" data-theme="titles">
  <div class="row">
    <div class="col s12">
      <h1 class="form-title flow-text navy-text">Add Usage Information</h1>
      <p class="form-caption flow-text grey-text">Subline here if required</p>
      <!--form-->
      <div class="row">
        <g:form controller="myInstitutions" action="processAddJUSPUsage" params="${[defaultInstShortcode:params.defaultInstShortcode]}" id="${tip.id}" class="col s12">
          <div class="row">
            <div class="input-field col s12 m6">
              <g:kbplusDatePicker inputid="usageDate" name="usageDate" value="" required="${true}"/>
              <label class="active">Usage Date</label>
            </div>
            
            <div class="input-field col s6">
              <input type="text" name="usageValue" required/>
              <label class="active">Usage Record</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <g:select name="factType"
                        from="${com.k_int.kbplus.RefdataValue.executeQuery('select o from RefdataValue as o where o.owner.desc=?',['FactType'])}"
                        optionKey="id"
                        optionValue="value"
                        />
              <label>Usage Type</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <input type="submit" class="waves-effect waves-light btn" value="Submit">
            </div>
          </div>
        </g:form>
      </div>
      <!--form end-->
    </div>
  </div>
 </div>
 