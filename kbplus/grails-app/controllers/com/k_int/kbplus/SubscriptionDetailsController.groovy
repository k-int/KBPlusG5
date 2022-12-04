package com.k_int.kbplus

import grails.converters.*
import grails.plugin.springsecurity.annotation.Secured

import org.elasticsearch.groovy.common.xcontent.*
import org.apache.poi.ss.usermodel.*
import org.apache.poi.hssf.usermodel.*
import org.apache.poi.hssf.util.HSSFColor

import groovy.xml.MarkupBuilder
import groovy.xml.StreamingMarkupBuilder

import com.k_int.kbplus.auth.*;
import com.k_int.kbplus.AuditLogEvent


//For Transform
import groovyx.net.http.*
import static groovyx.net.http.ContentType.*
import static groovyx.net.http.Method.*

import java.text.SimpleDateFormat

@Mixin(com.k_int.kbplus.mixins.PendingChangeMixin)
class SubscriptionDetailsController {

  def springSecurityService
  def gazetteerService
  def alertsService
  def genericOIDService
  def transformerService
  def exportService
  def pendingChangeService
  def institutionsService
  def ESSearchService
  def executorWrapperService
  def executorService
  def dashboardService
  def renewals_reversemap = ['subject':'subject', 'provider':'provid', 'pkgname':'tokname' ]

  private static String COST_PERIODS_FOR_SUB =
    'select min(co.startDate), max(co.endDate) from CostItem as co where co.sub = :sub';

  private static String COST_ITEMS_FOR_SUB =
     'select ci from CostItem as ci where ci.sub = :sub and ci.startDate > :start';

  private static String INVOICES_FOR_SUB_HQL =
     'select co.invoice, sum(co.costInLocalCurrencyIncVAT), sum(co.costInBillingCurrencyIncVAT), co from CostItem as co where co.sub = :sub group by co.invoice order by min(co.invoice.startDate) desc';

  private static String USAGE_FOR_SUB_IN_PERIOD =
    'select f.reportingYear, f.reportingMonth+1, sum(f.factValue) '+
    'from Fact as f, TitleInstance as ti, TitleInstancePackagePlatform as tipp, IssueEntitlement as ie '+
    'where f.factFrom >= :start and f.factTo <= :end and f.factType.value=:jr1a and ' +
    'f.inst = :inst and ' +
    'f.relatedTitle = ti.id and ' +
    'tipp.title.id = ti.id and ' +
    'ie.tipp.id = tipp.id and ' +
    'ie.subscription = :sub ' +
    'group by f.reportingYear, f.reportingMonth order by f.reportingYear desc, f.reportingMonth desc';

