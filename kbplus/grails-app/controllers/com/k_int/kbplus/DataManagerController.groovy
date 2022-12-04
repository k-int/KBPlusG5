package com.k_int.kbplus

import static grails.async.Promises.*
import grails.async.Promise;
import static java.util.concurrent.TimeUnit.*

import java.text.SimpleDateFormat

import com.k_int.custprops.PropertyDefinition
import com.k_int.kbplus.auth.User
import com.k_int.utils.DatabaseMessageSource
import grails.converters.*
import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.annotation.Secured
import grails.gorm.transactions.Transactional
import au.com.bytecode.opencsv.CSVReader
import org.apache.commons.io.input.BOMInputStream

class DataManagerController {

  def springSecurityService 
  def institutionsService
  static String TEMPLATE_LICENSES_QUERY = " from License as l where l.type.value = :templateType and ( l.status!=:lic_status or l.status=null )"
  static String ALL_LICENSES_QUERY = " from License as l where exists ( select ol from OrgRole as ol where ol.lic = l AND ol.roleType = :org_role ) AND (l.status!=:lic_status or l.status=null ) "

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def index() { 
    def result =[:]
    def pending_change_pending_status = RefdataCategory.lookupOrCreate("PendingChangeStatus", "Pending")

    result.pendingChanges = PendingChange.executeQuery("select pc from PendingChange as pc where pc.pkg is not null and ( pc.status is null or pc.status = ? ) order by ts desc", [pending_change_pending_status]);

    result
  }


  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def changeLog() { 

    def result =[:]
    log.debug("changeLog ${params}");
    def formatter = new java.text.SimpleDateFormat("yyyy-MM-dd")

    def exporting = params.format == 'csv' ? true : false

    if ( exporting ) {
      result.max = 100000
      params.max = 100000
      result.offset = 0
    }
    else {
      def user = User.get(springSecurityService.principal.id)
      result.max = params.max ? Integer.parseInt(params.max) : user.defaultPageSize
      params.max = result.max
      result.offset = params.offset ? Integer.parseInt(params.offset) : 0;
    }

    if ( params.startDate == null ) {
      def cal = new java.util.GregorianCalendar()
      cal.setTimeInMillis(System.currentTimeMillis())
      cal.set(Calendar.DAY_OF_MONTH,1)
      params.startDate=formatter.format(cal.getTime())
    }
    if ( params.endDate == null ) { params.endDate = formatter.format(new Date()) }
    if ( ( params.creates == null ) && ( params.updates == null ) ) {
      params.creates='Y'
    }
    if(params.startDate > params.endDate){
      flash.error = "From Date cannot be after To Date."
      return
    }
    def base_query = "from AuditLogEvent as e where e.className in (:l) AND e.lastUpdated >= :s AND e.lastUpdated <= :e AND e.eventName in (:t)"

    def types_to_include = []
    if ( params.packages=="Y" ) types_to_include.add('com.k_int.kbplus.Package');
    if ( params.licenses=="Y" ) types_to_include.add('com.k_int.kbplus.License');
    if ( params.titles=="Y" ) types_to_include.add('com.k_int.kbplus.TitleInstance');
    if ( params.tipps=="Y" ) types_to_include.add('com.k_int.kbplus.TitleInstancePackagePlatform');
    // com.k_int.kbplus.Subscription                 |
    // com.k_int.kbplus.IdentifierOccurrence         |

    def events_to_include=[]
    if ( params.creates=="Y" ) events_to_include.add('INSERT');
    if ( params.updates=="Y" ) events_to_include.add('UPDATE');
    
    result.actors = []
    def actors_dms = []
    def actors_users = []

    def all_types = [ 'com.k_int.kbplus.Package','com.k_int.kbplus.License','com.k_int.kbplus.TitleInstance','com.k_int.kbplus.TitleInstancePackagePlatform' ]

    // Get a distinct list of actors
    def auditActors = AuditLogEvent.executeQuery('select distinct(al.actor) from AuditLogEvent as al where al.className in ( :l  )',[l:all_types])

    def formal_role = com.k_int.kbplus.auth.Role.findByAuthority('INST_ADM')
     
    // From the list of users, extract and who have the INST_ADM role
    def rolesMa = []
    if ( auditActors )
      rolesMa = com.k_int.kbplus.auth.UserOrg.executeQuery(
        'select distinct(userorg.user.username) from UserOrg as userorg ' +
        'where userorg.formalRole = (:formal_role) and userorg.user.username in (:actors)',
        [formal_role:formal_role,actors:auditActors])

    auditActors.each {
      def u = User.findByUsername(it)
      
      if ( u != null ) {
        if(rolesMa.contains(it)){
          actors_dms.add([it, u.displayName]) 
        }else{
          actors_users.add([it, u.displayName]) 
        }
      }
    }

    // Sort the list of data manager users
    actors_dms.sort{it[1]}

    // Sort the list of ordinary users
    actors_users.sort{it[1]}

    result.actors = actors_dms.plus(actors_users)

    log.debug("${params}");
    if ( types_to_include.size() == 0 ) {
      types_to_include.add('com.k_int.kbplus.Package')
      params.packages="Y"
    }

    def start_date = formatter.parse(params.startDate)
    def end_date = formatter.parse(params.endDate)

    final long hoursInMillis = 60L * 60L * 1000L;
    end_date = new Date(end_date.getTime() + (24L * hoursInMillis - 2000L)); 

    def query_params = ['l':types_to_include,'s':start_date,'e':end_date, 't':events_to_include]
   

    def filterActors = params.findAll{it.key.startsWith("change_actor_")}
    if(filterActors) {
      def multipleActors = false;
      def condition = "AND ( "
      filterActors.each{        
          if(multipleActors){
            condition = "OR"
          }
          if ( it == "change_actor_PEOPLE" ) {
            base_query += " ${condition} e.actor <> \'system\' AND e.actor <> \'anonymousUser\' "
            multipleActors = true
          }
          else if(it.key != 'change_actor_ALL' && it.key != 'change_actor_PEOPLE'){
            def paramKey = it.key.replaceAll("[^A-Za-z]", "")//remove things that can cause problems in sql
            base_query += " ${condition} e.actor = :${paramKey} "
            query_params."${paramKey}" = it.key.split("change_actor_")[1]
            multipleActors = true
          }     
      } 
      base_query += " ) "  
    }
  
  

    if ( types_to_include.size() > 0 ) {
  
      def limits = (!params.format||params.format.equals("html"))?[max:result.max, offset:result.offset]:[max:result.max,offset:0]
      result.historyLines = AuditLogEvent.executeQuery('select e '+base_query+' order by e.lastUpdated desc', 
                                                       query_params, limits);
      result.num_hl = AuditLogEvent.executeQuery('select count(e) '+base_query,
                                                 query_params)[0];
      result.formattedHistoryLines = []
      result.historyLines.each { hl ->
  
        def line_to_add = [ lastUpdated: hl.lastUpdated,
                            actor: User.findByUsername(hl.actor), 
                            propertyName: hl.propertyName,
                            oldValue: hl.oldValue,
                            newValue: hl.newValue
                          ]
        def linetype = null

        switch(hl.className) {
          case 'com.k_int.kbplus.License':
            def license_object = License.get(hl.persistedObjectId);
            if (license_object) {
                def licence_name = license_object.licenseType ? license_object.licenseType+': ' : ''
                licence_name += license_object.reference ?: '**No reference**'
                line_to_add.link = createLink(controller:'licenseDetails', action: 'index', id:hl.persistedObjectId)
                line_to_add.name = licence_name
            }
            linetype = 'Licence'
            break;
          case 'com.k_int.kbplus.Subscription':
            break;
          case 'com.k_int.kbplus.Package':
            def package_object = Package.get(hl.persistedObjectId);
            if (package_object) {
                line_to_add.link = createLink(controller:'packageDetails', action: 'show', id:hl.persistedObjectId)
                line_to_add.name = package_object.name
            }
            linetype = 'Package'
            break;
          case 'com.k_int.kbplus.TitleInstancePackagePlatform':
            def tipp_object = TitleInstancePackagePlatform.get(hl.persistedObjectId);
            if ( tipp_object != null ) {
                line_to_add.link = createLink(controller:'tipp', action: 'show', id:hl.persistedObjectId)
                line_to_add.name = tipp_object.title?.title + ' / ' + tipp_object.pkg?.name
            }
            linetype = 'TIPP'
            break;
          case 'com.k_int.kbplus.TitleInstance':
            def title_object = TitleInstance.get(hl.persistedObjectId);
            if (title_object) {
                line_to_add.link = createLink(controller:'titleDetails', action: 'show', id:hl.persistedObjectId)
                line_to_add.name = title_object.title
            }
            linetype = 'Title'
            break;
          case 'com.k_int.kbplus.IdentifierOccurrence':
            break;
          default:
            log.error("Unexpected event class name found ${hl.className}")
            break;
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

        if(line_to_add.eventName.contains('null')){
          log.error("We have a null line in DM change log and we exclude it from output...${hl}");
        }else{
          result.formattedHistoryLines.add(line_to_add);
        }
      }
  
    }
    else {
      result.num_hl = 0
    }


    withFormat {
      html {
        result
      }
      csv {
        response.setHeader("Content-disposition", "attachment; filename=\"DMChangeLog.csv\"")
        response.contentType = "text/csv"
        def out = response.outputStream
        def actors_list = getActorNameList(params)
        out.withWriter { w ->
        w.write('Start Date, End Date, Change Actors, Packages, Licences, Tittles, TIPPs, New Items, Updates\n')
        w.write("\"${params.startDate}\", \"${params.endDate}\", \"${actors_list}\", ${params.packages}, ${params.licenses}, ${params.titles}, ${params.tipps}, ${params.creates}, ${params.updates} \n")
    if(result.formattedHistoryLines.size() == 100000 ){
      w.write('Not all results in query were exported\n')
    }
        w.write('Timestamp,Name,Event,Property,Actor,Old,New,Link\n')
          result.formattedHistoryLines.each { c ->
            if(c.eventName){
            def line = "\"${c.lastUpdated}\",\"${c.name}\",\"${c.eventName}\",\"${c.propertyName}\",\"${c.actor?.displayName}\",\"${c.oldValue}\",\"${c.newValue}\",\"${c.link}\"\n"
            w.write(line)
              
            }
          }
        }
        out.close()
      }
    }
  }

  def getActorNameList(params) {
    def actors = []
    def filterActors = params.findAll{it.key.startsWith("change_actor_")}
    if(filterActors) {

      if ( params.change_actor_PEOPLE == 'Y' ) {
        actors += "All Real Users"
      }
      if(params.change_actor_ALL == "Y"){
        actors += "All Including System"
      }
      filterActors.each{      
          if(it.key != 'change_actor_ALL' && it.key != 'change_actor_PEOPLE'){
            def paramKey = it.key.replaceAll("[^A-Za-z]", "")//remove things that can cause problems in sql
            def username = it.key.split("change_actor_")[1]
            def user = User.findByUsername(username)
            if(user){
              actors += user.displayName
              
            }
          }     
      }     
    }
    return actors
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def allLicenses() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.transforms = grailsApplication.config.licenceTransforms

    if(SpringSecurityUtils.ifNotGranted('ROLE_KBPLUS_EDITOR,ROLE_ADMIN')){
      flash.error =  message(code:"default.access.error")
      response.sendError(401)
      return;
    }

    def date_restriction = null;
    def sdf = new java.text.SimpleDateFormat(session.sessionPreferences?.globalDateFormat)

    if (params.validOn == null) {
      result.validOn = sdf.format(new Date(System.currentTimeMillis()))
      date_restriction = sdf.parse(result.validOn)
    } else if (params.validOn.trim() == '') {
      result.validOn = ""
    } else {
      result.validOn = params.validOn
      date_restriction = sdf.parse(params.validOn)
    }


    def prop_types_list = PropertyDefinition.findAll()
    result.custom_prop_types = prop_types_list.collectEntries{
    [(it.name) : it.type + "&&" + it.refdataCategory]
    //We do this for the interface, so we can display select box when we are working with refdata.
    //Its possible there is another way
    }

    result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;
    result.max = params.format ? 10000 : result.max
    result.offset = params.format? 0 : result.offset

    def licensee_role = RefdataCategory.lookupOrCreate('Organisational Role', 'Licensee');
    def template_license_type = RefdataCategory.lookupOrCreate('License Type', 'Template');
    def licence_status = RefdataCategory.lookupOrCreate('License Status', 'Deleted')

    def qry_params = [:]

    def qry = TEMPLATE_LICENSES_QUERY
          qry_params['templateType'] = 'Template'
          qry_params['lic_status'] = licence_status
    
    if ((params['keyword-search'] != null) && (params['keyword-search'].trim().length() > 0)) {
      if (params.jiscLicSearch == "true") {
        log.debug("Searching for JISC License Id")
        qry += " and l.jiscLicenseId = :jli"
        qry_params += [jli:"${params['keyword-search']}"]
        result.keyWord = params['keyword-search']
      }
      else {
        qry += " and lower(l.reference) like :ref"
        qry_params += [ref:"%${params['keyword-search'].toLowerCase()}%"]
        result.keyWord = params['keyword-search'].toLowerCase()
      }
    }

    if ( (params.propertyFilter != null) && params.propertyFilter.trim().length() > 0 ) {
      def propDef = PropertyDefinition.findByName(params.propertyFilterType)
      def propQuery = buildPropertySearchQuery(params,propDef)
      qry += propQuery.query
      qry_params += propQuery.queryParam
      result.propertyFilterType = params.propertyFilterType
      result.propertyFilter = params.propertyFilter
    }

    if (date_restriction) {
      qry += " and ( ( l.startDate <= :date_restr and l.endDate >= :date_restr ) OR l.startDate is null OR l.endDate is null ) "
      qry_params += [date_restr: date_restriction]
      qry_params += [date_restr: date_restriction]
    }

    def sortclause = null
    
    if ((params.sort != null) && (params.sort.length() > 0)) {
    def sortOpts = params.sort.tokenize(':')
    if (sortOpts.size() == 2) {
      sortclause = " order by l.${sortOpts[0]} ${sortOpts[1]}"
    }
    else {
      sortclause = " order by l.reference asc"
    }
    } else {
    sortclause = " order by l.reference asc"
    }

    log.debug("currentLicense query=${qry}, params=${qry_params}");

    result.licenseCount = License.executeQuery("select count(l) ${qry}".toString(), qry_params)[0];
    result.licenses = License.executeQuery("select l ${qry} ${sortclause}".toString(), qry_params, [max: result.max, offset: result.offset]);
  
  def filename = "data_manager_licence_list"
    withFormat {
      html result
      json {
        response.setHeader("Content-disposition", "attachment; filename=\"${filename}.json\"")
        response.contentType = "text/json"
        render(template: 'licJson', model:result, contentType: "text/json", encoding: "UTF-8")
      }
      csv {
        response.setHeader("Content-disposition", "attachment; filename=\"${filename}.csv\"")
        response.contentType = "text/csv"
        render(template: 'lic_csv', model:result, contentType: "text/csv", encoding: "UTF-8")
      }
      xml {
        result.formatter = new java.text.SimpleDateFormat('yyyy-MM-dd')
        response.setHeader("Content-disposition", "attachment; filename=\"${filename}.xml\"")
        response.contentType = "text/xml"
        render(template: 'licXml', model:result, contentType: "text/xml", encoding: "UTF-8")
      }
    }
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def exportAllLicencesModal() {
  render(template:"/templates/allLicencesExportModal", params:params)
  }
  
  def buildPropertySearchQuery(params,propDef) {
    def result = [:]

    def query = " and exists ( select cp from l.customProperties as cp where cp.type.name = :prop_filter_name and  "
    def queryParam = [prop_filter_name:params.propertyFilterType];
    switch (propDef.type){
      case Integer.toString():
        query += "cp.intValue = :filter_val "
        def value;
        try{
         value =Integer.parseInt(params.propertyFilter)
        }catch(Exception e){
          log.error("Exception parsing search value: ${e}")
          value = 0
        }
        queryParam += [filter_val:value]
        break;
      case BigDecimal.toString():
        query += "cp.decValue = :filter_val "
        try{
         value = new BigDecimal(params.propertyFilter)
        }catch(Exception e){
          log.error("Exception parsing search value: ${e}")
          value = 0.0
        }
        queryParam += [filter_val:value]
        break;
      case String.toString():
        query += "cp.stringValue like :filter_val "
        queryParam += [filter_val:params.propertyFilter]
        break;
      case RefdataValue.toString():
        query += "cp.refValue.value like :filter_val "
        queryParam += [filter_val:params.propertyFilter]
        break;
      default:
        log.error("Error executing buildPropertySearchQuery. Definition type ${propDef.type} case not found. ")
    }
    query += ")"

    result.query = query
    result.queryParam = queryParam
    result
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def addLicenceModal() {
  render(template:"/templates/addTemplateLicenceModal", params:params)
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def addTemplateLicense() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.institution = request.getAttribute('institution')//Org.findByShortcode(params.shortcode)

    result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

    if(SpringSecurityUtils.ifNotGranted('ROLE_KBPLUS_EDITOR,ROLE_ADMIN')){
      flash.error =  message(code:"default.access.error")
      response.sendError(401)
      return;
    }

    def template_license_type = RefdataCategory.lookupOrCreate('License Type', 'Template');
    def qparams = [template_license_type]
    def public_flag = RefdataCategory.lookupOrCreate('YN', 'No');

   // This query used to allow institutions to copy their own licenses - now users only want to copy template licenses
    // (OS License specs)
    // def qry = "from License as l where ( ( l.type = ? ) OR ( exists ( select ol from OrgRole as ol where ol.lic = l AND ol.org = ? and ol.roleType = ? ) ) OR ( l.isPublic=? ) ) AND l.status.value != 'Deleted'"

    def query = "from License as l where l.type = ? AND l.status.value != 'Deleted'"

    if (params.filter) {
      query += " and lower(l.reference) like ?"
      qparams.add("%${params.filter.toLowerCase()}%")
    }

    //separately select all licences that are not public or are null, to test access rights.
    // For some reason that I could track, l.isPublic != 'public-yes' returns different results.
    def non_public_query = query + " and ( l.isPublic = ? or l.isPublic is null) "

    if ((params.sort != null) && (params.sort.length() > 0)) {
      query += " order by l.${params.sort} ${params.order}"
    } else {
      query += " order by sortableReference asc"
    }

    println qparams
    result.numLicenses = License.executeQuery("select count(l) ${query}".toString(), qparams)[0]
    result.licenses = License.executeQuery("select l ${query}".toString(), qparams,[max: result.max, offset: result.offset])

    //We do the following to remove any licences the user does not have access rights
    qparams += public_flag

    def nonPublic = License.executeQuery("select l ${non_public_query}".toString(), qparams)
    def no_access = nonPublic.findAll{ !it.hasPerm("view",result.user)  }

    result.licenses = result.licenses - no_access
    result.numLicenses = result.numLicenses - no_access.size()

    result
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def newTemplateLicense() {
    if(SpringSecurityUtils.ifNotGranted('ROLE_KBPLUS_EDITOR,ROLE_ADMIN')){
      flash.error =  message(code:"default.access.error")
      response.sendError(401)
      return;
    }

    def baseLicense = params.baselicense ? License.get(params.baselicense) : null;

    def copyTemplate = institutionsService.copyTemplate(params)
    if (copyTemplate.hasErrors() ) {
      log.error("Problem saving template license ${copyTemplate.errors}");
      render view: 'editLicense', model: [licenseInstance: copyTemplate]
    }else{
      flash.message = message(code: 'license.created.message', args: [message(code: 'licence', default: 'Licence'), copyTemplate.id])
      redirect controller: 'licenseDetails', action: 'index', params: params, id: copyTemplate.id
    }
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def coreTitlesImport() {

  if ( request.method=="POST" ) {
    def upload_mime_type = request.getFile("titles_file")?.contentType
    def upload_filename = request.getFile("titles_file")?.getOriginalFilename()
    def input_stream = request.getFile("titles_file")?.inputStream

    CSVReader r = new CSVReader( new InputStreamReader(input_stream, java.nio.charset.Charset.forName('UTF-8') ) )
    String[] nl;
    String[] cols;
    def first = true
    def rowNo = 0
    Long long_subId
    if (params.subId) long_subId = Long.parseLong(params.subId)
    def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd')
    if ( long_subId ) {
      
      while ((nl = r.readNext()) != null) {
      rowNo++
      if ( first ) {
        first = false; // Skip header
        cols=nl;
        flash.message="Core titles import received for subscription ${long_subId}... ";
      }
      else {
        // Reset upload info for each row
        def title = null;
        def query_params = []
        def i = 0;
        def ident = null;
        def idInput = null;
        def idType = null;
        java.util.Date start_date = null;
        java.util.Date end_date = null;
        
        // Set up base_query
        def query = "select ie.id from IssueEntitlement as ie where ie.subscription.id = ?"
        query_params.add(long_subId)
        
        // Grab appropriate data from each column
        cols.each { cn ->
        if(nl[i].trim().length() > 0) {
          switch ( cn.trim() ) {
            case 'coreStart':
            start_date = sdf.parse(nl[i].trim())
            break;
            case 'Identifier':
            idInput = nl[i].trim()
            if (idInput.substring(0,5) == 'eissn') {
              ident = idInput.substring(6)
              idType = "eissn"
            }
            if (idInput.substring(0,4) == 'issn') {
              ident = idInput.substring(5)
              idType = "issn"
            }
            break;
            case 'coreEnd':
            end_date = sdf.parse(nl[i].trim())
            break;
            default:
              break;
          }
        }
        i++;
        }
        
        // Check if minimum requirement for core title creation is met
        if (start_date && ident){
        
            query += " and exists ( select io from IdentifierOccurrence as io where io.ti = ie.tipp.title and io.identifier.ns.ns = ? and io.identifier.value = ? )"
            query_params.add(idType)
            query_params.add(ident)
  
            log.debug("${query}");
            log.debug("${query_params}");
        
            def ie_ids = IssueEntitlement.executeQuery(query,query_params);
          
          if (ie_ids.size() == 0){
            flash.message+="Identifier on row ${rowNo} not found in this subscription... ";
            log.debug("${idType}: ${ident} not found in subscription");
          }
          else {
            log.debug("Got start date & id -- process");
        
            // Get each IE found and add core date
            ie_ids.each { ie_id ->
              IssueEntitlement.withNewTransaction() {
                IssueEntitlement ie = IssueEntitlement.read(ie_id);
                def tip = ie.getTIP()
                log.debug("Extend core dates ${ie_id} start:${start_date} end:${end_date} ie_id:${ie.id} tip_id:${tip.id}");
                tip.extendCoreExtent(start_date,end_date);
              }
              }
          }
        }
        else {
          // Either Start Date or Identifier hasn't been found for this row - Show error message
          flash.message+="Core title on row ${rowNo} not imported... ";
          log.debug("Missing startDate or id: sd - ${start_date}, id - ${ident}");
        }
      }
      }
      flash.message+="Import has read ${rowNo - 1} rows of data.";
    }
    else {
      // Subscription id hasn't been input - Show error message
      flash.message="You must choose a Subscription Id.";
      log.debug("Missing sub. ${params}");
    }
    return
  }
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def productImport() {
  
    if ( request.method=="POST" ) {
      def upload_mime_type = request.getFile("products_file")?.contentType
      def upload_filename = request.getFile("products_file")?.getOriginalFilename()
      def input_stream = request.getFile("products_file")?.inputStream

      def bom_is = new BOMInputStream(input_stream)
      CSVReader r = new CSVReader( new InputStreamReader(bom_is, java.nio.charset.Charset.forName('UTF-8') ) )

      // CSVReader r = new CSVReader( new InputStreamReader(input_stream, java.nio.charset.Charset.forName('UTF-8') ) )
      String[] nl;
      String[] cols;
      def first = true
      def rowNo = 0
      
      while ((nl = r.readNext()) != null) {
        rowNo++
        if ( first ) {
          first = false; // Skip header
          cols=nl;
          flash.message="Product import received... ";
        }
        else {
    
          log.debug("Process row ${nl} - headers are ${cols}");
    
          // Reset upload info for each row
          def prodId = null;
          def prodName = null;
          def pkgId = null;
          def newProd = null;
          def asgnPkg = null;


          // Grab appropriate data from each column
          int i = 0;
          cols.each { cn ->
            switch ( cn.trim().toLowerCase() ) {
              case 'product':
                prodName = nl[i].trim()
                break;
              case 'identifier':
                prodId = nl[i].trim()
                break;
              case 'package':
                pkgId = nl[i].trim()
                break;
              default:
                log.debug("Unhandled column : ${cn}/${cn.trim().toLowerCase()}");
                break;
            }
            i++;
          }
    
          // Check input has both product id and name
          if ( ( prodId != null ) && ( prodName != null ) ) {
            // Check if product already exists
            newProd = Product.findByIdentifier(prodId)
  
            // If product doesn't exist, then create new product
            if (!newProd) {
              newProd = new Product(
                name: prodName,
                identifier: prodId)
              if (!newProd.save(flush: true, failOnError: true)) {
                log.debug("Product ${newProd} failed to save")
                flash.message += "New product:${prodName} failed to save... "
              } else {
                log.debug("Product save ${newProd} ok")
              }
            }
  
            // Add product to package
            if (pkgId) {
              asgnPkg = Package.get(pkgId)
              if (!PackageProduct.findByProductAndPkg(newProd, asgnPkg)) {
                new PackageProduct(
                  pkg: asgnPkg,
                  product: newProd).save(flush: true, failOnError: true)

                  log.debug("Product ${newProd} now associated with package ${pkgId}")
              }
              else {
                flash.message+="Product on row ${rowNo} with id:${prodId} is already associated with package:${pkgId}... ";
                log.debug("Product already associated with package");
              }
            }

          }
          else {
            flash.message+="Product on row ${rowNo} is missing valid id(${prodId}) or name(${prodName})... ${nl} (${cols})";
            log.debug("Missing product name or id = ${rowNo} ${nl} ${cols}");
          }
        }
      }
      flash.message+="Import has read ${rowNo - 1} rows of data.";
      return
    }
  }
    
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def linkJiscLicences() {

	if ( request.method=="POST" ) {
	  def upload_mime_type = request.getFile("licence_file")?.contentType
	  def upload_filename = request.getFile("licence_file")?.getOriginalFilename()
	  def input_stream = request.getFile("licence_file")?.inputStream

	  CSVReader r = new CSVReader( new InputStreamReader(input_stream, java.nio.charset.Charset.forName('UTF-8') ) )
	  String[] nl;
	  String[] cols;
	  def first = true
	  def rowNo = 0
	  
	  while ((nl = r.readNext()) != null) {
		rowNo++
		if ( first ) {
		  first = false; // Skip header
		  cols=nl;
		  flash.message="License link import received... ";
		}
		else {
		  // Reset upload info for each row
		  def jiscId = null;
		  def kbId = null;
		  def lic = null;
		  def i = 0;
		  
		  // Grab appropriate data from each column
		  cols.each { cn ->
			switch ( cn.trim() ) {
			  case 'JiscLicenceId':
				jiscId = nl[i].trim()
				break;
			  case 'KBLicenceId':
				kbId = nl[i].trim()
				break;
			  default:
				break;
			}
			i++;
		  }
		  
		  // Check input has both KB+ and Jisc license id
		  if (jiscId && kbId) {
			  //Find license
			  lic = License.findById(kbId)
			  if(lic) {
				  //assign Jisc license id 
				  lic.jiscLicenseId = jiscId
				  if (!lic.save(flush: true, failOnError: true)) {
					  log.debug("License ${lic} failed to save")
					  flash.message += "Licence ${kbId} failed to save... "
				  }
			  }
			  else {
				  flash.message+="Licence ${kbId} not found... ";
				  log.debug("License ${kbId} not found in database")
			  }
		  }
		  else {
			  flash.message+="Licence on row ${rowNo} is missing valid id... ";
			  log.debug("Missing jisc licence id or kb+ licence id");
		  }
		}
	  }
	  flash.message+="Import has read ${rowNo - 1} rows of data.";
	  return
	}
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def deletedTitleManagement() {
    def result = [:]
    if(SpringSecurityUtils.ifNotGranted('ROLE_KBPLUS_EDITOR,ROLE_ADMIN')){
      flash.error =  message(code:"default.access.error")
      response.sendError(401)
      return;
    }
    result.user = User.get(springSecurityService.principal.id)
    result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;

    def paginate_after = params.paginate_after ?: ( (2*result.max)-1);
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

    def deleted_title_status =  RefdataCategory.lookupOrCreate( RefdataCategory.TI_STATUS, 'Deleted' );
    def qry_params = [deleted_title_status]

    def base_qry = " from TitleInstance as t where ( t.status = ? )"

    result.titleInstanceTotal = Subscription.executeQuery("select count(t) "+base_qry, qry_params )[0]

    result.titleList = Subscription.executeQuery("select t ${base_qry}".toString(), qry_params, [max:result.max, offset:result.offset]);

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def expungeDeletedPlatforms() {
    redirect(controller:'home')
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def expungeDeletedTitles() {

    log.debug("expungeDeletedTitles.. Create async task..");
    if(SpringSecurityUtils.ifNotGranted('ROLE_KBPLUS_EDITOR,ROLE_ADMIN')){
      flash.error =  message(code:"default.access.error")
      response.sendError(401)
      return;
    }

    Promise p = task {

      def ctr = 0;

      try {
        log.debug("Delayed start");
        synchronized(this) {
          Thread.sleep(2000);
        }

        log.debug("Query...");
        def l = TitleInstance.executeQuery('select t.id from TitleInstance t where t.status.value=?',['Deleted']);

        if ( ( l != null ) && ( l instanceof List ) ) {
          log.debug("Processing...");
          l.each { ti_id -> 
            TitleInstance.withNewTransaction {
              log.debug("Expunging title [${ctr++}] ${ti_id}");
              TitleInstance.expunge(ti_id);
            }
          }
        }
        else {
          log.error("${l} was null or not a list -- ${l?.class.name}");
        }

        log.debug("Completed processing - ${ctr}");
      }
      catch( Exception e ) {
        e.printStackTrace()
        log.error("Problem",e);
      }

      return "expungeDeletedTitles Completed - ${ctr} titles expunged"
    }


    p.onError { Throwable err ->
  log.debug("An error occured ${err.message}")
    }

    p.onComplete { result ->
        log.debug("Promise returned $result")
    }

    log.debug("Got promise : ${p}. ${p.class.name}");
    log.debug("expungeDeletedTitles.. Returning");

    redirect(controller:'home')
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def expungeDeletedTIPPS() {

    log.debug("expungeDeletedTIPPS.. Create async task..");
    if(SpringSecurityUtils.ifNotGranted('ROLE_KBPLUS_EDITOR,ROLE_ADMIN')){
      flash.error =  message(code:"default.access.error")
      response.sendError(401)
      return;
    }
    def p = task {

      def ctr = 0;

      try {
        log.debug("Delayed start");
        synchronized(this) {
          Thread.sleep(2000);
        }

        log.debug("Query...");
        def l = TitleInstancePackagePlatform.executeQuery('select t.id from TitleInstancePackagePlatform t where t.status.value=?',['Deleted']);

        if ( ( l != null ) && ( l instanceof List ) ) {
          log.debug("Processing...");
          l.each { ti_id ->
            TitleInstance.withNewTransaction {
              log.debug("Expunging title [${ctr++}] ${ti_id}");
              TitleInstancePackagePlatform.expunge(ti_id);
            }
          }
        }
        else {
          log.error("${l} was null or not a list -- ${l?.class.name}");
        }

        log.debug("Completed processing - ${ctr}");
      }
      catch( Exception e ) {
        e.printStackTrace()
        log.error("Problem",e);
      }

      return "expungeDeletedTIPPS Completed - ${ctr} TIPPS expunged"
    }


    p.onError { Throwable err ->
        log.debug("An error occured ${err.message}")
    }

    p.onComplete { result ->
        log.debug("Promise returned $result")
    }

    log.debug("Got promise : ${p}. ${p.class.name}");
    log.debug("expungeDeletedTIPPS.. Returning");

    redirect(controller:'home')
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def expungeDeletedOrgs() {
    def deletd_org_status = RefdataCategory.lookupOrCreate(RefdataCategory.ORG_STATUS, "Deleted")
    Org.executeUpdate('delete from Org where status = :deletedStatus',[deletedStatus:deletd_org_status]);
    redirect(controller:'home')
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def toggleLang() {
    def referer = request.getHeader('referer')
    if ((session.showLocaliseButton==null)||(session.showLocaliseButton=='N')) {
      session.showLocaliseButton='Y'
    }
    else {
      session.showLocaliseButton='N'
    }

    redirect(url: referer)
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def content() {
    def result=[:]
    def qry_params=[:]
    def meta_params=[:]

    result.keys = ContentItem.executeQuery('select distinct(ci.key) from ContentItem as ci',qry_params,meta_params);
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  @Transactional(readOnly=true)
  def contentItem() {
    def result=[:]
    // Make a string list of all available locales
    result.otherLocales = (Locale.getAvailableLocales() as List<Locale>).findResults { 
      Locale l -> 
      
      // Filter only locales that have a language and country
      l.language && l.country ? l.toString() : null
    }.sort()

    def located_content_items = ContentItem.findAllByKey(params.id)
    result.contentItems = located_content_items.collect { ContentItem ci ->
      
      // Remove from the other Locales
      result.otherLocales.remove(ci.locale);
      
      ci
    }

    // Move en_GB to head of list, most likely after default to set
    if ( result.otherLocales.contains('en_GB') ) {
      result.otherLocales.remove('en_GB')
      result.otherLocales.add(0,'en_GB')
    }
  
    String accept = request.getHeader('Accept')
    if (accept?.toLowerCase()?.contains('json')) {
      render result as JSON
      return
    }
    result
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def updateContent() {
    log.debug("updateContent(${params})");
    def referer = request.getHeader('referer')
    
    String key = params.id
    String locale = params.locale
    
    if (key && locale) {
      try {
        
        String message = "${locale} translation for ${key}"
        
        if (params.delete) {
          ContentItem ci = ContentItem.findByKeyAndLocale(key, locale)
          ci?.delete(failOnError:true, flush: true)
          message = "Deleted ${message}"
        } else {
          String content = params.content
          if (content) {
            ContentItem ci = ContentItem.findOrCreateByKeyAndLocale(key, locale)
            
            if (ci.id) {
              // New item.
              message = "Updated ${message}"
            } else {
              message = "Added ${message}"
            }
            ci.content = content
            ci.save(failOnError:true, flush: true)
          }
        }
      
        // Ensure messages are refreshed, by removing the cache entry.
        DatabaseMessageSource.clearCacheEntry(key, locale)
        
        flash.message = message
      } catch (Exception e) {
        flash.error = "Error when modifying ${locale} translation for ${key}.\n${e.message}"
        log.error(e)
      }
    }
    redirect(action: 'contentItem', id: key)
  }

}
