<g:set var="cfg" value="${[[col:'SubscriptionID', value:{s, ctx -> s.id } ],
						   [col:'SubscriptionName', value:{s, ctx -> raw(s.name) } ]
                           ]}"/><g:set var="tabchar" value="\t"/><g:set var="ctx" value="${[testvar:'hello']}"
/><g:set var="cgg" value="${[[col:'publication_title', value:{e, ctx -> raw(e.tipp?.title?.title) } ],
                           [col:'ID.issn', value:{e, ctx -> e.tipp?.title?.getIssn() } ],
                           [col:'ID.eissn', value:{ e, ctx -> e.tipp?.title?.getEissn() } ],
                           [col:'date_first_issue_online', value:{e, ctx -> e.startDate?formatter.format(e.startDate):'' }],
                           [col:'num_first_vol_online', value:{e, ctx -> e.startVolume }],
                           [col:'num_first_issue_online', value:{e, ctx -> e.startIssue } ],
                           [col:'date_last_issue_online', value:{e, ctx -> e.endDate?formatter.format(e.endDate):'' } ],
                           [col:'num_last_vol_online', value: {e, ctx -> e.endVolume }],
                           [col:'num_last_issue_online', value:{e, ctx -> e.endIssue }],
						   [col:'ID.kbart_title_id', value:{e, ctx -> e.tipp?.title?.getIdentifierValue('kbart_title_id') } ],
						   [col:'embargo_info', value:{e, ctx -> e.embargo }],
                           [col:'coverage_depth', value:{e, ctx -> e.coverageDepth }],
                           [col:'coverage_notes', value:{e, ctx -> raw(e.coverageNote) }],
                           [col:'publisher_name', value:{e, ctx -> raw(e.tipp?.title?.publisher?.name) }],
						   [col:'ID.doi', value:{e, ctx -> e.tipp?.title?.getDoi() } ],
						   [col:'ID.isbn', value:{e, ctx -> e.tipp?.title?.getIsbn() } ],
						   [col:'platform.host.name', value:{e, ctx -> raw(e.tipp?.platform?.name) }],
						   [col:'platform.host.url', value:{e, ctx -> raw(e.tipp?.platform?.primaryUrl) }],
						   [col:'platform.administrative.name', value:{e, ctx -> raw(e.tipp?.getHostPlatform()?.name) }],
						   [col:'platform.administrative.url', value:{e, ctx -> raw(e.tipp?.getCombinedPlatformUrl()) }],
						   [col:'access_start_date', value:{e, ctx -> e.accessStartDate?formatter.format(e.accessStartDate):'' }],
						   [col:'access_end_date', value:{e, ctx -> e.accessEndDate?formatter.format(e.accessEndDate):'' }],
						   [col:'access_status', value:{e, ctx -> e.tipp?.getAvailabilityStatusAsString() }],
                           ]}"/><g:set var="tabchar" value=","
/><g:set var="formatter" value="${new java.text.SimpleDateFormat('yyyy-MM-dd')}"
/><g:encodeAs codec="Raw"><g:each in="${cfg}" var="a">"${a.col}"${tabchar}</g:each><g:each in="${cgg}" var="b">"${b.col}"${tabchar}</g:each>
<g:each in="${subscriptions}" var="subscription"
><g:each in="${subscription.issueEntitlements}" var="ies"
><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">"${r.value.call(subscription, ctx)}"${tabchar}</g:if
><g:else>"${r.value}"${tabchar}</g:else></g:each
><g:each in="${cgg}" var="s"><g:if test="${s.value instanceof groovy.lang.Closure}">"${s.value.call(ies, ctx)}"${tabchar}</g:if
><g:else>"${s.value}"${tabchar}</g:else></g:each>
</g:each></g:each></g:encodeAs>