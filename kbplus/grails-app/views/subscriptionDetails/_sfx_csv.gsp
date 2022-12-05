<g:set var="cfg" value="${[[col:'ISSN/ISBN', value:{e, ctx -> e.tipp.title.getIssn()?:e.tipp.title.getEissn()?:e.tipp.title.getIsbn() } ],
                           [col:'tabchar', value:'\t'],
					       [col:'open start', value:raw('$obj->parsedDate(">=",')],
					       [col:'Start Date', value:{e, ctx -> e.startDate?formatter.format(e.startDate):'undef'}],
						   [col:'comma', value:','],
    					   [col:'Start volume', value:{e, ctx -> e.startVolume?e.startVolume:'undef'}],
						   [col:'comma', value:','],
	    				   [col:'Start issue', value:{e, ctx -> e.startIssue?e.startIssue:'undef'}],
						   [col:'close start', value:')'],
						   [col:'and', value:raw(' && ')],
		    			   [col:'open end', value:raw('$obj->parsedDate("<=",')],
			    		   [col:'End Date', value:{e, ctx -> e.endDate?formatter.format(e.endDate):'undef'}],
						   [col:'comma', value:','],
				    	   [col:'End volume', value:{e, ctx -> e.endVolume?e.endVolume:'undef'}],
						   [col:'comma', value:','],
					       [col:'End issue', value:{e, ctx -> e.endIssue?e.endIssue:'undef'}],
						   [col:'close end', value:')'],
						   [col:'tabchar', value:'\t'],
                           [col:'Active', value:'ACTIVE']
                           ]}"
/><g:set var="cgg" value="${[[col:'ISSN/ISBN', value:{e, ctx -> e.tipp.title.getIssn()?:e.tipp.title.getEissn()?:e.tipp.title.getIsbn() } ],
                           [col:'tabchar', value:'\t'],
					       [col:'open start', value:raw('$obj->parsedDate(">=",')],
					       [col:'Start Date', value:{e, ctx -> e.startDate?formatter.format(e.startDate):'undef'}],
						   [col:'comma', value:','],
    					   [col:'Start volume', value:{e, ctx -> e.startVolume?e.startVolume:'undef'}],
						   [col:'comma', value:','],
	    				   [col:'Start issue', value:{e, ctx -> e.startIssue?e.startIssue:'undef'}],
						   [col:'close start', value:')'],
						   [col:'tabchar', value:'\t'],
                           [col:'Active', value:'ACTIVE']
                           ]}"
/><g:set var="chg" value="${[[col:'ISSN/ISBN', value:{e, ctx -> e.tipp.title.getIssn()?:e.tipp.title.getEissn()?:e.tipp.title.getIsbn() } ],
                           [col:'tabchar', value:'\t'],
					       [col:'open end', value:raw('$obj->parsedDate("<=",')],
			    		   [col:'End Date', value:{e, ctx -> e.endDate?formatter.format(e.endDate):'undef'}],
						   [col:'comma', value:','],
				    	   [col:'End volume', value:{e, ctx -> e.endVolume?e.endVolume:'undef'}],
						   [col:'comma', value:','],
					       [col:'End issue', value:{e, ctx -> e.endIssue?e.endIssue:'undef'}],
						   [col:'close end', value:')'],
						   [col:'tabchar', value:'\t'],
                           [col:'Active', value:'ACTIVE']
                           ]}"
/><g:set var="cg" value="${[[col:'ISSN/ISBN', value:{e, ctx -> e.tipp.title.getIssn()?:e.tipp.title.getEissn()?:e.tipp.title.getIsbn() } ],
                           [col:'tabchar', value:'\t'],
						   [col:'tabchar', value:'\t'],
                           [col:'Active', value:'ACTIVE']
                           ]}"/><g:set var="formatter" value="${new java.text.SimpleDateFormat('yyyy')}"
/><g:encodeAs codec="Raw"><g:each in="${entitlements}" var="entitlement"
><g:if test="${entitlement.startDate || entitlement.startVolume || entitlement.endIssue }"
><g:if test="${entitlement.endDate || entitlement.endVolume || entitlement.endIssue }"
><g:each in="${cfg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">${r.value.call(entitlement, ctx)}</g:if
><g:else>${r.value}</g:else></g:each></g:if><g:else
><g:each in="${cgg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">${r.value.call(entitlement, ctx)}</g:if
><g:else>${r.value}</g:else></g:each></g:else
></g:if><g:elseif test="${entitlement.endDate || entitlement.endVolume || entitlement.endIssue }"
><g:each in="${chg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">${r.value.call(entitlement, ctx)}</g:if
><g:else>${r.value}</g:else></g:each></g:elseif
><g:else><g:each in="${cg}" var="r"><g:if test="${r.value instanceof groovy.lang.Closure}">${r.value.call(entitlement, ctx)}</g:if
><g:else>${r.value}</g:else></g:each></g:else>
</g:each></g:encodeAs>


	
	
	
	
	
	
	
	
 
	
	
	
	