  private static String TOTAL_USAGE_FOR_SUB_IN_PERIOD =
    'select sum(f.factValue) '+
    'from Fact as f, TitleInstance as ti, TitleInstancePackagePlatform as tipp, IssueEntitlement as ie '+
    'where f.factFrom >= :start and f.factTo <= :end and f.factType.value=:jr1a and ' +
    'f.relatedTitle = ti.id and ' +
    'f.inst = :inst and ' +
    'tipp.title.id = ti.id and ' +
    'ie.tipp.id = tipp.id and ' +
    'ie.subscription = :sub';


  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def index() {

    def result = [:]

    result.user = User.get(springSecurityService.principal.id)
    result.subscriptionInstance = Subscription.get(params.id)

    if(!userAccessCheck( result.subscriptionInstance, result.user, 'view')) return

    log.debug("subscriptionDetails id:${params.id} format=${response.format}");

    result.transforms = grailsApplication.config.subscriptionTransforms

    result.max = params.max ? Integer.parseInt(params.max) : ( (response.format && response.format != "html" && response.format != "all" ) ? 10000 : result.user.defaultPageSize );
    result.offset = (params.offset && response.format && response.format != "html") ? Integer.parseInt(params.offset) : 0;

    log.debug("max = ${result.max}");

    def pending_change_pending_status = RefdataCategory.lookupOrCreate("PendingChangeStatus", "Pending")
    def pendingChanges = PendingChange.executeQuery("select pc.id from PendingChange as pc where subscription=? and ( pc.status is null or pc.status = ? ) order by ts desc", [result.subscriptionInstance, pending_change_pending_status ]);

    if(result.subscriptionInstance?.isSlaved?.value == "Auto" && pendingChanges){
      log.debug("Slaved subscription, auto-accept pending changes")
      def changesDesc = []
      pendingChanges.each{change ->
        if(!pendingChangeService.performAccept(change,request)){
          log.debug("Auto-accepting pending change has failed.")
        }else{
          changesDesc.add(PendingChange.get(change).desc)
        }
      }
      request.message = changesDesc
    }else{
      result.pendingChanges = pendingChanges.collect{PendingChange.get(it)}
    }

  //licence icon info
  if (result.subscriptionInstance?.owner?.customProperties) {

    result.subscriptionInstance?.owner?.customProperties.each { prop ->

      def icon = workoutLicenceIcon(prop?.refValue?.icon)

      switch (prop.type.name) {
        case "Include in VLE":
        result.licVLE = icon[0]
        result.licVLE_info = icon[1]
        break;
        
      case "Include In Coursepacks":
        result.licCoursepacks = icon[0]
        result.licCoursepacks_info = icon[1]
        break;
        
      case "ILL - InterLibraryLoans":
        result.licILL = icon[0]
        result.licILL_info = icon[1]
        break;
        
      case "Walk In Access":
        result.licWalkIn = icon[0]
        result.licWalkIn_info = icon[1]
        break;
      
      case "Remote Access":
        result.licRA = icon[0]
        result.licRA_info = icon[1]
        break;
        
      case "Alumni Access":
        result.licAA = icon[0]
        result.licAA_info = icon[1]
        break;
        
      default:
        break;
      }
    }
  }
  else {
    result.licVLE = ""
    result.licCoursepacks = ""
    result.licILL = ""
    result.licWalkIn = ""
    result.licRA = ""
    result.licAA = ""
    
    result.licVLE_info = ""
    result.licCoursepacks_info = ""
    result.licILL_info = ""
    result.licWalkIn_info = ""
    result.licRA_info = ""
    result.licAA_info = ""
  }

    // If transformer check user has access to it
    if(params.transforms && !transformerService.hasTransformId(result.user, params.transforms)) {
      flash.error = "It looks like you are trying to use an unvalid transformer or one you don't have access to!"
      params.remove("transforms")
      params.remove("format")
      redirect action:'currentTitles', params:params
    }

    if ( result.subscriptionInstance == null ) {
      flash.error = "No subscription found -- is it deleted?"
      redirect controller:'home', action:'index'
    }

    // result.institution = Org.findByShortcode(params.shortcode)
    result.institution = result.subscriptionInstance.subscriber
    if ( result.institution ) {
      result.subscriber_shortcode = result.institution.shortcode
      result.institutional_usage_identifier = result.institution.getIdentifierByType('JUSP');
    }

    if ( result.subscriptionInstance.isEditableBy(result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }

    if (params.mode == "advanced"){
      params.asAt = null
    }

    def deleted_ie = RefdataCategory.lookupOrCreate('Entitlement Issue Status','Deleted');
    def qry_params = [result.subscriptionInstance]

    def date_filter
    if(params.asAt && params.asAt.length() > 0) {
      def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd');
      date_filter = sdf.parse(params.asAt)
      result.as_at_date = date_filter;
      result.editable = false;
    }else{
      date_filter = new Date()
      result.as_at_date = date_filter;
    }

    // def num_core_assertions_subqry = '(select count(ca) from CoreAssertion as ca where ca.tiinp';

    def base_qry = "from IssueEntitlement as ie where ie.subscription = ? "
    if ( params.filter ) {
      if ( params.mode != 'advanced' ) {
        // If we are not in advanced mode, hide IEs that are not current, otherwise filter
        // base_qry += "and ie.status <> ? and ( ? >= coalesce(ie.accessStartDate,subscription.startDate) ) and ( ( ? <= coalesce(ie.accessEndDate,subscription.endDate) ) OR ( ie.accessEndDate is null ) )  "
        // qry_params.add(deleted_ie);
        base_qry += "and ( ? >= coalesce(ie.accessStartDate,subscription.startDate) ) and ( ( ? <= coalesce(ie.accessEndDate,subscription.endDate) ) OR ( ie.accessEndDate is null ) )  "
        qry_params.add(date_filter);
        qry_params.add(date_filter);
      }
      base_qry += "and ( ( lower(ie.tipp.title.title) like ? ) or ( exists ( from IdentifierOccurrence io where io.ti.id = ie.tipp.title.id and io.identifier.value like ? ) ) ) "
      qry_params.add("%${params.filter.trim().toLowerCase()}%") 
      qry_params.add("%${params.filter}%")
    }
    else {
      if ( params.mode != 'advanced' ) {
        // If we are not in advanced mode, hide IEs that are not current, otherwise filter

        base_qry += " and ( ? >= coalesce(ie.accessStartDate,subscription.startDate) ) and ( ( ? <= coalesce(ie.accessEndDate,subscription.endDate) ) OR ( ie.accessEndDate is null ) ) "
        qry_params.add(date_filter);
        qry_params.add(date_filter);
      }
    }

    base_qry += " and ie.status <> ? "
    qry_params.add(deleted_ie);

    if ( params.pkgfilter && ( params.pkgfilter != '' ) ) {
      base_qry += " and ie.tipp.pkg.id = ? "
      qry_params.add(Long.parseLong(params.pkgfilter));
    }

    def sort_clause = null;
    if ( ( params.sort != null ) && ( params.sort.length() > 0 ) ) {
	    def sortOpts = params.sort.tokenize(':')
	    if (sortOpts.size() == 2) {
	      sort_clause = "order by ie.${sortOpts[0]} ${sortOpts[1]} "
	    }
	    else {
	      sort_clause = "order by ie.tipp.title.title asc"
	    }
    }
    else {
      sort_clause = "order by ie.tipp.title.title asc"
    }

    result.num_sub_rows = IssueEntitlement.executeQuery("select count(ie) "+base_qry, qry_params )[0]

  
    //edit history count for new display on page
    def history_qry_params = [result.subscriptionInstance.class.name, "${result.subscriptionInstance.id}"]
    result.historyLinesTotal = AuditLogEvent.executeQuery("select count(e.id) from AuditLogEvent as e where className=? and persistedObjectId=?",history_qry_params)[0];
  
    //todo history count for new display on page
    result.todoHistoryLinesTotal = PendingChange.executeQuery("select count(pc) from PendingChange as pc where subscription=?", result.subscriptionInstance)[0];
  
    //expected and previous counts for new displays on page
    def exp_prev_qry_params = [result.subscriptionInstance]
    def exp_prev_date_filter = new Date();
    exp_prev_qry_params.add(exp_prev_date_filter);
  
    def exp_prev_base_qry = "from IssueEntitlement as ie where ie.subscription = ? and ie.status.value != 'Deleted' "
    def exp_qry = exp_prev_base_qry + "and (coalesce(ie.accessStartDate,subscription.startDate) > ? )"
    def prev_qry = exp_prev_base_qry + "and ( coalesce(ie.accessEndDate,subscription.endDate) <= ? )"
	
	result.expectedTitles = IssueEntitlement.executeQuery("select ie "+exp_qry, exp_prev_qry_params)
	result.previousTitles = IssueEntitlement.executeQuery("select ie "+prev_qry, exp_prev_qry_params)
  
    result.expectedCount = IssueEntitlement.executeQuery("select count(ie) "+exp_qry, exp_prev_qry_params )[0]
    result.previousCount = IssueEntitlement.executeQuery("select count(ie) "+prev_qry, exp_prev_qry_params )[0]

    log.debug("subscriptionInstance returning... ${result.num_sub_rows} rows ");
    def filename = "subscriptionDetails_${result.subscriptionInstance.identifier}"

    result.costItems = getCostPerUseData(result.subscriptionInstance);
	
	if ( params.sort?.startsWith('core_status') ) {
		log.debug("Retrieving all subscription entitlements")
		result.entitlements = IssueEntitlement.executeQuery("select ie "+base_qry+" "+sort_clause, qry_params);
		sortOnCoreStatus(result, params, date_filter)
		
	}
	else {
		result.entitlements = IssueEntitlement.executeQuery("select ie "+base_qry+" "+sort_clause, qry_params, [max:result.max, offset:result.offset]);
	}

    if(executorWrapperService.hasRunningProcess(result.subscriptionInstance)){
      result.processingpc = true
    }
    withFormat {
      html {
        result
      }
      csv {
        response.contentType = "text/csv"
        if ( (params.transformId == "kbplus") || (params.transformId == "alma") ) {
		  response.setHeader("Content-disposition", "attachment; filename=\"${filename}.csv\"")
        }
        else {
		  def transformFilename = filename + "_" + params.transformId
		  response.setHeader("Content-disposition", "attachment; filename=\"${transformFilename}.txt\"")
        }
		render(template: params.transformId+'_csv', model:result, contentType: "text/csv", encoding: "UTF-8")
      }
      json {
        log.debug("Respond subJson, result...");
		response.setHeader("Content-disposition", "attachment; filename=\"${filename}.json\"")
		response.contentType = "text/json"
		render(template: 'subJson', model:result, contentType: "text/json", encoding: "UTF-8")
      }
      xml {
		result.formatter = new java.text.SimpleDateFormat('yyyy-MM-dd')
		response.setHeader("Content-disposition", "attachment; filename=\"${filename}.xml\"")
		response.contentType = "text/xml"
		render(template: 'subXml', model:result, contentType: "text/xml", encoding: "UTF-8")
      }
    }
  }
  
  def workoutLicenceIcon(icon) {

    def result = ["", ""]

    if (icon == "greenTick") {
      result = ["yes", "done"]
    }
    else if (icon == "purpleQuestion") {
      result = ["neither", "info_outline"]
    }
    else if (icon.equals("redCross")) {
      result = ["no", "clear" ]
    }
    else {
      result = ["", "" ]
    }


  
    result
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def exportSubscription(){
    def subscription = Subscription.get(params.id)
    def transforms = grailsApplication.config.subscriptionTransforms
    
    render(template:"/templates/subscriptions_export_modal", model:[subscriptionInstance:subscription, transforms:transforms])
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def editSubscription(){
    def result = [:]
    log.debug('getting edit modal: ' + params)
    result.user = User.get(springSecurityService.principal.id)
    result.subscriptionInstance = Subscription.get(params.id)
    
    //look at ripping off possible Licenses for subscription code
    def subscriber = result.subscriptionInstance.getSubscriber();
    if ( subscriber ) {
    def licensee_role = RefdataCategory.lookupOrCreate('Organisational Role','Licensee');
    def template_license_type = RefdataCategory.lookupOrCreate('License Type','Template');
    def qry_params = [subscriber, licensee_role]
    def qry = "select l from License as l where exists ( select ol from OrgRole as ol where ol.lic = l AND ol.org = ? and ol.roleType = ? ) AND l.status.value != 'Deleted' order by l.reference"
    def license_list = License.executeQuery(qry, qry_params);
    result.licences = license_list
    }
    
    def child_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='Relationship'"
    def child = RefdataValue.executeQuery(child_qry,[])
    
    render(template:"editSubscription", model:[subscriptionInstance:result.subscriptionInstance, licences:result?.licences, childs:child])//,model:[message:params.message,coreDates:dates,tipID:tip.id,tip:tip])
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processEditSubscription(){
    log.debug('params: ' + params)
    
    def subscription = Subscription.get(params.id)
    
    subscription.name = params.subscriptionName
    if (params.licence) {
      def lic = License.get(params.licence)
      if (lic) {
        subscription.owner = lic
      }
    }
    else {
      subscription.owner = null
    }
    
    def sdf = new SimpleDateFormat('yyyy-MM-dd')
    subscription.startDate = sdf.parse(params.startDate)
    subscription.endDate = sdf.parse(params.endDate)
    
    if (params?.manualRenewalDate) {
      subscription.manualRenewalDate = sdf.parse(params.manualRenewalDate)
    }
    
    subscription.cancellationAllowances = params?.cancellationAllowances
    subscription.impId = params?.impId
    
    if (params?.child) {
      def child =  RefdataValue.get(params.child)
      if (child) {
        subscription.isSlaved = child
      }
    }
    
    log.debug('attempting to save edited subscription with id: ' + params.id)
    subscription.save(flush:true, failOnError:true)
    log.debug('saved edited subscription with id: ' + params.id)
    
    //redirect action: 'index', id:params.id, params:[defaultInstShortcode:params.defaultInstShortcode]
    def referer = request.getHeader('referer')
    if (params.anchor) {
      referer += params.anchor
    }
    redirect(url: referer)
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def removeLicence() {
    log.debug('params: ' + params)
    
    def subscription = Subscription.get(params.id)
    subscription.owner = null
    
    log.debug('attempting to save edited subscription with id: ' + params.id)
    subscription.save(flush:true, failOnError:true)
    log.debug('saved edited subscription with id: ' + params.id)
    
    def referer = request.getHeader('referer')
    if (params.anchor) {
      referer += params.anchor
    }
    redirect(url: referer)
  }
  
  def sortOnCoreStatus(result,params, date_filter){
	log.debug("Sorting entitlements based on core status")
  
	if(params.sort.endsWith('desc')) {
		result.entitlements.reverse(true)
		result.entitlements.sort{it.getTIP()?.coreStatus(date_filter)}
		result.entitlements.reverse(true)
	}
	else {
		result.entitlements.sort{it.getTIP()?.coreStatus(date_filter)}
	}
	
	log.debug("Converting entitlements to paginated list")
	int issue = 0
	def sortedCoreTitles = new ArrayList()
	for (ie in result.entitlements){
		if (issue >= result.offset) {
			 sortedCoreTitles.add(ie)
		}
		issue++
		
		if (sortedCoreTitles.size() == (result.max) ) {
			 break;
		}
	}
	result.entitlements = sortedCoreTitles
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def unlinkPackage(){
    log.debug("unlinkPackage :: ${params}")
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.subscription = Subscription.get(params.subscription.toLong())
    result.package = Package.get(params.package.toLong())
    def query = "from IssueEntitlement ie, Package pkg where ie.subscription =:sub and pkg.id =:pkg_id and ie.tipp in ( select tipp from TitleInstancePackagePlatform tipp where tipp.pkg.id = :pkg_id ) "
    def queryParams = [sub:result.subscription,pkg_id:result.package.id]

    if (result.subscription.isEditableBy(result.user) ) {
      result.editable = true
      if(params.confirmed){
      //delete matches
      IssueEntitlement.withTransaction { status ->
        removePackagePendingChanges(result.package.id,result.subscription.id,params.confirmed)
        def deleteIdList = IssueEntitlement.executeQuery("select ie.id ${query}".toString(),queryParams)
        if(deleteIdList) IssueEntitlement.executeUpdate("delete from IssueEntitlement ie where ie.id in (:delList)",[delList:deleteIdList]);
        SubscriptionPackage.executeUpdate("delete from SubscriptionPackage sp where sp.pkg=? and sp.subscription=? ",[result.package,result.subscription])
      }
      }else{
        def numOfPCs = removePackagePendingChanges(result.package.id,result.subscription.id,params.confirmed)

        def numOfIEs = IssueEntitlement.executeQuery("select count(ie) ${query}".toString(),queryParams)[0]
        def conflict_item_pkg = [name:"Linked Package",details:[['link':createLink(controller:'packageDetails', action: 'show', id:result.package.id), 'text': result.package.name]],action:[actionRequired:false,text:'Link will be removed']]
        def conflicts_list = [conflict_item_pkg]

        if(numOfIEs > 0){
          def conflict_item_ie = [name:"Package IEs",details:[['text': 'Number of IEs: '+numOfIEs]],action:[actionRequired:false,text:'IEs will be deleted']]
          conflicts_list += conflict_item_ie
        }
        if(numOfPCs > 0){
          def conflict_item_pc = [name:"Pending Changes",details:[['text': 'Number of PendingChanges: '+ numOfPCs]],action:[actionRequired:false,text:'Pending Changes will be deleted']]
          conflicts_list += conflict_item_pc
        }

        return render(template: "unlinkPackageModal",model:[pkg:result.package,subscription:result.subscription,conflicts_list:conflicts_list, defaultInstShortcode:params.defaultInstShortcode])
      }
    }else{
      result.editable = false
    }

    def params_sc = []
    if (params.defaultInstShortcode) {
      params_sc = [defaultInstShortcode:params.defaultInstShortcode]
  }
    redirect action: 'index', id:params.subscription, params:params_sc

  }
  def removePackagePendingChanges(pkg_id,sub_id,confirmed){

    def tipp_class = TitleInstancePackagePlatform.class.getName()
    def tipp_id_query = "from TitleInstancePackagePlatform tipp where tipp.pkg.id = ?"
    def change_doc_query = "from PendingChange pc where pc.subscription.id = ? "
    def tipp_ids = TitleInstancePackagePlatform.executeQuery("select tipp.id ${tipp_id_query}".toString(),[pkg_id])
    def pendingChanges = PendingChange.executeQuery("select pc.id, pc.changeDoc ${change_doc_query}".toString(),[sub_id])

    def pc_to_delete = []
    pendingChanges.each{pc->
      def parsed_change_info = JSON.parse(pc[1])
      if(parsed_change_info.tippID) {
        pc_to_delete +=pc[0]
      }
      else if(parsed_change_info.changeDoc){
        def (oid_class,ident) = parsed_change_info.changeDoc.OID.split(":")
        if(oid_class == tipp_class && tipp_ids.contains(ident.toLong()) ){
          pc_to_delete += pc[0]
        }
      }
      else{
        log.error("Could not decide if we should delete the pending change id:${pc[0]} - ${parsed_change_info}")
      }
    }
    if(confirmed && pc_to_delete){
      log.debug("Deleting Pending Changes: ${pc_to_delete}")
      def del_pc_query = "delete from PendingChange where id in (:del_list) "
      PendingChange.executeUpdate(del_pc_query,[del_list:pc_to_delete])
    }else{
      return pc_to_delete.size()
    }
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def compareModal() {
    def result = [:]
    
    if (params.subA && params.subB) {
      result.subInsts = []
      def subAId = params.subA.substring( params.subA.indexOf(":")+1)
      result.subInsts.add(Subscription.get(subAId))
      
      def subBId = params.subB.substring( params.subB.indexOf(":")+1)
      result.subInsts.add(Subscription.get(subBId))
    }
    else {
      def currentDate = new java.text.SimpleDateFormat('yyyy-MM-dd').format(new Date())
      params.insrt = "Y"
      params.dlt = "Y"
      params.updt = "Y"
      params.dateA = currentDate
      params.dateB = currentDate
    }
    
    if(params.defaultInstShortcode) {
      result.institutionName = request.getAttribute('institution').name
      result.defaultInstShortcode = params.defaultInstShortcode
      log.debug("FIND ORG NAME ${result.institutionName}")
    }
    
    
    
    
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def compare(){
    def result = [:]
    result.unionList = []

    result.user = User.get(springSecurityService.principal.id)
    result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0
	
	if(params.defaultInstShortcode){
	  result.institutionName = request.getAttribute('institution').name
	  result.defaultInstShortcode = params.defaultInstShortcode
	  log.debug("FIND ORG NAME ${result.institutionName}")
	}

    if(params.subA?.length() > 0 && params.subB?.length() > 0 ){
      log.debug("compare :: Subscriptions submitted for comparison ${params.subA} and ${params.subB}.")
      log.debug("compare :: Dates submited are ${params.dateA} and ${params.dateB}")

      result.subInsts = []
      result.subDates = []

      def listA
      def listB
      try{
        listA = createCompareList(params.subA ,params.dateA, params, result)
        listB = createCompareList(params.subB, params.dateB, params, result)
        if(!params.countA){
          def countQuery = "select count(elements(sub.issueEntitlements)) from Subscription sub where sub.id = ?"
          params.countA = Subscription.executeQuery(countQuery, [result.subInsts.get(0).id])
          params.countB = Subscription.executeQuery(countQuery, [result.subInsts.get(1).id])
        }
      }catch(IllegalArgumentException e){
        request.message = e.getMessage()
        return
      }

      result.listACount = listA.size()
      result.listBCount = listB.size()

      def mapA = listA.collectEntries { [it.tipp.title.title, it] }
      def mapB = listB.collectEntries { [it.tipp.title.title, it] }

      log.debug("listA:${result.listACount} listB:${result.listBCount} mapA:${mapA.size()} mapB:${mapB.size()}");

      def comparison_name = "Compare_sub_${params.subA}_on_${params.dateA}_and_sub_${params.subB}_on_${params.dateB}"

      //FIXME: It should be possible to optimize the following lines
      def unionList = mapA.keySet().plus(mapB.keySet()).toList()
      unionList = unionList.unique()
      result.unionListSize = unionList.size()
      unionList.sort()

      def filterRules = [params.insrt?true:false, params.dlt?true:false, params.updt?true:false, params.nochng?true:false ]
      withFormat{
        html{
          def toIndex = ( result.offset+result.max < unionList.size() ) ? ( result.offset+result.max ) : ( unionList.size() )
          result.comparisonMap = institutionsService.generateComparisonMap(unionList,mapA,mapB,result.offset, toIndex.intValue(),filterRules)
          log.debug("Comparison Map"+result.comparisonMap)
          result
        }
        csv {
          try{
          log.debug("Create CSV Response")
          def comparisonMap = institutionsService.generateComparisonMap(unionList, mapA, mapB, 0, unionList.size(),filterRules)
          def dateFormatter = new java.text.SimpleDateFormat('yyyy-MM-dd')

           response.setHeader("Content-disposition", "attachment; filename=\"${comparison_name}.csv\"")
           response.contentType = "text/csv"
           def out = response.outputStream
           out.withWriter { writer ->
            writer.write("${result.subInsts[0].name} on ${params.dateA}, ${result.subInsts[1].name} on ${params.dateB}\n")
            writer.write('IE Title, pISSN, eISSN, Start Date A, Start Date B, Start Volume A, Start Volume B, Start Issue A, Start Issue B, End Date A, End Date B, End Volume A, End Volume B, End Issue A, End Issue B, Coverage Note A, Coverage Note B, ColorCode\n');
            log.debug("UnionList size is ${unionList.size}")
            comparisonMap.each{ title, values ->
              def ieA = values[0]
              def ieB = values[1]
              def colorCode = values[2]
              def pissn = ieA ? ieA.tipp.title.getIdentifierValue('issn') : ieB.tipp.title.getIdentifierValue('issn');
              def eissn = ieA ? ieA.tipp.title.getIdentifierValue('eISSN') : ieB.tipp.title.getIdentifierValue('eISSN')

              writer.write("\"${title}\",\"${pissn?:''}\",\"${eissn?:''}\",\"${formatDateOrNull(dateFormatter,ieA?.startDate)}\",\"${formatDateOrNull(dateFormatter,ieB?.startDate)}\",\"${ieA?.startVolume?:''}\",\"${ieB?.startVolume?:''}\",\"${ieA?.startIssue?:''}\",\"${ieB?.startIssue?:''}\",\"${formatDateOrNull(dateFormatter,ieA?.endDate)}\",\"${formatDateOrNull(dateFormatter,ieB?.endDate)}\",\"${ieA?.endVolume?:''}\",\"${ieB?.endVolume?:''}\",\"${ieA?.endIssue?:''}\",\"${ieB?.endIssue?:''}\",\"${ieA?.coverageNote?:''}\",\"${ieB?.coverageNote?:''}\",\"${colorCode}\"\n")
            }
            writer.write("END");
            writer.flush();
            writer.close();
           }
           out.close()

          }catch(Exception e){
            log.error("An Exception was thrown here",e)
          }
        }
        xls {
          log.debug("User requested xls");
          def comparisonMap = institutionsService.generateComparisonMap(unionList, mapA, mapB, 0, unionList.size(),filterRules)

          response.setHeader("Content-disposition", "attachment; filename=\"${comparison_name}.xls\"")
          response.contentType = "application/vnd.ms-excel"
          def out = response.outputStream
          streamComparisonXLS(result.subInsts[0].name, params.dateA, result.subInsts[1].name, params.dateB, comparisonMap, out);
		  out.flush()
		  out.close()
        }
      }
    }else{
      //def currentDate = new java.text.SimpleDateFormat('yyyy-MM-dd').format(new Date())
      //params.dateA = currentDate
      //params.dateB = currentDate
      //params.insrt = "Y"
      //params.dlt = "Y"
      //params.updt = "Y"
      
      request.message = "Please select two subscriptions for comparison"
      flash.message = "Please select two subscriptions for comparison"
	  result
    }
    
  }

  def streamComparisonXLS(subA, dateA, subB, dateB, comparisonMap, out) {
	
	def dateFormatter = new java.text.SimpleDateFormat('yyyy-MM-dd')
	
	//Create workbook
	HSSFWorkbook workbook = new HSSFWorkbook(); 
	CreationHelper factory = workbook.getCreationHelper();
	HSSFSheet firstSheet = workbook.createSheet("Comparison Export");
	Drawing drawing = firstSheet.createDrawingPatriarch();
	  
	//Set colours for rows with IEs in one or both subscriptions 
	HSSFCellStyle green_cell_style = workbook.createCellStyle();
	green_cell_style.setFillForegroundColor(HSSFColor.LIGHT_GREEN.index);
	green_cell_style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
	  
	HSSFCellStyle yellow_cell_style = workbook.createCellStyle();
	yellow_cell_style.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
	yellow_cell_style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
	  
	HSSFCellStyle red_cell_style = workbook.createCellStyle();
	red_cell_style.setFillForegroundColor(HSSFColor.ROSE.index);
	red_cell_style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
	  
	//Init row and column
	int rc = 0;
	int cc = 0;
	HSSFRow row = null;
	HSSFCell cell = null;
	
	//Subscriptions being compared
    row = firstSheet.createRow(rc++);
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("${subA} on ${dateA}"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("${subB} on ${dateB}"));
	
	//Headers
	cc = 0;
	row = firstSheet.createRow(rc++);
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("IE Title"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("ISSN"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("eISSN"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("Start Date A"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("Start Date B"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("Start Valume A"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("Start Volume B"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("Start Issue A"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("Start Issue B"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("End Date A"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("End Date B"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("End Volume A"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("End Volume B"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("End Issue A"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("End Issue B"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("Coverage Note A"));
	cell = row.createCell(cc++);
	cell.setCellValue(new HSSFRichTextString("Coverage Note B"));
	  
	//Iterate through map to build rows
	comparisonMap.each{ title, values ->
		def ieA = values[0]
		def ieB = values[1]
		def colorCode = values[2]
		def issn = ieA ? ieA.tipp.title.getIdentifierValue('issn') : ieB.tipp.title.getIdentifierValue('issn');
		def eissn = ieA ? ieA.tipp.title.getIdentifierValue('eISSN') : ieB.tipp.title.getIdentifierValue('eISSN')
		
		//Set row color
		def cellStyle
		if (colorCode == "success") cellStyle = green_cell_style
		else if (colorCode == "warning") cellStyle = yellow_cell_style
		else cellStyle = red_cell_style
		
		//Add values into row
		cc = 0;
		row = firstSheet.createRow(rc++);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(title));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(issn));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(eissn));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(formatDateOrNull(dateFormatter,ieA?.startDate)));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(formatDateOrNull(dateFormatter,ieB?.startDate)));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(ieA?.startVolume?:''));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(ieB?.startVolume?:''));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(ieA?.startIssue?:''));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(ieB?.startIssue?:''));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(formatDateOrNull(dateFormatter,ieA?.endDate)));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(formatDateOrNull(dateFormatter,ieB?.endDate)));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(ieA?.endVolume?:''));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(ieB?.endVolume?:''));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(ieA?.endIssue?:''));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(ieB?.endIssue?:''));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(ieA?.coverageNote?:''));
		cell.setCellStyle(cellStyle);
		cell = row.createCell(cc++);
		cell.setCellValue(new HSSFRichTextString(ieB?.coverageNote?:''));
		cell.setCellStyle(cellStyle);
	}
	
	//adjust width of columns
	/*for (int i = 0; i < comparisonMap.size(); i++) {
		firstSheet.autoSizeColumn(i); //adjust width of the second column
	}*/
	
	workbook.write(out)
  }

  def formatDateOrNull(formatter, date) {
      def result;
      if(date){
        result = formatter.format(date)
      }else{
        result = ''
      }
      return result
  }


  def createCompareList(sub,dateStr,params, result){
   def returnVals = [:]

   log.debug("createCompareList(${sub},${dateStr},...");

   def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd')
   def date = ( dateStr && ( dateStr.length() > 0 ) ) ? sdf.parse(dateStr) : new Date()
   def subId = sub.substring( sub.indexOf(":")+1)

   def subInst = Subscription.get(subId)
   // if(subInst.startDate > date || subInst.endDate < date){
   if(date < subInst.startDate ) {
     date = subInst.startDate
   }
   else if ( date > subInst.endDate ) {
     date = subInst.endDate
   }

   result.subInsts.add(subInst)

   result.subDates.add(sdf.format(date))

   def queryParams = [subInst]
   def query = generateIEQuery(params,queryParams, true, date)

   log.debug("Query: select ie ${query} ${queryParams}");
   def list = IssueEntitlement.executeQuery("select ie "+query,  queryParams);

   log.debug("createCompareList returning list of size ${list?.size()}");
   list

  }

  def generateIEQuery(params, qry_params, showDeletedTipps, asAt) {

    def base_qry = "from IssueEntitlement as ie left outer join ie.tipp.status as tippstatus where ie.subscription = ? "

    if ( showDeletedTipps == false ) {
         base_qry += "and tippstatus.value != 'Deleted'  "
    }

    if ( params.filter ) {
      base_qry += " and ( ( lower(ie.tipp.title.title) like ? ) or ( exists ( from IdentifierOccurrence io where io.ti.id = ie.tipp.title.id and io.identifier.value like ? ) ) )"
      qry_params.add("%${params.filter.trim().toLowerCase()}%")
      qry_params.add("%${params.filter}%")
    }

    if ( params.startsBefore && params.startsBefore.length() > 0 ) {
        def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd');
        def d = sdf.parse(params.startsBefore)
        base_qry += " and ie.startDate <= ?"
        qry_params.add(d)
    }

    if ( asAt != null ) {
        base_qry += " and ( ( ? >= coalesce(ie.tipp.accessStartDate, ie.startDate) ) and ( ( ? <= ie.tipp.accessEndDate ) or ( ie.tipp.accessEndDate is null ) ) ) "
        qry_params.add(asAt);
        qry_params.add(asAt);
    }

    return base_qry
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def batchEditModal() {
    def result = [:]
    
    def iemedium_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='IEMedium'"
    result.iemedium = RefdataValue.executeQuery(iemedium_qry,[])
    
    def corestatus_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='CoreStatus'"
    result.corestatus = RefdataValue.executeQuery(corestatus_qry,[])
    
    result
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def subscriptionBatchUpdate() {
    def subscriptionInstance = Subscription.get(params.id)
    // def formatter = new java.text.SimpleDateFormat("MM/dd/yyyy")
    def formatter = new java.text.SimpleDateFormat("yyyy-MM-dd")
    def user = User.get(springSecurityService.principal.id)
	def institution = request.getAttribute('institution')

    if(!userAccessCheck( subscriptionInstance, user, 'edit')) return


    log.debug("subscriptionBatchUpdate ${params}");

    params.each { p ->
      if ( p.key.startsWith('_bulkflag.') && (p.value=='on'))  {
        def ie_to_edit = p.key.substring(10);

        def ie = IssueEntitlement.get(ie_to_edit)

        if ( params.bulkOperation == "edit" ) {

		  if ( params.clear_start_date ) {
			log.debug("Deleting Start Dates")
			ie.startDate = null
		  }
          else if ( params.bulk_start_date && ( params.bulk_start_date.trim().length() > 0 ) ) {
            ie.startDate = formatter.parse(params.bulk_start_date)
          }

		  if ( params.clear_end_date ) {
		    log.debug("Deleting End Dates")
		    ie.endDate = null
		  }
          else if ( params.bulk_end_date && ( params.bulk_end_date.trim().length() > 0 ) ) {
            ie.endDate = formatter.parse(params.bulk_end_date)
          }

          if ( params.bulk_core_start && ( params.bulk_core_start.trim().length() > 0 ) ) {
            ie.coreStatusStart = formatter.parse(params.bulk_core_start)
          }

          if ( params.bulk_core_end && ( params.bulk_core_end.trim().length() > 0 ) ) {
            ie.coreStatusEnd = formatter.parse(params.bulk_core_end)
          }

          if ( params.bulk_embargo && ( params.bulk_embargo.trim().length() > 0 ) ) {
            ie.embargo = params.bulk_embargo
          }

          if ( params.bulk_coreStatus.trim().length() > 0 ) {
            def selected_refdata = genericOIDService.resolveOID(params.bulk_coreStatus.trim())
            log.debug("Selected core status is ${selected_refdata}");
            ie.coreStatus = selected_refdata
          }

          if ( params.bulk_medium.trim().length() > 0 ) {
            def selected_refdata = genericOIDService.resolveOID(params.bulk_medium.trim())
            log.debug("Selected medium is ${selected_refdata}");
            ie.medium = selected_refdata
          }

          if ( params.bulk_coverage && (params.bulk_coverage.trim().length() > 0 ) ) {
            ie.coverageDepth = params.bulk_coverage
          }
		  
		  if ( params.clear_coverage_note ) {
			  log.debug("Deleting Coverage Notes")
			  ie.coverageNote = null
		  }
		  else if( params.bulk_coverage_note && (params.bulk_coverage_note.trim().length() > 0 ) ) {
			  log.debug("Changing ${params.bulk_coverage_note}")
			  ie.coverageNote = params.bulk_coverage_note
		  }

          if ( ie.save(flush:true) ) {
          }
          else {
            log.error("Problem saving ${ie.errors}")
          }
        }
		else if ( params.bulkOperation == "core" ) {
			log.debug("Updating ie ${ie.id} core dates");
			def tip = ie.getTIP()
			def startDate
			def endDate
			if ( params.core_start_date && ( params.core_start_date.trim().length() > 0 ) ) {
				startDate = formatter.parse(params.core_start_date)
			}
			if ( params.core_end_date && ( params.core_end_date.trim().length() > 0 ) ) {
				endDate = formatter.parse(params.core_end_date)
			}
			if(tip && startDate){
				log.debug('tip: ' + tip)
				log.debug("Extending tip ${tip.id} with start ${startDate}")
				tip.extendCoreExtent(startDate, endDate)
			}
		}
        else if ( params.bulkOperation == "remove" ) {
          log.debug("Updating ie ${ie.id} status to deleted");
          def deleted_ie = RefdataCategory.lookupOrCreate('Entitlement Issue Status','Deleted');
          ie.status = deleted_ie;
          if ( ie.save(flush:true) ) {
			  dashboardService.clearTitleCount(institution)
          }
          else {
            log.error("Problem saving ${ie.errors}")
          }
        }
      }
    }

  def params_sc = []
  if (params.defaultInstShortcode) {
    params_sc = [defaultInstShortcode:params.defaultInstShortcode]
  }
    redirect action: 'index', params:[id:subscriptionInstance?.id,sort:params.sort,order:params.order,offset:params.offset,max:params.max]+params_sc
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def addEntitlements() {
    log.debug("addEntitlements....");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.subscriptionInstance = Subscription.get(params.id)
    result.institution = result.subscriptionInstance.subscriber

    if(!userAccessCheck( result.subscriptionInstance, result.user, 'edit')) return


    result.max = params.max ? Integer.parseInt(params.max) : request.user.defaultPageSize;
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

    /*if ( result.subscriptionInstance.isEditableBy(result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }*/

    def tipp_deleted = RefdataCategory.lookupOrCreate(RefdataCategory.TIPP_STATUS,'Deleted');
    def ie_deleted = RefdataCategory.lookupOrCreate('Entitlement Issue Status','Deleted');

    log.debug("filter: \"${params.filter}\"");

    if ( result.subscriptionInstance ) {
      // We need all issue entitlements from the parent subscription where no row exists in the current subscription for that item.
      def basequery = null;
      def qry_params = [result.subscriptionInstance, tipp_deleted, result.subscriptionInstance, ie_deleted]

      if ( params.filter ) {
        log.debug("Filtering....");
        basequery = "from TitleInstancePackagePlatform tipp where tipp.pkg in ( select pkg from SubscriptionPackage sp where sp.subscription = ? ) and tipp.status != ? and ( not exists ( select ie from IssueEntitlement ie where ie.subscription = ? and ie.tipp.id = tipp.id and ie.status != ? ) ) and ( ( lower(tipp.title.title) like ? ) OR ( exists ( select io from IdentifierOccurrence io where io.ti.id = tipp.title.id and io.identifier.value like ? ) ) ) "
        qry_params.add("%${params.filter.trim().toLowerCase()}%")
        qry_params.add("%${params.filter}%")
      }
      else {
        basequery = "from TitleInstancePackagePlatform tipp where tipp.pkg in ( select pkg from SubscriptionPackage sp where sp.subscription = ? ) and tipp.status != ? and ( not exists ( select ie from IssueEntitlement ie where ie.subscription = ? and ie.tipp.id = tipp.id and ie.status != ? ) )"
      }

      if ( params.endsAfter && params.endsAfter.length() > 0 ) {
        def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd');
        def d = sdf.parse(params.endsAfter)
        basequery += " and tipp.endDate >= ?"
        qry_params.add(d)
      }

      if ( params.startsBefore && params.startsBefore.length() > 0 ) {
        def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd');
        def d = sdf.parse(params.startsBefore)
        basequery += " and tipp.startDate <= ?"
        qry_params.add(d)
      }


      if ( params.pkgfilter && ( params.pkgfilter != '' ) ) {
        basequery += " and tipp.pkg.id = ? "
        qry_params.add(Long.parseLong(params.pkgfilter));
      }


      if ( ( params.sort != null ) && ( params.sort.length() > 0 ) ) {
        basequery += " order by tipp.${params.sort} ${params.order} "
      }
      else {
        basequery += " order by tipp.title.title asc "
      }

      log.debug("Query ${basequery} ${qry_params}");

      result.num_tipp_rows = IssueEntitlement.executeQuery("select count(tipp) "+basequery, qry_params )[0]
      result.tipps = IssueEntitlement.executeQuery("select tipp ${basequery}".toString(), qry_params, [max:result.max, offset:result.offset]);
    }
    else {
      result.num_sub_rows = 0;
      result.tipps = []
    }

    result
  }
    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def previous() {
       previousAndExpected(params,'previous');
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def expected() {
        previousAndExpected(params,'expected');
    }

    def previousAndExpected (params, screen){
        log.debug("previousAndExpected ${params}");
        def result = [:]

        result.user = User.get(springSecurityService.principal.id)
        def subscriptionInstance = Subscription.get(params.id)
        if (!subscriptionInstance) {
            request.message = message(code: 'default.not.found.message', args: [message(code: 'package.label', default: 'Subscription'), params.id])
            redirect action: 'list'
            return
        }
        result.subscriptionInstance = subscriptionInstance
        result.institution = result.subscriptionInstance.subscriber

        if(!userAccessCheck( result.subscriptionInstance, result.user, 'view')) return

        if ( result.subscriptionInstance.isEditableBy(result.user) ) {
          result.editable = true
        }
        else {
          result.editable = false
        }

        result.max = params.max ? Integer.parseInt(params.max) : request.user.defaultPageSize
        params.max = result.max
        result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

        def limits = (!params.format||params.format.equals("html"))?[max:result.max, offset:result.offset]:[offset:0]

        def qry_params = [subscriptionInstance]
        def date_filter =  new Date();

        def base_qry = "from IssueEntitlement as ie where ie.subscription = ? "
        base_qry += "and ie.status.value != 'Deleted' "
        if ( date_filter != null ) {
            if(screen.equals('previous')) {
                base_qry += " and ( coalesce(ie.accessEndDate,subscription.endDate) <= ? ) "
            }else{
                base_qry += " and (coalesce(ie.accessStartDate,subscription.startDate) > ? )"
            }
            qry_params.add(date_filter);
        }

        log.debug("Base qry: ${base_qry}, params: ${qry_params}, result:${result}");
        result.titlesList = IssueEntitlement.executeQuery("select ie "+base_qry, qry_params, limits);
        result.num_ie_rows = IssueEntitlement.executeQuery("select count(ie) "+base_qry, qry_params )[0]

        result.lastie = result.offset + result.max > result.num_ie_rows ? result.num_ie_rows : result.offset + result.max;

        result
    }
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processAddEntitlements() {
    log.debug("addEntitlements....");
    def result = [:]

    result.user = User.get(springSecurityService.principal.id)
    result.subscriptionInstance = Subscription.get(params.siid)
    result.institution = result.subscriptionInstance?.subscriber

    if(!userAccessCheck( result.subscriptionInstance, result.user, 'edit')) return


    if ( result.subscriptionInstance ) {
      params.each { p ->
        if (p.key.startsWith('_bulkflag.') ) {
          def tipp_id = p.key.substring(10);
          // def ie = IssueEntitlement.get(ie_to_edit)
          def tipp = TitleInstancePackagePlatform.get(tipp_id)

          if ( tipp == null ) {
            log.error("Unable to tipp ${tipp_id}");
            flash.error("Unable to tipp ${tipp_id}");
          }
          else {
            def ie_current = RefdataCategory.lookupOrCreate('Entitlement Issue Status','Current');

            def new_ie = new IssueEntitlement(status: ie_current,
                                              subscription: result.subscriptionInstance,
                                              tipp: tipp,
                                              accessStartDate: tipp.accessStartDate,
                                              accessEndDate: tipp.accessEndDate,
                                              startDate:tipp.startDate,
                                              startVolume:tipp.startVolume,
                                              startIssue:tipp.startIssue,
                                              endDate:tipp.endDate,
                                              endVolume:tipp.endVolume,
                                              endIssue:tipp.endIssue,
                                              embargo:tipp.embargo,
                                              coverageDepth:tipp.coverageDepth,
                                              coverageNote:tipp.coverageNote,
                                              ieReason:'Manually Added by User')
            if ( new_ie.save(flush:true) ) {
              log.debug("Added tipp ${tipp_id} to sub ${params.siid}");
			  dashboardService.clearTitleCount(result.institution)
            }
            else {
              new_ie.errors.each { e ->
                log.error(e);
              }
              flash.error = new_ie.errors
            }
          }
        }
      }
    }
    else {
      log.error("Unable to locate subscription instance");
    }
  
  def params_sc = []
  if (result.institution) {
    params_sc = [defaultInstShortcode:result.institution.shortcode]
  }
    redirect action: 'index', id:result.subscriptionInstance?.id, params:params_sc
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def removeEntitlement() {
    log.debug("removeEntitlement....");
    def ie = IssueEntitlement.get(params.ieid)
	def institution = request.getAttribute('institution')
    def deleted_ie = RefdataCategory.lookupOrCreate('Entitlement Issue Status','Deleted');
    ie.status = deleted_ie;
  ie.save(flush:true, failOnError:true)
  dashboardService.clearTitleCount(institution)
  
  def params_sc = []
  if (params.defaultInstShortcode) {
    params_sc = [defaultInstShortcode:params.defaultInstShortcode]
  }
    redirect action: 'index', id:params.sub, params:params_sc
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def notes() {

    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.subscriptionInstance = Subscription.get(params.id)
    result.institution = result.subscriptionInstance.subscriber

    if ( result.institution ) {
      result.subscriber_shortcode = result.institution.shortcode
    }

    if(!userAccessCheck( result.subscriptionInstance, result.user, 'view')) return

    if ( result.subscriptionInstance.isEditableBy(result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def documents() {

    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.subscriptionInstance = Subscription.get(params.id)
    result.institution = result.subscriptionInstance.subscriber

    if(!userAccessCheck( result.subscriptionInstance, result.user, 'view')) return


    if ( result.institution ) {
      result.subscriber_shortcode = result.institution.shortcode
    }

    if ( result.subscriptionInstance.isEditableBy(result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def renewals() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.subscriptionInstance = Subscription.get(params.id)
    result.institution = result.subscriptionInstance.subscriber

    if(!userAccessCheck( result.subscriptionInstance, result.user, 'view')) return

    if ( result.institution ) {
      result.subscriber_shortcode = result.institution.shortcode
    }

    if ( result.subscriptionInstance.isEditableBy(result.user) ) {
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

    params.each { p ->
      if (p.key.startsWith('_deleteflag.') ) {
        def docctx_to_delete = p.key.substring(12);
        log.debug("Looking up docctx ${docctx_to_delete} for delete");
        def docctx = DocContext.get(docctx_to_delete)
        docctx.status = RefdataCategory.lookupOrCreate('Document Context Status','Deleted');
      }
    }

    redirect controller: 'subscriptionDetails', action:params.redirectAction, id:params.instanceId
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def additionalInfo() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.subscriptionInstance = Subscription.get(params.id)
    result.institution = result.subscriptionInstance.subscriber
   
    if(!userAccessCheck( result.subscriptionInstance, result.user, 'view')) return

   
    if ( result.subscriptionInstance.isEditableBy(result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }


    // if ( ! result.subscriptionInstance.hasPerm("view",result.user) ) {
    //   render status: 401
    //   return
    // }

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def launchRenewalsProcess() {
    def result = [:]
    log.debug("launchRenewalsProcess(${params})");

    result.user = User.get(springSecurityService.principal.id)
    result.subscriptionInstance = Subscription.get(params.id)
    result.institution = result.subscriptionInstance.subscriber

    log.debug("Initialise shopping basket");
    def shopping_basket = UserFolder.findByUserAndShortcode(result.user,'SOBasket') ?: new UserFolder(user:result.user, shortcode:'SOBasket').save(flush:true);

    log.debug("Clear basket....");
    shopping_basket.items?.clear();
    shopping_basket.save(flush:true)

    def oid = "com.k_int.kbplus.Subscription:${params.id}"
    log.debug("Adding subscripiton ${oid} to shopping basket");
    shopping_basket.addIfNotPresent(oid)
    shopping_basket.save(flush:true, failOnError:true);

    log.debug("Redirect to renewals search basket size is ${shopping_basket.items.size()}");
    redirect controller:'myInstitutions',action:'renewalsSearch',params:[defaultInstShortcode:result.subscriptionInstance.subscriber.shortcode]
  }

  def userAccessCheck(sub,user,role_str){
    if ((sub == null || user == null ) || ! sub.hasPerm(role_str,user) ) {
		log.debug("return 401....");
		flash.error = "You do not have permission to ${role_str} ${sub?.name?:'this subscription'}. Please request access to ${sub?.subscriber?.name?:'subscription institution'} on the profile page";
      response.sendError(401);
      return false
    }
	return true
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def acceptChange() {
    processAcceptChange(params, Subscription.get(params.id), genericOIDService)
    redirect controller: 'subscriptionDetails', action:'index',id:params.id
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def rejectChange() {
    processRejectChange(params, Subscription.get(params.id))
    redirect controller: 'subscriptionDetails', action:'index',id:params.id
  }


  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def possibleLicensesForSubscription() {
    def result = []

    def subscription = genericOIDService.resolveOID(params.oid)
    def subscriber = subscription.getSubscriber();

    result.add([value:'', text:'None']);

    if ( subscriber ) {

      def licensee_role = RefdataCategory.lookupOrCreate('Organisational Role','Licensee');
      def template_license_type = RefdataCategory.lookupOrCreate('License Type','Template');

      def qry_params = [subscriber, licensee_role]

      def qry = "select l from License as l where exists ( select ol from OrgRole as ol where ol.lic = l AND ol.org = ? and ol.roleType = ? ) AND l.status.value != 'Deleted' order by l.reference"

      def license_list = License.executeQuery(qry, qry_params);
      license_list.each { l ->
        result.add([value:"${l.class.name}:${l.id}",text:l.reference ?: "No reference - license ${l.id}"]);
      }
    }
    render result as JSON
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def linkPackage() {
    log.debug("Link package, params: ${params}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.subscriptionInstance = Subscription.get(params.id)
    result.institution = result.subscriptionInstance.subscriber

    if(!userAccessCheck( result.subscriptionInstance, result.user, 'edit')) return


    if ( params.addType && ( params.addType != '' ) ) {
      def params_sc = []
      if (params.defaultInstShortcode) {
      params_sc = [defaultInstShortcode:params.defaultInstShortcode]
    }  
      def pkg_to_link = Package.get(params.addId)
      log.debug("Add package ${params.addType} to subscription ${params}");
    if ( params.addType == 'With' ) {

      // This can take a potentially long time - so run it using the executor service....
      java.util.concurrent.Future link_package_future = executorService.submit( {
        pkg_to_link.addToSubscription(result.subscriptionInstance, true)
      } as java.lang.Runnable);

      // Wait for up to 30 seconds
      try {
        link_package_future?.get(30L, java.util.concurrent.TimeUnit.SECONDS)
      }
      catch ( java.util.concurrent.TimeoutException te ) {
        flash.message = "Creating entitlements for all titles from package ${pkg_to_link.name} in subscription ${result.subscriptionInstance.name} is taking a while. We have started the process and it will complete in the background, usually within a few minutes. Please check back shortly";
      }

      redirect action:'index', id:params.id, params:params_sc
    }
    else if ( params.addType == 'Without' ) {
      pkg_to_link.addToSubscription(result.subscriptionInstance, false)
        //use to redirect to addEntitlements here but because this is now in a modal, we re-direct to sub details index page and they can add titles from there
        //redirect action:'addEntitlements', id:params.id, params:params
        redirect action:'index', id:params.id, params:params_sc
      }
    }

    if ( result.subscriptionInstance.isEditableBy(result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }

    if ( result.institution ) {
      result.subscriber_shortcode = result.institution.shortcode
      result.institutional_usage_identifier = result.institution.getIdentifierByType('JUSP');
    }
    log.debug("Going for ES")
    params.rectype = "Package"
    result.putAll(ESSearchService.search(params))

    result
  }

  def buildRenewalsQuery(params) {
    log.debug("BuildQuery...");

    StringWriter sw = new StringWriter()

    // sw.write("subtype:'Subscription Offered'")
    sw.write("rectype:'Package'")

    renewals_reversemap.each { mapping ->

      // log.debug("testing ${mapping.key}");

      if ( params[mapping.key] != null ) {
        if ( params[mapping.key].class == java.util.ArrayList) {
          params[mapping.key].each { p ->
                sw.write(" AND ")
                sw.write(mapping.value)
                sw.write(":")
                sw.write("\"${p}\"")
          }
        }
        else {
          // Only add the param if it's length is > 0 or we end up with really ugly URLs
          // II : Changed to only do this if the value is NOT an *
          if ( params[mapping.key].length() > 0 && ! ( params[mapping.key].equalsIgnoreCase('*') ) ) {
            sw.write(" AND ")
            sw.write(mapping.value)
            sw.write(":")
            sw.write("\"${params[mapping.key]}\"")
          }
        }
      }
    }


    def result = sw.toString();
    result;
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def edit_history() {
    log.debug("subscriptionDetails::edit_history ${params}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.subscription = Subscription.get(params.id)
    result.institution = result.subscription.subscriber

    if(!userAccessCheck( result.subscription, result.user, 'view')) return

    if ( result.subscription.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }

    result.max = params.max ?: result.user.defaultPageSize;
    result.offset = params.offset ?: 0;

    def qry_params = [result.subscription.class.name, "${result.subscription.id}"]
    result.historyLines = AuditLogEvent.executeQuery("select e from AuditLogEvent as e where className=? and persistedObjectId=? order by id desc", qry_params, [max:result.max, offset:result.offset]);
    result.historyLinesTotal = AuditLogEvent.executeQuery("select count(e.id) from AuditLogEvent as e where className=? and persistedObjectId=?",qry_params)[0];

    result
  }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def todo_history() {
    log.debug("subscriptionDetails::todo_history ${params}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.subscription = Subscription.get(params.id)

    result.institution = result.subscription.subscriber

    if(!userAccessCheck( result.subscription, result.user, 'view')) return


    if ( result.subscription.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }

    result.max = params.max ?: result.user.defaultPageSize;
    result.offset = params.offset ?: 0;

    def qry_params = [result.subscription.class.name, "${result.subscription.id}"]

    result.todoHistoryLines = PendingChange.executeQuery("select pc from PendingChange as pc where pc.subscription=? order by pc.ts desc", [result.subscription], [max:result.max, offset:result.offset]);

    result.todoHistoryLinesTotal = PendingChange.executeQuery("select count(pc) from PendingChange as pc where subscription=?", result.subscription)[0];

    result
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def pendingChanges() {
    log.debug("subscriptionDetails::pendingChanges ${params}");
    def user = User.get(springSecurityService.principal.id)
    def subscription = Subscription.get(params.id)
    
    if(!userAccessCheck( subscription, user, 'view')) return
    
    def editable = false
    if ( subscription.hasPerm("edit",user) ) {
      editable = true
    }
    
    def processingpc = false
    if(executorWrapperService.hasRunningProcess(subscription)){
      processingpc = true
    }
    
    def max = params.max ? Integer.parseInt(params.max) : ( (response.format && response.format != "html" && response.format != "all" ) ? 10000 : user.defaultPageSize );
    def offset = (params.offset && response.format && response.format != "html") ? Integer.parseInt(params.offset) : 0;
    
    def pending_change_pending_status = RefdataCategory.lookupOrCreate("PendingChangeStatus", "Pending")
    def pendingChangesTotal = PendingChange.executeQuery("select count(pc) from PendingChange as pc where subscription=? and ( pc.status is null or pc.status = ? )", [subscription, pending_change_pending_status])[0];
    
    if (offset >= pendingChangesTotal) {
      offset = 0
    }
    
    def pendingChanges = PendingChange.executeQuery("select pc.id from PendingChange as pc where subscription=? and ( pc.status is null or pc.status = ? ) order by ts desc", [subscription, pending_change_pending_status ], [max:max, offset:offset]);
    
    def pcs = null
    if(subscription?.isSlaved?.value == "Auto" && pendingChanges) {
      log.debug("Slaved subscription, auto-accept pending changes")
      def changesDesc = []
      pendingChanges.each{change ->
        if(!pendingChangeService.performAccept(change,request)) {
          log.debug("Auto-accepting pending change has failed.")
        } else {
          changesDesc.add(PendingChange.get(change).desc)
        }
      }
      request.message = changesDesc
    } else {
      pcs = pendingChanges.collect{PendingChange.get(it)}
    }
    
    render(template:"/templates/pendingChangesModal", model:[model:subscription, modelType:'Subscription', pendingChanges:pcs, pendingChangesTotal:pendingChangesTotal, editable:editable, processingpc:processingpc, name:subscription.name, offset:offset, max:max, theme:'subscriptions'])
  }


  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def costPerUsev2() {
    def result = [:]

    result.user = User.get(springSecurityService.principal.id)
    result.subscription = Subscription.get(params.id)

    // result.institution = Org.findByShortcode(params.shortcode)
    result.institution = result.subscription.subscriber
    if ( result.institution ) {
      result.subscriber_shortcode = result.institution.shortcode
      result.institutional_usage_identifier = result.institution.getIdentifierByType('JUSP');
    }

    if ( ! result.subscription.hasPerm("view",result.user) ) {
      response.sendError(401);
      return
    }

    if ( result.subscription.hasPerm("edit",result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }

    result.costItems = getCostPerUseData(subscription)

    result
  }

  def getCostPerUseData(subscription) {

    def result = [:]
    Date one_year_ago = new Date(System.currentTimeMillis()-(1000*60*60*24*366))  // ms*sec/min*min/hr*hr/day*365 (366=365+1)

    def cp = CostItem.executeQuery(COST_PERIODS_FOR_SUB,[sub:subscription])

    // New cost per use algorithm - step 1 - compute a grid with one column for each month period that spans the whole subscription
    Date cpu_date_start = cp[0][0];
    Date cpu_date_end = cp[0][1];

    if ( ( cpu_date_start == null ) || ( cpu_date_end == null ) ) {
      result.message = "Unable to determine start or end dates for cost items under the subscription"
      return result;
    }

    if ( cpu_date_start < one_year_ago ) {
      log.debug("Constrain start date to one year ago");
      cpu_date_start = one_year_ago;
    }

    log.debug("cost periods for sub: ${cp}");

    // log.debug("Get all invoices for sub ${result.subscription}");
    result.costItems = [:]
    result.costItems.periods = getPeriodsBetween(cpu_date_start,cpu_date_end);
    result.number_of_cost_periods_for_sub = result.costItems.periods.size();
    result.costItems.apportionment = []

    log.debug("Done filling out period grid ${result.costItems}");

    try {
    
      // Get a unique list of invoices - For each applicable invoice, caculate the contribution that cost item made to the
      // total cost in the given period - EG a USD1200 invoice over 12 months contributes 1k cost per period.
      // Allocate that
      //Previous calculation for 2 years was: System.currentTimeMillis()-(1000*60*60*24*731) -> ms*sec/min*min/hr*hr/day*731 (731=365*2+1)

      log.debug("Finding all cost items for sub ${subscription.id} from ${one_year_ago}");

      def cis = CostItem.executeQuery(COST_ITEMS_FOR_SUB,[sub:subscription, start: one_year_ago]);
  
      // For each cost item, work out what apportionment of that cost item should be allocated to each period in the overall
      // subscription period.
      cis.each { cost_item ->
        // log.debug("${cost_item.id} ${cost_item.startDate} ${cost_item.endDate} ${cost_item.costInLocalCurrencyIncVAT}");
        def periods_for_cost_item = getPeriodsBetween(cost_item.startDate, cost_item.endDate);
  
        def cost_item_line = [:]
  
        // If the item is a credit item, make the total negative, otherwise it's positive
        if ( cost_item.costItemCategory?.value?.equals('Credit') ) {
          cost_item_line.total_cost = cost_item.costInLocalCurrencyIncVAT
        }
        else{
          cost_item_line.total_cost = 0 - cost_item.costInLocalCurrencyIncVAT
        }
  
        cost_item_line.number_periods = periods_for_cost_item.size();
  
        log.debug("cost_item_line so far ${cost_item_line}");
  
        if ( cost_item_line.number_periods > 0 ) {
  
          log.debug("Cost item line contains ${cost_item_line.number_periods} periods and is for total cost ${cost_item_line.total_cost}");
  
          cost_item_line.ci_id = cost_item.id
          cost_item_line.apportionment = cost_item_line.total_cost / cost_item_line.number_periods
          cost_item_line.start_year = periods_for_cost_item[0].year
          cost_item_line.start_month = periods_for_cost_item[0].month
          cost_item_line.end_year = periods_for_cost_item[cost_item_line.number_periods-1].year
          cost_item_line.end_month = periods_for_cost_item[cost_item_line.number_periods-1].month
          cost_item_line.periods = []
  
          def apportionment_status = false
          result.costItems.periods.each { per ->
            if ( per.total == null ) {
              per.total = 0.00f;
            }
  
            // If a period in the overall apportionment matches a period in this cost item, add an entry, otherwise a zero
            if ( ( per.year == cost_item_line.start_year ) && ( per.month == cost_item_line.start_month ) ) {
              apportionment_status = true
            }
            else if ( ( per.year > cost_item_line.end_year ) || ( per.year > cost_item_line.end_year && per.month > cost_item_line.end_month ) ) {
              apportionment_status = false
            }
  
  
            log.debug("period -> (${cost_item_line.start_year}-${cost_item_line.start_month} to ${cost_item_line.end_year}-${cost_item_line.end_month}) now:${per.year}-${per.month} apportion(${cost_item_line.apportionment}):${apportionment_status}");
            if ( apportionment_status ) {
              
              cost_item_line.periods.add(cost_item_line.apportionment)
              per.total += cost_item_line.apportionment
            }
            else {
              cost_item_line.periods.add(0.00f)
            }
  
          }
  
          log.debug("Cost item line : ${cost_item_line}");
          result.costItems.apportionment.add(cost_item_line)
        }
      }
  
      log.debug("Processing ${result.costItems.periods?.size()} cost per use periods");
  
      result.costItems.periods.each { per ->
        log.debug("Calculating total usage for period from ${per.period_start_date} to ${per.period_end_date} sub ${subscription?.id}");
        try {
          def subscribing_org = subscription.getSubscriber();

          if ( subscribing_org == null ) 
            throw new RuntimeException("Subscribing org is empty. Cannot continue");

          per.usage_str = Fact.executeQuery(TOTAL_USAGE_FOR_SUB_IN_PERIOD, [
                            inst:subscribing_org,
                            start:per.period_start_date, 
                            end:per.period_end_date, 
                            sub:subscription, 
                            jr1a:'JUSP:JR1' ])?.get(0)
          log.debug("query returns ${per.usage_str}");

          per.usage = Integer.parseInt((per.usage_str) ?: "0");
          log.debug("Got usage ${per.usage} ${per.usage?.class?.name}");
          if ( ( per.total != null ) && 
               ( per.usage != null ) && 
               ( per.total != 0 ) && 
               ( per.usage != 0 ) ) {
            per.cost_per_use = per.total / per.usage
          }
          else {
            log.warn("Zero cost(${per.total}) and or zero usage (${per.usage})");
            per.cost_per_use = 0;
          }
        }
        catch ( Exception e ) {
          log.error("Problem calculating cost per use",e);
          per.cost_per_use = 0;
        }
      }
    }
    catch ( Exception e ) {
      log.error("Problem trying to calculate cost per use",e);
    }
    finally {
      log.debug("getCostPerUseData returning");
    }

    result.costItems;
  }

  private List getPeriodsBetween(d1,d2) {
    def result = []
    Calendar cal = Calendar.getInstance();

    cal.setTime(d1)
    int start_year=cal.get(Calendar.YEAR);
    int start_month=cal.get(Calendar.MONTH);

    cal.setTime(d2)
    int end_year=cal.get(Calendar.YEAR);
    int end_month=cal.get(Calendar.MONTH);

    int y = start_year
    int m = start_month
    log.debug("${y} ${m} ${end_year} ${end_month}");
    for ( ; ( ( y<end_year ) || ( y==end_year && m<=end_month ) ); ) {
      // **REMEMBER** new Date(y,m,d) constructor is 1-based for d and m
      // Work out dates for the start and the end of the period so we can use them in any queries
      def period_start_date = new Date(y-1900,m,1)
      def next_month = null
      if ( m==12 ) {
        next_month= new Date(y+1-1900,1,1)
      }
      else {
        next_month= new Date(y-1900,m+1,1)
      }
      def period_end_date = new Date(next_month.getTime()-1000)
      def entry = [year:y, month:m, period_start_date:period_start_date, period_end_date:period_end_date]
      log.debug("Add entry ${entry}");
      result.add(entry)

      if ( m == 11 ) {
        m=0;
        y++
      }
      else {
        m++
      }
    }
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def details() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.subscriptionInstance =  Subscription.get(params.id)
    
    if(!userAccessCheck( result.subscriptionInstance, result.user, 'view')) return

    // result.institution = Org.findByShortcode(params.shortcode)
    result.institution = result.subscriptionInstance.subscriber
    if ( result.institution ) {
      result.subscriber_shortcode = result.institution.shortcode
      result.institutional_usage_identifier = result.institution.getIdentifierByType('JUSP');
    }

    if ( result.subscriptionInstance.isEditableBy(result.user) ) {
      result.editable = true
    }
    else {
      result.editable = false
    }


    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def modalcompare() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    result.subscriptionInstanceList=Subscription.list(params)
    result.subscriptionInstanceTotal=Subscription.count()
    result
  }
}
