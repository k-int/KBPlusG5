package com.k_int.kbplus

import grails.converters.*
import grails.plugin.springsecurity.annotation.Secured
import grails.converters.*
import org.elasticsearch.groovy.common.xcontent.*
import groovy.xml.MarkupBuilder
import com.k_int.kbplus.auth.*;


class DocWidgetController {

  def springSecurityService
  def docstoreService
  def gazetteerService
  def alertsService

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def addNoteView() {
    log.debug("add note modal: " + params)
    render(template:"/templates/addNote",model:[ownobjid:params.ownobjid,ownobjclass:params.ownobjclass,owntp:params.owntp,theme:params.theme]);
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def editNoteView() {
    log.debug("edit note modal: " + params)
    def doc = Doc.get(params.id)
    render(template:"/templates/editNote", model:[doc:doc,theme:params.theme]);
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def viewNotes() {
    def owner
    def domain_class=grailsApplication.getArtefact('Domain',params.ownobjclass)
    if ( domain_class ) {
      def instance = domain_class.getClazz().get(params.ownobjid)
      if ( instance ) {
        owner = instance
      }
    }
    
    render(template:"/templates/viewNotes", model:[ownerobj:owner,theme:params.theme]);
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def createNote() { 
    log.debug("Create note referer was ${request.getHeader('referer')} or ${request.request.RequestURL}");
    def user = User.get(springSecurityService.principal.id)
    def domain_class=grailsApplication.getArtefact('Domain',params.ownerclass)

    if ( domain_class ) {
      def instance = domain_class.getClazz().get(params.ownerid)
      if ( instance ) {
        log.debug("Got owner instance ${instance}");

        def doc_content = new Doc(contentType:0,
                  title: params.title,
                                  content: params.licenceNote,
                                  type:RefdataCategory.lookupOrCreate('Document Type','Note'),
                  creator:params.creator,
                                  user:user).save(flush:true, failOnError:true)

        def alert = null;
        if ( params.licenceNoteShared ) {
          switch ( params.licenceNoteShared ) {
            case "0":
              break;
            case "1":
              alert = new Alert(sharingLevel:1, createdBy:user).save(flush:true, failOnError:true);
              break;
            case "2":
              alert = new Alert(sharingLevel:2, createdBy:user).save(flush:true, failOnError:true);
              break;
          }
        }

        log.debug("Setting new context type to ${params.ownertp}..");
        def doc_context = new DocContext("${params.ownertp}":instance,
                                         owner:doc_content,
                                         doctype:RefdataCategory.lookupOrCreate('Document Type',params.doctype),
                                         alert:alert).save(flush:true);
      }
      else {
        log.debug("no instance");
      }
    }
    else {
      log.debug("no type");
    }

    def referer = request.getHeader('referer')
  if (params.anchor) {
    referer += params.anchor
  }
  
  redirect(url: referer)
    // redirect(url: request.request.RequestURL)
    // request.request.RequestURL
    // request.getHeader('referer') 
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processEditNote() {
  log.debug("process edit note....");
  log.debug("params: " + params);
  def user = User.get(springSecurityService.principal.id)
  def doc = Doc.get(params.id)
  
  if (params.title) {
    doc.title = params.title
  }
  else {
    doc.title = null
  }
  
  if (params.content) {
    doc.content = params.content
  }
  else {
    doc.content = null
  }
  
  if (params.creator) {
    doc.creator = params.creator
  }
  else {
    doc.creator = null
  }
  
  doc.save(flush:true, failOnError:true)
  
  def referer = request.getHeader('referer')
  if (params.anchor) {
    referer += params.anchor
  }
  
  redirect(url: referer)
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def addDocumentView() {
    log.debug("add document modal: " + params)
    render(template:"/templates/addDocument",model:[ownobjid:params.ownobjid,ownobjclass:params.ownobjclass,owntp:params.owntp,theme:params.theme]);
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def editDocumentView() {
    log.debug("edit note modal: " + params)
    def doc = Doc.get(params.id)
    render(template:"/templates/editDocument", model:[doc:doc,theme:params.theme]);
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def uploadDocument() {
    log.debug("upload document....");

    def input_file = request.getFile("upload_file")
    def input_stream = input_file?.inputStream
    def original_filename = request.getFile("upload_file")?.originalFilename

    def user = User.get(springSecurityService.principal.id)

    def domain_class=grailsApplication.getArtefact('Domain',params.ownerclass)

    if ( domain_class ) {
      def instance = domain_class.getClazz().get(params.ownerid)
      if ( instance ) {
        log.debug("Got owner instance ${instance}");

        if ( input_stream ) {
          // def docstore_uuid = docstoreService.uploadStream(input_stream, original_filename, params.upload_title)
          // log.debug("Docstore uuid is ${docstore_uuid}");
    
          def doc_content = new Doc(contentType:3,
                                    uuid: java.util.UUID.randomUUID().toString(),
                                    filename: original_filename,
                                    mimeType: request.getFile("upload_file")?.contentType,
                                    title: params.upload_title,
                                    creator: params.creator,
                                    blobLength: new Long(input_file.size),
                                    type:RefdataCategory.lookupOrCreate('Document Type',params.doctype))

          // doc_content.setBlobData(input_stream, input_file.size)
          doc_content.save(flush:true, failOnError:true)
          docstoreService.saveStreamToUUID(doc_content.uuid, input_stream);

          def doc_context = new DocContext("${params.ownertp}":instance,
                                           owner:doc_content,
                                           user:user,
                                           doctype:RefdataCategory.lookupOrCreate('Document Type',params.doctype)).save(flush:true, failOnError:true);

          log.debug("Doc created and new doc context set on ${params.ownertp} for ${params.ownerid}");
        }
        
      }
      else {
        log.error("Unable to locate document owner instance for class ${params.ownerclass}:${params.ownerid}");
      }
    }
    else {
      log.warn("Unable to locate domain class when processing generic doc upload. ownerclass was ${params.ownerclass}");
    }
  
  
  def referer = request.getHeader('referer')
  if (params.anchor) {
    referer += params.anchor
  }
  
  redirect(url: referer)
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processEditDocument() {
  log.debug("process edit document....");
  log.debug("params: " + params);
  def user = User.get(springSecurityService.principal.id)
  def doc = Doc.get(params.id)
  
  doc.title = params.title
  doc.filename = params.filename
  doc.creator = params.creator
  doc.save(flush:true, failOnError:true)
  
  def referer = request.getHeader('referer')
  if (params.anchor) {
    referer += params.anchor
  }
  
  redirect(url: referer)
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def deleteDocument() {
  def ctxlist = []

  log.debug("deleteDocuments ${params}");
  log.debug("Looking up docctx ${params.id} for delete");
  def docctx = DocContext.get(params.id)
  docctx.status = RefdataCategory.lookupOrCreate('Document Context Status','Deleted');
  docctx.save(flush:true, failOnErro:true)
  
  def referer = request.getHeader('referer')
  if (params.anchor) {
    referer += params.anchor
  }
  
  redirect(url: referer)
  }
}
