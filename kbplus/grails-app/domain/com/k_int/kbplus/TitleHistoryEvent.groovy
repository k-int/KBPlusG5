package com.k_int.kbplus

import javax.persistence.Transient

class TitleHistoryEvent {

  Date eventDate
  Set participants

  static hasMany = [ participants:TitleHistoryEventParticipant ]
  static mappedBy = [ participants:'event' ]

  @Transient 
  public boolean inRole(String role, TitleInstance t) {
    boolean result = false
    participants.each { p ->
      if ( ( p.participant.id == t.id ) && ( p.participantRole == role ) )
        result = true
    }
    return result
  }

  @Transient 
  def fromTitles() {
    participants.findAll{it.participantRole=='In'}.collect{ it.participant }
  }

  @Transient 
  def toTitles() {
    participants.findAll{it.participantRole=='Out'}.collect{ it.participant }
  }
}
