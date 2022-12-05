<g:set var="cfg" value="${[[col:'KB+ Licence ID', value:{l, ctx -> l.id } ],
                           [col:'LicenceReference', value:{l, ctx -> raw(l.reference) } ],
                           [col:'NoticePeriod', value:{ l, ctx -> l.noticePeriod } ],
                           [col:'LicenceURL', value:{l, ctx -> raw(l.licenseUrl) }],
                           [col:'LicensorRef', value:{l, ctx -> l.licensorRef }],
                           [col:'LicenseeRef', value:{l, ctx -> l.licenseeRef } ],
                           [col:'StartDate', value:{l, ctx -> l.startDate?formatter.format(l.startDate):'' } ],
                           [col:'EndDate', value: {l, ctx -> l.endDate?formatter.format(l.endDate):'' }],
                           [col:'Licence Category', value:{l, ctx -> l.licenseCategory?.value }],
						   [col:'Licence Status', value:{l, ctx -> l.status?.value } ],
						   [col:'Alumni Access', value:{l, ctx -> l.getCustomPropByName('Alumni Access')?.value }],
                           [col:'Alumni Access Notes', value:{l, ctx -> raw(l.getCustomPropByName('Alumni Access')?.note?.replaceAll('"','\'')) }],
						   [col:'Concurrent Access', value:{l, ctx -> l.getCustomPropByName('Concurrent Access')?.value }],
						   [col:'Concurrent Access Notes', value:{l, ctx -> raw(l.getCustomPropByName('Concurrent Access')?.note?.replaceAll('"','\'')) }],
						   [col:'Enterprise Access', value:{l, ctx -> l.getCustomPropByName('Enterprise Access')?.value }],
						   [col:'Enterprise Access Notes', value:{l, ctx -> raw(l.getCustomPropByName('Enterprise Access')?.note?.replaceAll('"','\'')) }],
						   [col:'ILL - InterLibraryLoans', value:{l, ctx -> l.getCustomPropByName('ILL - InterLibraryLoans')?.value }],
						   [col:'ILL - InterLibraryLoans Notes', value:{l, ctx -> raw(l.getCustomPropByName('ILL - InterLibraryLoans')?.note?.replaceAll('"','\'')) }],
						   [col:'Include In Coursepacks', value:{l, ctx -> l.getCustomPropByName('Include In Coursepacks')?.value }],
						   [col:'Include In Coursepacks Notes', value:{l, ctx -> raw(l.getCustomPropByName('Include In Coursepacks')?.note?.replaceAll('"','\'')) }],
						   [col:'Include in VLE', value:{l, ctx -> l.getCustomPropByName('Include in VLE')?.value }],
						   [col:'Include in VLE Notes', value:{l, ctx -> raw(l.getCustomPropByName('Include in VLE')?.note?.replaceAll('"','\'')) }],
						   [col:'Multi Site Access', value:{l, ctx -> l.getCustomPropByName('Multi Site Access')?.value }],
						   [col:'Multi Site Access Notes', value:{l, ctx -> raw(l.getCustomPropByName('Multi Site Access')?.note?.replaceAll('"','\'')) }],
						   [col:'Notice Period', value:{l, ctx -> l.getCustomPropByName('Notice Period')?.value }],
						   [col:'Notice Period Notes', value:{l, ctx -> raw(l.getCustomPropByName('Notice Period')?.note?.replaceAll('"','\'')) }],
						   [col:'Partners Access', value:{l, ctx -> l.getCustomPropByName('Partners Access')?.value }],
						   [col:'Partners Access Notes', value:{l, ctx -> raw(l.getCustomPropByName('Partners Access')?.note?.replaceAll('"','\'')) }],
						   [col:'Post Cancellation Access Entitlement', value:{l, ctx -> l.getCustomPropByName('Post Cancellation Access Entitlement')?.value }],
						   [col:'Post Cancellation Access Entitlement Notes', value:{l, ctx -> raw(l.getCustomPropByName('Post Cancellation Access Entitlement')?.note?.replaceAll('"','\'')) }],
						   [col:'Remote Access', value:{l, ctx -> l.getCustomPropByName('Remote Access')?.value }],
						   [col:'Remote Access Notes', value:{l, ctx -> raw(l.getCustomPropByName('Remote Access')?.note?.replaceAll('"','\'')) }],
						   [col:'Walk In Access', value:{l, ctx -> l.getCustomPropByName('Walk In Access')?.value }],
						   [col:'Walk In Access Notes', value:{l, ctx -> raw(l.getCustomPropByName('Walk In Access')?.note?.replaceAll('"','\'')) }]
                           ]}"/><g:set var="tabchar" value=","
/><g:set var="formatter" value="${new java.text.SimpleDateFormat('yyyy-MM-dd')}"
/><g:encodeAs codec="Raw"><g:each in="${cfg}" var="r">"${r.col}"${tabchar}</g:each>
<g:each in="${licences}" var="licence"
><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">"${r.value.call(licence, ctx)}"${tabchar}</g:if
><g:else>"${r.value}"${tabchar}</g:else></g:each>
</g:each></g:encodeAs>