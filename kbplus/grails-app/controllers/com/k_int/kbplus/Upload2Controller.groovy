package com.k_int.kbplus

import org.apache.commons.lang3.time.DateUtils
import org.springframework.dao.DataIntegrityViolationException
import grails.converters.*
import org.elasticsearch.groovy.common.xcontent.*
import groovy.xml.MarkupBuilder
import grails.plugin.springsecurity.annotation.Secured
import com.k_int.kbplus.auth.*;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.log4j.*
import au.com.bytecode.opencsv.CSVReader
import java.text.SimpleDateFormat
import grails.plugin.springsecurity.SpringSecurityUtils
import org.mozilla.universalchardet.UniversalDetector;
import org.apache.commons.io.input.BOMInputStream
import java.text.SimpleDateFormat


class Upload2Controller {

  def springSecurityService
  def sessionFactory
  //def propertyInstanceMap = org.codehaus.groovy.grails.plugins.DomainClassGrailsPlugin.PROPERTY_INSTANCE_MAP
  def packageIngestService
  def genericOIDService

  def isDataManagerOrAdminUser(user) {
    def result = false
    if (user) {
      if (user.hasSystemRole('ROLE_KBPLUS_EDITOR') || user.hasSystemRole('ROLE_ADMIN')) {
        result = true
      }
    }
    else {
      log.debug("user is null when checking permissions")
    }
    result
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def uploadPackageFile() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    
    if (!isDataManagerOrAdminUser(result.user)) {
      log.error("Sending 401 - Unauthorised");
      flash.error='You do not have the correct permissions to see this page. Only Data Managers and Admin users can view this page.'
      response.sendError(401)
    }

    if (request.method == 'POST' ) {
      log.debug(request.getFile("soFile")?.getOriginalFilename())
      if (request.getFile("soFile").getOriginalFilename()) {
        log.debug("Process upload file....");
        result.validationResult = packageIngestService.readPackageCSV(request, params)
        result.validationResult.strictmode = (params.strictmode=='off') ? false : true
        log.debug("strict mode: ${result.validationResult.strictmode}")
    
        log.debug("Validate....");
        packageIngestService.validate(result.validationResult)
      
        log.debug("Package ingest id is ${result.validationResult?.ingest_queue_id} redirecting to reviewPackage");
        redirect(action:'reviewPackage', id:result.validationResult?.ingest_queue_id)
      }
      else {
        flash.error = 'You must select a package to import.'
        redirect(action:'uploadPackageFile')
      }
    }
    

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def reviewPackage() {
    log.debug("reviewPackage(${params.id})");
    def result = [:];
    result.user = User.get(springSecurityService.principal.id)
    
    if (!isDataManagerOrAdminUser(result.user)) {
      log.error("Sending 401 - Unauthorised");
      flash.error='You do not have the correct permissions to see this page. Only Data Managers and Admin users can view this page.'
      response.sendError(401)
    }

    if ( params.id ) {
      result.validationResult = packageIngestService.getPackageFromUploadWorkspace(params.id)
    }
    else {
      redirect(action:'uploadPackageFile');
    }

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processPackage() {
    log.debug("processPackage(${params}) user=${springSecurityService.principal?.id}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    
    if (!isDataManagerOrAdminUser(result.user)) {
      log.error("Sending 401 - Unauthorised");
      flash.error='You do not have the correct permissions to see this page. Only Data Managers and Admin users can view this page.'
      response.sendError(401)
    }
    
    def sdf = possible_date_formats
    if ( params.id ) {
      result.putAll( packageIngestService.getPackageFromUploadWorkspace(params.id))

      log.debug("${params.packageMatchAction} ${params.packageToUpdate}");
      switch ( params.packageMatchAction ) {
        case "useExisting":
          break;
        case "newPackage":
          log.debug("${params.newPackageName}");
          result.incremental = false
          // result.normPkgIdentifier=params.id -- DMs are creating multiple new packages from a single upload. Not ideal, so generate a new UUID.
          result.normPkgIdentifier=java.util.UUID.randomUUID().toString();
          if ( result.soPackageName == null ) result.soPackageName = [:]
          result.soPackageName.value=params.newPackageName
          break;
        case "alternateExisting":
          log.debug("${params.packageToUpdate}");
          def pkg_to_update = genericOIDService.resolveOID(params.packageToUpdate);
          if ( pkg_to_update ) {
            result.incremental = true
            result.normPkgIdentifier=pkg_to_update.identifier
            log.debug("Update existing package ${params.packageToUpdate} -- lookup=${pkg_to_update}, norm pkgid = ${pkg_to_update.identifier}");
          }
          break;
        default:
          log.error("Unhandled package match action");
      }

      if ( params.overrideContentProvider ) {
        log.debug("Override content provider");
        def cp_obj = null;
        if ( params.overrideContentProvider.startsWith('com.k_int.kbplus.Org:__new__:') ) {
          def new_cp_components = params.overrideContentProvider.split(':');
          cp_obj = new Org(name:new_cp_components[2]).save(flush:true, failOnError:true);
        }
        else {
          cp_obj = genericOIDService.resolveOID(params.overrideContentProvider)
        }
        if ( result.packageProvider == null ) result.packageProvider = [:]
        result.packageProvider.value = cp_obj?.name;
      }

      if ( ( params.overridePackageScope ) && ( params.overridePackageScope.trim().length() > 0 ) ) {
        result.packageScope = RefdataCategory.lookupOrCreate(RefdataCategory.PKG_SCOPE,params.overridePackageScope).save()
      }

      if ( params.overrideConsortium ) {
        log.debug("User overriding consortium: ${params.overrideConsortium}");
        def co_obj = null;
        if ( params.overrideConsortium.startsWith('com.k_int.kbplus.Org:__new__:') ) {
          def new_co_components = params.overrideConsortium.split(':');
          co_obj = new Org(name:new_co_components[2]).save(flush:true, failOnError:true);
        }
        else {
          log.debug("Resolve oid ${params.overrideConsortium}");
          co_obj = genericOIDService.resolveOID(params.overrideConsortium)
          result.consortiumOrg = co_obj
        }

        if ( result.consortium == null ) 
          result.consortium = [:]

        result.consortium.value = co_obj?.name;

        log.debug("result.consortium.value will be ${result.consortium.value}");
      }

      result.overrides = []
      params.keySet().each { k ->
        if ( k.startsWith('override_') && params[k]=='on' ) {
          result.overrides.add(k.substring(9,k.length()));
        }
      }

      if ( result.aggreementTermStartYear == null ) result.aggreementTermStartYear = [:]
      result.aggreementTermStartYear?.value = ( ( params.overrideStartDate ) && ( params.overrideStartDate.length() > 0 ) ) ? parseDate(params.overrideStartDate, possible_date_formats) : null;

      if ( result.aggreementTermEndYear == null ) result.aggreementTermEndYear = [:]
      result.aggreementTermEndYear?.value = (( params.overrideEndDate ) && ( params.overrideEndDate.length() > 0 ) ) ? parseDate(params.overrideEndDate, possible_date_formats) : null;

      def repeat_upload =  (params.loadPackage=='repeat'?true:false)

      packageIngestService.processUploadPackage(result, repeat_upload)

      log.debug("Respond with new package, ${result.new_pkg_id} ${repeat_upload} ${params.defaultInstShortcode} ${result.user?.defaultDash?.shortcode} ${result.user}");

      if ( ( result.new_pkg_id != null ) && ( repeat_upload == false ) ) {
        if ( result.user != null ) {
          log.debug("Redirecting to packageDetails::show::${result.new_pkg_id}");
          def inst = params.defaultInstShortcode ?: result.user?.defaultDash?.shortcode
          if ( inst ) {
            redirect(controller:'packageDetails', action:'show', id:result.new_pkg_id, params:[defaultInstShortcode:inst])
          }
          else {
            flash.error="Package ${result.new_pkg_id} was created, but we were not able to find a default inst for  (${springSecurityService.principal?.id}). Redirecting to home. Please screenshot and send to support";
            log.warn("No inst when processing package upload. Package ${result.new_pkg_id} Principal ${springSecurityService.principal?.id}");
            redirect(controller:'home')
          }
        }
        else {
          flash.error="Package ${result.new_pkg_id} was created, but we were not able to find a user for principal (${springSecurityService.principal?.id}). Redirecting to home. Please screenshot and send to support";
          log.warn("No result.user when processing package upload. Package ${result.new_pkg_id} Principal ${springSecurityService.principal?.id}");
          redirect(controller:'home')
        }
      }
      else {
        redirect(action:'uploadPackageFile')
      }
    }
    else {
      redirect(action:'uploadPackageFile')
    }
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def downloadBadfile() {
    def user = User.get(springSecurityService.principal.id)
    
    if (!isDataManagerOrAdminUser(user)) {
      log.error("Sending 401 - Unauthorised");
      flash.error='You do not have the correct permissions to see this page. Only Data Managers and Admin users can view this page.'
      response.sendError(401)
    }
    
    def validationResult = packageIngestService.getPackageFromUploadWorkspace(params.id)
    log.debug("downloadBadfile()");
    def response_filename = "${params.id}_bad.csv"
    //     response.setContentLength(assetContent.size())

    response.setHeader("Content-disposition", "attachment; filename=\"${response_filename}\"")
    response.setContentType("text/csv")
    OutputStream out = response.getOutputStream()

    au.com.bytecode.opencsv.CSVWriter w = new au.com.bytecode.opencsv.CSVWriter(new OutputStreamWriter(out))
    w.writeNext(validationResult.soHeaderLine as String[])

    // out.write(validationResult.soHeaderLine)
    validationResult.tipps.each {
      if ( it.messages?.size() > 0 ) {
        w.writeNext(it.row as String[])
         it.messages.each { m ->
           String[] msg = [ 'MESSAGE: '+m.toString() ]
           w.writeNext(msg)
         }
      }
    }

    w.flush();
    w.close()
    out.flush()
    out.close()
  }

  def possible_date_formats = [
          [regexp:'[0-9]{2}/[0-9]{2}/[0-9]{4}', format: new SimpleDateFormat('dd/MM/yyyy')],
          [regexp:'[0-9]{4}/[0-9]{2}/[0-9]{2}', format: new SimpleDateFormat('yyyy/MM/dd')],
          [regexp:'[0-9]{4}-[0-9]{2}-[0-9]{2}', format: new SimpleDateFormat('yyyy-MM-dd')],
          [regexp:'[0-9]{2}/[0-9]{2}/[0-9]{2}', format: new SimpleDateFormat('dd/MM/yy')],
          [regexp:'[0-9]{4}/[0-9]{2}', format: new SimpleDateFormat('yyyy/MM')],
          [regexp:'[0-9]{4}', format: new SimpleDateFormat('yyyy')]
  ];

  def parseDate(datestr, possible_formats) {
    def parsed_date = null;
    for(Iterator i = possible_formats.iterator(); ( i.hasNext() && ( parsed_date == null ) ); ) {
      try {
        def date_format_info = i.next();

        if ( datestr ==~ date_format_info.regexp ) {
          def formatter = date_format_info.format
          parsed_date = formatter.parse(datestr);
          java.util.Calendar c = new java.util.GregorianCalendar();
          c.setTime(parsed_date)
          if ( ( 0 <= c.get(java.util.Calendar.MONTH) ) && ( c.get(java.util.Calendar.MONTH) <= 11 ) ) {
            // Month is valid
          }
          else {
            // Invalid date
            parsed_date = null
            // log.debug("Parsed ${datestr} using ${formatter.toPattern()} : ${parsed_date}");
          }
        }
      }
      catch ( Exception e ) {
      }
    }
    parsed_date
  }
}
