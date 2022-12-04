package com.k_int.kbplus

class Erratum {

  String fingerprint
  String whenClause
  String thenClause
  String action
  String param1
  String comment

  static mapping = {
             id column:'er_id'
    fingerprint column:'er_fingerprint', index:'er_fingerprint_idx'
     whenClause column:'er_when', type:'text'
     thenClause column:'er_then', type:'text'
         action column:'er_action'
         param1 column:'er_param1', type:'text'
        comment column:'er_comment', type:'text'
  }

  static constraints = {
    fingerprint(nullable:false, blank:false,maxSize:128);
    whenClause(nullable:false, blank:false);
    thenClause(nullable:true, blank:true);
    action(nullable:true, blank:true);
    param1(nullable:true, blank:true);
    comment(nullable:true, blank:true);
  }

}
