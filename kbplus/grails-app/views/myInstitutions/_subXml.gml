model {
  Iterable<com.k_int.kbplus.Subscription> subscriptions
  java.text.SimpleDateFormat formatter
}

Subscriptions {
	subscriptions.each {subInstance->
		Subscription(id:subInstance.id) {
    		SubscriptionName subInstance.name
    		if(subInstance.startDate){SubTermStartDate formatter.format(subInstance.startDate)}
    		if(subInstance.endDate){SubTermEndDate formatter.format(subInstance.endDate)}
	    	subInstance.orgRelations.each {orgRole->
    			RelatedOrg(id:orgRole.org.id) {
     				OrgName orgRole.org.name
     				OrgRole orgRole.roleType.value
     				OrgIDs {
    					orgRole.org.ids.each {id->
    						def idOcc = (IdentifierOccurrence)id
     						ID(namespace:idOcc.identifier.ns.ns) {
      							Value idOcc.identifier.value
     						}
    					}
   					}
    			}
   			}
	    }
    }
}

