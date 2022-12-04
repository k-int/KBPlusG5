package com.k_int.kbplus

import com.k_int.kbplus.auth.*;
import grails.plugin.springsecurity.annotation.Secured
import grails.converters.*
import au.com.bytecode.opencsv.CSVReader
import com.k_int.custprops.PropertyDefinition
import grails.util.Holders
import java.security.MessageDigest
import org.apache.commons.io.FileUtils

class AdminController {

  def springSecurityService
  def dataloadService
  def zenDeskSyncService
  def juspSyncService
  def globalSourceSyncService
  def messageService
  def changeNotificationService
  def enrichmentService
  def sessionFactory
  def tsvSuperlifterService
  def executorWrapperService
  def docstoreService
  def executorService

  static boolean ftupdate_running = false

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def index() { }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def manageAffiliationRequests() {
    log.debug("manageAffiliationRequests()");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)

    // List all pending requests...
    result.pendingRequests = UserOrg.findAllByStatus(0, [sort:'dateRequested'])
    result
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def updatePendingChanges() {
  //Find all pending changes with licence FK and timestamp after summer 14
  // For those with changeType: CustomPropertyChange, change it to PropertyChange
  // on changeDoc add value propertyOID with the value of OID
    String theDate = "01/05/2014 00:00:00";
    def summer_date = new Date().parse("d/M/yyyy H:m:s", theDate)
    def criteria = PendingChange.createCriteria()
    def changes = criteria.list{
      isNotNull("license")
      ge("ts",summer_date)
      like("changeDoc","%changeType\":\"CustomPropertyChange\",%")
    }
    log.debug("Starting PendingChange Update. Found:${changes.size()}")

    changes.each{
        def parsed_change_info = JSON.parse(it.changeDoc)
        parsed_change_info.changeType = "PropertyChange"
        parsed_change_info.changeDoc.propertyOID = parsed_change_info.changeDoc.OID
        it.changeDoc = parsed_change_info
        it.save(failOnError:true)
    }
    log.debug("Pending Change Update Complete.")
    redirect(controller:'home')

  }


  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def actionAffiliationRequest() {
    log.debug("actionMembershipRequest");
    def req = UserOrg.get(params.req);
    def user = User.get(springSecurityService.principal.id)
    if ( req != null ) {
      switch(params.act) {
        case 'approve':
          req.status = 1;
          break;
        case 'deny':
          req.status = 2;
          break;
        default:
          log.error("FLASH UNKNOWN CODE");
          break;
      }
      // req.actionedBy = user
      req.dateActioned = System.currentTimeMillis();
      req.save(flush:true);
    }
    else {
      log.error("FLASH");
    }
    redirect(action: "manageAffiliationRequests")
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def hardDeletePkgs(){
    def result = [:]
    //If we make a search while paginating return to start
    if(params.search == "yes"){
        params.offset = 0
        params.search = null
    }
    result.user = User.get(springSecurityService.principal.id)
    result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

    if(params.id){
      def pkg = Package.get(params.id)
      def conflicts_list = []
      if(pkg.documents){
        def document_map = [:]
        document_map.name = "Documents"
        document_map.details = []
        pkg.documents.each{
          document_map.details += ['text':it.owner.title]
        }
        document_map.action = ['actionRequired':false,'text':"References will be deleted"]
        conflicts_list += document_map
      }
      if(pkg.subscriptions){
        def subscription_map = [:]
        subscription_map.name = "Subscriptions"
        subscription_map.details = []
        pkg.subscriptions.each{

          if(it.subscription.status.value != "Deleted"){
            subscription_map.details += ['link':createLink(controller:'subscriptionDetails', action: 'index', id:it.subscription.id), 'text': it.subscription.name]
          }else{
            subscription_map.details += ['link':createLink(controller:'subscriptionDetails', action: 'index', id:it.subscription.id), 'text': "(Deleted)" + it.subscription.name]
          }
        }
        subscription_map.action = ['actionRequired':true,'text':"Unlink subscriptions. (IEs will be removed as well)"]
        if(subscription_map.details){
          conflicts_list += subscription_map
        }
      }
      if(pkg.tipps){
        def tipp_map = [:]
        tipp_map.name = "TIPPs"
        def totalIE = 0
        pkg.tipps.each{
          totalIE += IssueEntitlement.countByTipp(it)
        }
        tipp_map.details = [['text':"Number of TIPPs: ${pkg.tipps.size()}"],
                ['text':"Number of IEs: ${totalIE}"]]
        tipp_map.action = ['actionRequired':false,'text':"TIPPs and IEs will be deleted"]
        conflicts_list += tipp_map
      }
      result.conflicts_list = conflicts_list
      result.pkg = pkg

      render(view: "hardDeleteDetails",model:result)
	  return
    }else{
      def criteria = Package.createCriteria()
      result.pkgs = criteria.list(max: result.max, offset:result.offset){
          if(params.pkg_name){
            ilike("name","${params.pkg_name}%")
          }
          order("name", params.order?:'asc')
      }
    }
    
    result
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def performPackageDelete(){
   if (request.method == 'POST'){
      def pkg = Package.get(params.id)
      Package.withTransaction { status ->
        log.info("Deleting Package ")
        log.info("${pkg.id}::${pkg}")
        pkg.pendingChanges.each{
          it.delete()
        }
        pkg.documents.each{
          it.delete()
        }
        pkg.orgs.each{
          it.delete()
        }

        pkg.subscriptions.each{
          it.delete()
        }
        pkg.tipps.each{
          it.delete()
        }
        pkg.delete()
      }
      log.info("Delete Complete.")
   }
   redirect controller: 'admin', action:'hardDeletePkgs'

  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def userMerge(){
     log.debug("AdminController :: userMerge :: ${params}");
     def usrMrgId = params.userToMerge == "null"?null:params.userToMerge
     def usrKeepId = params.userToKeep == "null"?null:params.userToKeep
     def result = [:]
     try {
       log.debug("Determine user merge operation : ${request.method}");
       switch (request.method) {
         case 'GET':
           if(usrMrgId && usrKeepId ){
             def usrMrg = User.get(usrMrgId)
             def usrKeep =  User.get(usrKeepId)
             log.debug("Selected users : ${usrMrg}, ${usrKeep}");
             result.userRoles = usrMrg.getAuthorities()
             result.userAffiliations =  usrMrg.getAuthorizedAffiliations()
             result.userMerge = usrMrg
             result.userKeep = usrKeep
           }else{
            log.error("Missing keep/merge userid ${params}");
            flash.error = "Please select'user to keep' and 'user to merge' from the dropdown."
           }
           log.debug("Get processing completed");
           break;
         case 'POST':
           log.debug("Post...");
           if(usrMrgId && usrKeepId){
             def usrMrg = User.get(usrMrgId)
             def usrKeep =  User.get(usrKeepId)
             def success = false
             try{
               log.debug("Copying user roles... from ${usrMrg} to ${usrKeep}");
               success = copyUserRoles(usrMrg, usrKeep)
               log.debug("Result of copyUserRoles : ${success}");
             }catch(Exception e){
              log.error("Exception while copying user roles.",e)
             }
             if(success){
               log.debug("Success");
               usrMrg.enabled = false
               log.debug("Save disable and save merged user");
               usrMrg.save(flush:true,failOnError:true)
               flash.message = "Rights copying successful. User '${usrMrg.displayName}' is now disabled."
             }else{
               flash.error = "An error occured before rights transfer was complete."
             }
           }else{
            flash.error = "Please select'user to keep' and 'user to merge' from the dropdown."
           }
           break
         default:
           break;
       }

       log.debug("Get all users");
       result.usersAll = User.list(sort:"display", order:"asc")
       log.debug("Get active users");
       def activeHQL = " from User as usr where usr.enabled=true or usr.enabled=null order by display asc"
       result.usersActive = User.executeQuery(activeHQL)
    }
    catch ( Exception e ) {
      log.error("Problem in user merge",e);
    }

    log.debug("Returning ${result}");
    result
  }

  def copyUserRoles(usrMrg, usrKeep){
    def mergeRoles = usrMrg.getAuthorities()
    def mergeAffil = usrMrg.getAuthorizedAffiliations()
    def currentRoles = usrKeep.getAuthorities()
    def currentAffil = usrKeep.getAuthorizedAffiliations()

    mergeRoles.each{ role ->
      if(!currentRoles.contains(role)){
        UserRole.create(usrKeep,role)
      }
    }
    mergeAffil.each{affil ->
      if(!currentAffil.contains(affil)){

        // We should check that the new role does not already exist
        def existing_affil_check = UserOrg.findByOrgAndUserAndFormalRole(affil.org,usrKeep,affil.formalRole);

        if ( existing_affil_check == null ) {
          log.debug("No existing affiliation");
          def newAffil = new UserOrg(org:affil.org,user:usrKeep,formalRole:affil.formalRole,status:3)
          if(!newAffil.save(flush:true,failOnError:true)){
            log.error("Probem saving user roles");
            newAffil.errors.each { e ->
              log.error(e);
            }
            return false
          }
        }
        else {
          if (affil.status != existing_affil_check.status) {
            existing_affil_check.status = affil.status
            existing_affil_check.save()
          }
          log.debug("Affiliation already present - skipping ${existing_affil_check}");
        }
      }
    }
    log.debug("copyUserRoles returning true");
    return true
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def showAffiliations() {
    log.debug("showAffiliations()");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.users = User.list()

    withFormat {
      html {
        render(view:'showAffiliations',model:result)
      }
      json {
        def r2 = []
        result.users.each { u ->
          def row = [:]
          row.username = u.username
          row.display = u.display
          row.instname = u.instname
          row.instcode = u.instcode
          row.email = u.email
          row.shibbScope = u.shibbScope
          row.enabled = u.enabled
          row.accountExpired = u.accountExpired
          row.accountLocked = u.accountLocked
          row.passwordExpired = u.passwordExpired
          row.affiliations = []
          u.affiliations.each { ua ->
            row.affiliations.add( [org: ua.org.shortcode, status: ua.status, formalRole:formalRole?.authority] )
          }
          r2.add(row)
        }
        render r2 as JSON
      }
    }
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def allNotes() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    def sc = DocContext.createCriteria()
    result.alerts = sc.list {
      alert {
        gt('sharingLevel', -1)
      }
    }

    result
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def dataCleanse() {
    // Sets nominal platform
    dataloadService.dataCleanse()
    redirect(url: request.getHeader('referer'))
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def titleAugment() {
    // Sets nominal platform
    dataloadService.titleAugment()
  }


  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def licenseLink() {
    if ( ( params.sub_identifier ) && ( params.lic_reference.length() > 0 ) ) {
    }
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def settings() {
    def result = [:]
    result.settings = Setting.list();
    result
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def toggleBoolSetting() {
    def result = [:]
    def s = Setting.findByName(params.setting);
    if ( s ) {
      if ( s.tp == 1 ) {
        if ( s.value == 'true' )
          s.value = 'false'
        else
          s.value = 'true'
      }
      s.save(flush:true)
    }
    redirect controller: 'admin', action:'settings'
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def esIndexUpdate() { 
    println("esIndexUpdate");
    try {
      log.debug("Update site mappings");
      dataloadService.updateSiteMapping();
      log.debug("manual start full text index");
      dataloadService.updateFTIndexes();
    }
    catch ( Exception e ) {
      log.error("Problem",e);
    }
    finally {
      log.debug("redirecting to home...");
    }

    println("esIndexUpdate");
    redirect(controller:'home')
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def fullReset() {

    if ( ftupdate_running == false ) {
      try {
        ftupdate_running = true
        new EventLog(event:'kbplus.fullReset',message:'Full Reset',tstp:new Date(System.currentTimeMillis())).save(flush:true)
        log.debug("Delete all existing FT Control entries");
        FTControl.withTransaction {
          FTControl.executeUpdate("delete FTControl c");
        }

        log.debug("Clear ES");
        dataloadService.clearDownAndInitES();

        log.debug("manual start full text index");
        dataloadService.updateFTIndexes();
      }
      finally {
        ftupdate_running = false
        log.debug("fullReset complete..");
      }
    }
    else {
      log.debug("FT update already running");
    }

    log.debug("redirecting to home...");
    redirect(controller:'home')

  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def forumSync() {
    redirect(controller:'home')
    zenDeskSyncService.doSync()
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def juspSync() {
    log.debug("juspSync()");
    juspSyncService.doSync()
    redirect(controller:'home')
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def globalSync() {
    log.debug("start global sync...");
    globalSourceSyncService.runAllActiveSyncTasks()
    log.debug("done global sync...");
    redirect(controller:'home')
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def manageGlobalSources() {
    def result=[:]
    log.debug("manageGlobalSources...");
    result.sources = GlobalRecordSource.list()
    result
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def newGlobalSource() {
    def result=[:]
    log.debug("manageGlobalSources...");
    result.newSource = GlobalRecordSource.findByIdentifier(params.identifier) ?: new GlobalRecordSource(
                                                                                         identifier:params.identifier,
                                                                                         name:params.name,
                                                                                         type:params.type,
                                                                                         haveUpTo:null,
                                                                                         uri:params.uri,
                                                                                         listPrefix:params.listPrefix,
                                                                                         fullPrefix:params.fullPrefix,
                                                                                         principal:params.principal,
                                                                                         credentials:params.credentials,
                                                                                         rectype:params.int('rectype'));
    result.newSource.save();

    redirect action:'manageGlobalSources'
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def manageContentItems() {
    def result=[:]

    result.items = ContentItem.list()

    result
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def newContentItem() {
    def result=[:]
    if ( ( params.key != null ) && ( params.content != null ) && ( params.key.length() > 0 ) && ( params.content.length() > 0 ) ) {

      def locale = ( ( params.locale != null ) && ( params.locale.length() > 0 ) ) ? params.locale : ''

      if ( ContentItem.findByKeyAndLocale(params.key,locale) != null ) {
        flash.message = 'Content item already exists'
      }
      else {
        ContentItem.lookupOrCreate(params.key, locale, params.content)
      }
    }

    redirect(action:'manageContentItems')
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def editContentItem() {
    def result=[:]
    if ( params.id ) {

      def contentItem = ContentItem.get(params.id)
      if ( contentItem != null ) {
        log.debug("Identified content item... edit");
        result.contentItem = contentItem
      }
      else {
        flash.message="Unable to locate content item for key ${idparts}"
        redirect(action:'manageContentItems');
      }
      if ( request.method.equalsIgnoreCase("post")) {
        contentItem.content = params.content
        contentItem.save(flush:true)
        messageService.update( contentItem.key, contentItem.locale)
        redirect(action:'manageContentItems');
      }
    }
    else {
      flash.message="Unable to parse content item id ${params.id} - ${idparts}"
      redirect(action:'manageContentItems');
    }

    result
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def forceSendNotifications() {
    changeNotificationService.aggregateAndNotifyChanges()
    redirect(controller:'home')
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def tippTransfer(){
    log.debug("tippTransfer :: ${params}")
    def result = [:]
    result.error = []

    if(params.sourceTIPP && params.targetTI){
      def ti = TitleInstance.get(params.long("targetTI"))
      def tipp = TitleInstancePackagePlatform.get(params.long("sourceTIPP"))
      if(ti && tipp){
        tipp.title = ti
        try{
          tipp.save(flush:true,failOnError:true)
          result.success = true
        }catch(Exception e){
          log.error(e)
          result.error += "An error occured while saving the changes."
        }
      }else{
        if(!ti) result.error += "No TitleInstance found with identifier: ${params.targetTI}."
        if(!tipp) result.error += "No TIPP found with identifier: ${params.sourceTIPP}" 
      }
    }

    result
  }

  @Secured(['ROLE_ADMIN','IS_AUTHENTICATED_FULLY'])
  def ieTransfer(){
    def result = [:]
    if(params.sourceTIPP && params.targetTIPP){
      result.sourceTIPPObj = TitleInstancePackagePlatform.get(params.sourceTIPP)
      result.targetTIPPObj = TitleInstancePackagePlatform.get(params.targetTIPP)
    }

    if(params.transfer == "Go" && result.sourceTIPPObj && result.targetTIPPObj){
      log.debug("Tranfering ${IssueEntitlement.countByTipp(result.sourceTIPPObj)} IEs from ${result.sourceTIPPObj} to ${result.targetTIPPObj}")
      def sourceIEs = IssueEntitlement.findAllByTipp(result.sourceTIPPObj)
      sourceIEs.each{
        it.setTipp(result.targetTIPPObj)
        it.save(flush:true, failOnError:true)
      }
    }

    result
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def titleMerge() {
    def result=[:]

    if ( ( params.titleIdToDeprecate != null ) &&
         ( params.titleIdToDeprecate.length() > 0 ) &&
         ( params.correctTitleId != null ) &&
         ( params.correctTitleId.length() > 0 ) ) {
      result.title_to_deprecate = TitleInstance.get(params.titleIdToDeprecate)
      result.correct_title = TitleInstance.get(params.correctTitleId)

      if ( params.MergeButton=='Go' ) {
        log.debug("Execute title merge....");
        result.title_to_deprecate.tipps.each { tipp ->
          log.debug("Update tipp... ${tipp.id}");
          tipp.title = result.correct_title
          tipp.save()
        }
        redirect(action:'titleMerge',params:[titleIdToDeprecate:params.titleIdToDeprecate, correctTitleId:params.correctTitleId])
      }

      TitleInstance.executeUpdate('update TitleInstance set parentTitle = :pref where parentTitle = :titleToDelete',[pref:result.correct_title, titleToDelete:result.title_to_deprecate]);
      TitleInstance.executeUpdate('update TitleHistoryEventParticipant set participant = :pref where participant = :titleToDelete',[pref:result.correct_title, titleToDelete:result.title_to_deprecate]);

      result.title_to_deprecate.status = RefdataCategory.lookupOrCreate(RefdataCategory.TI_STATUS, "Deleted")

      result.title_to_deprecate.save(flush:true);
    }
    result
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def orgsMerge() {

    //log.debug(params)

    def result=[:]

    if ( ( params.orgIdToDeprecate != null ) &&
         ( params.orgIdToDeprecate.length() > 0 ) &&
         ( params.correctOrgId != null ) &&
         ( params.correctOrgId.length() > 0 ) ) {
      result.org_to_deprecate = Org.get(params.orgIdToDeprecate)
      result.correct_org = Org.get(params.correctOrgId)

      if ( params.MergeButton=='Go' ) {
        log.debug("Execute title merge....");

        OrgRole.executeUpdate('update OrgRole set org=:newOrg where org=:oldOrg',[newOrg:result.correct_org, oldOrg:result.org_to_deprecate]);
        IdentifierOccurrence.executeUpdate('update IdentifierOccurrence set org=:newOrg where org=:oldOrg',[newOrg:result.correct_org, oldOrg:result.org_to_deprecate]);
        OrgVariantName.executeUpdate('update OrgVariantName set owner=:newOrg where owner=:oldOrg',[newOrg:result.correct_org, oldOrg:result.org_to_deprecate]);
        TitleInstitutionProvider.executeUpdate('update TitleInstitutionProvider set provider=:newOrg where provider=:oldOrg',[newOrg:result.correct_org, oldOrg:result.org_to_deprecate]);
        TitleInstitutionProvider.executeUpdate('update TitleInstitutionProvider set institution=:newOrg where institution=:oldOrg',[newOrg:result.correct_org, oldOrg:result.org_to_deprecate]);
        OrgCustomProperty.executeUpdate('update OrgCustomProperty set owner=:newOrg where owner=:oldOrg',[newOrg:result.correct_org, oldOrg:result.org_to_deprecate]);
        Combo.executeUpdate('update Combo set fromOrg=:newOrg where fromOrg=:oldOrg',[newOrg:result.correct_org, oldOrg:result.org_to_deprecate]);
        Combo.executeUpdate('update Combo set toOrg=:newOrg where toOrg=:oldOrg',[newOrg:result.correct_org, oldOrg:result.org_to_deprecate]);
        def newvm = new  OrgVariantName(owner:result.correct_org, variantName:result.org_to_deprecate.name).save(flush:true, failOnError:true);

        result.org_to_deprecate.status = RefdataCategory.lookupOrCreate(RefdataCategory.ORG_STATUS, "Deleted")
        result.org_to_deprecate.save(flush:true);

        redirect(action:'orgsMerge',params:[orgIdToDeprecate:params.orgIdToDeprecate, correctOrgId:params.correctOrgId])
      }
    }
    result
  }


  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def platformMerge() {

    //log.debug(params)

    def result=[:]

    if ( ( params.platformIdToDeprecate != null ) &&
            ( params.platformIdToDeprecate.length() > 0 ) &&
            ( params.correctPlatformId != null ) &&
            ( params.correctPlatformId.length() > 0 ) ) {
      result.platform_to_deprecate = Platform.get(params.platformIdToDeprecate)
      result.correct_platform = Platform.get(params.correctPlatformId)

      if ( result.platform_to_deprecate &&
           result.correct_platform &&
           params.MergeButton=='Go' ) {

        log.debug("Execute platform merge....");

        TitleInstancePackagePlatform.executeUpdate('update TitleInstancePackagePlatform set platform = :new where platform = :old',[new:result.correct_platform, old:result.platform_to_deprecate]);
        PlatformTIPP.executeUpdate('update PlatformTIPP set platform = :new where platform = :old',[new:result.correct_platform, old:result.platform_to_deprecate]);
        PlatformUrlTemplate.executeUpdate('update PlatformUrlTemplate set platform = :new where platform = :old',[new:result.correct_platform, old:result.platform_to_deprecate]);
        Package.executeUpdate('update Package set nominalPlatform = :new where nominalPlatform = :old',[new:result.correct_platform, old:result.platform_to_deprecate]);

        result.platform_to_deprecate.delete(flush:true, failOnError:true);

        redirect(action:'platformMerge',params:[platformIdToDeprecate:params.platformIdToDeprecate, correctPlatformId:params.correctPlatformId])
      }

      // result.platform_to_deprecate.status = RefdataCategory.lookupOrCreate(RefdataCategory.PLT_STATUS, "Deleted")
      // result.platform_to_deprecate.save(flush:true);
      
    }
    result
  }
  
  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def propertyMerge() {
	def result=[:]

	if ( ( params.propertyIdToDeprecate != null ) &&
		 ( params.propertyIdToDeprecate.length() > 0 ) &&
		 ( params.correctPropertyId != null ) &&
		 ( params.correctPropertyId.length() > 0 ) ) {
		 
	  def dep_prop = PropertyDefinition.get(params.propertyIdToDeprecate)
	  def cor_prop = PropertyDefinition.get(params.correctPropertyId)
	  
	  if (dep_prop.type != cor_prop.type) {
		  log.debug("Properties not the same type")
		  flash.message = "Properties are required to be of the same type."
		  redirect(action:'propertyMerge')
	  }
	  
	  if ((dep_prop.descr != 'Licence Property') || (cor_prop.descr != 'Licence Property')) {
		  log.debug("Properties not both licence properties")
		  flash.message = "Properties need to both be licence properties."
		  redirect(action:'propertyMerge')
	  }
	  
	  if ( params.MergeButton=='Go' ) {
		log.debug("Execute property merge....");
		def prop_exists
		def newProp
		def dep_prop_inst
		
		dep_prop.getOccurrencesOwner('com.k_int.kbplus.LicenseCustomProperty').each { license ->
		  log.debug("Update license... ${license.id}");
		  
		  prop_exists = license.customProperties.find{it.type.name == cor_prop.name}
		  
		  log.debug("${prop_exists}")
		  
		  if (prop_exists == null) {
			  newProp = PropertyDefinition.createPropertyValue(license, cor_prop)
			  if(newProp.hasErrors()) {
				log.error(newProp.errors)
			  } 
			  else {
				log.debug("New Property created: " + newProp.type.name)
				
				dep_prop_inst = license.customProperties.find{it.type.name == dep_prop.name}
				
				if (dep_prop_inst.stringValue) {
					log.debug("str value found")
					newProp.stringValue = dep_prop_inst.stringValue
				}
				else if (dep_prop_inst.intValue) {
					if (dep_prop_inst.intValue.getClass() == Integer.class) {
						newProp.intValue = dep_prop_inst.intValue
					} else {
					newProp.intValue = Integer.parseInt(dep_prop_inst.intValue)
					}
					log.debug("int value found")
				}
				else if (dep_prop_inst.decValue) {
					newProp.decValue = new BigDecimal(dep_prop_inst.decValue)
					log.debug("dec value found")
				}
				else if (dep_prop_inst.refValue) {
					def rdv = RefdataValue.get(dep_prop_inst.refValue.id)
					if (rdv) {
						newProp.refValue = rdv
					}
					log.debug("ref value found")
				}
				
				if (dep_prop_inst.note) {
					newProp.setNote(dep_prop_inst.note)
				}
				
				newProp.save(flush:true, failOnError:true)
				
				license.customProperties.remove(dep_prop_inst)
			    dep_prop_inst.delete(flush:true)
				
			  }
		  }
		  else {
			  log.debug("Licence ${license.id} already contains property: " + cor_prop.name)
			  flash.message = "Licences that already contain property " + cor_prop.name + " have not been merged."
		  }
		}
		
		redirect(action:'propertyMerge',params:[propertyIdToDeprecate:params.propertyIdToDeprecate, correctPropertyId:params.correctPropertyId])
		
	  }
		
	  result.property_to_deprecate = dep_prop
	  result.correct_property = cor_prop
		
	  
	}
	result
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def orgsExport() {
    response.setHeader("Content-disposition", "attachment; filename=\"orgsExport.csv\"")
    response.contentType = "text/csv"
    def out = response.outputStream
    out << "org.name,sector,consortia,id.jusplogin,id.JC,id.Ringold,id.UKAMF,iprange,membershipYesNo\n"
    Org.list().each { org ->
      def consortium = org.outgoingCombos.find{it.type.value=='Consortium'}.collect{it.toOrg.name}.join(':')

      out << "\"${org.name}\",\"${org.sector?:''}\",\"${consortium}\",\"${org.getIdentifierByType('jusplogin')?.value?:''}\",\"${org.getIdentifierByType('JC')?.value?:''}\",\"${org.getIdentifierByType('Ringold')?.value?:''}\",\"${org.getIdentifierByType('UKAMF')?.value?:''}\",\"${org.ipRange?:''}\",\"${org.membershipOrganisation}\"\n"
    }
    out.close()
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def orgsImport() {

    if ( request.method=="POST" ) {
      def upload_mime_type = request.getFile("orgs_file")?.contentType
      def upload_filename = request.getFile("orgs_file")?.getOriginalFilename()
      def input_stream = request.getFile("orgs_file")?.inputStream

      CSVReader r = new CSVReader( new InputStreamReader(input_stream, java.nio.charset.Charset.forName('UTF-8') ) )
      String[] nl;
      def first = true
	  def broken = false
      while ((nl = r.readNext()) != null && !broken) {
        if ( first ) {
          first = false; // Skip header
        }
        else {
          if ( nl.length == 10 ) {
            def candidate_identifiers = [
              'jusplogin':nl[3],
              'jusp':nl[4],
              'JC':nl[5],
              'Ringold':nl[6],
              'UKAMF':nl[7],
            ]

            // 8 == iprange 

            def membership_yn = null;
            if ( nl[9].trim().length() > 0 ) {
              switch ( nl[9].toLowerCase() ) {
                case 'y':
                case 'yes':
                  membership_yn = 'Yes'
                  break;
                case 'n':
                case 'no':
                  membership_yn = 'No'
                  break;
                default:
                  membership_yn = 'No'
                  break;
              }
            }

            log.debug("Load ${nl[0]}, ${nl[1]}, ${nl[2]} ${candidate_identifiers} ${nl[8]} ${nl[9]} (as ${membership_yn})");

            def o = Org.lookupOrCreate(nl[0],
                               nl[1],
                               nl[2],
                               candidate_identifiers,
                               nl[8],  // IPRange
                               membership_yn);

            log.debug("Result: ${o} ${o?.name}");
          }
          else {
			broken = true;
            //flash.message = 'Incorrect number of columns in import csv';
          }
        }
      }
	  
	  if (broken) {
		  flash.message = 'Incorrect number of columns in import csv';
	  }
	  else {
		  flash.message = 'CSV of Orgs Successfully loaded';
	  }
	  
	  redirect(action:'orgsImport')
    }
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def docstoreMigrate() {
    docstoreService.migrateToDb()
    redirect(controller:'home')
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def triggerHousekeeping() {
    log.debug("trigggerHousekeeping()");
    enrichmentService.initiateHousekeeping()
    redirect(controller:'home')
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def triggerDocstoreMigration() {
    log.debug("trigggerDocstoreMigration()");
    docstoreService.doMigration()
    redirect(controller:'home')
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def deleteGlobalSource() {
    GlobalRecordSource.removeSource(params.long('id'));
    redirect(action:'manageGlobalSources')
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def initiateCoreMigration() {
    log.debug("initiateCoreMigration...");
    enrichmentService.initiateCoreMigration()
    redirect(controller:'home')
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def titlesImport() {

    if ( request.method=="POST" ) {
      def upload_mime_type = request.getFile("titles_file")?.contentType
      def upload_filename = request.getFile("titles_file")?.getOriginalFilename()
      def input_stream = request.getFile("titles_file")?.inputStream

      CSVReader r = new CSVReader( new InputStreamReader(input_stream, java.nio.charset.Charset.forName('UTF-8') ) )
      String[] nl;
      String[] cols;
      def first = true
      while ((nl = r.readNext()) != null) {
        if ( first ) {
          first = false; // Skip header
          cols=nl;

          // Make sure that there is at least one valid identifier column
        }
        else {
          def title = null;
          def bindvars = []
          // Set up base_query
          def q = "Select distinct(t) from TitleInstance as t "
          def joinclause = ''
          def whereclause = ' where ';
          def i = 0;
          def disjunction_ctr = 0;
          cols.each { cn ->
            if ( cn == 'title.id' ) {
              if ( disjunction_ctr++ > 0 ) { whereclause += ' OR ' }
              whereclause += 't.id = ?'
              bindvars.add(new Long(nl[i]));
            }
            else if ( cn == 'title.title' ) {
              title = nl[i]
            }
            else if ( cn.startsWith('title.id.' ) ) {
              // Namespace and value
              if ( nl[i].trim().length() > 0 ) {
                if ( disjunction_ctr++ > 0 ) { whereclause += ' OR ' }
                joinclause = " join t.ids as id "
                whereclause += " ( id.identifier.ns.ns = ? AND id.identifier.value = ? ) "
                bindvars.add(cn.substring(9))
                bindvars.add(nl[i])
              }
            }
            i++;
          }

          log.debug("\n\n");
          log.debug(q);
          log.debug(joinclause);
          log.debug(whereclause);
          log.debug("${bindvars}");

          def title_search = TitleInstance.executeQuery(q+joinclause+whereclause,bindvars);
          log.debug("Search returned ${title_search.size()} titles");

          if ( title_search.size() == 0 ) {
            if ( title != null ) {
              log.debug("New title - create identifiers and title ${title}");
            }
            else {
              log.debug("NO match - no title - skip row");
            }
          }
          else if ( title_search.size() == 1 ) {
            log.debug("Matched one - see if any of the supplied identifiers are missing");
            def title_obj = title_search[0]
            def c = 0;
            cols.each { cn ->
              if ( cn.startsWith('title.id.' ) ) {
                def ns = cn.substring(9)
                def val = nl[c]
                log.debug("validate ${title_obj.title} has identifier with ${ns} ${val}");
                title_obj.checkAndAddMissingIdentifier(ns,val);
              }
              c++
            }
          }
          else {
            log.debug("Unable to continue - matched multiple titles");
          }
        }
      }
    }
  }
  
  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def uploadIssnL() {
    def result=[:]
    boolean hasStarted = false

    if (request.method == 'POST'){
      def input_stream = request.getFile("sameasfile")?.inputStream

      def target_file = File.createTempFile("issn-l-upload-${java.util.UUID.randomUUID().toString()}", ".tmp");
      FileUtils.copyInputStreamToFile(input_stream, target_file);

      def future = executorService.submit({
        try {
          log.debug("Uploading ISSN-L...");
          dataloadService.performUploadISSNL(target_file)
        }
        catch ( Exception e ) {
          log.error("Problem uploading issn-l mapping file",e);
        }
      } as java.util.concurrent.Callable)
      log.debug("Uploading ISSNL is returning");
      hasStarted = true
    }

    [hasStarted: hasStarted]
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def financeImport() {
    def result = [:];
    if (request.method == 'POST'){
      def input_stream = request.getFile("tsvfile")?.inputStream
      result.loaderResult = tsvSuperlifterService.load(input_stream,grailsApplication.config.financialImportTSVLoaderMappings,params.dryRun=='Y'?true:false)
    }
    result
  }
  
  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def uploadErrata() {
    def result = [:]

    boolean hasStarted = false

    if (request.method == 'POST'){
      def input_stream = request.getFile("eratta")?.inputStream
      CSVReader reader = new CSVReader( new InputStreamReader(input_stream, java.nio.charset.Charset.forName('UTF-8') ), ',' as char )
      def future = executorService.submit({
        performUploadErrata(reader)
      } as java.lang.Runnable)
      log.debug("Uploading ISSNL is returning");
      result.hasStarted = true
    }

    result;
  }

   private def performUploadErrata(reader) {

     def nl = reader.readNext()
     log.debug("Got header  : ${nl}");

     if ( nl ) {
       // get first row
       nl = reader.readNext()
       while ( nl ) {
         try {
           log.debug("Got row  : ${nl}");
  
           def when_clause = "identifier=\"${nl[0]}\" AND key(title)=\"${com.k_int.kbplus.utils.TextUtils.generateKeyTitle(nl[1])}\"".toString()
           def then_clause = "identifier=\"${nl[2]}\"".toString()
           MessageDigest md5_digest = MessageDigest.getInstance("MD5");
           md5_digest.update(when_clause.getBytes())
           byte[] md5sum = md5_digest.digest();
           def fingerprint = new BigInteger(1, md5sum).toString(16);
  
           def e = Erratum.findByFingerprint(fingerprint) 
           if ( e ) {
             log.debug("Matched existing erratum");
           }
           else {
             log.debug("create new erratum");
             e = new Erratum(fingerprint:fingerprint, whenClause:when_clause, thenClause:then_clause, action:'use', param1:nl[2], comment:nl[3]).save(flush:true, failOnError:true);
           }
  
           // See if this rule applies to anything in the database right now
           def identifier_parts = nl[0].split(':')
           log.debug("Checking if uploaded correction matches any existing ids ${identifier_parts}");
  
           if ( identifier_parts.length == 2 ) {
             def ios = IdentifierOccurrence.executeQuery('select io from IdentifierOccurrence as io where io.identifier.ns.ns = :ns and io.identifier.value=:value and io.ti.keyTitle = :kt',
                                                                      [ns:identifier_parts[0],value:identifier_parts[1],kt:com.k_int.kbplus.utils.TextUtils.generateKeyTitle(nl[1])]);
             if ( ios.size() == 1 ) {
               log.debug("Rule matched -- update");
               def new_identifier_parts = nl[2].split(':')
               if ( new_identifier_parts.length == 2 ) {
                 def new_identifier = Identifier.lookupOrCreateCanonicalIdentifier(new_identifier_parts[0],new_identifier_parts[1]);
                 ios[0].identifier = new_identifier
                 ios[0].save(flush:true, failOnError:true);
               }
               else {
                 log.error("Unable to parse replacement identifier -- ${nl[2]}");
               }
             }
           }
  
         }
         catch( Exception e ) {
           log.error("problem",e);
         }
         nl = reader.readNext()
       }
     }
   }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
   def jobs() {
     def result=[:]
     result.activeFutures = executorWrapperService.getActiveFutures()
     result
   }
}
