<g:set var="cfg" value="${['col1':'val1',
                           'col2':'val2',
                           'col3':'val3',
                           'col4':'val4']}"/>
<g:set var="tabchar" value="\t"/>
<g:encodeAs codec="Raw"><g:each in="${cfg}" var="k,v">${k}${tabchar}</g:each>
<g:each in="${entitlements}" var="entitlement"><g:each in="${cfg}" var="k,v">${entitlement.id}${tabchar}</g:each>
</g:each></g:encodeAs>
