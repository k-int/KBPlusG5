package com.k_int.eventLog;

/**
 * Copied from k-int utility suite - event tracking
 */
public class EventLogRecord {

  EventLogDomain eventLogDomain
  String sequenceId
  Long timestamp
  String eventObjectKey
  String eventType

  static mapping = {
                 id column:'kelr_id'
            version column:'kelr_version'
     eventLogDomain column:'kelr_domain_fk'
         sequenceId column:'kelr_sequence_id'
          timestamp column:'kelr_timestamp'
     eventObjectKey column:'kelr_event_object_key'
          eventType column:'kelr_event_type'

  }

  static constraints = {
  }

  public boolean equals(Object o) {
    if ( o.id == this.id ) {
      return true;
    }
  }

}
