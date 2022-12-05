<g:set var="tip" value="${issueEntitlement.getTIP()}" />
<g:if test="${tip}">
	<g:set var="dateFormatter" value="${new java.text.SimpleDateFormat(session.sessionPreferences?.globalDateFormat)}"/>
	<g:set var="date" value="${date ? dateFormatter.parse(date) : null}"/>
	<g:set var="status" value="${tip.coreStatus(date)}"/>
	<g:set var="coreicon" value="${status?['with-core','Core']:status==null?['not-core','Not Core']:['was-core','Was/Will Be Core']}"/>
	<a class="btn-floating btn-large waves-effect ${coreicon[0]} ${center?'centered':''} mt-20 force-default-pointer"><i></i></a>
	<br/>
	<p class="${center?'center-align':''}">${coreicon[1]}</p>
	<g:if test="${editable}">
		<p class="${center?'center-align':''}"><a href="#kbmodal" ajax-url="${createLink(controller:'ajax', action:'getTipCoreDates', params:[tipID:tip.id, title:issueEntitlement.tipp?.title?.title, theme:theme])}" reload="true" class="modalButton">Edit Core Status</a></p>
	</g:if>
</g:if>
<g:else>
	<p class="${center?'center-align':''}">Content Provider missing. Add one as Org Link of the Package.</p>
</g:else>