<g:set var="cfg" value="${[[col:'publication_title', value:{e, ctx -> raw(e.tipp.title.title) } ],
                           [col:'print_identifier', value:{e, ctx -> e.tipp.title.getIssn() ?: e.tipp.title.getIsbn() } ],
                           [col:'online_identifier', value:{ e, ctx -> e.tipp.title.getEissn()?: e.tipp.title.getIdentifierValue('eisbn') } ],
                           [col:'date_first_issue_online', value:{e, ctx -> e.startDate?formatter.format(e.startDate):'' }],
                           [col:'num_first_vol_online', value:{e, ctx -> e.startVolume }],
                           [col:'num_first_issue_online', value:{e, ctx -> e.startIssue } ],
                           [col:'date_last_issue_online', value:{e, ctx -> e.endDate?formatter.format(e.endDate):'' } ],
                           [col:'num_last_vol_online', value: {e, ctx -> e.endVolume }],
                           [col:'num_last_issue_online', value:{e, ctx -> e.endIssue }],
                           [col:'title_url', value:{e, ctx -> raw(e.tipp.getCombinedPlatformUrl()) }],
                           [col:'first_author', value:''],
                           [col:'title_id', value:{e, ctx -> e.tipp.title.getIdentifierValue('kbart_title_id') } ],
                           [col:'coverage_depth', value:{e, ctx -> e.coverageDepth }],
                           [col:'coverage_notes', value:{e, ctx -> raw(e.coverageNote) }],
                           [col:'publisher_name', value:''],
                           [col:'location', value:''],
                           [col:'title_notes', value:{e, ctx -> raw(e.coverageNote) }],
                           [col:'oclc_collection_name', value:''],
                           [col:'oclc_collection_id', value:''],
                           [col:'oclc_entry_id', value:''],
                           [col:'oclc_linkscheme', value:''],
                           [col:'oclc_number', value:''],
                           [col:'ACTION', value:'raw']
                           ]}"/><g:set var="tabchar" value="\t"
/><g:set var="formatter" value="${new java.text.SimpleDateFormat('yyyy-MM-dd')}"
/><g:encodeAs codec="Raw"><g:each in="${cfg}" var="r">"${r.col}"${tabchar}</g:each>
<g:each in="${entitlements}" var="entitlement"
><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">"${r.value.call(entitlement, ctx)}"${tabchar}</g:if
><g:else>"${r.value}"${tabchar}</g:else></g:each>
</g:each></g:encodeAs>