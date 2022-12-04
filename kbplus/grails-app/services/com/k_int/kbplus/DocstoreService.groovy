package com.k_int.kbplus

import groovy.xml.MarkupBuilder
import groovyx.net.http.*
import groovyx.net.http.ContentType.*
import groovyx.net.http.Method.*

import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream

import org.apache.commons.io.FileUtils
import org.apache.commons.io.IOUtils
import org.apache.http.entity.mime.*
import org.apache.http.entity.mime.content.*

import groovy.util.logging.Slf4j

@Slf4j
class DocstoreService {
  
  def grailsApplication
  def genericOIDService
  def sessionFactory

  @javax.annotation.PostConstruct
  def init() {
    log.debug("DocstoreService::init");
    log.debug("Docstore dir ${grailsApplication.config.docstoreDir} doDocstoreMigration:${grailsApplication.config.doDocstoreMigration}");
  }

  def doMigration() {
    log.debug("Docstore::doMigration() dir ${grailsApplication.config.docstoreDir} doDocstoreMigration:${grailsApplication.config.doDocstoreMigration}");

    File f = new File(grailsApplication.config.docstoreDir);

    if (!f.isDirectory()) {
      log.debug("Making root docstore dir ${f}");
      f.mkdirs()
    }

    Doc.executeQuery('select d.id from Doc as d where d.contentType = 3 AND ( d.migrated is NULL or d.migrated=:y )',[y:'y']).each { doc_id_to_migrate ->

      Doc.withNewTransaction {
        log.debug("Migrate ${doc_id_to_migrate}");
        def doc_to_migrate = Doc.get(doc_id_to_migrate)
        def doc_is = doc_to_migrate.getBlobData()
        if ( doc_is ) {

          doc_to_migrate.setBlobLength(doc_to_migrate.getBlobSize())

          if ( doc_to_migrate.uuid == null ) {
            log.debug("Assigning new UUID");
            doc_to_migrate.uuid = java.util.UUID.randomUUID().toString();
          }

          log.debug("uuid: ${doc_to_migrate.uuid}");
          saveStreamToUUID(doc_to_migrate.uuid, doc_is);

          // doc migrated to v3 -- filesystem
          doc_to_migrate.migrated = '3'

          doc_to_migrate.save(flush:true, failOnError:true);
        }
      }
      cleanUpGorm();
    }

    log.debug("doMigration completed");
  }

  def copyDocuments(source, destination) {
    source = genericOIDService.resolveOID(source)
    destination = genericOIDService.resolveOID(destination)
    if(source == null  ||  destination == null) return;
    source.documents.each{
      def docCopy = new DocContext(owner:it.owner,globannounce:it.globannounce,status:it.status,doctype:it.doctype,alert:it.alert,domain:it.domain)
      destination.addToDocuments(docCopy)
      destination.save(flush:true)
    }
  }

  /**
   * Given a uuid like aabbcc return a path like /some/root/aa/bb/ where we will store all the files starting aabb
   */
  String getUUIDFilepath(String uuid) {
    log.debug("uuid: ${uuid}");
    String dirpath_one = uuid.substring(0,2);
    String dirpath_two = uuid.substring(2,4);
    String docdir_path = grailsApplication.config.docstoreDir+'/'+dirpath_one+'/'+dirpath_two
    return docdir_path
  }

  void saveStreamToUUID(String uuid, InputStream doc_is) {

    def docdir = getUUIDFilepath(uuid);
    File f = new File(docdir);
    if (!f.isDirectory()) {
      log.debug("Making dir ${f}");
      f.mkdirs()
    }

    def doc_file = new File ( docdir+'/'+uuid )
    if ( ! doc_file.exists() ) {
      org.apache.commons.io.FileUtils.copyToFile(doc_is,doc_file)
    }
    else {
      log.debug("Skip ${doc_file} - already exists");
    }
  }

  InputStream getStreamFromUUID(String uuid) {
    String uuid_full_path = getUUIDFilepath(uuid)+'/'+uuid
    File f = new File(uuid_full_path);
    return new java.io.FileInputStream(f);
  }

  def streamDocResponse(response, doc) {
    response.setContentType(doc.mimeType)
    response.addHeader("content-disposition", "attachment; filename=\"${doc.filename}\"")
    response.outputStream << getStreamFromUUID(doc.uuid);
  }

  def cleanUpGorm() {
    log.debug("Clean up GORM");
    def session = sessionFactory.currentSession
    session.flush()
    session.clear()
  }

}
