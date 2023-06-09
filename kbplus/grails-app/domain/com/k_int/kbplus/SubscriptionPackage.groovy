package com.k_int.kbplus

import javax.persistence.Transient

class SubscriptionPackage {

  Subscription subscription
  Package pkg

  static mapping = {
                id column:'sp_id'
           version column:'sp_version'
      subscription column:'sp_sub_fk'
               pkg column:'sp_pkg_fk'
  }

  static constraints = {
    subscription(nullable:true, blank:false)
    pkg(nullable:true, blank:false)
  }

  @Transient
  static def refdataFind(params) {

    def result = [];
    def hqlString = "select sp from SubscriptionPackage as sp where lower(sp.pkg.name) like :n"
    def hqlParams = [n:((params.q ? params.q.toLowerCase() : '' ) + "%")]

    if ( params.subFilter ) {
      hqlString += ' and sp.subscription.id = :s'
      hqlParams.s = (params.long('subFilter'))
    }

    def results = SubscriptionPackage.executeQuery(hqlString,hqlParams)

    results?.each { t ->
      def sp = com.k_int.ClassUtils.deproxy(t)
      def resultText = sp.subscription.name + '/' + sp.pkg.name
      result.add([id:"${sp.class.name}:${sp.id}",text:resultText])
    }

    result
  }
}
