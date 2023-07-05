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
  def groovyPageRenderer;
  def groovyPageLocator;

  private String baseExportDir = null;
  private boolean running = true;
  private Object exportRequestMonitor = new Object();
  private UUID instanceId = null;
  private static String PENDING_EXPORT_REQUESTS_QRY = 'select o.id from Org as o where o.exportStatus = :requested and o.batchMonitorUUID is null'
  private static String PENDING_EXPORT_REQUESTS_QRY2 = 'select o from Org as o where o.exportStatus is not null'

        
  static String INSTITUTIONAL_LICENSES_QUERY = "select l from License as l where exists ( select ol from OrgRole as ol where ol.lic = l AND ol.org = :lic_org and ol.roleType = :org_role ) AND (l.status!=:lic_status or l.status=null ) "

  static String INSTITUTIONAL_SUBSCRIPTIONS_QUERY = "select s from Subscription as s where ( ( exists ( select o from s.orgRelations as o where o.roleType.value = 'Subscriber' and o.org = :o ) ) )"



  @javax.annotation.PostConstruct
  def init () {
    this.instanceId = UUID.randomUUID();
    baseExportDir = grailsApplication.config.exportsDir ?: './exportFiles'
    File f = new File(baseExportDir);
    if (!f.isDirectory()) {
      log.debug("Making root export dir ${f}");
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
        log.info("watchExportRequests() - main loop");
        synchronized(exportRequestMonitor) {
          exportRequestMonitor.wait(120000); //  Sleep 2m or until woken up
        }

        // Whilst there is work to do, continue generating exports
        try {
          while ( processNextExportRequest() ) {
            log.info("Processing an export request");
          }
        }
        catch ( Exception e ) {
          log.error("Problem",e);
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
      log.debug("Export request queue size: ${pending_requests?.size()}");
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

      writeExportFiles(new_uuid, new_export_dir,o);
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

  private writeExportFiles(String export_uuid, String base, Org inst) {
    File index = new File(base+'/index.tsv');
    index << "This is an export with ID ${export_uuid}\n";

    exportLicenses(inst, index, base);
    exportSubscriptions(inst, index, base);
  }

  private void exportLicenses(Org inst, File index, String base) {
    def licensee_role = RefdataCategory.lookupOrCreate('Organisational Role', 'Licensee');
    def template_license_type = RefdataCategory.lookupOrCreate('License Type', 'Template');
    def licence_status = RefdataCategory.lookupOrCreate('License Status', 'Deleted')

    Map qry_params = [lic_org:inst, 
                      org_role:licensee_role,
                      lic_status:licence_status]

    License.executeQuery(INSTITUTIONAL_LICENSES_QUERY, qry_params).each { lic ->
      log.debug("license ${lic}");

      def license_reference_str = lic.reference?:'NO_LIC_REF_FOR_ID_'+lic.id;

      index << "license\t${lic.id}\t${license_reference_str}\t\n".toString();

      Map model = [:];
      model.onixplLicense = lic.onixplLicense;
      model.license = lic;
      model.transforms = grailsApplication.config.licenceTransforms

      templateOutput('/licenseDetails/lic_ie_csv', model, "${base}/licence_${lic.id}_entitlements.csv", 'text/csv');
      templateOutput('/licenseDetails/lic_pkg_csv', model, "${base}/license_${lic.id}_packages.csv", 'text/csv');
      templateOutput('/licenseDetails/lic_csv', model, "${base}/license_${lic.id}.csv", 'text/csv');
    }

  }

  // https://stackoverflow.com/questions/47485529/grails-groovypagerenderer-injecting-in-file-inside-src-groovy
  // https://sergiodelamo.com/blog/how-to-render-a-gsp-in-a-grails-service.html
  // https://searchcode.com/file/115997997/grails-web-gsp/src/main/groovy/org/grails/web/gsp/io/CachingGrailsConventionGroovyPageLocator.java/
  private void templateOutput(String tname, Map m, String filename, String ct) {
    def tmpl = groovyPageLocator.findTemplateByPath(tname)
    log.debug("Located template ${tmpl}");
    File f = new File(filename);
    groovyPageRenderer.renderTo(template: tname, model: m, contentType: ct, encoding: "UTF-8", new FileWriter(f));
  }

  private void exportSubscriptions(Org inst, File index, String base) {

    Map qry_params = [o:inst]
    Subscription.executeQuery(INSTITUTIONAL_SUBSCRIPTIONS_QUERY, qry_params).each { sub ->
      log.debug("output subscription ${sub}");
      index << "subscription ${sub}\tcol\tcol\tcol\tcol\n".toString();
    }
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
