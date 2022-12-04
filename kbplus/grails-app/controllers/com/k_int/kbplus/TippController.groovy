package com.k_int.kbplus

import grails.converters.*
import grails.plugin.springsecurity.annotation.Secured
import grails.converters.*
import groovy.xml.MarkupBuilder
import com.k_int.kbplus.auth.*;
import grails.plugin.springsecurity.SpringSecurityUtils
import java.text.SimpleDateFormat

class TippController {

  def springSecurityService
  def genericOIDService

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def show() { 
    def result = [:]

    result.user = User.get(springSecurityService.principal.id)
    if ( SpringSecurityUtils.ifAllGranted('ROLE_ADMIN') )
      result.editable=true
    else
      result.editable=false

    result.tipp = TitleInstancePackagePlatform.get(params.id)
    result.titleInstanceInstance = result.tipp.title

    if (!result.titleInstanceInstance) {
      flash.message = message(code: 'default.not.found.message', args: [message(code: 'titleInstance.label', default: 'TitleInstance'), params.id])
      redirect action: 'list'
      return
    }

    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    def paginate_after = params.paginate_after ?: 19;
    result.max = params.max
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

    def base_qry = "from TitleInstancePackagePlatform as tipp where tipp.title = ? and tipp.status.value != 'Deleted' "
    def qry_params = [result.titleInstanceInstance]

    if ( params.filter ) {
      base_qry += " and lower(tipp.pkg.name) like ? "
      qry_params.add("%${params.filter.trim().toLowerCase()}%")
    }

    if ( params.endsAfter && params.endsAfter.length() > 0 ) {
      def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd');
      def d = sdf.parse(params.endsAfter)
      base_qry += " and tipp.endDate >= ?"
      qry_params.add(d)
    }

    if ( params.startsBefore && params.startsBefore.length() > 0 ) {
      def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd');
      def d = sdf.parse(params.startsBefore)
      base_qry += " and tipp.startDate <= ?"
      qry_params.add(d)
    }

    if ( ( params.sort != null ) && ( params.sort.length() > 0 ) ) {
      base_qry += " order by lower(${params.sort}) ${params.order}"
    }
    else {
      base_qry += " order by lower(tipp.title.title) asc"
    }

    log.debug("Base qry: ${base_qry}, params: ${qry_params}, result:${result}");
    // result.tippList = TitleInstancePackagePlatform.executeQuery("select tipp "+base_qry, qry_params, [max:result.max, offset:result.offset]);
    result.tippList = TitleInstancePackagePlatform.executeQuery("select tipp "+base_qry, qry_params, [max:300, offset:0]);
    result.num_tipp_rows = TitleInstancePackagePlatform.executeQuery("select count(tipp) "+base_qry, qry_params )[0]

    result
  }
  
  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def edit() {
	  log.debug("edit() :: ${params}");
	  
	  def result = [:]
	  
	  result.user = User.get(springSecurityService.principal.id)
	  if ( SpringSecurityUtils.ifAllGranted('ROLE_ADMIN') ) {
		  result.editable=true
	  }
	  else {
		  result.editable=false
	  }
	  
	  result.tipp = TitleInstancePackagePlatform.get(params.id)
	  result.titleInstanceInstance = result.tipp.title
	  
	  def status_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='TIPP Status'"
	  result.tippStatusList = RefdataValue.executeQuery(status_qry,[])
	  
	  def statusreason_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='Tipp.StatusReason'"
	  result.tippStatusReasonList = RefdataValue.executeQuery(statusreason_qry,[])
	  
	  def delayed_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='TitleInstancePackagePlatform.DelayedOA'"
	  result.delayedList = RefdataValue.executeQuery(delayed_qry,[])
	  
	  def hybrid_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='TitleInstancePackagePlatform.HybridOA'"
	  result.hybridList = RefdataValue.executeQuery(hybrid_qry,[])
	  
	  def payment_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='TitleInstancePackagePlatform.PaymentType'"
	  result.paymentList = RefdataValue.executeQuery(payment_qry,[])
	  
	  result
  }
  
  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def processEdit() {
	  log.debug("processEdit() :: ${params}");
	  
	  def user = User.get(springSecurityService.principal.id)
	  def tipp = TitleInstancePackagePlatform.get(params.id)
	  
	  def sdf = new SimpleDateFormat('yyyy-MM-dd')
	  
	  if (params.accessStartDate) {
		  tipp.accessStartDate = sdf.parse(params.accessStartDate)
	  }
	  else {
		  tipp.accessStartDate = null
	  }
	  
	  if (params.accessEndDate) {
		  tipp.accessEndDate = sdf.parse(params.accessEndDate)
	  }
	  else {
		  tipp.accessEndDate = null
	  }
	  
	  if (params.startDate) {
		  tipp.startDate = sdf.parse(params.startDate)
	  }
	  else {
		  tipp.startDate = null
	  }
	  
	  if (params.startVolume) {
		  tipp.startVolume = params.startVolume
	  }
	  else {
		  tipp.startVolume = null
	  }
	  
	  if (params.startIssue) {
		  tipp.startIssue = params.startIssue
	  }
	  else {
		  tipp.startIssue = null
	  }
	  
	  if (params.endDate) {
		  tipp.endDate = sdf.parse(params.endDate)
	  }
	  else {
		  tipp.endDate = null
	  }
	  
	  if (params.endVolume) {
		  tipp.endVolume = params.endVolume
	  }
	  else {
		  tipp.endVolume = null
	  }
	  
	  if (params.endIssue) {
		  tipp.endIssue = params.endIssue
	  }
	  else {
		  tipp.endIssue = null
	  }
	  
	  if (params.coverageDepth) {
		  tipp.coverageDepth = params.coverageDepth
	  }
	  else {
		  tipp.coverageDepth = null
	  }
	  
	  if (params.coverageNote) {
		  tipp.coverageNote = params.coverageNote
	  }
	  else {
		  tipp.coverageNote = null
	  }
	  
	  if (params.embargo) {
		  tipp.embargo = params.embargo
	  }
	  else {
		  tipp.embargo = null
	  }
	  
	  if (params.hostPlatformURL) {
		  tipp.hostPlatformURL = params.hostPlatformURL
	  }
	  else {
		  tipp.hostPlatformURL = null
	  }
	  
	  if (params.status) {
		  def st =  RefdataValue.get(params.status)
		  if (st) {
			  tipp.status = st
		  }
	  }
	  else {
		  tipp.status = null
	  }
	  
	  if (params.statusReason) {
		  def str =  RefdataValue.get(params.statusReason)
		  if (str) {
			  tipp.statusReason = str
		  }
	  }
	  else {
		  tipp.statusReason = null
	  }
	  
	  if (params.delayedOA) {
		  def delayed =  RefdataValue.get(params.delayedOA)
		  if (delayed) {
			  tipp.delayedOA = delayed
		  }
	  }
	  else {
		  tipp.delayedOA = null
	  }
	  
	  if (params.hybridOA) {
		  def hybrid =  RefdataValue.get(params.hybridOA)
		  if (hybrid) {
			  tipp.hybridOA = hybrid
		  }
	  }
	  else {
		  tipp.hybridOA = null
	  }
	  
	  if (params.payment) {
		  def pay =  RefdataValue.get(params.payment)
		  if (pay) {
			  tipp.payment = pay
		  }
	  }
	  else {
		  tipp.payment = null
	  }
	  
	  tipp.save(flush:true, failOnError:true)
	  
	  redirect(url: request.getHeader('referer'))
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def list() {

    log.debug("list() :: ${params}");
    def result = [:]

    def platform_oids = null;
    if ( params.platformsToInclude?.trim()?.length() > 0 )
      platform_oids = params.platformsToInclude?.split(',');

    def package_oids = null;
    if ( params.pkgsToInclude?.trim()?.length() > 0 )
      package_oids = params.pkgsToInclude?.split(',');

    log.debug("platforms: ${platform_oids} ${platform_oids?.length}");
    log.debug("packages: ${package_oids} ${package_oids?.length}");

    def base_qry = "from TitleInstancePackagePlatform as tipp "
    def qry_params=[:]

    def has_where = false

    if ( params.title?.length() > 0 ) {
      if (!has_where) {
        base_qry+= ' where '; 
        has_where=true;
      }
      base_qry += ' tipp.title.title like :titlestr '
      qry_params['titlestr'] = "%${params.title.trim()}%"
    }

    if ( platform_oids?.length > 0 ) {
      if (!has_where) { base_qry+= ' where '; has_where=true; } else { base_qry+= ' and ' }

      base_qry += ' tipp.platform.id in :platformlist '
      qry_params['platformlist'] = platform_oids.collect { Long.parseLong(it.trim().split(':')[1]) }
    }

    if ( package_oids?.length > 0 ) {
      if (!has_where) { base_qry+= ' where '; has_where=true; } else { base_qry+= ' and ' }

      base_qry += ' tipp.pkg.id in :packagelist '
      qry_params['packagelist'] = package_oids.collect { Long.parseLong(it.trim().split(':')[1]) }
    }

    log.debug("Query: ${base_qry}");
    log.debug("Params: ${qry_params}");

    result.tipps = TitleInstancePackagePlatform.executeQuery("select tipp "+base_qry, qry_params, [max:30, offset:0]);
    result.tippTotal = TitleInstancePackagePlatform.executeQuery("select count(tipp) "+base_qry, qry_params )[0]

    result;
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def tippAction() {
    log.debug("Tipp action ${params}");
    switch ( params.tippAction ) {
      case 'platformMigration':
        redirect(action:'platformMigration', params:params);
        break;
      default:
        redirect(url: request.getHeader('referer'))
        break;
    }
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def platformMigration() {
    def result = [:]
    log.debug("platformMigration -- ${params}");

    if ( params.selectAll == 'on' ) {

      log.debug("Doing select all on platform migration");

      result.explicitTipps = false
      result.titleQuery = ''
      result.platforms = []
      result.packages = []
      result.h_count = params.h_count

      def platform_oids = null;
      if ( params.h_platforms?.trim()?.length() > 0 ) {
        platform_oids = params.h_platforms?.split(',');
        platform_oids.each { p ->
          result.platforms.add(genericOIDService.resolveOID(p))
        }
      }

      def package_oids = null;
      if ( params.h_pkgs?.trim()?.length() > 0 ) {
        package_oids = params.h_pkgs?.split(',');
        package_oids.each { p ->
          result.packages.add(genericOIDService.resolveOID(p))
        }
      }
    }
    else {
      log.debug("platformMigration :: explicit tipps");
      result.explicitTipps = true
      result.tipps = []
      params.keySet().each {
        if ( it.startsWith('tipp_') && ( params[it]=='on' ) ) {
          def tippid = it.substring(5,it.length());
          result.tipps.add(TitleInstancePackagePlatform.get(Long.parseLong(tippid)));
        }
      }
    }

    if ( params.migact == 'PROCESS' ) {

      def ok = true

      log.debug("Process");
      def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd');


      def new_platform = genericOIDService.resolveOID(params.newPlatform)
      def platform_date = sdf.parse(params.platformMigrationDate)

      if ( new_platform && platform_date ) {

        log.debug("Got platform and date, select all = ${params.selectAll}, params:${params}");

        if ( params.selectAll == 'on' ) {

          def base_qry = "from TitleInstancePackagePlatform as tipp "
          def qry_params=[:]

          def has_where = false

          if ( params.h_title?.length() > 0 ) {
            log.debug("Adding title....");
            if (!has_where) {
              base_qry+= ' where ';
              has_where=true;
            }
            base_qry += ' tipp.title.title like :titlestr '
            qry_params['titlestr'] = "%${params.h_title.trim()}%"
          }

          if ( result.platforms.size() > 0 ) {
            log.debug("Adding platforms....");
            if (!has_where) { base_qry+= ' where '; has_where=true; } else { base_qry+= ' and ' }

            base_qry += ' tipp.platform.id in :platformlist '
            qry_params['platformlist'] = result.platforms.collect { it.id }
          }

          if ( result.packages.size() > 0 ) {
            log.debug("Adding packages....");
            if (!has_where) { base_qry+= ' where '; has_where=true; } else { base_qry+= ' and ' }

            base_qry += ' tipp.pkg.id in :packagelist '
            qry_params['packagelist'] = result.packages.collect { it.id }
          }

          log.debug("Query: ${base_qry}");
          log.debug("Params: ${qry_params}");
          def migration_counter = 0;

          TitleInstancePackagePlatform.executeQuery("select tipp "+base_qry, qry_params, [offset:0]).each {
            log.debug("Call migrateTipp(${it},${platform_date},${new_platform}) count:${++migration_counter}");
            migrateTipp(it, platform_date, new_platform);
          }

          log.debug("Done iterating over tipps");
        }
        else {
          params.keySet().each {
            if ( it.startsWith('tipp_') && ( params[it]=='on' ) ) {
              def tippid = it.substring(5,it.length());
              def tipp_to_update = TitleInstancePackagePlatform.get(Long.parseLong(tippid));
              if ( tipp_to_update ) {
                migrateTipp(tipp_to_update, platform_date, new_platform);
              }
            }
          }
        }
      }
      else {
        log.warn("Unable to process new platform or date");
      }

      if ( ok ) {
        request.message="Updated ${params.h_count} TIPPS";
        redirect(action:'list');
      }
    }

    log.debug("platformMigration::All done");
    result;
  }

  private def migrateTipp(tipp, platform_date, new_platform) {
  
    log.debug("Migrate tipp ${tipp} to ${new_platform} as at ${platform_date}");

    try {
      def new_tipp = new TitleInstancePackagePlatform();
      new_tipp.accessStartDate = platform_date
      new_tipp.accessEndDate = tipp.accessEndDate
      new_tipp.startDate = tipp.startDate
      new_tipp.rectype = tipp.rectype
      new_tipp.startVolume = tipp.startVolume
      new_tipp.startIssue = tipp.startIssue
      new_tipp.endDate = tipp.endDate
      new_tipp.endVolume = tipp.endVolume
      new_tipp.endIssue = tipp.endIssue
      new_tipp.embargo = tipp.embargo
      new_tipp.coverageDepth = tipp.coverageDepth
      new_tipp.coverageNote = tipp.coverageNote
      new_tipp.impId = tipp.impId
      new_tipp.status = tipp.status
      new_tipp.option = tipp.option
      new_tipp.delayedOA = tipp.delayedOA
      new_tipp.hybridOA = tipp.hybridOA
      new_tipp.statusReason = tipp.statusReason
      new_tipp.payment = tipp.payment
      new_tipp.hostPlatformURL = tipp.hostPlatformURL
      new_tipp.coreStatusStart = tipp.coreStatusStart
      new_tipp.coreStatusEnd = tipp.coreStatusEnd
      new_tipp.accessType = tipp.accessType
      new_tipp.pkg = tipp.pkg
      new_tipp.platform = new_platform
      new_tipp.title = tipp.title
      new_tipp.sub = tipp.sub
      new_tipp.derivedFrom = tipp.derivedFrom
      new_tipp.masterTipp = tipp.masterTipp

      log.debug("Saving new TIPP to replace old TIPP ${tipp}");
      new_tipp.save(flush:true, failOnError:true);
      log.debug("New tipp id is ${new_tipp.id}");
  
      log.debug("updating old TIPP with new access end date of ${platform_date}");
      tipp.accessEndDate = platform_date
      tipp.save(flush:true, failOnError:true);
  
      log.debug("Terminating any old issue entitlements, creating new ones against the new tipp ${tipp}");
      IssueEntitlement.executeQuery('select ie from IssueEntitlement as ie where ie.tipp = :t',[t:tipp]).each { ie ->
        log.debug("Migrate IE ${ie.id}");
        def new_ie = new IssueEntitlement()
        new_ie.accessStartDate = platform_date
        new_ie.accessEndDate = ie.accessEndDate
        new_ie.status = ie.status
        new_ie.startDate = ie.startDate
        new_ie.startVolume = ie.startVolume
        new_ie.startIssue = ie.startIssue
        new_ie.endDate = ie.endDate
        new_ie.endVolume = ie.endVolume
        new_ie.endIssue = ie.endIssue
        new_ie.embargo = ie.embargo
        new_ie.coverageDepth = ie.coverageDepth
        new_ie.coverageNote = ie.coverageNote
        new_ie.ieReason = ie.ieReason
        new_ie.coreStatusStart = ie.coreStatusStart
        new_ie.coreStatusEnd = ie.coreStatusEnd
        new_ie.coreStatus = ie.coreStatus
        new_ie.medium = ie.medium
        new_ie.subscription = ie.subscription
        new_ie.tipp = new_tipp
        new_ie.save(flush:true, failOnError:true)
  
        ie.accessEndDate = platform_date
        log.debug("Saving new IE to replace old IE ${ie}");
        ie.save(flush:true, failOnError:true);
      }
  
    }
    catch ( Exception e ) {
      log.error("Problem with migrate tipp",e);
    }
    finally {
      log.debug("Migrate tipp completed");
    }
  }
}
