<g:set var="cfg" value="${[[col:'publication_title', value:{e, ctx -> raw(e.title?.title) } ],
                           [col:'ID.issn', value:{e, ctx -> e.title?.getIssn() } ],
                           [col:'ID.eissn', value:{ e, ctx -> e.title?.getEissn() } ],
                           [col:'date_first_issue_online', value:{e, ctx -> e.startDate?formatter.format(e.startDate):'' }],
                           [col:'num_first_vol_online', value:{e, ctx -> e.startVolume }],
                           [col:'num_first_issue_online', value:{e, ctx -> e.startIssue } ],
                           [col:'date_last_issue_online', value:{e, ctx -> e.endDate?formatter.format(e.endDate):'' } ],
                           [col:'num_last_vol_online', value: {e, ctx -> e.endVolume }],
                           [col:'num_last_issue_online', value:{e, ctx -> e.endIssue }],
						   [col:'ID.kbart_title_id', value:{e, ctx -> e.title?.getIdentifierValue('kbart_title_id') } ],
						   [col:'embargo_info', value:{e, ctx -> e.embargo }],
                           [col:'coverage_depth', value:{e, ctx -> e.coverageDepth }],
                           [col:'coverage_notes', value:{e, ctx -> raw(e.coverageNote) }],
                           [col:'publisher_name', value:{e, ctx -> raw(e.title?.publisher?.name) }],
						   [col:'ID.doi', value:{e, ctx -> e.title?.getDoi() } ],
						   [col:'ID.isbn', value:{e, ctx -> e.title?.getIsbn() } ],
						   [col:'platform.host.name', value:{e, ctx -> raw(e.platform?.name) }],
						   [col:'platform.host.url', value:{e, ctx -> raw(e.getCombinedPlatformUrl()) }],
						   [col:'platform.administrative.name', value:{e, ctx -> raw(e.getHostPlatform()?.name) }],
						   [col:'platform.administrative.url', value:{e, ctx -> raw(e.platform?.primaryUrl) }],
						   [col:'hybrid_oa', value:{e, ctx -> e.hybridOA }],
						   [col:'access_start_date', value:{e, ctx -> e.accessStartDate?formatter.format(e.accessStartDate):'' }],
						   [col:'access_end_date', value:{e, ctx -> e.accessEndDate?formatter.format(e.accessEndDate):'' }],
						   [col:'access_status', value:{e, ctx -> e.getAvailabilityStatusAsString() }],
						   [col:'tipp.status', value:{e, ctx -> e.status }],
						   [col:'publication_type', value:{e, ctx -> e.title?.publicationType }],
                           ]}"/><g:set var="tabchar" value=","
/><g:set var="formatter" value="${new java.text.SimpleDateFormat('yyyy-MM-dd')}"
/><g:encodeAs codec="Raw">Provider${tabchar}${packageInstance.getContentProvider()?.name }
Package Identifier${tabchar}${packageInstance.id }
Package Name${tabchar}${packageInstance.name }
Agreement Term Start Year${tabchar}${packageInstance.startDate?formatter.format(packageInstance.startDate):'' }
Agreement Term End Year${tabchar}${packageInstance.endDate?formatter.format(packageInstance.endDate):'' }
Consortium<g:each in="${packageInstance.getConsortia()}" var="consortium">${tabchar}${consortium}</g:each>
<g:each in="${cfg}" var="r">"${r.col}"${tabchar}</g:each>
<g:each in="${titlesList}" var="tipp"
><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">"${r.value.call(tipp, ctx)}"${tabchar}</g:if
><g:else>"${r.value}"${tabchar}</g:else></g:each>
</g:each>
<g:if test="${expectedTitles.size() > 0}">Expected Titles
<g:each in="${cfg}" var="r">"${r.col}"${tabchar}</g:each>
<g:each in="${expectedTitles}" var="expectedTitle"
><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">"${r.value.call(expectedTitle, ctx)}"${tabchar}</g:if
><g:else>"${r.value}"${tabchar}</g:else></g:each>
</g:each>
</g:if><g:if test="${previousTitles.size() > 0}">Previous Titles
<g:each in="${cfg}" var="r">"${r.col}"${tabchar}</g:each>
<g:each in="${previousTitles}" var="previousTitle"
><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">"${r.value.call(previousTitle, ctx)}"${tabchar}</g:if
><g:else>"${r.value}"${tabchar}</g:else></g:each>
</g:each></g:if></g:encodeAs>