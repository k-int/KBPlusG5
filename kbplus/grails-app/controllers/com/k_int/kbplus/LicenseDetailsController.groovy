package com.k_int.kbplus

import grails.converters.*
import grails.plugin.springsecurity.annotation.Secured
import org.elasticsearch.groovy.common.xcontent.*
import groovy.xml.StreamingMarkupBuilder
import com.k_int.kbplus.auth.*;
import java.text.SimpleDateFormat


@Mixin(com.k_int.kbplus.mixins.PendingChangeMixin)
class LicenseDetailsController {

  def springSecurityService
  def docstoreService
  def gazetteerService
  def alertsService
  def genericOIDService
  def transformerService
  def exportService
  def institutionsService
  def pendingChangeService
  def executorWrapperService

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def index() {
    log.debug("licenseDetails: ${params}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    // result.institution = Org.findByShortcode(params.shortcode)
    result.license = License.get(params.id)
    result.transforms = grailsApplication.config.licenceTransforms

    if(!userAccessCheck(result.license,result.user,'view')) return

    log.debug("User access check passed");

    //used for showing/hiding the Licence Actions menus
    def admin_role = Role.findAllByAuthority("INST_ADM")
    result.canCopyOrgs = UserOrg.executeQuery("select uo.org from UserOrg uo where uo.user=(:user) and uo.formalRole=(:role) and uo.status in (:status)",[user:result.user,role:admin_role,status:[1,3]])

    if ( result.license.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }
  
    def license_reference_str = result.license.reference?:'NO_LIC_REF_FOR_ID_'+params.id

    def filename = "licenceDetails_${license_reference_str.replace(" ", "_")}"
    result.onixplLicense = result.license.onixplLicense;

    if(executorWrapperService.hasRunningProcess(result.license)){
      log.debug("PEndingChange processing in progress")
      result.processingpc = true
    }else{

      def pending_change_pending_status = RefdataCategory.lookupOrCreate("PendingChangeStatus", "Pending")
      def pendingChanges = PendingChange.executeQuery("select pc.id from PendingChange as pc where license=:l and ( pc.status is null or pc.status = :s ) order by pc.ts desc", 
                                                      [l:result.license, s:pending_change_pending_status]);

        //Filter any deleted subscriptions out of displayed links
        Iterator<Subscription> it = result.license.subscriptions.iterator()
        while(it.hasNext()){
            def sub = it.next();
            if(sub.status == RefdataCategory.lookupOrCreate('Subscription Status','Deleted')){
                it.remove();
            }
        }

      log.debug("pc result is ${result.pendingChanges}");
      if(result.license.incomingLinks.find{it?.isSlaved?.value == "Yes"} && pendingChanges){
        log.debug("Slaved lincence, auto-accept pending changes")
        def changesDesc = []
        pendingChanges.each{change ->
          if(!pendingChangeService.performAccept(change,request)){
            log.debug("Auto-accepting pending change has failed.")
          }else{
            changesDesc.add(PendingChange.get(change).desc)
          }
        }
        flash.message = changesDesc
      }else{
        result.pendingChanges = pendingChanges.collect{PendingChange.get(it)}
      }
    }
    result.availableSubs = getAvailableSubscriptions(result.license,result.user)
  
  //edit history count
  def eh_qry_params = [licClass:result.license.class.name, prop:LicenseCustomProperty.class.name,owner:result.license, licId:"${result.license.id}"]  
  result.historyLinesTotal = AuditLogEvent.executeQuery("select count(e.id) from AuditLogEvent as e where ( (className=:licClass and persistedObjectId=:licId) or (className = :prop and persistedObjectId in (select lp.id from LicenseCustomProperty as lp where lp.owner=:owner))) ", eh_qry_params)[0];
  
  //todo history count
  result.todoHistoryLinesTotal = PendingChange.executeQuery("select count(pc) from PendingChange as pc where pc.license=:l order by pc.ts desc", [l:result.license])[0];
  
    withFormat {
      html result
      json {
      response.setHeader("Content-disposition", "attachment; filename=\"${filename}.json\"")
      response.contentType = "text/json"
      render(template: 'licJson', model:result, contentType: "text/json", encoding: "UTF-8")
      }
      xml { 
        if ((params.transformId) && (result.transforms[params.transformId] != null)) {
            switch(params.transformId) {
              case "sub_ie":
                response.setHeader("Content-disposition", "attachment; filename=\"${filename}.csv\"")
          response.contentType = "text/csv"
          render(template: 'lic_ie_csv', model:result, contentType: "text/csv", encoding: "UTF-8")
                break;
              case "sub_pkg":
          response.setHeader("Content-disposition", "attachment; filename=\"${filename}.csv\"")
          response.contentType = "text/csv"
          render(template: 'lic_pkg_csv', model:result, contentType: "text/csv", encoding: "UTF-8")
                break;
            }
        }else{
      result.formatter = new java.text.SimpleDateFormat('yyyy-MM-dd')
      response.setHeader("Content-disposition", "attachment; filename=\"${filename}.xml\"")
      response.contentType = "text/xml"
      render(template: 'licXml', model:result, contentType: "text/xml", encoding: "UTF-8")
        }
        
      }
      csv {
    result.propSet = buildLicensePropertySet(result.license)
        response.setHeader("Content-disposition", "attachment; filename=\"${filename}.csv\"")
        response.contentType = "text/csv"
        render(template: 'lic_csv', model:result, contentType: "text/csv", encoding: "UTF-8")
      }
    }
  }
  
  def buildLicensePropertySet(license) {
    Set propertiesSet = new TreeSet();
    
    propertiesSet.addAll(license.customProperties.collect{ prop ->
      prop.type.name
    })
    return propertiesSet
    
  }
  
  def getAvailableSubscriptions(licence,user){
    def licenceInstitutions = licence?.orgLinks?.findAll{ orgRole ->
      orgRole.roleType?.value == "Licensee"
    }?.collect{  it.org?.hasUserWithRole(user,'INST_ADM')?it.org:null  }

    def subscriptions = null
    if(licenceInstitutions){
      def sdf = new java.text.SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
      def date_restriction =  new Date(System.currentTimeMillis())

      def base_qry = " from Subscription as s where  ( ( exists ( select o from s.orgRelations as o where o.roleType.value = 'Subscriber' and o.org in (:orgs) ) ) ) AND ( s.status.value != 'Deleted' ) AND (s.owner = null) "
      def qry_params = [orgs:licenceInstitutions]
      base_qry += " and s.startDate <= (:start) and s.endDate >= (:start) "
      qry_params.putAll([start:date_restriction])
      subscriptions = Subscription.executeQuery("select s ${base_qry}".toString(), qry_params)
    }
    return subscriptions
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def editLicense(){
    log.debug('getting edit licence modal: ' + params)
    def user = User.get(springSecurityService.principal.id)
    def license = License.get(params.id)
    
    def rdv_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc=:desc"
    def status_values = RefdataValue.executeQuery(rdv_qry,[desc:'License Status'])
    def yn_values = RefdataValue.executeQuery(rdv_qry,[desc:'YN'])
    def liccat_values = RefdataValue.executeQuery(rdv_qry,[desc:'LicenseCategory'])
    
    render(template:"editLicence", model:[license:license, status_values:status_values, yn_values:yn_values, liccat_values:liccat_values])
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processEditLicense(){
    log.debug('params: ' + params)
    
    def license = License.get(params.id)
    
    license.reference = params.reference
    license.contact = params.contact
    license.licenseUrl = params.licUrl
    license.licensorRef = params.licensorRef
    license.licenseeRef = params.licenseeRef
    license.jiscLicenseId = params.jiscLicenseId
    
    def sdf = new SimpleDateFormat('yyyy-MM-dd')
    if (params.startDate) {
      license.startDate = sdf.parse(params.startDate)
    }
    
    if (params.endDate) {
      license.endDate = sdf.parse(params.endDate)
    }
    
    if (params?.status) {
      def status =  RefdataValue.get(params.status)
      if (status) {
        license.status = status
      }
    }
    
    if (params?.ispublic) {
      def ispublic =  RefdataValue.get(params.ispublic)
      if (ispublic) {
        license.isPublic = ispublic
      }
    }
    
    if (params?.liccat) {
      def liccat =  RefdataValue.get(params.liccat)
      if (liccat) {
        license.licenseCategory = liccat
      }
    }
    
    log.debug('attempting to save edited license with id: ' + params.id)
    license.save(flush:true, failOnError:true)
    log.debug('saved edited license with id: ' + params.id)
    
    params.each { p ->
      if (p.key.startsWith('_incominglink.')) {
        def incomingid = p.key.substring(14);
        def link_to_edit = Link.get(incomingid)
        if (link_to_edit) {
          if (p.value) {
            def rdv_slaved = RefdataValue.get(p.value)
            if (rdv_slaved) {
              link_to_edit.isSlaved = rdv_slaved
            }
          }
          else {
            link_to_edit.isSlaved = null
          }
          link_to_edit.save(flush:true, failOnError:true)
        }
      }
    }
    
    def referer = request.getHeader('referer')
    if (params.anchor) {
      referer += params.anchor
    }
    redirect(url: referer)
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def exportLicense(){
    def license = License.get(params.id)
    def transforms = grailsApplication.config.licenceTransforms
    
    render(template:"/templates/licence_export_modal", model:[license:license, transforms:transforms])
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def linkToSubscription(){
    log.debug("linkToSubscription :: ${params}")
    if(params.subscription && params.licence){
      def sub = Subscription.get(params.subscription)
      def owner = License.get(params.licence)
      owner.addToSubscriptions(sub)
      owner.save(flush:true)
    }
    redirect controller:'licenseDetails', action:'index', params: [id:params.licence, defaultInstShortcode:params.defaultInstShortcode]

  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def consortia() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.license = License.get(params.id)
   
    def hasAccess
    def isAdmin
    if (result.user.getAuthorities().contains(Role.findByAuthority('ROLE_ADMIN'))) {
        isAdmin = true;
    }else{
       hasAccess = result.license.orgLinks.find{it.roleType?.value == 'Licensing Consortium' &&
      it.org.hasUserWithRole(result.user,'INST_ADM') }
    }
    if( !isAdmin && (result.license.licenseType != "Template" || hasAccess == null)) {
      flash.error = message(code:'licence.consortia.access.error')
      response.sendError(401) 
      return
    }
    if ( result.license.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }

    log.debug("consortia(${params.id}) - ${result.license}")
    def consortia = result.license?.orgLinks?.find{
      it.roleType?.value == 'Licensing Consortium'}?.org

    if(consortia){
      result.consortia = consortia
      result.consortiaInstsWithStatus = []
    def type = RefdataCategory.lookupOrCreate('Combo Type', 'Consortium')
    def institutions_in_consortia_hql = "select c.fromOrg from Combo as c where c.type = :t and c.toOrg = :o order by c.fromOrg.name"
    def consortiaInstitutions = Combo.executeQuery(institutions_in_consortia_hql, [t:type, o:consortia])

     result.consortiaInstsWithStatus = [ : ]
     def findOrgLicences = "SELECT lic from License AS lic WHERE exists ( SELECT link from lic.orgLinks AS link WHERE link.org = :o and link.roleType.value = 'Licensee') AND exists ( SELECT incLink from lic.incomingLinks AS incLink WHERE incLink.fromLic = :l ) AND lic.status.value != 'Deleted'"
     consortiaInstitutions.each{ 
        def queryParams = [ o:it, l:result.license]
        def hasLicence = License.executeQuery(findOrgLicences, queryParams)
        if (hasLicence){
          result.consortiaInstsWithStatus.put(it, RefdataCategory.lookupOrCreate("YNO","Yes") )    
        }else{
          result.consortiaInstsWithStatus.put(it, RefdataCategory.lookupOrCreate("YNO","No") )    
        }
      }
    }else{
      flash.error=message(code:'licence.consortia.noneset')
    }

    result
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def generateSlaveLicences(){
    def slaved = RefdataCategory.lookupOrCreate('YN','Yes')
    params.each { p ->
        if(p.key.startsWith("_create.") && (p.value=='on')){
         def orgID = p.key.substring(8)
         def orgaisation = Org.get(orgID)
          def attrMap = [defaultInstShortcode:orgaisation.shortcode,baselicense:params.baselicense,lic_name:params.lic_name,isSlaved:slaved]
          log.debug("Create slave licence for ${orgaisation.name}")
          attrMap.copyStartEnd = true
          institutionsService.copyLicence(attrMap);          
        }
    }
    redirect controller:'licenseDetails', action:'consortia', params: [id:params.baselicense]
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def links() {
    log.debug("licenseDetails id:${params.id}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    // result.institution = Org.findByShortcode(params.shortcode)
    result.license = License.get(params.id)

    if ( result.license.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }


    if ( ! result.license.hasPerm("view",result.user) ) {
      response.sendError(401);
      return
    }

    result
  }
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def edit_history() {
    log.debug("licenseDetails::edit_history : ${params}");

    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.license = License.get(params.id)

    if(!userAccessCheck(result.license,result.user,'view')) return

    if ( result.license.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }

    result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;
    result.offset = params.offset ?: 0;


    def qry_params = [licClass:result.license.class.name, prop:LicenseCustomProperty.class.name,owner:result.license, licId:"${result.license.id}"]

    result.historyLines = AuditLogEvent.executeQuery("select e from AuditLogEvent as e where (( className=:licClass and persistedObjectId=:licId ) or (className = :prop and persistedObjectId in (select lp.id from LicenseCustomProperty as lp where lp.owner=:owner))) order by e.dateCreated desc", qry_params, [max:result.max, offset:result.offset]);
    
    def propertyNameHql = "select pd.name from LicenseCustomProperty as licP, PropertyDefinition as pd where licP.id= :l and licP.type = pd"
    
    result.historyLines?.each{
      if(it.className == qry_params.prop ){
        def propertyName = LicenseCustomProperty.executeQuery(propertyNameHql,[l:it.persistedObjectId.toLong()])[0]
        it.propertyName = propertyName
      }
    }

    result.historyLinesTotal = AuditLogEvent.executeQuery("select count(e.id) from AuditLogEvent as e where ( (className=:licClass and persistedObjectId=:licId) or (className = :prop and persistedObjectId in (select lp.id from LicenseCustomProperty as lp where lp.owner=:owner))) ",qry_params)[0];

    result

  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def pendingChanges() {
    log.debug("subscriptionDetails::pendingChanges ${params}");
    def user = User.get(springSecurityService.principal.id)
    def license = License.get(params.id)
    
    if(!userAccessCheck(license,user,'view')) return
    
    def editable = false
    if ( license.hasPerm("edit",user) ) {
      editable = true
    }
    
    def processingpc = false
    if(executorWrapperService.hasRunningProcess(license)){
      processingpc = true
    }
    
    def max = params.max ? Integer.parseInt(params.max) : ( (response.format && response.format != "html" && response.format != "all" ) ? 10000 : user.defaultPageSize );
    def offset = (params.offset && response.format && response.format != "html") ? Integer.parseInt(params.offset) : 0;
    
    def pending_change_pending_status = RefdataCategory.lookupOrCreate("PendingChangeStatus", "Pending")
    def pendingChangesTotal = PendingChange.executeQuery("select count(pc) from PendingChange as pc where license=:l and ( pc.status is null or pc.status = :s )", [l:license, s:pending_change_pending_status])[0];
    
    if (offset >= pendingChangesTotal) {
      offset = 0
    }
    
    def pendingChanges = PendingChange.executeQuery("select pc.id from PendingChange as pc where license=:l and ( pc.status is null or pc.status = :s ) order by pc.ts desc", [l:license, s:pending_change_pending_status], [max:max, offset:offset]);
    
    def pcs = null
    if(license.incomingLinks.find{it?.isSlaved?.value == "Yes"} && pendingChanges) {
      log.debug("Slaved lincence, auto-accept pending changes")
      def changesDesc = []
      pendingChanges.each{change ->
        if(!pendingChangeService.performAccept(change,request)) {
          log.debug("Auto-accepting pending change has failed.")
        } else {
          changesDesc.add(PendingChange.get(change).desc)
        }
      }
      flash.message = changesDesc
    } else {
      pcs = pendingChanges.collect{PendingChange.get(it)}
    }
    
    render(template:"/templates/pendingChangesModal", model:[model:license, modelType:'Licence', pendingChanges:pcs, pendingChangesTotal:pendingChangesTotal, editable:editable, processingpc:processingpc, name:license?.reference?:'Licence Reference Unset', offset:offset, max:max, theme:'licences'])
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def todo_history() {
    log.debug("licenseDetails::todo_history : ${params}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.license = License.get(params.id)

    if(!userAccessCheck(result.license,result.user,'view')) return

    if ( result.license.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }
    result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;
    result.offset = params.offset ?: 0;

    result.todoHistoryLines = PendingChange.executeQuery("select pc from PendingChange as pc where pc.license=:l order by pc.ts desc", [l:result.license],[max:result.max,offset:result.offset]);

    result.todoHistoryLinesTotal = PendingChange.executeQuery("select count(pc) from PendingChange as pc where pc.license=:l order by pc.ts desc", [l:result.license])[0];
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def notes() {
    log.debug("licenseDetails id:${params.id}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    // result.institution = Org.findByShortcode(params.shortcode)
    result.license = License.get(params.id)

    if(!userAccessCheck(result.license,result.user,'view')) return

    if ( result.license.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def documents() {
    log.debug("licenseDetails id:${params.id}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.license = License.get(params.id)

    if(!userAccessCheck(result.license,result.user,'view')) return

    if ( result.license.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }
    result
  }



  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def deleteDocuments() {
    def ctxlist = []

    log.debug("deleteDocuments ${params}");

    def user = User.get(springSecurityService.principal.id)
    def l = License.get(params.instanceId);

    if(!userAccessCheck(l,user,'edit')) return

    params.each { p ->
      if (p.key.startsWith('_deleteflag.') ) {
        def docctx_to_delete = p.key.substring(12);
        log.debug("Looking up docctx ${docctx_to_delete} for delete");
        def docctx = DocContext.get(docctx_to_delete)
        docctx.status = RefdataCategory.lookupOrCreate('Document Context Status','Deleted');
        docctx.save(flush:true);
      }
    }

    redirect controller: 'licenseDetails', action:params.redirectAction, params:[shortcode:params.shortcode], id:params.instanceId, fragment:'docstab'
  }

  def userAccessCheck(licence,user,role_str){
    boolean result = true;
    log.debug("userAccessCheck(${licence},${user},${role_str})");

    if ( (licence==null || user==null ) || ( licence?.hasPerm(role_str,user) != true ) ) {
      log.warn("User ${user} attempted operation requiring perm ${role_str} on license ${licence}");
      flash.error = "You do not have permission to ${role_str} ${licence?.reference?:'this licence'}. Please request access to ${licence?.licensee?.name?:'licence institution'} on the profile page";
      response.sendError(401);
      result=false
    }

    log.debug("userAccessCheck returns ${result}");
    return result;
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def acceptChange() {
    processAcceptChange(params, License.get(params.id), genericOIDService)
    redirect controller: 'licenseDetails', action:'index',id:params.id
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def rejectChange() {
    processRejectChange(params, License.get(params.id))
    redirect controller: 'licenseDetails', action:'index',id:params.id
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def additionalInfo() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.license = License.get(params.id)
    if(!userAccessCheck(result.license,result.user,'view')) return

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def create() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processNewTemplateLicense() {
    if ( params.reference && ( ! params.reference.trim().equals('') ) ) {

      def template_license_type = RefdataCategory.lookupOrCreate('License Type','Template');
      def license_status_current = RefdataCategory.lookupOrCreate('License Status','Current');
      
      def new_template_license = new License(reference:params.reference,
                                             type:template_license_type,
                                             status:license_status_current).save(flush:true);
      redirect(action:'index', id:new_template_license.id);
    }
    else {
      redirect(action:'create');
    }
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def unlinkLicense() {
    log.debug("unlinkLicense :: ${params}")
    License license = License.get(params.license_id);
    OnixplLicense opl = OnixplLicense.get(params.opl_id);

    if(! (opl && license)){
      log.error("Something has gone mysteriously wrong. Could not get Licence or OnixLicence. params:${params} license:${license} onix: ${opl}")
      flash.message = "An error occurred when unlinking the ONIX-PL license";
      if (params.defaultInstShortcode) {
        redirect(action: 'index', id: license.id, params: [defaultInstShortcode:params.defaultInstShortcode]);
      }
      else {
        redirect(action: 'index', id: license.id);
      }
    }

    String oplTitle = opl?.title;
    DocContext dc = DocContext.findByOwner(opl.doc);
    Doc doc = opl.doc;

    log.debug("About to call license.removeFromDocuments(dc)");
    // If we don't save the license or the opl, neither of these will have any effect :/ I don't know what the
    // author of these statements intended, but the effect is likely not to be what was expected
    license.removeFromDocuments(dc);
    opl.removeFromLicenses(license);
    if ( license.onixplLicense?.id == params.opl_id ) {
      license.onixplLicense = null;
    }

    // If there are no more links to this ONIX-PL License then delete the license and
    // associated data
    if (opl.licenses.isEmpty()) {
    
          opl.usageTerm.each{
            it.usageTermLicenseText.each{
              it.delete(flush: true, failOnError: true)
            }
          }
          opl.delete(flush: true, failOnError: true);
          dc.delete(flush: true, failOnError: true);
          doc.delete(flush: true, failOnError: true);
    }

    license.save(flush:true, failOnError:true);

    if (license.hasErrors()) {
      license.errors.each {
        log.error("License error: " + it);
      }
      flash.message = "An error occurred when unlinking the ONIX-PL license '${oplTitle}'";
    } else {
      flash.message = "The ONIX-PL license '${oplTitle}' was unlinked successfully";
    }



    if (params.defaultInstShortcode) {
      redirect(action: 'index', id: license.id, params: [defaultInstShortcode:params.defaultInstShortcode]);
    }
    else {
      redirect(action: 'index', id: license.id);
    }
  }
}
