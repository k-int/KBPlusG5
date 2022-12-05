<g:set var="cfg" value="${[[col:'licence_id', value:{l, ctx -> l.id } ],
                           [col:'licence_ref', value:{l, ctx -> raw(l.reference) } ],
                           ]}"
/><g:set var="cgg" value="${[[col:'subscription_id', value:{ s, ctx -> s.id } ],
                           [col:'subscription_name', value:{s, ctx -> raw(s.name) }],
                           [col:'subscription_start_date', value:{s, ctx -> s.startDate?formatter.format(s.startDate):'' }],
                           [col:'subscription_end_date', value:{s, ctx -> s.endDate?formatter.format(s.endDate):'' } ],
                           [col:'subscription_renewal_date', value:{s, ctx -> s.manualRenewalDate?formatter.format(s.manualRenewalDate):''  } ],
                           ]}"
/><g:set var="chg" value="${[[col:'package_id', value: {p, ctx -> p?.pkg?.id }],
                           [col:'package_name', value:{p, ctx -> raw(p?.pkg?.name) }],
						   [col:'package_provider', value:{p, ctx -> raw(p?.pkg?.getContentProvider()?.name) } ]
                           ]}"/><g:set var="tabchar" value=","
/><g:set var="formatter" value="${new java.text.SimpleDateFormat('yyyy-MM-dd')}"
/><g:encodeAs codec="Raw"><g:each in="${cfg}" var="a">"${a.col}"${tabchar}</g:each><g:each in="${cgg}" var="b">"${b.col}"${tabchar}</g:each><g:each in="${chg}" var="c">"${c.col}"${tabchar}</g:each>
<g:set value="${license}" var="license"
/><g:each in="${license.subscriptions}" var="sub"
><g:if test="${sub.packages}"><g:each in="${sub.packages}" var="subPkg"
><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">"${r.value.call(license, ctx)}"${tabchar}</g:if
><g:else>"${r.value}"${tabchar}</g:else></g:each
><g:each in="${cgg}" var="s"><g:if test="${s.value instanceof groovy.lang.Closure}">"${s.value.call(sub, ctx)}"${tabchar}</g:if
><g:else>"${s.value}"${tabchar}</g:else></g:each
><g:each in="${chg}" var="t"><g:if test="${t.value instanceof groovy.lang.Closure}">"${t.value.call(subPkg, ctx)}"${tabchar}</g:if
><g:else>"${t.value}"${tabchar}</g:else></g:each></g:each>
</g:if><g:else
><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">"${r.value.call(license, ctx)}"${tabchar}</g:if
><g:else>"${r.value}"${tabchar}</g:else></g:each
><g:each in="${cgg}" var="s"><g:if test="${s.value instanceof groovy.lang.Closure}">"${s.value.call(sub, ctx)}"${tabchar}</g:if
><g:else>"${s.value}"${tabchar}</g:else></g:each>
</g:else></g:each>
</g:encodeAs>