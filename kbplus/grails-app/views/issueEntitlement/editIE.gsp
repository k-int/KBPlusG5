<g:set var="dateFormatter" value="${new java.text.SimpleDateFormat(session.sessionPreferences?.globalDateFormat)}"/>
<div class="container" data-theme="subscriptions">
  <div class="row">
    <div class="col s12">
      <h1 class="form-title flow-text text-navy">Edit Issue Entitlement for ${issueEntitlement?.tipp.title.title} via Subscription: ${issueEntitlement.subscription.name}</h1>
      <p class="form-caption flow-text text-grey">Please update any information below and save to update.</p>
      <!--form-->
      <div class="row">
        <g:form controller="issueEntitlement" action="processEditIE" id="${issueEntitlement.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="col s12">
          <div class="row">
            <div class="input-field col s6">
              <g:kbplusDatePicker inputid="acc_start_date" name="accessStartDate" value="${issueEntitlement.accessStartDate?dateFormatter.format(issueEntitlement.accessStartDate):''}"/>
              <label class="active">Access Start Date</label>
            </div>
            <div class="input-field col s6">
              <g:kbplusDatePicker inputid="acc_end_date" name="accessEndDate" value="${issueEntitlement.accessEndDate?dateFormatter.format(issueEntitlement.accessEndDate):''}"/>
              <label class="active">Access End Date</label>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s4">
              <g:kbplusDatePicker inputid="from_date" name="startDate" value="${issueEntitlement.startDate?dateFormatter.format(issueEntitlement.startDate):''}"/>
              <label class="active">From Date</label>
            </div>
            <div class="input-field col s4">
              <input id="from_volume" name="startVolume" type="text" value="${issueEntitlement.startVolume}">
              <label for="from_volume" class="active">From Volume</label>
            </div>
            <div class="input-field col s4">
              <input id="from_issue" name="startIssue" type="text" value="${issueEntitlement.startIssue}">
              <label for="from_issue" class="active">From Issue</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s4">
              <g:kbplusDatePicker inputid="to_date" name="endDate" value="${issueEntitlement.endDate?dateFormatter.format(issueEntitlement.endDate):''}"/>
              <label class="active">To Date</label>
            </div>
            <div class="input-field col s4">
              <input id="to_volume" name="endVolume" type="text" value="${issueEntitlement.endVolume}">
              <label for="to_volume" class="active">To Volume</label>
            </div>
            <div class="input-field col s4">
              <input id="to_issue" name="endIssue" type="text" value="${issueEntitlement.endIssue}">
              <label for="to_issue" class="active">To Issue</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <select name="iemedium" id="iemedium">
                <option value="" selected>Select one</option>
                <g:each in="${iemedium}" var="m">
                  <option value="${m.class.name}:${m.id}" ${issueEntitlement?.medium?.id && issueEntitlement?.medium?.id == m.id?'selected':''}>${m.value}</option>
                </g:each>
              </select>
              <label>Core Medium</label>
            </div>
          </div>

          <div class="row">
            <div class="input-field col s12">
              <select name="coreStatus" id="coreStatus">
                <option value="" selected>Select one</option>
                <g:each in="${corestatus}" var="cs">
                  <option value="${cs.class.name}:${cs.id}" ${issueEntitlement?.coreStatus?.id && issueEntitlement?.coreStatus?.id == cs.id?'selected':''}>${cs.value}</option>
                </g:each>
              </select>
              <label>Entitlement Medium</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <input id="embargo" name="embargo" type="text" value="${issueEntitlement.embargo}" class="validate">
              <label for="embargo" class="active">Embargo</label>
            </div>
            <div class="input-field col s6">
              <input id="coverage_depth" name="coverageDepth" type="text" value="${issueEntitlement.coverageDepth}" class="validate">
              <label for="coverage_depth" class="active">Coverage Depth</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <textarea id="coverage_note" name="coverageNote" class="materialize-textarea">${issueEntitlement.coverageNote}</textarea>
              <label for="coverage_note" class="active">Coverage Note</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <input type="submit" class="waves-effect waves-light btn" value="Update">
            </div>
          </div>
        </g:form>
      </div>
      <!--form end-->
    </div>
  </div>
</div>
