package com.k_int.eventLog;

/**
 * Copied from k-int utility suite - event tracking
 */
public class EventLogDomain {

  String name

  static mapping = {
                 id column:'keld_id'
            version column:'keld_version'
               name column:'keld_name'
  }

  static constraints = {
  }

  public boolean equals(Object o) {
    if ( o.id == this.id ) {
      return true;
    }
  }

}
