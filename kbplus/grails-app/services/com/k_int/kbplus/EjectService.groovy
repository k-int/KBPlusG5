package com.k_int.kbplus

import com.k_int.kbplus.Org;
import groovy.util.logging.Slf4j
import java.util.UUID;
import java.io.*;
import java.util.zip.*;

/**
 *
 */

@Slf4j
class EjectService {

  def grailsApplication;

  private String baseExportDir = null;
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
    baseExportDir = grailsApplication.config.exportsDir ?: './exportFiles'
    File f = new File(baseExportDir);
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
    finally {
      log.info("watchExportRequests complete()")
    }
  }

  private boolean processNextExportRequest() {

    log.debug("processNextExportRequest()");

    boolean work_done = false;
    Org.withNewSession {
      List<Long> pending_requests = Org.executeQuery(PENDING_EXPORT_REQUESTS_QRY, [requested:'REQUESTED'])
      pending_requests.each { org_id ->
        log.debug("Check ${org_id}");
        boolean proceed=false;
        Org.withNewTransaction {
          Org o = Org.lock(org_id);
          // Take this request from the queue by marking it with the instance ID
          if ( ( o.batchMonitorUUID == null ) && ( o.exportStatus == 'REQUESTED' ) ) {
            o.batchMonitorUUID = this.instanceId;
            o.exportStatus = 'PROCESSING'
            o.save(flush:true, failOnError:true);
            proceed=true
            log.debug("Proceed to export");
          }
          else {
            log.warn("Unable to prepare export request");
          }
        }

        // If we have claimed the monitor for this instance - process it
        if ( proceed ) {

          Org.withNewTransaction {
            performExport(org_id);
          }

          Org.withNewTransaction {
            Org o = Org.lock(org_id);
            o.batchMonitorUUID = null;
            o.exportStatus = 'COMPLETE'
            o.save(flush:true, failOnError:true);
          }
        }
        else {
          log.info("Skip export request ${org_id} - proceed = false");
        }
      }
    }

    return work_done;
  }

  public Map performExport(Long org_id) {
    Map result= [:]
    log.debug("performExport(${org_id})");
    Org o = Org.get(org_id);

    if ( o != null ){
      String previous_export = o.exportUUID;
      String new_uuid = UUID.randomUUID().toString();
      String export_dir_name = grailsApplication.config.exportsDir ?: './exportFiles'
      String new_export_dir = export_dir_name+'/'+new_uuid;
      File f = new File(new_export_dir);
      if (!f.isDirectory()) {
        log.debug("Making root export dir ${f}");
        f.mkdirs()
      }

      writeExportFiles(new_uuid, new_export_dir);
      createZipfile(new_uuid, new_export_dir);
      // f.delete();

      o.exportUUID = new_uuid;
      o.currentExportDate = new Date();

      if ( previous_export != null ) {
        // tidy up the old export
      }

      o.save(flush:true, failOnError:true);
    }
    else {
      log.warn("Unable to locate org ${org_id} for export");
    }

    // set org.exportUUID =
    return result;
  }

  private writeExportFiles(String export_uuid, String base) {
    File dummy = new File(base+'/index.html');
    dummy << "This is an export with ID ${export_uuid}";
  }

  private createZipfile(String export_uuid, String base) {
    try {
      File sourceDir = new File(base);
      FileOutputStream fos = new FileOutputStream(base+'.zip');
      ZipOutputStream zos = new ZipOutputStream(fos);
      zipDir(sourceDir, sourceDir.getName(), zos);
      zos.close();
      fos.close();
      System.out.println("Directory zipped successfully!");
    } catch (IOException e) {
      e.printStackTrace();
    }     

  }

  private void zipDir(File sourceFile, String parentDir, ZipOutputStream zos) throws IOException {
    if (sourceFile.isDirectory()) {
      String dirName = parentDir + File.separator + sourceFile.getName();
      zos.putNextEntry(new ZipEntry(dirName + File.separator));

      File[] files = sourceFile.listFiles();
      if (files != null) {
        for (File file : files) {
          zipDir(file, dirName, zos);
        }
      }
    } else {
      FileInputStream fis = new FileInputStream(sourceFile);
      String fileName = parentDir + File.separator + sourceFile.getName();
      zos.putNextEntry(new ZipEntry(fileName));

      byte[] buffer = new byte[1024];
      int length;
      while ((length = fis.read(buffer)) > 0) {
        zos.write(buffer, 0, length);
      }

      zos.closeEntry();
      fis.close();
    }
  }


  public void requestEject(Org inst) {
    log.debug("requestEject(${inst})");
    inst.exportStatus = 'REQUESTED'
    inst.save(flush:true, failOnError:true);
  }
}
