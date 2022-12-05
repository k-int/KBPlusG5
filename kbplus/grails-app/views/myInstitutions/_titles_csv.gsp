<g:set var="cfg" value="${[[col:'Title_ID', value:{e, ctx -> e.tipp?.title?.id } ],
						   [col:'Title', value:{e, ctx -> raw(e.tipp?.title?.title) } ],
						   [col:'jusp', value:{ e, ctx -> e.tipp?.title?.getIdentifierValue('jusp') } ],
                           [col:'issn', value:{e, ctx -> e.tipp?.title?.getIssn() } ],
                           [col:'eissn', value:{ e, ctx -> e.tipp?.title?.getEissn() } ],
						   [col:'doi', value:{ e, ctx -> e.tipp?.title?.getIdentifierValue('doi') } ],
						   [col:'kbart_title_id', value:{ e, ctx -> e.tipp?.title?.getIdentifierValue('kbart_title_id') } ],
						   [col:'zdb', value:{ e, ctx -> e.tipp?.title?.getIdentifierValue('zdb') } ],
						   [col:'proquest', value:{ e, ctx -> e.tipp?.title?.getIdentifierValue('proquest') } ],
						   [col:'ebsco_title_id', value:{ e, ctx -> e.tipp?.title?.getIdentifierValue('ebsco_title_id') } ],
						   [col:'rcn', value:{ e, ctx -> e.tipp?.title?.getIdentifierValue('rcn') } ],
						   [col:'IE_ID', value:{e, ctx -> e.id } ],
						   [col:'IE_SubscriptionName', value:{e, ctx -> raw(e.subscription.name) }],
                           [col:'IE_StartDate', value:{e, ctx -> e.startDate?formatter.format(e.startDate):'' }],
                           [col:'IE_StartVolume', value:{e, ctx -> e.startVolume }],
                           [col:'IE_StartIssue', value:{e, ctx -> e.startIssue } ],
                           [col:'IE_EndDate', value:{e, ctx -> e.endDate?formatter.format(e.endDate):'' } ],
                           [col:'IE_EndVolume', value: {e, ctx -> e.endVolume }],
                           [col:'IE_EndIssue', value:{e, ctx -> e.endIssue }],
						   [col:'IE_Embargo', value:{e, ctx -> e.embargo }],
                           [col:'IE_Coverage', value:{e, ctx -> e.coverageDepth }],
                           [col:'IE_CoverageNote', value:{e, ctx -> raw(e.coverageNote) }],
						   [col:'IE_platformHostName', value:{e, ctx -> raw(e.tipp?.platform?.name) }],
						   [col:'IE_PlatformHostUrl', value:{e, ctx -> raw(e.tipp?.platform?.primaryUrl) }],
						   [col:'platform.administrative.name', value:{e, ctx -> raw(e.tipp?.getHostPlatform()?.name) }],
						   [col:'platform.administrative.url', value:{e, ctx -> raw(e.tipp?.getCombinedPlatformUrl()) }],
						   [col:'IE_CoreDateList', value:{e, ctx -> e.getTIP()?.getTextSummary() }],
						   [col:'IE_CoreMedium', value:{e, ctx -> e.coreStatus }]
                           ]}"/><g:set var="tabchar" value=","
/><g:set var="formatter" value="${new java.text.SimpleDateFormat('yyyy-MM-dd')}"
/><g:encodeAs codec="Raw"><g:each in="${cfg}" var="r">"${r.col}"${tabchar}</g:each>
<g:each in="${entitlements}" var="entitlement"
><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">"${r.value.call(entitlement, ctx)}"${tabchar}</g:if
><g:else>"${r.value}"${tabchar}</g:else></g:each>
</g:each></g:encodeAs>