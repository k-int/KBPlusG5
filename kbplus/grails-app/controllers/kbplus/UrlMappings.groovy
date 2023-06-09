package kbplus

class UrlMappings {

  static mappings = {
    "/$controller/$action?/$id?"{
      constraints {
        // apply constraints here
      }
    }

    "/"(view:"/publichome")

    "500"(view:'/serverCodes/error')
    "401"(view:'/serverCodes/forbidden')
    "403"(view:'/serverCodes/error')
    "404"(view:'/serverCodes/notFound404')

    "/myInstitutions"(controller:'home', action:'index');
    "/myInstitutions/$defaultInstShortcode/dashboard"(controller:'myInstitutions', action:'instdash')
    "/myInstitutions/$defaultInstShortcode" (controller:'myInstitutions', action:'instdash')
    "/myInstitutions/$defaultInstShortcode/requestExport" (controller:'myInstitutions', action:'requestExport')
    
    "/subscriptionDetails/$action" (controller:'subscriptionDetails')
    "/subscriptionDetails/$action/$id" (controller:'subscriptionDetails')
    
    "/myInstitutions/$defaultInstShortcode/subscriptionDetails/$action" (controller:'subscriptionDetails')
    "/myInstitutions/$defaultInstShortcode/subscriptionDetails/$action/$id" (controller:'subscriptionDetails')
    
    "/subscriptionImport/$action" (controller:'subscriptionImport')
    "/subscriptionImport/$action/$id" (controller:'subscriptionImport')
    
    "/myInstitutions/$defaultInstShortcode/subscriptionImport/$action" (controller:'subscriptionImport')
    "/myInstitutions/$defaultInstShortcode/subscriptionImport/$action/$id" (controller:'subscriptionImport')
    
    "/issueEntitlement/$action" (controller:'issueEntitlement')
    "/issueEntitlement/$action/$id" (controller:'issueEntitlement')
    
    "/myInstitutions/$defaultInstShortcode/issueEntitlement/$action" (controller:'issueEntitlement')
    "/myInstitutions/$defaultInstShortcode/issueEntitlement/$action/$id" (controller:'issueEntitlement')
    
    "/myInstitutions/$defaultInstShortcode/$action"(controller:'myInstitutions')

    "/titleDetails/$action" (controller:'titleDetails')
    "/titleDetails/$action/$id" (controller:'titleDetails')
    
    "/myInstitutions/$defaultInstShortcode/titleDetails/$action" (controller:'titleDetails')
    "/myInstitutions/$defaultInstShortcode/titleDetails/$action/$id" (controller:'titleDetails')
    
    "/licenseDetails/$action" (controller:'licenseDetails')
    "/licenseDetails/$action/$id" (controller:'licenseDetails')

    "/myInstitutions/$defaultInstShortcode/licenseDetails/$action" (controller:'licenseDetails')
    "/myInstitutions/$defaultInstShortcode/licenseDetails/$action/$id" (controller:'licenseDetails')
    
    "/myInstitutions/$defaultInstShortcode/licenceCompare/$action" (controller:'licenceCompare')
    "/myInstitutions/$defaultInstShortcode/licenceCompare/$action/$id" (controller:'licenceCompare')

    "/myInstitutions/$defaultInstShortcode/finance/$action" (controller:'finance')
    "/myInstitutions/$defaultInstShortcode/finance/$action/$id" (controller:'finance')
    
    "/packageDetails/$action" (controller:'packageDetails')
    "/packageDetails/$action/$id" (controller:'packageDetails')

    "/manageTitles/$action" (controller:'manageTitles')
    "/manageTitles/$action/$id" (controller:'manageTitles')
        
    "/myInstitutions/$defaultInstShortcode/manageTitles/$action" (controller:'manageTitles')
    "/myInstitutions/$defaultInstShortcode/manageTitles/$action/$id" (controller:'manageTitles')
    
    "/myInstitutions/$defaultInstShortcode/packageDetails/$action" (controller:'packageDetails')
    "/myInstitutions/$defaultInstShortcode/packageDetails/$action/$id" (controller:'packageDetails')
    "/about"(view:"/about")
    "/signup"(view:"/signup")
    "/contactus"(view:"/contactus")
    "/oai/$id"(controller:'oai',action:'index')

    "/privacy"(controller:'staticContent', action:'index') { contentKey='kbplus.privacy' }
    "/accessibility"(controller:'staticContent', action:'index') { contentKey='kbplus.accessibility' }
    "/cookies"(controller:'staticContent', action:'index') { contentKey='kbplus.cookies' }
  }

    // "/lic/$action?/$id?"(controller:'license')

    // "/myInstitutions/$shortcode/$action/$id"(controller:'myInstitutions')
    // "/myInstitutions/$shortcode/finance"(controller:'finance', action:'index')
    // name subfinance: "/subscriptionDetails/$sub/finance/"(controller:'finance', action:'index')
    // "/myInstitutions/$shortcode/tipview/$id"(controller:'myInstitutions', action:'tip')

    // "/ajax/$action?/$id?"(controller:'ajax')

    // "/"(controller:"home")

    // "/about"(view:"/about")
    // "/terms-and-conditions"(view:"/terms-and-conditions")
    // "/privacy-policy"(view:"/privacy-policy")
    // "/freedom-of-information-policy"(view:"/freedom-of-information-policy")
    // "/contact-us"(view:"/contact-us")
    // "/publichome"(view:"/publichome")
    // "/signup"(view:"/signup")
    // "/noHostPlatformUrl"(view:"/noHostPlatformUrl")

}
