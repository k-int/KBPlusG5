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
  def docstoreService;

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

    def sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

    if ( o != null ){
      String previous_export = o.exportUUID;
      String new_uuid = "${org_id}-${sdf.format(new Date())}"
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
  
      String lic_dir_path = "${base}/license_${lic.id}".toString();
      File lic_dir = new File(lic_dir_path);
      lic_dir.mkdirs();

      def license_reference_str = lic.reference?:'NO_LIC_REF_FOR_ID_'+lic.id;

      index << "license\t${lic.id}\t${license_reference_str}\t\n".toString();

      Map model = [:];
      model.onixplLicense = lic.onixplLicense;
      model.license = lic;
      model.transforms = grailsApplication.config.licenceTransforms

      templateOutput('/licenseDetails/lic_ie_csv', model, "${lic_dir_path}/licence_${lic.id}_entitlements.csv", 'text/csv');
      templateOutput('/licenseDetails/lic_pkg_csv', model, "${lic_dir_path}/license_${lic.id}_packages.csv", 'text/csv');
      templateOutput('/licenseDetails/lic_csv', model, "${lic_dir_path}/license_${lic.id}.csv", 'text/csv');

      lic.documents.each { ld ->
        println("License doc: ${ld} ${ld.owner.title} ${ld.owner.filename}");

        try {
          // Stream ld.blobContent to file 
          if ( ld.owner.uuid != null ) {
            InputStream is = docstoreService.getStreamFromUUID(ld.owner.uuid);
  
            String just_filename = null;
            if ( ld.owner.filename != null ) {
              log.debug("extract file ${ld.owner.filename}");
              just_filename = ld.owner.filename.contains("/") ? ld.owner.filename.substring(ld.owner.filename.lastIndexOf('/')+1, ld.owner.filename.length()) : ld.owner.filename;
            }
            else if ( ld.owner.title != null ) {
              log.debug("Using title as filename - ${ld.owner.title}");
              just_filename = ld.owner.title.contains("/") ? ld.owner.title.substring(ld.owner.title.lastIndexOf('/')+1, ld.owner.title.length()) : ld.owner.title;
            }
            else {
              just_filename = "${ld.owner.uuid}"
            }

            log.debug("Add license file \"${lic_dir_path}\"/\"${just_filename}\"");
            File docfile = new File("${lic_dir_path}/${just_filename}");
            docfile << is
          }
          else {
            log.warn("No UUID for doc ${ld.owner}");
          }
        }
        catch ( Exception e ) {
          log.error("Exception trying to export license file");
          File docfile = new File("${lic_dir_path}/licensefile_${ld.id}_error_note}");
          docfile << "Error attempting to export license file : ${e.message}";
        }
      }
    }
  }

  // https://stackoverflow.com/questions/47485529/grails-groovypagerenderer-injecting-in-file-inside-src-groovy
  // https://sergiodelamo.com/blog/how-to-render-a-gsp-in-a-grails-service.html
  // https://searchcode.com/file/115997997/grails-web-gsp/src/main/groovy/org/grails/web/gsp/io/CachingGrailsConventionGroovyPageLocator.java/
  private void templateOutput(String tname, Map m, String filename, String ct) {
    def tmpl = groovyPageLocator.findTemplateByPath(tname)
    // log.debug("Located template ${tmpl}");
    File f = new File(filename);
    groovyPageRenderer.renderTo(template: tname, model: m, contentType: ct, encoding: "UTF-8", new FileWriter(f));
  }

  private void exportSubscriptions(Org inst, File index, String base) {

    Map qry_params = [o:inst]
    Subscription.executeQuery(INSTITUTIONAL_SUBSCRIPTIONS_QUERY, qry_params).each { sub ->

      String sub_dir_path = "${base}/sub_${sub.id}".toString();
      File f = new File(sub_dir_path)
      f.mkdirs();

      List columns = []
      columns.add("subscription ${sub.id}");
      columns.add(sub.name);
      columns.add(sub.identifier);
      columns.add(sub.impId);
      columns.add(sub.startDate);
      columns.add(sub.endDate);
      columns.add(sub.owner?.id);
      columns.add(sub.owner?.reference);
      columns.add(sub.owner?.jiscLicenseId);

      sub.ids.each { io ->
        columns.add("${io.identifier.ns.ns}=${io.identifier.value}")
      }

      // log.debug("output subscription ${sub}");
      index << columns.join('\t').toString();
      Map model = [:]

      model.entitlements = IssueEntitlement.executeQuery("select ie from IssueEntitlement as ie where ie.subscription = :si and ie.status.value != 'Deleted'", [si:sub]);
      model.expectedTitles=[]
      model.previousTitles=[]

      templateOutput('/subscriptionDetails/kbplus_csv', model, "${sub_dir_path}/subscription_${sub.id}_entitlements.csv", 'text/csv');
    }
  }

  private createZipfile(String export_uuid, String base) {

    log.debug("createZipfile(${export_uuid},${base})");

    try {
      File sourceDir = new File(base);
      FileOutputStream fos = new FileOutputStream(base+'.zip');
      ZipOutputStream zos = new ZipOutputStream(fos);
      // zipDir(sourceDir, sourceDir.getName(), zos);
      // zipDir(sourceDir, '.', zos);

      // Descend into first level dir so we don't duplicate the path
      File[] files = sourceDir.listFiles();
      if (files != null) {
        for (File file : files) {
          zipDir(file, '.', zos);
        }
      }
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
      log.debug("Next zip entry -dir- ${dirName + File.separator}");
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
      log.debug("Next zip entry -file- ${fileName}");
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

  InputStream getStreamFromUUID(String uuid) {
    String export_dir_name = grailsApplication.config.exportsDir ?: './exportFiles'
    String export_file = export_dir_name+'/'+uuid+'.zip';
    File f = new File(export_file);
    return new java.io.FileInputStream(f);
  }
    
  def streamCurrentExport(inst, response) {
    if ( inst.exportUUID != null ) {
      response.setContentType('application/zip')
      response.addHeader("content-disposition", "attachment; filename=\"${inst.name}-${inst.currentExportDate}-export.zip\"")
      response.outputStream << getStreamFromUUID(inst.exportUUID)
    }
  }

}
