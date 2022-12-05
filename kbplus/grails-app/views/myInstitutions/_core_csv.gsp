<g:set var="cfg" value="${[[col:'Title', value:{t, ctx -> raw(t.title?.title) } ],
                           [col:'ID.issn', value:{t, ctx -> t.title?.getIssn() } ],
                           [col:'ID.eissn', value:{ t, ctx -> t.title?.getEissn() } ],
						   [col:'ID.jusp', value:{t, ctx -> t.title?.getIdentifierValue('jusp') } ],
						   [col:'ID.doi', value:{ t, ctx -> t.title?.getIdentifierValue('doi') } ],
						   [col:'ID.kbart_title_id', value:{t, ctx -> t.title?.getIdentifierValue('kbart_title_id') } ],
						   [col:'Provider Name', value:{t, ctx -> raw(t.provider?.name) }],
						   [col:'Core Date List', value:{t, ctx -> t.coreDates }],
						   [col:'Core Status', value:{t, ctx -> t.coreStatus(null)?'Core':t.coreStatus(null)==null?'Not Core':'Was/Will Be Core' }]
                           ]}"/><g:set var="tabchar" value=","
/><g:encodeAs codec="Raw"><g:each in="${cfg}" var="r">"${r.col}"${tabchar}</g:each>
<g:each in="${exportTips}" var="tip"
><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">"${r.value.call(tip, ctx)}"${tabchar}</g:if
><g:else>"${r.value}"${tabchar}</g:else></g:each>
</g:each></g:encodeAs>
