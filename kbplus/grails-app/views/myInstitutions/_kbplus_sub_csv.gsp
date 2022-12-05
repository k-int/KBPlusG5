<g:set var="cfg" value="${[[col:'SubscriptionID', value:{s, ctx -> s.id } ],
						   [col:'SubscriptionName', value:{s, ctx -> raw(s.name) } ],
                           [col:'SubTermStartDate', value:{s, ctx -> s.startDate?formatter.format(s.startDate):'' } ],
                           [col:'SubTermEndDate', value:{ s, ctx -> s.endDate?formatter.format(s.endDate):'' } ],
                           [col:'AssociatedLicence', value:{s, ctx -> raw(s.owner?.reference) }]
                           ]}"/><g:set var="tabchar" value=","
/><g:set var="formatter" value="${new java.text.SimpleDateFormat('yyyy-MM-dd')}"
/><g:encodeAs codec="Raw"><g:each in="${cfg}" var="r">"${r.col}"${tabchar}</g:each>
<g:each in="${subscriptions}" var="subscription"
><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">"${r.value.call(subscription, ctx)}"${tabchar}</g:if
><g:else>"${r.value}"${tabchar}</g:else></g:each>
</g:each></g:encodeAs>