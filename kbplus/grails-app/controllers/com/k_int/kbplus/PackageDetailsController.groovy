package com.k_int.kbplus

import org.springframework.dao.DataIntegrityViolationException
import grails.converters.*
import org.elasticsearch.groovy.common.xcontent.*
import groovy.xml.MarkupBuilder
import groovy.xml.StreamingMarkupBuilder
import grails.plugin.springsecurity.annotation.Secured
import com.k_int.kbplus.auth.*;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import grails.plugin.springsecurity.SpringSecurityUtils
import java.text.SimpleDateFormat
import com.k_int.kbplus.AuditLogEvent


class PackageDetailsController {

  def springSecurityService
  def transformerService
  def genericOIDService
  def ESSearchService
  def exportService
  def institutionsService
  def executorWrapperService
  def dashboardService
  
    static allowedMethods = [create: ['GET', 'POST'], edit: ['GET', 'POST'], delete: 'POST']

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def list() {
      def result = [:]
      result.user = User.get(springSecurityService.principal.id)

      result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;

      result.editable = true

      def paginate_after = params.paginate_after ?: ( (2*result.max)-1);
      result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

      def deleted_package_status =  RefdataCategory.lookupOrCreate( 'Package Status', 'Deleted' );
      def qry_params = [ps:deleted_package_status]

      def base_qry = " from Package as p where ( (p.packageStatus is null ) OR ( p.packageStatus = :ps ) ) "

      if ( params.q?.length() > 0 ) {
        base_qry += " and ( ( lower(p.name) like :q ) or ( lower(p.identifier) like :q ) )"
        qry_params.q = "%${params.q.trim().toLowerCase()}%";
      }

      if ( params.updateStartDate?.length() > 0 ) {
        base_qry += " and ( p.lastUpdated > :usd )"
        qry_params.usd = (params.date('updateStartDate','yyyy-MM-dd'));
      }

      if ( params.updateEndDate?.length() > 0 ) {
        base_qry += " and ( p.lastUpdated < :ued )"
        qry_params.eud = params.date('updateEndDate','yyyy-MM-dd');
      }

      if ( params.createStartDate?.length() > 0 ) {
        base_qry += " and ( p.dateCreated > :dc )"
        qry_params.dc = params.date('createStartDate','yyyy-MM-dd');
      }

      if ( params.createEndDate?.length() > 0 ) {
        base_qry += " and ( p.dateCreated < :ced )"
        qry_params.ced = params.date('createEndDate','yyyy-MM-dd');
      }
    
    if ((params.sort != null) && (params.sort.length() > 0)) {
      def sortOpts = params.sort.tokenize(':')
      if (sortOpts.size() == 2) {
        base_qry += " order by lower(p.${sortOpts[0]}) ${sortOpts[1]}"
      }
      else {
        base_qry += " order by lower(p.name) asc"
      }
    } else {
      base_qry += " order by lower(p.name) asc"
    }

      log.debug(base_qry)
      result.packageInstanceTotal = Subscription.executeQuery("select count(p) ${base_qry}".toString(), qry_params )[0]
      log.debug("Count of matching packages: ${result.packageInstanceTotal}");

      withFormat {
        html {
          result.packageInstanceList = Subscription.executeQuery("select p ${base_qry}".toString(), qry_params, [max:result.max, offset:result.offset]);
          result
        }
        csv {
           response.setHeader("Content-disposition", "attachment; filename=\"packages.csv\"")
           response.contentType = "text/csv"
           def packages = Subscription.executeQuery("select p ${base_qry}".toString(), qry_params) 
           def out = response.outputStream
       log.debug('colheads');
           out.withWriter { writer ->
             writer.write('Package Name, Creation Date, Last Modified, Identifier\n');
             packages.each { 
               log.debug("package into csv: " + it);
               writer.write("${it.name},${it.dateCreated},${it.lastUpdated},${it.identifier}\n")
             }
             writer.write("END");
             writer.flush();
             writer.close();
           }
           out.close()
        }
      }

    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def consortia(){

      def result = [:]
      result.user = User.get(springSecurityService.principal.id)
      result.packageInstance = Package.get(params.id)
      result.editable=isEditable()
      result.id = params.id

      def hasAccess       
      def isAdmin
      if (result.user.getAuthorities().contains(Role.findByAuthority('ROLE_ADMIN'))) {
          isAdmin = true;
      }else{
        hasAccess = result.packageInstance.orgLinks.find{it.roleType?.value == 'Package Consortia' &&
        it.org.hasUserWithRole(result.user,'INST_ADM') }
      }

      if( !isAdmin &&  hasAccess == null ) {
        flash.error = "Consortia screen only available to institution administrators for Packages with Package Consortium link."
        response.sendError(401) 
        return
      }
      def packageInstance = result.packageInstance

      def type = RefdataCategory.lookupOrCreate('Combo Type', 'Consortium')

      def institutions_in_consortia_hql = "select c.fromOrg from Combo as c where c.type = :t and c.toOrg in ( select org_role.org from Package as p join p.orgs as org_role where org_role.roleType.value = 'Package Consortia' and p = :p) order by c.fromOrg.name"
      def consortiaInstitutions = Combo.executeQuery(institutions_in_consortia_hql, [t:type, p:packageInstance])

      def package_consortia = "select org_role.org from Package as p join p.orgs as org_role where org_role.roleType.value = 'Package Consortia' and p = :p"
      def consortia = Package.executeQuery(package_consortia, [p:packageInstance]);


      def consortiaInstsWithStatus = [:]

      def hql = "SELECT role.org FROM OrgRole as role WHERE role.org = :o AND (role.roleType.value = 'Subscriber') AND ( EXISTS ( select sp from role.sub.packages as sp where sp.pkg = :p ) AND ( role.sub.status.value != 'Deleted' ) )"
      consortiaInstitutions.each{org ->
        log.debug("looking up all orgs based on consortia org ${org} and package ${packageInstance}");
        def queryParams = [o:org,p:packageInstance]
        def hasPackage = OrgRole.executeQuery(hql,  queryParams)
        if(hasPackage){
          consortiaInstsWithStatus.put(org,RefdataCategory.lookupOrCreate("YNO","Yes"))
        }else{
          consortiaInstsWithStatus.put(org,RefdataCategory.lookupOrCreate("YNO","No"))
        }
      }
      result.consortia = consortia
      result.consortiaInstsWithStatus = consortiaInstsWithStatus

      // log.debug("institutions with status are ${consortiaInstsWithStatus}")
           
      result
    }
	
	@Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def generateSlaveSubscriptions(){
      params.each { p ->
        if(p.key.startsWith("_create.") && (p.value=='on')){
         def orgID = p.key.substring(8)
         def orgaisation = Org.get(orgID)
         if(orgaisation)
          log.debug("Create slave subscription for ${orgaisation.name}")
          createNewSubscription(orgaisation,params.id,params.genSubName);
        }
      }
      redirect controller:'packageDetails', action:'consortia', params: [id:params.id]
    }

    def createNewSubscription(org,packageId,genSubName){
      //Initialize default subscription values
      log.debug("Create slave with org ${org} and packageID ${packageId}")

      def defaultSubIdentifier = java.util.UUID.randomUUID().toString()
      def pkg_to_link = Package.get(packageId)
      log.debug("Sub start Date ${pkg_to_link.startDate} and end date ${pkg_to_link.endDate}")
      pkg_to_link.createSubscription("Subscription Taken", genSubName?:"Slave subscription for ${pkg_to_link.name}", defaultSubIdentifier,
      pkg_to_link.startDate, pkg_to_link.endDate, org, "Subscriber", true, true)
	  
	  dashboardService.clearSubCount(institution)
    }

    @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
    def create() {
      def user = User.get(springSecurityService.principal.id)

      switch (request.method) {
        case 'GET':
          [packageInstance: new Package(params), user:user]
          break
        case 'POST':
          def providerName = params.contentProviderName
          def packageName = params.packageName
          def identifier = params.identifier

          def contentProvider = Org.findByName(providerName);
          def existing_pkg = Package.findByIdentifier(identifier);

          if ( contentProvider && existing_pkg==null ) {
            log.debug("Create new package, content provider = ${contentProvider}, identifier is ${identifier}");
            Package new_pkg = new Package(identifier:identifier, 
                                          contentProvider:contentProvider,
                                          name:packageName,
                                          impId:java.util.UUID.randomUUID().toString());
            if ( new_pkg.save(flush:true) ) {
              redirect action: 'edit', id:new_pkg.id
            }
            else {
              new_pkg.errors.each { e ->
                log.error("Problem: ${e}");
              }
              render view: 'create', model: [packageInstance: new_pkg, user:user]
            }
          }
          else {
            render view: 'create', model: [packageInstance: packageInstance, user:user]
            return
          }

          // flash.message = message(code: 'default.created.message', args: [message(code: 'package.label', default: 'Package'), packageInstance.id])
          // redirect action: 'show', id: packageInstance.id
          break
      }
    }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def compareModal() {
    def result = [:]
    
    if (params.pkgA && params.pkgB) {
      result.pkgInsts = []
      def pkgAId = params.pkgA.substring( params.pkgA.indexOf(":")+1)
      result.pkgInsts.add(Package.get(pkgAId))
      
      def pkgBId = params.pkgB.substring( params.pkgB.indexOf(":")+1)
      result.pkgInsts.add(Package.get(pkgBId))
    }
    else {
      def currentDate = new java.text.SimpleDateFormat('yyyy-MM-dd').format(new Date())
      params.insrt = "Y"
      params.dlt = "Y"
      params.updt = "Y"
      params.dateA = currentDate
      params.dateB = currentDate
    }
    
    result
  }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def compare(){
        def result = [:]
        result.unionList=[]
      
        result.user = User.get(springSecurityService.principal.id)
        result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;
        result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

        if (params.pkgA?.length() > 0 && params.pkgB?.length() > 0 ){

          result.pkgInsts = []
          result.pkgDates = []
          def listA
          def listB
          try{
            listA = createCompareList(params.pkgA, params.dateA, params, result)
            listB = createCompareList(params.pkgB, params.dateB, params, result)
            if(!params.countA){
              def countHQL = "select count(elements(pkg.tipps)) from Package pkg where pkg.id = :p"
              params.countA = Package.executeQuery(countHQL, [p:result.pkgInsts.get(0).id])
              params.countB = Package.executeQuery(countHQL, [p:result.pkgInsts.get(1).id])
            }
          }catch(IllegalArgumentException e){
            request.message = e.getMessage()
            return
          }
          result.listACount = listA.size()
          result.listBCount = listB.size()

          def mapA = listA.collectEntries { [it.title.title, it] }
          def mapB = listB.collectEntries { [it.title.title, it] }

          def unionList = mapA.keySet().plus(mapB.keySet()).toList() // heySet is hashSet
          unionList = unionList.unique()
          unionList.sort()

          result.unionListSize = unionList.size()
  
          def filterRules = [params.insrt?true:false, params.dlt?true:false, params.updt?true:false, params.nochng?true:false ]

          withFormat{
            html{
              def toIndex = result.offset+result.max < unionList.size()? result.offset+result.max: unionList.size()
              result.comparisonMap = 
                  institutionsService.generateComparisonMap(unionList, mapA, mapB,result.offset, toIndex.intValue(),filterRules)
              result
            }
            csv {
              try{
   
              def comparisonMap = 
              institutionsService.generateComparisonMap(unionList, mapA, mapB,0, unionList.size(),filterRules)
              log.debug("Create CSV Response")
              def dateFormatter = new java.text.SimpleDateFormat('yyyy-MM-dd')
               response.setHeader("Content-disposition", "attachment; filename=\"packageComparison.csv\"")
               response.contentType = "text/csv"
               def out = response.outputStream
               out.withWriter { writer ->
                writer.write("${result.pkgInsts[0].name} on ${params.dateA}, ${result.pkgInsts[1].name} on ${params.dateB}\n")
                writer.write('Title, pISSN, eISSN, Start Date A, Start Date B, Start Volume A, Start Volume B, Start Issue A, Start Issue B, End Date A, End Date B, End Volume A,End  Volume B,End  Issue A,End  Issue B, Coverage Note A, Coverage Note B, ColorCode\n');
                // log.debug("UnionList size is ${unionList.size}")
                comparisonMap.each { title, values ->
                  def tippA = values[0]
                  def tippB = values[1]
                  def colorCode = values[2]
                  def pissn = tippA ? tippA.title.getIdentifierValue('issn') : tippB.title.getIdentifierValue('issn');
                  def eissn = tippA? tippA.title.getIdentifierValue('eISSN') : tippB.title.getIdentifierValue('eISSN');

                  writer.write("\"${title}\",\"${pissn?:''}\",\"${eissn?:''}\",\"${formatDateOrNull(dateFormatter, tippA?.startDate)}\",\"${formatDateOrNull(dateFormatter, tippB?.startDate)}\",\"${tippA?.startVolume?:''}\",\"${tippB?.startVolume?:''}\",\"${tippA?.startIssue?:''}\",\"${tippB?.startIssue?:''}\",\"${formatDateOrNull(dateFormatter, tippA?.endDate)}\",\"${formatDateOrNull(dateFormatter, tippB?.endDate)}\",\"${tippA?.endVolume?:''}\",\"${tippB?.endVolume?:''}\",\"${tippA?.endIssue?:''}\",\"${tippB?.endIssue?:''}\",\"${tippA?.coverageNote?:''}\",\"${tippB?.coverageNote?:''}\",\"${colorCode}\"\n")
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
          }

        }else{
          def currentDate = new java.text.SimpleDateFormat('yyyy-MM-dd').format(new Date())
          params.dateA = currentDate
          params.dateB = currentDate
          params.insrt = "Y"
          params.dlt = "Y"
          params.updt = "Y"
          flash.message = "Please select two packages for comparison."
          result
        }
      
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

    def createCompareList(pkg,dateStr,params, result){
       def returnVals = [:]
       def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd')
       def date = dateStr?sdf.parse(dateStr):new Date()
       def packageId = pkg.substring( pkg.indexOf(":")+1)
        
       def packageInstance = Package.get(packageId)

       if (date < packageInstance.startDate) {
         throw new IllegalArgumentException(
           "${packageInstance.name} start date is ${sdf.format(packageInstance.startDate)}. " +
           "Date to compare it on is ${sdf.format(date)}, this is before start date.")
       }
       if (packageInstance.endDate && date > packageInstance.endDate){
         throw new IllegalArgumentException(
           "${packageInstance.name} end date is ${sdf.format(packageInstance.endDate)}. " +
           "Date to compare it on is ${sdf.format(date)}, this is after end date.")
       }

       result.pkgInsts.add(packageInstance)

       result.pkgDates.add(sdf.format(date))

       def queryParams = [packageInstance]         

       def query = generateBasePackageQuery(params,queryParams, true, date)
       def list = TitleInstancePackagePlatform.executeQuery("select tipp "+query,  queryParams);
   
       return list
    }
    
    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def show() {
      def verystarttime = exportService.printStart("PackageDetails show")
    
      def result = [:]
      boolean showDeletedTipps=false

      result.transforms = grailsApplication.config.packageTransforms
      result.feature_zendesk = Setting.findByName('feature.zendesk').value
      
      if ( SpringSecurityUtils.ifAnyGranted('ROLE_ADMIN,ROLE_KBPLUS_EDITOR') ) {
        result.editable=true
        showDeletedTipps=false; // true
      }
      else {
        result.editable=false
      }

      result.user = User.get(springSecurityService.principal.id)
      def packageInstance = Package.get(params.id)
      if (!packageInstance) {
        flash.message = message(code: 'default.not.found.message', args: [message(code: 'package.label', default: 'Package'), params.id])
        redirect action: 'list'
        return
      }

      def pending_change_pending_status = RefdataCategory.lookupOrCreate("PendingChangeStatus", "Pending")

      result.pendingChanges = PendingChange.executeQuery("select pc from PendingChange as pc where pc.pkg=:pkg and ( pc.status is null or pc.status = :st ) order by ts desc", [pkg:packageInstance, st:pending_change_pending_status]);

      log.debug("Package has ${result.pendingChanges?.size()} pending changes");

      result.pkg_link_str="${grailsApplication.config.SystemBaseURL}/packageDetails/show/${params.id}"

      if ( packageInstance.forumId != null ) {
        result.forum_url = "${grailsApplication.config.ZenDeskBaseURL}/forums/${packageInstance.forumId}"
      }

      result.subscriptionList=[]
      // We need to cycle through all the users institutions, and their respective subscripions, and add to this list
      // and subscription that does not already link this package
      def sub_status = RefdataCategory.lookupOrCreate('Subscription Status','Deleted')
      result.user?.getAuthorizedAffiliations().each { ua ->
        if ( ua.formalRole.authority == 'INST_ADM' ) {
          def qry_params = [o:ua.org, s:sub_status, p:packageInstance, d:new Date()]
          def q = "select s from Subscription as s where  ( ( exists ( select o from s.orgRelations as o where o.roleType.value = 'Subscriber' and o.org = :o ) ) ) AND ( s.status is null or s.status != :s ) AND ( not exists ( select sp from s.packages as sp where sp.pkg = :p ) ) AND s.endDate >= :d"
          Subscription.executeQuery(q, qry_params).each { s ->
            if ( ! result.subscriptionList.contains(s) ) {
              // Need to make sure that this package is not already linked to this subscription
              result.subscriptionList.add([org:ua.org,sub:s])
            }
          }
        }
      }
    
      result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;
      params.max = result.max
      def paginate_after = params.paginate_after ?: ( (2*result.max)-1);
      result.offset = params.offset ? Integer.parseInt(params.offset) : 0;
    
      def limits = (!params.format||params.format.equals("html"))?[max:result.max, offset:result.offset]:[offset:0]
    
      // def base_qry = "from TitleInstancePackagePlatform as tipp where tipp.pkg = ? "
      Map qry_params = [pkg:packageInstance]
      
      def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd');
      def today = new Date()
      if(!params.asAt){
        if(packageInstance.startDate > today){
          params.asAt = sdf.format(packageInstance.startDate)
        }else if(packageInstance.endDate < today && packageInstance.endDate){
          params.asAt = sdf.format(packageInstance.endDate)
        }
      }
      def date_filter
      if(params.mode == 'advanced'){
         date_filter = null
         params.asAt = null
      }else if(params.asAt && params.asAt.length() > 0 ) {
         date_filter = sdf.parse(params.asAt)    
      }else{
         date_filter = today
      }

      def base_qry = generateBasePackageQuery(params, qry_params, showDeletedTipps, date_filter);
    
    //edit history count for new display on page
    //def history_qry_params = [packageInstance.class.name, "${packageInstance.id}"]
    def history_qry_params = [ pkgcls:packageInstance.class.name, tippcls:'com.k_int.kbplus.TitleInstancePackagePlatform', pkgid:"${packageInstance.id}"]
    result.historyLinesTotal = AuditLogEvent.executeQuery("select count(e) from AuditLogEvent as e where ( e.className=:pkgcls and e.persistedObjectId=:pkgid ) or ( e.className = :tippcls and e.persistedObjectId in ( select id from TitleInstancePackagePlatform as tipp where tipp.pkg = :pkgid ) )",history_qry_params)[0];
    
    //expected and previous counts for new displays on page
    Map exp_prev_qry_params = [p:packageInstance]
    def exp_prev_date_filter = new Date();
    exp_prev_qry_params.dt = exp_prev_date_filter;
  
    def exp_prev_base_qry = "from TitleInstancePackagePlatform as tipp where tipp.pkg = :p and tipp.status.value != 'Deleted' "
    
    def exp_qry = exp_prev_base_qry + " and ( coalesce(tipp.accessStartDate, tipp.pkg.startDate) >= :dt ) "
    def prev_qry = exp_prev_base_qry + " and ( tipp.accessEndDate <= :dt ) "
	
	result.expectedTitles = TitleInstancePackagePlatform.executeQuery("select tipp "+exp_qry, exp_prev_qry_params)
	result.previousTitles = TitleInstancePackagePlatform.executeQuery("select tipp "+prev_qry, exp_prev_qry_params)
  
    result.expectedCount = TitleInstancePackagePlatform.executeQuery("select count(tipp) "+exp_qry, exp_prev_qry_params )[0]
    result.previousCount = TitleInstancePackagePlatform.executeQuery("select count(tipp) "+prev_qry, exp_prev_qry_params )[0]

      // log.debug("Base qry: ${base_qry}, params: ${qry_params}, result:${result}");
      result.titlesList = TitleInstancePackagePlatform.executeQuery("select tipp "+base_qry, qry_params, limits);
      result.num_tipp_rows = TitleInstancePackagePlatform.executeQuery("select count(tipp) "+base_qry, qry_params )[0]
      result.unfiltered_num_tipp_rows = TitleInstancePackagePlatform.executeQuery(
              "select count(tipp) from TitleInstancePackagePlatform as tipp where tipp.pkg = :p",[p:packageInstance])[0];

      result.lasttipp = result.offset + result.max > result.num_tipp_rows ? result.num_tipp_rows : result.offset + result.max;


      result.packageInstance = packageInstance
      if(executorWrapperService.hasRunningProcess(packageInstance)){
        result.processingpc = true
      }

    def filename = "${result.packageInstance.name}_asAt_${date_filter?sdf.format(date_filter):sdf.format(today)}"
    withFormat {
      html result
      json {
		  log.debug("Respond pkgJson, result...");
          response.setHeader("Content-disposition", "attachment; filename=\"${filename}.json\"")
		  response.contentType = "text/json"
		  render(template: 'pkgJson', model:result, contentType: "text/json", encoding: "UTF-8")
      }
      xml {
		  result.formatter = new java.text.SimpleDateFormat('yyyy-MM-dd')
          response.setHeader("Content-disposition", "attachment; filename=\"${filename}.xml\"")
		  response.contentType = "text/xml"
		  render(template: 'pkgXml', model:result, contentType: "text/xml", encoding: "UTF-8")
      }
	  csv {
		  response.contentType = "text/csv"
		  if ( params.transformId == "kbart2" ) {
			  response.setHeader("Content-disposition", "attachment; filename=\"${filename}.txt\"")
		  }
		  else {
			  response.setHeader("Content-disposition", "attachment; filename=\"${filename}.csv\"")
		  }
		  render(template: params.transformId+'_csv', model:result, contentType: "text/csv", encoding: "UTF-8")
	  }
    }
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def editPackage(){
    def result = [:]
    log.debug('getting edit modal: ' + params)
    result.user = User.get(springSecurityService.principal.id)
    result.packageInstance = Package.get(params.id)
    
    def provider = result.packageInstance.getContentProvider();
    if ( provider ) {
      def licensor_ref = RefdataCategory.lookupOrCreate('Organisational Role','Licensor');
      def qry_params = [o:provider, rt:licensor_ref]
      def qry = "select l from License as l where exists ( select ol from OrgRole as ol where ol.lic = l AND ol.org = :o and ol.roleType = :rt ) AND l.status.value != 'Deleted' order by l.reference"
      def license_list = License.executeQuery(qry, qry_params);
      result.licences = license_list
    }
    
    def public_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='YN'"
    def publicPackage = RefdataValue.executeQuery(public_qry,[])
    
    def packageListStatus_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='" + RefdataCategory.PKG_LIST_STAT + "'"
    def packageListStatus = RefdataValue.executeQuery(packageListStatus_qry,[])
    
    def breakable_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='" + RefdataCategory.PKG_BREAKABLE + "'"
    def breakable = RefdataValue.executeQuery(breakable_qry,[])
    
    def consistent_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='" + RefdataCategory.PKG_CONSISTENT + "'"
    def consistent = RefdataValue.executeQuery(consistent_qry,[])
    
    def fixed_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='" + RefdataCategory.PKG_FIXED + "'"
    def fixed = RefdataValue.executeQuery(fixed_qry,[])
    
    def packageScope_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='" + RefdataCategory.PKG_SCOPE + "'"
    def packageScope = RefdataValue.executeQuery(packageScope_qry,[])
    
    render(template:"editPackage", model:[packageInstance:result.packageInstance, licences:result?.licences, publicPackage:publicPackage,
        packageListStatus:packageListStatus, breakable:breakable, consistent:consistent, fixed:fixed, packageScope:packageScope])
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processEditPackage(){
    log.debug('params: ' + params)
    
    def pkg = Package.get(params.id)
    
    pkg.name = params.packageName
    if (params?.licence) {
      def lic = License.get(params.licence)
      if (lic) {
        pkg.license = lic
      }
    }
    else {
      pkg.license = null
    }
    
    def sdf = new SimpleDateFormat('yyyy-MM-dd')
    if (params.startDate) {
      pkg.startDate = sdf.parse(params.startDate)
    }
    else {
      pkg.startDate = null
    }
    
    if (params.endDate) {
      pkg.endDate = sdf.parse(params.endDate)
    }
    else {
      pkg.endDate = null
    }
    
    if (params?.public) {
      def isPublic =  RefdataValue.get(params.public)
      if (isPublic) {
        pkg.isPublic = isPublic
      }
    }
    else {
      pkg.isPublic = null
    }
    
    if (params?.vendorURL) {
      pkg.vendorURL = params.vendorURL
    }
    else {
      pkg.vendorURL = null
    }
    
    if (params?.packageListStatus) {
      def packageListStatus =  RefdataValue.get(params.packageListStatus)
      if (packageListStatus) {
        pkg.packageListStatus = packageListStatus
      }
    }
	else {
      pkg.packageListStatus = null
    }

    if (params?.breakable) {
      def breakable =  RefdataValue.get(params.breakable)
      if (breakable) {
        pkg.breakable = breakable
      }
    }
    else {
      pkg.breakable = null
    }
    
    if (params?.consistent) {
      def consistent =  RefdataValue.get(params.consistent)
      if (consistent) {
        pkg.consistent = consistent
      }
    }
    else {
      pkg.consistent = null
    }
    
    if (params?.fixed) {
      def fixed =  RefdataValue.get(params.fixed)
      if (fixed) {
        pkg.fixed = fixed
      }
    }
    else {
      pkg.fixed = null
    }
    
    if (params?.packageScope) {
      def packageScope =  RefdataValue.get(params.packageScope)
      if (packageScope) {
        pkg.packageScope = packageScope
      }
    }
    else {
      pkg.packageScope = null
    }
    
    log.debug('attempting to save edited package with id: ' + params.id)
    pkg.save(flush:true, failOnError:true)
    log.debug('saved edited package with id: ' + params.id)
    
    //redirect action: 'index', id:params.id, params:[defaultInstShortcode:params.defaultInstShortcode]
    redirect(url: request.getHeader('referer'))
  }
  
  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def addTitleModal() {
	  log.debug('addTitleModal(): ' + params)
	  def result = [:]
	  
	  result.pkg = Package.get(params.id)
	  
	  if ( SpringSecurityUtils.ifAllGranted('ROLE_ADMIN') ) {
		  result.editable=true
	  }
	  else {
		  result.editable=false
	  }
	  
	  result
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def exportPackage(){
    def packageInstance = Package.get(params.id)
    def transforms = grailsApplication.config.packageTransforms
    
    render(template:"/templates/package_export_modal", model:[packageInstance:packageInstance, transforms:transforms])
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def current() {
    log.debug("current ${params}");
    def result = [:]
    boolean showDeletedTipps=false
    result.user = User.get(springSecurityService.principal.id)
    result.editable=isEditable()

    def packageInstance = Package.get(params.id)
    if (!packageInstance) {
      flash.message = message(code: 'default.not.found.message', args: [message(code: 'package.label', default: 'Package'), params.id])
      redirect action: 'list'
      return
    }
    result.packageInstance = packageInstance

    result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize
    params.max = result.max
    def paginate_after = params.paginate_after ?: ( (2*result.max)-1);
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

    def limits = (!params.format||params.format.equals("html"))?[max:result.max, offset:result.offset]:[offset:0]

    // def base_qry = "from TitleInstancePackagePlatform as tipp where tipp.pkg = ? "
    def qry_params = [packageInstance]
    def date_filter =  params.mode == 'advanced' ? null : new Date();

    def base_qry = generateBasePackageQuery(params, qry_params, showDeletedTipps, date_filter);

    log.debug("Base qry: ${base_qry}, params: ${qry_params}, result:${result}");
    result.titlesList = TitleInstancePackagePlatform.executeQuery("select tipp "+base_qry, qry_params, limits);
    result.num_tipp_rows = TitleInstancePackagePlatform.executeQuery("select count(tipp) "+base_qry, qry_params )[0]

    result.lasttipp = result.offset + result.max > result.num_tipp_rows ? result.num_tipp_rows : result.offset + result.max;


    result
  }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def deleteDocuments() {
        def ctxlist = []

        log.debug("deleteDocuments ${params}");

        params.each { p ->
            if (p.key.startsWith('_deleteflag"@.') ) {
                def docctx_to_delete = p.key.substring(12);
                log.debug("Looking up docctx ${docctx_to_delete} for delete");
                def docctx = DocContext.get(docctx_to_delete)
                docctx.status = RefdataCategory.lookupOrCreate('Document Context Status','Deleted');
            }
        }

        redirect controller: 'packageDetails', action:params.redirectAction, id:params.instanceId
    }



  @Secured(['ROLE_USER','IS_AUTHENTICATED_FULLY'])
  def documents() {
      def result = [:]
      result.user = User.get(springSecurityService.principal.id)
      result.packageInstance = Package.get(params.id)
      result.editable=isEditable()

      result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def expected() {
    previous_expected(params,"expected")
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def previous() {
      previous_expected(params,"previous")
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def previous_expected(params,func) {
    log.debug("previous_expected ${params}");
    def result = [:]
    boolean showDeletedTipps=false
    result.user = User.get(springSecurityService.principal.id)
    result.editable=isEditable()
    def packageInstance = Package.get(params.id)
    if (!packageInstance) {
      flash.message = message(code: 'default.not.found.message', args: [message(code: 'package.label', default: 'Package'), params.id])
      redirect action: 'list'
      return
    }
    result.packageInstance = packageInstance

    result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize
    params.max = result.max
    def paginate_after = params.paginate_after ?: ( (2*result.max)-1);
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

    def limits = (!params.format||params.format.equals("html"))?[max:result.max, offset:result.offset]:[offset:0]

    // def base_qry = "from TitleInstancePackagePlatform as tipp where tipp.pkg = ? "
    def qry_params = [packageInstance]

    def base_qry = "from TitleInstancePackagePlatform as tipp where tipp.pkg = ? "
    base_qry += "and tipp.status.value != 'Deleted' "

    if(func=="expected"){
      base_qry += " and ( coalesce(tipp.accessStartDate, tipp.pkg.startDate) >= ? ) "
    }else{
      base_qry += " and ( tipp.accessEndDate <= ? ) "
    }
    qry_params.add(new Date());
    

    base_qry += " order by ${params.sort?:'tipp.title.sortTitle'} ${params.order?:'asc'} "

    log.debug("Base qry: ${base_qry}, params: ${qry_params}, result:${result}");
    result.titlesList = TitleInstancePackagePlatform.executeQuery("select tipp "+base_qry, qry_params, limits);
    result.num_tipp_rows = TitleInstancePackagePlatform.executeQuery("select count(tipp) "+base_qry, qry_params )[0]

    result.lasttipp = result.offset + result.max > result.num_tipp_rows ? result.num_tipp_rows : result.offset + result.max;

    result
  }

 

  def generateBasePackageQuery(params, qry_params, showDeletedTipps, asAt) {

    def base_qry = "from TitleInstancePackagePlatform as tipp where tipp.pkg = :pkg "

     if ( showDeletedTipps != true ) {
         base_qry += "and tipp.status.value != 'Deleted' "
     }

    if ( asAt != null ) {
      base_qry += " and ( ( :start_date >= coalesce(tipp.accessStartDate, tipp.pkg.startDate) ) and ( ( :start_date <= tipp.accessEndDate ) or ( tipp.accessEndDate is null ) ) ) "
      qry_params.start_date = asAt;
    }

    if ( params.filter ) {
      base_qry += " and ( ( lower(tipp.title.title) like :t1 ) or ( exists ( from IdentifierOccurrence io where io.ti.id = tipp.title.id and io.identifier.value like :i1 ) ) )"
      qry_params.t1 = ("%${params.filter.trim().toLowerCase()}%")
      qry_params.i1 = ("%${params.filter}%")
    }

    if ( params.coverageNoteFilter ) {
      base_qry += "and lower(tipp.coverageNote) like :coverage_note"
      qry_params.coverage_note = ("%${params.coverageNoteFilter?.toLowerCase()}%")
    }

    if ( params.endsAfter && params.endsAfter.length() > 0 ) {
      def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd');
      def d = sdf.parse(params.endsAfter)
      base_qry += " and tipp.endDate >= :end_date"
      qry_params.end_date = (d)
    }

    if ( params.startsBefore && params.startsBefore.length() > 0 ) {
      def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd');
      def d = sdf.parse(params.startsBefore)
      base_qry += " and tipp.startDate <= :start_date"
      qry_params.start_date = (d)
    }

    if ( ( params.sort != null ) && ( params.sort.length() > 0 ) ) {
      base_qry += " order by lower(${params.sort}) ${params.order}"
    }
    else {
      base_qry += " order by lower(tipp.title.title) asc"
    }

    return base_qry
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def uploadTitles() {
    def pkg = Package.get(params.id)
    def upload_mime_type = request.getFile("titleFile")?.contentType
    log.debug("Uploaded content type: ${upload_mime_type}");
    def input_stream = request.getFile("titleFile")?.inputStream

    if ( upload_mime_type=='application/vnd.ms-excel' ) {
      attemptXLSLoad(pkg,input_stream);
    }
    else {
      attemptCSVLoad(pkg,input_stream);
    }

    redirect action:'show', id:params.id
  }

  def attemptXLSLoad(pkg,stream) {
    log.debug("attemptXLSLoad");
    HSSFWorkbook wb = new HSSFWorkbook(stream);
    HSSFSheet hssfSheet = wb.getSheetAt(0);

    attemptv1XLSLoad(pkg,hssfSheet);
  }

  def attemptCSVLoad(pkg,stream) {
    log.debug("attemptCSVLoad");
    attemptv1CSVLoad(pkg,stream);
  }

  def attemptv1XLSLoad(pkg,hssfSheet) {

    log.debug("attemptv1XLSLoad");
    def extracted = [:]
    extracted.rows = []

    int row_counter = 0;
    Iterator rowIterator = hssfSheet.rowIterator();
    while (rowIterator.hasNext()) {
      HSSFRow hssfRow = (HSSFRow) rowIterator.next();
      switch(row_counter++){
        case 0:
          break;
        case 1:
          break;
        case 2:
          // Record header row
          log.debug("Header");
          hssfRow.cellIterator().each { c ->
            log.debug("Col: ${c.toString()}");
          }
          break;
        default:
          // A real data row
          def row_info = [
            issn:hssfRow.getCell(0)?.toString(),
            eissn:hssfRow.getCell(1)?.toString(),
            date_first_issue_online:hssfRow.getCell(2)?.toString(),
            num_first_volume_online:hssfRow.getCell(3)?.toString(),
            num_first_issue_online:hssfRow.getCell(4)?.toString(),
            date_last_issue_online:hssfRow.getCell(5)?.toString(),
            date_first_volume_online:hssfRow.getCell(6)?.toString(),
            date_first_issue_online:hssfRow.getCell(7)?.toString(),
            embargo:hssfRow.getCell(8)?.toString(),
            coverageDepth:hssfRow.getCell(9)?.toString(),
            coverageNote:hssfRow.getCell(10)?.toString(),
            platformUrl:hssfRow.getCell(11)?.toString()
          ]

          extracted.rows.add(row_info);
          log.debug("datarow: ${row_info}");
          break;
      }
    }
    
    processExractedData(pkg,extracted);
  }

  def attemptv1CSVLoad(pkg,stream) {
    log.debug("attemptv1CSVLoad");
    def extracted = [:]
    processExractedData(pkg,extracted);
  }

  def processExractedData(pkg, extracted_data) {
    log.debug("processExractedData...");
    List old_title_list = [ [title: [id:667]], [title:[id:553]], [title:[id:19]] ]
    List new_title_list = [ [title: [id:19]], [title:[id:554]], [title:[id:667]] ]

    reconcile(old_title_list, new_title_list);
  }

  def reconcile(old_title_list, new_title_list) {
    def title_list_comparator = new com.k_int.kbplus.utils.TitleComparator()
    Collections.sort(old_title_list, title_list_comparator)
    Collections.sort(new_title_list, title_list_comparator)

    Iterator i1 = old_title_list.iterator()
    Iterator i2 = new_title_list.iterator()

    def current_old_title = i1.hasNext() ? i1.next() : null;
    def current_new_title = i2.hasNext() ? i2.next() : null;
    
    while ( current_old_title || current_new_title ) {
      if ( current_old_title == null ) {
        // We have exhausted all old titles. Everything in the new title list must be newly added
        log.debug("Title added: ${current_new_title.title.id}");
        current_new_title = i2.hasNext() ? i2.next() : null;
      }
      else if ( current_new_title == null ) {
        // We have exhausted new old titles. Everything remaining in the old titles list must have been removed
        log.debug("Title removed: ${current_old_title.title.id}");
        current_old_title = i1.hasNext() ? i1.next() : null;
      }
      else {
        // Work out whats changed
        if ( current_old_title.title.id == current_new_title.title.id ) {
          // This title appears in both old and new lists, it may be an updated
          log.debug("title ${current_old_title.title.id} appears in both lists - possible update / unchanged");
          current_old_title = i1.hasNext() ? i1.next() : null;
          current_new_title = i2.hasNext() ? i2.next() : null;
        }
        else {
          if ( current_old_title.title.id > current_new_title.title.id ) {
            // The current old title id is greater than the current new title. This means that a new title must
            // have been introduced into the new list with a lower title id than the one on the current list.
            // hence, current_new_title.title.id is a new record. Consume it and move forwards.
            log.debug("Title added: ${current_new_title.title.id}");
            current_new_title = i2.hasNext() ? i2.next() : null;
          }
          else {
            // The current old title is less than the current new title. This indicates that the current_old_title
            // must have been removed in the new list. Process it as a removal and continue.
            log.debug("Title removed: ${current_old_title.title.id}");
            current_old_title = i1.hasNext() ? i1.next() : null;
          }
        }
      }
    }
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def index() {
    def result = [:]
    result.user = springSecurityService.getCurrentUser()
    params.max = result.user.defaultPageSize

    if (springSecurityService.isLoggedIn()) {
      params.rectype = "Package" // Tells ESSearchService what to look for
      if(params.q == "")  params.remove('q');
     
      if(params.search.equals("yes")){
        //when searching make sure results start from first page
        params.offset = 0
        params.remove("search")
      }
	  
	  if (params.sort) {
        def sortOpts = params.sort.tokenize(':')
	    if (sortOpts.size() == 2){
		  params.sort = sortOpts[0]
		  params.order = sortOpts[1]
	    }
		else {
		  params.sort = "sortname.keyword"
		}
	  }
	  else {
		params.sort = "sortname.keyword"
	  }

      result =  ESSearchService.search(params)   
    }
    result  
  }

  def isEditable(){
    if ( SpringSecurityUtils.ifAllGranted('ROLE_ADMIN') ) {
      return true
    }
    else {
      return false
    }
  }


  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def addToSub() {
    log.debug('params: ' + params)
    def pkg = Package.get(params.id)
    def sub = Subscription.get(params.subid)

    def add_entitlements = ( params.addEntitlements == 'on' ? true : false )
    pkg.addToSubscription(sub,add_entitlements)
  
  if (params.defaultInstShortcode) {
      redirect(action:'show', params: [id:params.id, defaultInstShortcode:params.defaultInstShortcode]);
  }
  else {
    redirect(action:'show', params: [id:params.id]);
  }
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def addToPrd() {
	log.debug('params: ' + params)
	def pkg = Package.get(params.id)
	def prd = Product.get(params.prdid)

	pkg.addToProduct(prd)
  
    if (params.defaultInstShortcode) {
	  redirect(action:'show', params: [id:params.id, defaultInstShortcode:params.defaultInstShortcode]);
    }
    else {
	  redirect(action:'show', params: [id:params.id]);
    }
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def getAddPrdView() {
	  def result = [:]
	  log.debug('getting edit modal: ' + params)
	  result.user = User.get(springSecurityService.principal.id)
	  result.packageInstance = Package.get(params.id)
	  result.productList=[]
	  // TODO rewrite query to select relevant products for package
	  def q = "select p from Product as p WHERE ( not exists ( select pp from p.packages as pp where pp.pkg = :p ) )"
	  def qry_params = [p:result.packageInstance]
	  Product.executeQuery(q, qry_params).each { p ->
		if ( ! result.productList.contains(p) ) {
		  // Need to make sure that this package is not already linked to this product
		  result.productList.add([prd:p])
		}
	  }
	  render(template: "addProduct", model:[packageInstance: result.packageInstance, productList:result.productList])
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def notes() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.packageInstance = Package.get(params.id)
    result.editable=isEditable()
    result
  }
  
  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def batchModal(){
	  log.debug("batchModal(): ${params}")
	  def result = [:]
	  result.pkg = Package.get(params.id)

      def hybridOA_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc='TitleInstancePackagePlatform.HybridOA'"
      result.hybridOA = RefdataValue.executeQuery(hybridOA_qry,[])

	  result
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def packageBatchUpdate() {

    def packageInstance = Package.get(params.id)
    boolean showDeletedTipps=false

    if ( SpringSecurityUtils.ifAllGranted('ROLE_ADMIN') ) {
      showDeletedTipps=true
    }

    log.debug("packageBatchUpdate ${params}");

    def formatter = new java.text.SimpleDateFormat("yyyy-MM-dd")

    def bulk_fields = [
      [ formProp:'start_date', domainClassProp:'startDate', type:'date'],
      [ formProp:'start_volume', domainClassProp:'startVolume'],
      [ formProp:'start_issue', domainClassProp:'startIssue'],
      [ formProp:'end_date', domainClassProp:'endDate', type:'date'],
      [ formProp:'end_volume', domainClassProp:'endVolume'],
      [ formProp:'end_issue', domainClassProp:'endIssue'],
      [ formProp:'coverage_depth', domainClassProp:'coverageDepth'],
      [ formProp:'coverage_note', domainClassProp:'coverageNote'],
      [ formProp:'embargo', domainClassProp:'embargo'],
      [ formProp:'delayedOA', domainClassProp:'delayedOA', type:'ref'],
      [ formProp:'hybridOA', domainClassProp:'hybridOA', type:'ref'],
      [ formProp:'payment', domainClassProp:'payment', type:'ref'],
      [ formProp:'hostPlatformURL', domainClassProp:'hostPlatformURL'],
    ]

    //TODO: this needs modifying as no design for batch all and batch selected, only batch selected, also no delete in batch all for some reason at the moment??
    if ( params.BatchSelectedBtn=='on' ) {
      log.debug("Apply batch changes - selected")
      params.filter=null //remove filters
      params.coverageNoteFilter=null
      params.startsBefore=null
      params.endsAfter=null

      params.each { p ->
        if (p.key.startsWith('_bulkflag.') && ( p.value == 'on' ) ) {
          def tipp_id_to_edit = p.key.substring(10);
          log.debug("row selected for bulk edit: ${tipp_id_to_edit}");
          def tipp_to_bulk_edit = TitleInstancePackagePlatform.get(tipp_id_to_edit);
          boolean changed = false

          if ( params.bulkOperation=='edit') {
            //JN - Does hit this bit...
            bulk_fields.each { bulk_field_defn ->
              if ( params["clear_${bulk_field_defn.formProp}"] == 'on' ) {
                      log.debug("Request to clear field ${bulk_field_defn.formProp}");
                      tipp_to_bulk_edit[bulk_field_defn.domainClassProp] = null
                      changed = true
                  }
                  else {
                    //JN - Gets here
                    def proposed_value = params['bulk_'+bulk_field_defn.formProp]
                      //JN - Proposed value is null or empty string
                      if ( ( proposed_value != null ) && ( proposed_value.length() > 0 ) ) {
                          log.debug("Set field ${bulk_field_defn.formProp} to ${proposed_value}");
                          if ( bulk_field_defn.type == 'date' ) {
                              tipp_to_bulk_edit[bulk_field_defn.domainClassProp] = formatter.parse(proposed_value)
                            log.debug("Date TIPP field to bulk edit: "+tipp_to_bulk_edit)

                          }
                          else if ( bulk_field_defn.type == 'ref' ) {
                            log.debug("Recognising field as REF")
                            tipp_to_bulk_edit[bulk_field_defn.domainClassProp] = genericOIDService.resolveOID(proposed_value)
                            log.debug("Ref TIPP field to bulk edit: "+tipp_to_bulk_edit)

                          }
                          else {
                              tipp_to_bulk_edit[bulk_field_defn.domainClassProp] = proposed_value
                            log.debug("Else TIPP field to bulk edit: "+tipp_to_bulk_edit)

                          }
                          changed = true
                      }
                      //JN - Hits debug below - Ref value doesn't look to be tied in or captured...
                      log.debug("No proposed value conditions hit...")
              }
            }
            if ( changed )
              tipp_to_bulk_edit.save(flush:true, failOnError:true);
          }
          else {
            log.debug("Bulk removal ${tipp_to_bulk_edit.id}");
            tipp_to_bulk_edit.status = RefdataCategory.lookupOrCreate( RefdataCategory.TIPP_STATUS, 'Deleted' );
            tipp_to_bulk_edit.save(flush:true, failOnError:true);
          }
        }
      }
    }
    else if ( params.BatchAllBtn=='on' ) {
      log.debug("Batch process all filtered by: "+params.filter);
      def qry_params = [packageInstance]
      def base_qry = generateBasePackageQuery(params, qry_params, showDeletedTipps, new Date())
      def tipplist = TitleInstancePackagePlatform.executeQuery("select tipp "+base_qry, qry_params)
      tipplist.each {  tipp_to_bulk_edit ->
        boolean changed=false
        log.debug("update tipp ${tipp_to_bulk_edit.id}");
        if ( params.bulkOperation=='edit') {
          bulk_fields.each { bulk_field_defn ->
            if ( params["clear_${bulk_field_defn.formProp}"] == 'on' ) {
              log.debug("Request to clear field ${bulk_field_defn.formProp}");
              tipp_to_bulk_edit[bulk_field_defn.domainClassProp] = null
              changed = true
            }
            else {
              def proposed_value = params['bulk_'+bulk_field_defn.formProp]
              if ( ( proposed_value != null ) && ( proposed_value.length() > 0 ) ) {
                log.debug("Set field ${bulk_field_defn.formProp} to proposed_value");
                if ( bulk_field_defn.type == 'date' ) {
                  tipp_to_bulk_edit[bulk_field_defn.domainClassProp] = formatter.parse(proposed_value)
                }
                else if ( bulk_field_defn.type == 'ref' ) {
                  tipp_to_bulk_edit[bulk_field_defn.domainClassProp] = genericOIDService.resolveOID(proposed_value)
                }
                else {
                  tipp_to_bulk_edit[bulk_field_defn.domainClassProp] = proposed_value
                }
                changed = true
              }
            }
          }
          if ( changed )
            tipp_to_bulk_edit.save(flush:true, failOnError:true);
        }
      }
    }
	
	def params_map = [id:params.id,sort:params.sort,order:params.order,max:params.max,offset:params.offset]
	if (params.defaultInstShortcode) {
		params_map += [defaultInstShortcode:params.defaultInstShortcode]
	}
    redirect(action:'show', params:params_map);
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def history() {
    def result = [:]
    def exporting = params.format == 'csv' ? true : false

    if ( exporting ) {
      result.max = 9999999
      params.max = 9999999
      result.offset = 0
    }
    else {
      def user = User.get(springSecurityService.principal.id)
      result.max = params.max ? Integer.parseInt(params.max) : user.defaultPageSize
      params.max = result.max
      result.offset = params.offset ? Integer.parseInt(params.offset) : 0;
    }

    result.packageInstance = Package.get(params.id)
    result.editable=isEditable()
    def base_query = 'from AuditLogEvent as e where ( e.className = :pkgcls and e.persistedObjectId = :pkgid ) or ( e.className = :tippcls and e.persistedObjectId in ( select id from TitleInstancePackagePlatform as tipp where tipp.pkg = :pkgid ) )'

    def limits = (!params.format||params.format.equals("html"))?[max:result.max, offset:result.offset]:[offset:0]

    def query_params = [ pkgcls:'com.k_int.kbplus.Package', tippcls:'com.k_int.kbplus.TitleInstancePackagePlatform', pkgid:params.id]

    log.debug("base_query: ${base_query}, params:${query_params}, limits:${limits}");

    result.historyLines = AuditLogEvent.executeQuery('select e '+base_query+' order by e.lastUpdated desc', query_params, limits);
    result.historyLinesTotal = AuditLogEvent.executeQuery('select count(e) '+base_query, query_params)[0];
    result.formattedHistoryLines = []


    result.historyLines.each { hl ->

        def line_to_add = [:]
        def linetype = null

        switch(hl.className) {
          case 'com.k_int.kbplus.Package':
            def package_object = Package.get(hl.persistedObjectId);
            line_to_add = [ link: createLink(controller:'packageDetails', action: 'show', id:hl.persistedObjectId, params:[defaultInstShortcode:params.defaultInstShortcode]),
                            name: package_object.toString(),
                            lastUpdated: hl.lastUpdated,
                            propertyName: hl.propertyName,
                            actor: User.findByUsername(hl.actor),
                            oldValue: hl.oldValue,
                            newValue: hl.newValue
                          ]
            linetype = 'Package'
            break;
          case 'com.k_int.kbplus.TitleInstancePackagePlatform':
            def tipp_object = TitleInstancePackagePlatform.get(hl.persistedObjectId);
            if ( tipp_object != null ) {
              line_to_add = [ link: createLink(controller:'tipp', action: 'show', id:hl.persistedObjectId),
                              name: tipp_object.title?.title + " / "+tipp_object.pkg?.name,
                              lastUpdated: hl.lastUpdated,
                              propertyName: hl.propertyName,
                              actor: User.findByUsername(hl.actor),
                              oldValue: hl.oldValue,
                              newValue: hl.newValue
                            ]
              linetype = 'TIPP'
            }
            else {
              log.debug("Cleaning up history line that relates to a deleted item");
              hl.delete();
            }
        }
        switch ( hl.eventName ) {
          case 'INSERT':
            line_to_add.eventName= "New ${linetype}"
            break;
          case 'UPDATE':
            line_to_add.eventName= "Updated ${linetype}"
            break;
          case 'DELETE':
            line_to_add.eventName= "Deleted ${linetype}"
            break;
          default:
            line_to_add.eventName= "Unknown ${linetype}"
            break;
        }
        result.formattedHistoryLines.add(line_to_add);
    }

    result
  }
}
