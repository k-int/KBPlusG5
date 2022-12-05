<g:encodeAs codec="Raw"><g:set var="tabchar" value=","
/><g:each in="${aliases}" var="alias"
>"${alias}"${tabchar}</g:each>
<g:each in="${data}" var="data_row"><g:if test="${(data_row instanceof Object[])}"
><g:each in="${data_row}" var="data_item">"${data_item}"${tabchar}</g:each></g:if
><g:else>"${data_row}"${tabchar}</g:else>
</g:each></g:encodeAs>