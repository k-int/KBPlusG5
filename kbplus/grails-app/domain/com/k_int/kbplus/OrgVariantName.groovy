package com.k_int.kbplus

class OrgVariantName {

  Org owner
  String variantName

  static belongsTo = [
    owner:Org
  ]

  static mapping = {
            id column:'ovn_id'
          name column:'ovn_name', index:'org_name_idx'
  }

  static constraints = {
  }

  def afterInsert() {
    if ( owner ) {
      owner.nonce="${System.currentTimeMillis()}"
    }
  }
}
