model {
  Iterable<com.k_int.kbplus.License> licenses
  java.text.SimpleDateFormat formatter
}

Licences {
	licenses.each {license->
		Licence {
			LicenceReference license.reference
			NoticePeriod license.noticePeriod
			LicenceURL license.licenseUrl
			LicensorRef license.licensorRef
			LicenseeRef license.licenseeRef
			license.orgLinks.each {orgRole->
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
				license.customProperties.each {custprops ->
					LicenceProperty(name:custprops.type?.name) {
						Value custprops.getValue()
						Note custprops.getNote()
					}
				}
			}
		}
	}
}