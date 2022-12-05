<%@ page import="java.text.SimpleDateFormat"%>
<%
	def dateFormatter = new SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
%>

<div class="container" data-theme="home">
  <div class="row">
    <div class="col s12">
      <h1 class="form-title flow-text text-navy">Editing TIPP For: ${titleInstanceInstance?.title}, In Package: ${tipp.pkg.name}, On Platform: ${tipp.platform.name}</h1>
      <p class="form-caption flow-text text-grey">Please update any information below and save to update.</p>
      <!--form-->
      <div class="row">
        <g:form controller="tipp" action="processEdit" id="${tipp.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}" class="col s12">
          <div class="row">
            <div class="input-field col s6">
              <g:kbplusDatePicker inputid="accessStartDate" name="accessStartDate" value="${tipp.accessStartDate ? dateFormatter.format(tipp.accessStartDate) : null}"/>
              <label class="active">Access Start Date (Enters Package)</label>
            </div>
            <div class="input-field col s6">
              <g:kbplusDatePicker inputid="accessEndDate" name="accessEndDate" value="${tipp.accessEndDate ? dateFormatter.format(tipp.accessEndDate) : null}"/>
              <label class="active">Access End Date (Leaves Package)</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <g:kbplusDatePicker inputid="startDate" name="startDate" value="${tipp.startDate ? dateFormatter.format(tipp.startDate) : null}"/>
              <label class="active">TIPP Start Date</label>
            </div>
            <div class="input-field col s6">
              <g:kbplusDatePicker inputid="endDate" name="endDate" value="${tipp.endDate ? dateFormatter.format(tipp.endDate) : null}"/>
              <label class="active">TIPP End Date</label>
            </div>           
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <input name="startVolume" id="startVolume" value="${tipp?.startVolume}" type="text" class="validate">
              <label class="active">TIPP Start Volume</label>
            </div>
            <div class="input-field col s6">
              <input name="endVolume" id="endVolume" value="${tipp?.endVolume}" type="text" class="validate">
              <label class="active">TIPP End Volume</label>
            </div>
            
          </div>

          <div class="row">
            <div class="input-field col s6">
              <input name="startIssue" id="startIssue" value="${tipp?.startIssue}" type="text" class="validate">
              <label class="active">TIPP Start Issue</label>
            </div>
            <div class="input-field col s6">
              <input name="endIssue" id="endIssue" value="${tipp?.endIssue}" type="text" class="validate">
              <label class="active">TIPP End Issue</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <input name="coverageDepth" id="coverageDepth" value="${tipp?.coverageDepth}" type="text" class="validate">
              <label class="active">Coverage Depth</label>
            </div>
            <div class="input-field col s6">
              <input name="embargo" id="embargo" value="${tipp?.embargo}" type="text" class="validate">
              <label class="active">Embargo</label>
            </div>
          </div>
          
          
          
          <div class="row">
            <div class="input-field col s6">
              <input name="hostPlatformURL" id="hostPlatformURL" value="${tipp?.hostPlatformURL}" type="text" class="validate">
              <label class="active">Host URL</label>
            </div>
            <div class="input-field col s6">
              <g:select name="status"
                        id="status"
                        from="${tippStatusList}"
                        optionKey="id"
                        optionValue="value"
                        value="${tipp?.status?.id}"
                        noSelection="['':'']"
                        />
              <label>Status</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <g:select name="statusReason"
                        id="statusReason"
                        from="${tippStatusReasonList}"
                        optionKey="id"
                        optionValue="value"
                        value="${tipp?.statusReason?.id}"
                        noSelection="['':'']"
                        />
              <label>Status Reason</label>
            </div>
            <div class="input-field col s6">
              <g:select name="delayedOA"
                        id="delayedOA"
                        from="${delayedList}"
                        optionKey="id"
                        optionValue="value"
                        value="${tipp?.delayedOA?.id}"
                        noSelection="['':'']"
                        />
              <label>Delayed OA</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <g:select name="hybridOA"
                        id="hybridOA"
                        from="${hybridList}"
                        optionKey="id"
                        optionValue="value"
                        value="${tipp?.hybridOA?.id}"
                        noSelection="['':'']"
                        />
              <label>Hybrid OA</label>
            </div>
            <div class="input-field col s6">
              <g:select name="payment"
                        id="payment"
                        from="${paymentList}"
                        optionKey="id"
                        optionValue="value"
                        value="${tipp?.payment?.id}"
                        noSelection="['':'']"
                        />
              <label>Payment</label>
            </div>
          </div>

          <div class="row">
            <div class="input-field col s12">
              <textarea name="coverageNote" class="materialize-textarea">${tipp.coverageNote}</textarea>
              <label class="active">Coverage Note</label>
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
