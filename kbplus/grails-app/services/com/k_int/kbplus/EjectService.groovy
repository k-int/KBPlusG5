package com.k_int.kbplus

import com.k_int.kbplus.Org;
import groovy.util.logging.Slf4j

/**
 *
 */

@Slf4j
class EjectService {

  private boolean running = true;
  private Object exportRequestMonitor = new Object();

  @javax.annotation.PostConstruct
  def init () {
    log.info("EjectService::init");
    // es_index= grailsApplication.config.aggr_es_index ?: 'kbplus'
    java.lang.Thread.startDaemon({
      this.watchExportRequests();
    })
  }

  private void watchExportRequests() {
    log.info("start watching export requests");
    try {
      while(running) {
        log.info("watchExportRequests()");
        synchronized(exportRequestMonitor) {
          exportRequestMonitor.wait(120000); //  Sleep 2m or until woken up
        }

        // Whilst there is work to do, continue generating exports
        while ( processNextExportRequest() ) {
          log.info("Processing an export request");
        }
      }
    }
    catch ( Exception e ) {
      log.error("Error in watchExportRequests thread",e);
    }
  }

  private boolean processNextExportRequest() {
    return false;
  }

  public void requestFreshExport(Org org) {
  }

}
