<g:set var="cfg" value="${[[col:'Title', value:{e, ctx -> raw(e.tipp.title.title) } ],
                           [col:'ISSN/ISBN', value:{e, ctx -> e.tipp.title.getIssn()?:e.tipp.title.getEissn()?:e.tipp.title.getIsbn() } ],
                           [col:'Type', value:'Journal' ],
                           [col:'Status', value:{e, ctx -> 'Subscribed' }],
                           [col:'Default Dates', value:''],
                           [col:'Custom Date From', value:{e, ctx -> e.startDate?formatter.format(e.startDate):'' } ],
                           [col:'Custom Date To', value:{e, ctx -> e.endDate?formatter.format(e.endDate):'' } ],
                           [col:'Title Id', value:''],
                           [col:'Publication date', value:''],
                           [col:'Edition', value:''],
                           [col:'Publisher', value:''],
                           [col:'Public Note', value:'' ],
                           [col:'Display Public Note', value:''],
                           [col:'Location Note', value:''],
                           [col:'Display Location Note', value:''],
                           [col:'Default URL', value:''],
                           [col:'Custom URL', value:'']
                           ]}"/><g:set var="tabchar" value="\t"
/><g:set var="formatter" value="${new java.text.SimpleDateFormat('MM/dd/yyyy')}"
/><g:encodeAs codec="Raw"><g:each in="${cfg}" var="r">"${r.col}"${tabchar}</g:each>
<g:each in="${entitlements}" var="entitlement"
><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">"${r.value.call(entitlement, ctx)}"${tabchar}</g:if
><g:else>"${r.value}"${tabchar}</g:else></g:each>
</g:each></g:encodeAs>


	
	
	
	
	
	
	
	
 
	
	
	
	

