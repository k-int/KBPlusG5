package com.k_int.kbplus

import com.k_int.kbplus.auth.*;

class SavedQuery {

  String ref
  String query
  String type
  User owner

  static mapping = {
                  id column:'sq_id'
             version column:'sq_version'
                 ref column:'sq_ref'
               query column:'sq_query'
                type column:'sq_type'
               owner column:'sq_owner_fk'
  }

  static constraints = {
      ref(nullable:true, blank:false)
    query(nullable:false, blank:false)
     type(nullable:false, blank:false)
    owner(nullable:false, blank:false)
  }
}
