package com.k_int.kbplus

import javax.persistence.Transient

class PackageProduct {

  Package pkg
  Product product

  static mapping = {
                id column:'pp_id'
           version column:'pp_version'
               pkg column:'pp_pkg_fk'
           product column:'pp_prd_fk'
  }

  static constraints = {
    pkg(nullable:true, blank:false)
    product(nullable:true, blank:false)
  }
  
}
