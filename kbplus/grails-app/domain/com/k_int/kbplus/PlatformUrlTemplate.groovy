package com.k_int.kbplus

class PlatformUrlTemplate {

  Date startsOn
  String templateUrl
  static belongsTo = [ platform: Platform ]

  static constraints = {
    startsOn(nullable:true)
    platform(nullable:false)
    templateUrl(nullable:false, blank:false)
  }

  static mapping = {
             table 'platform_url_template'
                id column:'put_id'
           version column:'put_version'
          startsOn column:'put_starts_on'
       templateUrl column:'put_template_url'
          platform column:'put_plat_fk'
  }

}


