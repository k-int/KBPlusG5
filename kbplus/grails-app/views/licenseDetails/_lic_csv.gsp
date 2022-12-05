<g:set var="cfg" value="${[[col:'KB+ Licence ID', value:{l, ctx -> l.id } ],
                           [col:'LicenceReference', value:{l, ctx -> raw(l.reference) } ],
                           [col:'NoticePeriod', value:{ l, ctx -> l.noticePeriod } ],
                           [col:'LicenceURL', value:{l, ctx -> raw(l.licenseUrl) }],
                           [col:'LicensorRef', value:{l, ctx -> raw(l.licensorRef) }],
                           [col:'LicenseeRef', value:{l, ctx -> raw(l.licenseeRef) }],
                           [col:'StartDate', value:{l, ctx -> l.startDate?formatter.format(l.startDate):'' } ],
                           [col:'EndDate', value: {l, ctx -> l.endDate?formatter.format(l.endDate):'' }],
                           [col:'Licence Category', value:{l, ctx -> l.licenseCategory?.value }],
						   [col:'Licence Status', value:{l, ctx -> l.status?.value } ]
                           ]}"
/><g:set var="cgg" value="${[[col:'Custom Property Value',value:{l, p -> if(l.customProperties.find{it.type.name == p}) l.customProperties.find{it.type.name == p}.value}],
						   [col:'Custom Property Note', value:{l, p -> if(l.customProperties.find{it.type.name == p}) raw(l.customProperties.find{it.type.name == p}.note?.replaceAll('"','\''))}]
                           ]}"/><g:set var="tabchar" value=","
/><g:set var="formatter" value="${new java.text.SimpleDateFormat('yyyy-MM-dd')}"
/><g:encodeAs codec="Raw"><g:each in="${cfg}" var="r">"${r.col}"${tabchar}</g:each><g:each in="${propSet}" var="s">"${s}"${tabchar}"${s + ' Notes' }"${tabchar}</g:each>
<g:set value="${license}" var="license"
/><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">"${r.value.call(license, ctx)}"${tabchar}</g:if
><g:else>"${r.value}"${tabchar}</g:else></g:each
><g:each in="${propSet}" var="custProp"
><g:each in="${cgg}" var="s"><g:if test="${s.value instanceof groovy.lang.Closure}">"${s.value?.call(license, custProp)}"${tabchar}</g:if
><g:else>"${s.value}"${tabchar}</g:else></g:each></g:each>
</g:encodeAs>