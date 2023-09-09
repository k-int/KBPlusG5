model {
  Iterable<com.k_int.kbplus.IssueEntitlement> entitlements
  Iterable<com.k_int.kbplus.IssueEntitlement> expectedTitles
  Iterable<com.k_int.kbplus.IssueEntitlement> previousTitles
  com.k_int.kbplus.Subscription subscriptionInstance
  java.text.SimpleDateFormat formatter
}

Subscription(id:subscriptionInstance.id) {
    SubscriptionName subscriptionInstance.name
    ids {
      subscriptionInstance.ids.each { ido ->
        Identifier( namespace:ido.ns.ns) {
          Value ido.value
        }
      }
    }
    if(subscriptionInstance.startDate){SubTermStartDate formatter.format(subscriptionInstance.startDate)}
    if(subscriptionInstance.endDate){SubTermEndDate formatter.format(subscriptionInstance.endDate)}
	subscriptionInstance.orgRelations.each {orgRole->
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
   	if(subscriptionInstance.owner){Licence(id:subscriptionInstance.owner?.id) {
    	LicenceReference subscriptionInstance.owner?.reference
    	NoticePeriod subscriptionInstance.owner?.noticePeriod
    	LicenceURL subscriptionInstance.owner?.licenseUrl
    	LicensorRef subscriptionInstance.owner?.licensorRef
    	LicenseeRef subscriptionInstance.owner?.licenseeRef
	    subscriptionInstance.owner?.orgLinks.each {orgRole->
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
    	LicenceProperties {
    		subscriptionInstance.owner.customProperties.each {custprops ->
     			LicenceProperty(name:custprops.type?.name) {
      				Value custprops.getValue()
      				Note custprops.getNote()
     			}
    		}
   		}
	}}
	TitleList {
	    entitlements.each {ie->
	    	IssueEntitlement(id:ie.id) {
		    	CoverageStatement {
		    		if(ie.startDate){StartDate formatter.format(ie.startDate)}
				  	StartVolume ie.startVolume
				  	StartIssue ie.startIssue
				  	if(ie.endDate){EndDate formatter.format(ie.endDate)}
				  	EndVolume ie.endVolume
				  	EndIssue ie.endIssue
				  	Embargo ie.embargo
				  	CoverageDepth ie.coverageDepth
				  	CoverageNote ie.coverageNote
				  	HostPlatformName ie.tipp?.platform?.name
				  	HybridOA ie.tipp?.hybridOA?.value
				  	DelayedOA ie.tipp?.delayedOA?.value
				  	Payment ie.tipp?.payment?.value
				  	HostPlatformURL ie.tipp?.combinedPlatformUrl
				  	PackageID ie.tipp?.pkg?.id
  					PackageName ie.tipp?.pkg?.name
				  	AccessStartDate ie.accessStartDate
  					AccessEndDate ie.accessEndDate
  					AccessStatus ie.tipp?.getAvailabilityStatusAsString()
		    	}
	  			PublicationType ie.tipp.title.publicationType
	  			if(ie.tipp.title.dateMonographPublishedPrint){DateMonographPublishedPrint formatter.format(ie.tipp.title.dateMonographPublishedPrint)}
	  			if(ie.tipp.title.dateMonographPublishedOnline){DateMonographPublishedOnline formatter.format(ie.tipp.title.dateMonographPublishedOnline)}
	  			MonographVolume ie.tipp.title.monographVolume
	  			MonographEdition ie.tipp.title.monographEdition
	  			FirstEditor ie.tipp.title.firstEditor
	  			Title ie.tipp.title.title
	  			TitleIDs {
	  				ie.tipp.title.ids.each {id->
    					def idOcc = (IdentifierOccurrence)id
     					ID(namespace:idOcc.identifier.ns.ns) {
      						Value idOcc.identifier.value
     					}
    				}
	  			}
  			}
	    }
    }
    ExpectedTitles {
	    expectedTitles.each {et->
	    	IssueEntitlement(id:et.id) {
		    	CoverageStatement {
		    		if(et.startDate){StartDate formatter.format(et.startDate)}
				  	StartVolume et.startVolume
				  	StartIssue et.startIssue
				  	if(et.endDate){EndDate formatter.format(et.endDate)}
				  	EndVolume et.endVolume
				  	EndIssue et.endIssue
				  	Embargo et.embargo
				  	CoverageDepth et.coverageDepth
				  	CoverageNote et.coverageNote
				  	HostPlatformName et.tipp?.platform?.name
				  	HybridOA et.tipp?.hybridOA?.value
				  	DelayedOA et.tipp?.delayedOA?.value
				  	Payment et.tipp?.payment?.value
				  	HostPlatformURL et.tipp?.combinedPlatformUrl
				  	PackageID et.tipp?.pkg?.id
  					PackageName et.tipp?.pkg?.name
				  	AccessStartDate et.accessStartDate
  					AccessEndDate et.accessEndDate
  					AccessStatus et.tipp?.getAvailabilityStatusAsString()
		    	}
	  			PublicationType et.tipp.title.publicationType
	  			if(et.tipp.title.dateMonographPublishedPrint){DateMonographPublishedPrint formatter.format(et.tipp.title.dateMonographPublishedPrint)}
	  			if(et.tipp.title.dateMonographPublishedOnline){DateMonographPublishedOnline formatter.format(et.tipp.title.dateMonographPublishedOnline)}
	  			MonographVolume et.tipp.title.monographVolume
	  			MonographEdition et.tipp.title.monographEdition
	  			FirstEditor et.tipp.title.firstEditor
	  			Title et.tipp.title.title
	  			TitleIDs {
	  				et.tipp.title.ids.each {id->
    					def idOcc = (IdentifierOccurrence)id
     					ID(namespace:idOcc.identifier.ns.ns) {
      						Value idOcc.identifier.value
     					}
    				}
	  			}
  			}
	    }
    }
    PreviousTitles {
	    previousTitles.each {pt->
	    	IssueEntitlement(id:pt.id) {
		    	CoverageStatement {
		    		if(pt.startDate){StartDate formatter.format(pt.startDate)}
				  	StartVolume pt.startVolume
				  	StartIssue pt.startIssue
  					if(pt.endDate){EndDate formatter.format(pt.endDate)}
				  	EndVolume pt.endVolume
				  	EndIssue pt.endIssue
				  	Embargo pt.embargo
				  	CoverageDepth pt.coverageDepth
				  	CoverageNote pt.coverageNote
				  	HostPlatformName pt.tipp?.platform?.name
				  	HybridOA pt.tipp?.hybridOA?.value
				  	DelayedOA pt.tipp?.delayedOA?.value
				  	Payment pt.tipp?.payment?.value
				  	HostPlatformURL pt.tipp?.combinedPlatformUrl
				  	PackageID pt.tipp?.pkg?.id
  					PackageName pt.tipp?.pkg?.name
				  	AccessStartDate pt.accessStartDate
  					AccessEndDate pt.accessEndDate
  					AccessStatus pt.tipp?.getAvailabilityStatusAsString()
		    	}
	  			PublicationType pt.tipp.title.publicationType
	  			if(pt.tipp.title.dateMonographPublishedPrint){DateMonographPublishedPrint formatter.format(pt.tipp.title.dateMonographPublishedPrint)}
	  			if(pt.tipp.title.dateMonographPublishedOnline){DateMonographPublishedOnline formatter.format(pt.tipp.title.dateMonographPublishedOnline)}
	  			MonographVolume pt.tipp.title.monographVolume
	  			MonographEdition pt.tipp.title.monographEdition
	  			FirstEditor pt.tipp.title.firstEditor
	  			Title pt.tipp.title.title
	  			TitleIDs {
	  				pt.tipp.title.ids.each {id->
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

