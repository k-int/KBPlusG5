package com.k_int.kbplus

import com.k_int.custprops.PropertyDefinition
import com.k_int.kbplus.abstract_domain.CustomProperty
import javax.persistence.Transient

class LicenseCustomProperty implements CustomProperty {

  @Transient
  def grailsApplication

  @Transient
  def messageSource

  static auditable = true

  static belongsTo = [
      type : PropertyDefinition,
      owner: License
  ]

  PropertyDefinition type
  License owner

  @Transient
  def onChange = { oldMap,newMap ->
    log.debug("onChange LicenseCustomProperty ${oldMap} -> ${newMap}")
    def changeNotificationService = grailsApplication.mainContext.getBean("changeNotificationService")
      controlledProperties.each{ cp->
          if ( oldMap[cp] != newMap[cp] ) {
          log.debug("Change found on ${this.class.name}:${this.id}.")
          changeNotificationService.notifyChangeEvent([
                           OID: "${this.owner.class.name}:${this.owner.id}",
                           event:'CustomProperty.updated',
                           prop: cp,
                           name: type.name,
                           type: this."${cp}".getClass().name,  
                           old: oldMap[cp] instanceof RefdataValue? oldMap[cp].toString() : oldMap[cp],
                           new: newMap[cp] instanceof RefdataValue? newMap[cp].toString() : newMap[cp],
                           propertyOID: "${this.class.name}:${this.id}"
                          ])
          }
      }
    log.debug("onChange LicenseCustomProperty complete");
  }
  @Transient
  def onDelete = { oldMap ->
    log.debug("onDelete LicenseCustomProperty")
    def oid = "${this.owner.class.name}:${this.owner.id}"
    def changeDoc = [ OID: oid,
                     event:'CustomProperty.deleted',  
                     prop: "${this.type.name}",
                     old: "",
                     new: "property removed",
                     name: this.type.name
                     ]
    def changeNotificationService = grailsApplication.mainContext.getBean("changeNotificationService")
    // changeNotificationService.broadcastEvent("com.k_int.kbplus.License:${owner.id}", changeDoc);
    changeNotificationService.notifyChangeEvent(changeDoc) 
  }
  

  @Transient
  def onSave = { props ->
    log.debug("LicenseCustomProperty saved ${props}")
  }

  public String toString() {
    return "LicenseCustomProperty id:${this.id} type:${this.type} owner:${this.owner} note:${this.note}".toString()
  }
}
