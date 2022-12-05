model {
  Iterable<com.k_int.kbplus.TitleInstitutionProvider> exportTips
  java.text.SimpleDateFormat formatter
}

TitleInstitutionProviders {
	exportTips.each {tip->
		Title tip.title?.title
		TitleID tip.title?.id
		PublicationType tip.title?.publicationType
		if(tip.title?.dateMonographPublishedPrint){DateMonographPublishedPrint formatter.format(tip.title?.dateMonographPublishedPrint)}
		if(tip.title?.dateMonographPublishedOnline){DateMonographPublishedOnline formatter.format(tip.title?.dateMonographPublishedOnline)}
		MonographVolume tip.title?.monographVolume
		MonographEdition tip.title?.monographEdition
		FirstAuthor tip.title?.firstAuthor
		FirstEditor tip.title?.firstEditor
		TitleIDs {
			tip.title.ids.each {id->
				def idOcc = (IdentifierOccurrence)id
				ID(namespace:idOcc.identifier.ns.ns) {
					Value idOcc.identifier.value
				}
			}
		}
		CoverageStatement {
			ProviderID tip.provider?.id
   			ProviderName tip.provider?.name
   			CoreDateList {
   				tip.coreDates.each {cDate->
   					if(cDate.startDate){CoreDateStart formatter.format(cDate.startDate)}
   					if(cDate.endDate){CoreDateEnd formatter.format(cDate.endDate)}
   				}
    		}
   			CoreStatus tip.coreStatus(null)?'Core':tip.coreStatus(null)==null?'Not Core':'Was/Will Be Core'
   		}
	}
}