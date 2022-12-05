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
			JiscLicenseId license.jiscLicenseId
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