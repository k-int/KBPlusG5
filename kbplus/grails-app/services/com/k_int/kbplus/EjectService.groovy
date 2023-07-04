package com.k_int.kbplus

import com.k_int.kbplus.Org;
import groovy.util.logging.Slf4j
import java.util.UUID;

/**
 *
 */

@Slf4j
class EjectService {

  def grailsApplication;

  private boolean running = true;
  private Object exportRequestMonitor = new Object();
  private UUID instanceId = null;
  private static String PENDING_EXPORT_REQUESTS_QRY = '''
select o.id
from Org as o 
where o.exportStatus = :requested
and o.batchMonitorUUID is null
'''

  @javax.annotation.PostConstruct
  def init () {
    this.instanceId = UUID.randomUUID();
    String export_dir_name = grailsApplication.config.exportsDir ?: './exportFiles'
    File f = new File(export_dir_name);
    if (!f.isDirectory()) {
      log.debug("Making root exort dir ${f}");
      f.mkdirs()
    }

    log.info("EjectService::init - instance id is ${this.instanceId}");
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
    boolean work_done = false;
    Org.withNewSession {
      List<Long> pending_requests = Org.executeQuery(PENDING_EXPORT_REQUESTS_QRY, [requested:'REQUESTED'])
      pending_requests.each { org_id ->
        boolean proceed=false;
        Org.withNewTransaction {
          Org o = Org.lock(org_id);

          // Take this request from the queue by marking it with the instance ID
          if ( ( o.batchMonitorUUID == null ) && ( o.exportStatus == 'REQUESTED' ) ) {
            o.batchMonitorUUID = this.instanceId;
            o.exportStatus = 'PROCESSING'
            o.save(flush:true, failOnError:true);
            proceed=true
          }
        }

        // If we have claimed the monitor for this instance - process it
        if ( proceed ) {

          performExport(org_id);

          Org.withNewTransaction {
            Org o = Org.lock(org_id);
            o.batchMonitorUUID = null;
            o.exportStatus = 'COMPLETE'
            o.save(flush:true, failOnError:true);
          }
        }
      }
    }
    return work_done;
  }

  public Map performExport(Long org_id) {
    Map result= [:]
    log.debug("performExport(${org_id})");
    // set org.exportUUID =
    return result;
  }

  public void requestEject(Org inst) {
    log.debug("requestEject(${inst})");
  }
}
