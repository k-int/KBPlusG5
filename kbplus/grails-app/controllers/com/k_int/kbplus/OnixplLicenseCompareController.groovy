package com.k_int.kbplus

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.util.GrailsNameUtils

import com.k_int.kbplus.onixpl.OnixPLHelperService
import com.k_int.kbplus.onixpl.OnixPLService

class OnixplLicenseCompareController {
  
  private static final String TEMPLATE_ROOT = "/templates/onix/"
  private static final String TEMPLATE_DEFAULT = "default"

  OnixPLService onixPLService
  OnixPLHelperService onixPLHelperService

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def index() {
    ArrayList<OnixplLicense> oplList = OnixplLicense.list();
	def termList = onixPLService.tsComparisonPoints
	log.debug("term list: " + termList)
    [list: oplList, termList: termList]
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def matrix() {
    
    log.debug("matrix:: selectedLicences:${params.selectedLicences}")
    // All licenses need to be compared.
    boolean allLicenses = false

    if(params.selectedLicences instanceof String && params.selectedLicences.startsWith("[")){
      params.selectedLicences = params.selectedLicences.substring(1,params.selectedLicences.size()-1)split(",")
    }
    // Cast each element in the list to a Long.
    List<Long> licenses =  params.list("selectedLicences").collect { String param ->
      if (param.toLowerCase() == "all") {
        allLicenses = true
      } else {
        return param as Long
      }
    }
    // Get the main licence.
    Long license_id = licenses.get(0)
    licenses.remove(0)
    OnixplLicense main_license = OnixplLicense.get(license_id)
    if(main_license == null){
      flash.error = "No OnixLicense found for the given id: ${license_id}."
      response.sendError(404)
      return;
    }
    // Get the list of licenses we are comparing with.
    List<OnixplLicense> compare_to =
      allLicenses ? OnixplLicense.findAllByIdNotEqual( license_id ) : OnixplLicense.findAllByIdInList( licenses )

    // The list to limit to.
    ArrayList<String> comparison_points = params.list("sections")
    // Should we compare all?
    if (comparison_points.remove("_:PublicationsLicenseExpression") != false || params.compareAll) {
      comparison_points = onixPLService.allComparisonPoints
    }
    // Filter.
    def match = params."match" ?: OnixPLService.COMPARE_RETURN_ALL
    
    // Comparison
    Map comparison = new TreeMap()
    comparison.putAll( onixPLService.compareLicenses(main_license, compare_to, comparison_points, match) )
    
    // Get the results.
    def result = [
      "data"          : comparison,
      "main_license"  : main_license.getTitle(),
      "headings"      : [main_license.getTitle()] + (compare_to*.getTitle() as List)
    ]
    
    // Serve the version required of the page.
    switch(request.forwardURI){
      case {String it -> it.endsWith(".json")} :
        render new JSON (result).toString(true)
        break;
        
      default :        
        // Add the other display information.
      
        result.putAll ([
          "service"       : onixPLService
        ])
        return result
    }
  }
}
