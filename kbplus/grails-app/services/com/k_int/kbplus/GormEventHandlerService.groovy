package com.k_int.kbplus

import grails.events.annotation.Subscriber
import grails.events.annotation.gorm.Listener
import groovy.transform.CompileStatic
import groovy.util.logging.Slf4j
import org.grails.datastore.mapping.engine.event.AbstractPersistenceEvent
import org.grails.datastore.mapping.engine.event.PostDeleteEvent
import org.grails.datastore.mapping.engine.event.PostInsertEvent
import org.grails.datastore.mapping.engine.event.PostUpdateEvent
import com.k_int.kbplus.LicenseCustomProperty
import com.k_int.kbplus.License

@Slf4j
class GormEventHandlerService {

  def grailsApplication
  
  // event is a subclass of AbstractPersistenceEvent
  @Subscriber 
  void afterInsert(PostInsertEvent event) {

    // If the entity created was a licenseCustomProperty, we want to touch the holder of the custprop
    if ( event.entityObject instanceof LicenseCustomProperty ) {
      log.debug("A new license custom property was created : ${event.entityObject}");
      //com.k_int.kbplus.LicenseCustomProperty lcp = event.entityObject;
    }
  }

  @Subscriber 
  void afterUpdate(PostUpdateEvent event) { 
    if ( event.entityObject instanceof LicenseCustomProperty ) {
      log.debug("A license custom property was updated : ${event.entityObject}");
    }
  }

  @Subscriber 
  void afterDelete(PostDeleteEvent event) {
    if ( event.entityObject instanceof LicenseCustomProperty ) {
      log.debug("A license custom property was deleted : ${event.entityObject}");
    }
  }


  private void touchLicense(License l) {
    l.lastmod = System.currentTimeMillis();
    l.save(flush:true, failOnError:true);
  }
}
