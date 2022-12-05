model {
  Iterable<com.k_int.kbplus.IssueEntitlement> entitlements
  java.text.SimpleDateFormat formatter
}

TitleList {
	entitlements.each {ie->
	    IssueEntitlement(id:ie.id) {
		    CoverageStatement {
		    	if(ie.startDate){StartDate formatter.format(ie.startDate)}
  				if(ie.endDate){EndDate formatter.format(ie.endDate)}
			  	StartVolume ie.startVolume
			  	StartIssue ie.startIssue
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