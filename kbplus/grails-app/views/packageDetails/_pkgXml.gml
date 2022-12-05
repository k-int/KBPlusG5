model {
  Iterable<com.k_int.kbplus.TitleInstancePackagePlatform> titlesList
  Iterable<com.k_int.kbplus.TitleInstancePackagePlatform> expectedTitles
  Iterable<com.k_int.kbplus.TitleInstancePackagePlatform> previousTitles
  com.k_int.kbplus.Package packageInstance
  java.text.SimpleDateFormat formatter
}

Package(id:packageInstance.id) {
    PackageName packageInstance.name
    if(packageInstance.startDate){SubTermStartDate formatter.format(packageInstance.startDate)}
    if(packageInstance.endDate){SubTermEndDate formatter.format(packageInstance.endDate)}
	packageInstance.orgs.each {orgRole->
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
	if(packageInstance.license){Licence(id:packageInstance.license?.id) {
    	LicenceReference packageInstance.license?.reference
    	NoticePeriod packageInstance.license?.noticePeriod
    	LicenceURL packageInstance.license?.licenseUrl
    	LicensorRef packageInstance.license?.licensorRef
    	LicenseeRef packageInstance.license?.licenseeRef
	    packageInstance.license?.orgLinks.each {orgRole->
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
    		packageInstance.license.customProperties.each {custprops ->
     			LicenceProperty(name:custprops.type?.name) {
      				Value custprops.getValue()
      				Note custprops.getNote()
     			}
    		}
   		}
	}}
	TitleList {
	    titlesList.each {tipp->
	    	Tipp(tipp.id) {
		    	CoverageStatement {
		    		if(tipp.startDate){StartDate formatter.format(tipp.startDate)}
				  	StartVolume tipp.startVolume
				  	StartIssue tipp.startIssue
				  	if(tipp.endDate){EndDate formatter.format(tipp.endDate)}
				  	EndVolume tipp.endVolume
				  	EndIssue tipp.endIssue
				  	Embargo tipp.embargo
				  	CoverageDepth tipp.coverageDepth
				  	CoverageNote tipp.coverageNote
				  	HostPlatformName tipp.platform?.name
  					HybridOA tipp.hybridOA?.value
  					DelayedOA tipp.delayedOA?.value
  					Payment tipp.payment?.value
  					HostPlatformURL tipp.combinedPlatformUrl
  					AccessStartDate tipp.accessStartDate
  					AccessEndDate tipp.accessEndDate
  					AccessStatus tipp.getAvailabilityStatusAsString()
		    	}
	  			PublicationType tipp.title.publicationType
	  			if(tipp.title.dateMonographPublishedPrint){DateMonographPublishedPrint formatter.format(tipp.title.dateMonographPublishedPrint)}
	  			if(tipp.title.dateMonographPublishedOnline){DateMonographPublishedOnline formatter.format(tipp.title.dateMonographPublishedOnline)}
	  			MonographVolume tipp.title.monographVolume
	  			MonographEdition tipp.title.monographEdition
	  			FirstEditor tipp.title.firstEditor
	  			Title tipp.title.title
	  			TitleIDs {
	  				tipp.title.ids.each {id->
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
	    	Tipp(id:et.id) {
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
				  	HostPlatformName et.platform?.name
  					HybridOA et.hybridOA?.value
  					DelayedOA et.delayedOA?.value
  					Payment et.payment?.value
  					HostPlatformURL et.combinedPlatformUrl
  					AccessStartDate et.accessStartDate
  					AccessEndDate et.accessEndDate
  					AccessStatus et.getAvailabilityStatusAsString()
		    	}
	  			PublicationType et.title.publicationType
	  			if(et.title.dateMonographPublishedPrint){DateMonographPublishedPrint formatter.format(et.title.dateMonographPublishedPrint)}
	  			if(et.title.dateMonographPublishedOnline){DateMonographPublishedOnline formatter.format(et.title.dateMonographPublishedOnline)}
	  			MonographVolume et.title.monographVolume
	  			MonographEdition et.title.monographEdition
	  			FirstEditor et.title.firstEditor
	  			Title et.title.title
	  			TitleIDs {
	  				et.title.ids.each {id->
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
	    	Tipp(id:pt.id) {
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
				  	HostPlatformName pt.platform?.name
  					HybridOA pt.hybridOA?.value
  					DelayedOA pt.delayedOA?.value
  					Payment pt.payment?.value
  					HostPlatformURL pt.combinedPlatformUrl
  					AccessStartDate pt.accessStartDate
  					AccessEndDate pt.accessEndDate
  					AccessStatus pt.getAvailabilityStatusAsString()
		    	}
	  			PublicationType pt.title.publicationType
	  			if(pt.title.dateMonographPublishedPrint){DateMonographPublishedPrint formatter.format(pt.title.dateMonographPublishedPrint)}
	  			if(pt.title.dateMonographPublishedOnline){DateMonographPublishedOnline formatter.format(pt.title.dateMonographPublishedOnline)}
	  			MonographVolume pt.title.monographVolume
	  			MonographEdition pt.title.monographEdition
	  			FirstEditor pt.title.firstEditor
	  			Title pt.title.title
	  			TitleIDs {
	  				pt.title.ids.each {id->
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

