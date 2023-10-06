package com.k_int.kbplus

import grails.converters.*
import grails.plugin.springsecurity.annotation.Secured
import org.elasticsearch.groovy.common.xcontent.*
import groovy.xml.MarkupBuilder
import com.k_int.kbplus.auth.*;
import com.k_int.kbplus.AuditLogEvent
import groovy.sql.Sql
import grails.plugin.cache.CacheEvict
import grails.plugin.cache.Cacheable
import grails.plugin.cache.CachePut



class PublicExportController {
  def ESSearchService
  def formatter = new java.text.SimpleDateFormat("yyyy-MM-dd")
  def exportService
  def transformerService

  // Access directly to DB for packageChangeLog which needs union
  def dataSource

  public static most_recent_package_change = null;
  public static cached_package_atom_feed = null;
  public static last_atom_feed_check = null;

  @Secured(['permitAll'])
  def index() { 
    def result = [:]


    if ( params.format == 'atom' ) {
      atom()
    }
    else {
      params.max = 30

      params.rectype = "Package" // Tells ESSearchService what to look for
      if(params.q == "")  params.remove('q');
      params.isPublic="Yes"
      if(params.lastUpdated){
        params.lastModified ="[${params.lastUpdated} TO 2100]"
      }
      
      if (!params.sort){
        params.sort="sortname.keyword"
        params.order = "ASC"
      }
      else {
        if (params.sort.contains(":")) {
          def sortOpts = params.sort.tokenize(':')
          if (sortOpts.size() == 2){
            params.sort = sortOpts[0]
            params.order = sortOpts[1]
          }
          else {
            params.sort="sortname.keyword"
            params.order = "ASC"
          }
        }
      }
    
      if(params.search.equals("yes")){
        //when searching make sure results start from first page
        params.offset = 0
        params.search = null
      }

      if(params.filter == "current") {
        //params.tempFQ = " -pkg_scope:\"Master File\" -\"open access\" ";
	params.endYear = ">="+(new Date().year +1900)
      }

      result =  ESSearchService.search(params)   

      result.transforms = grailsApplication.config.packageTransforms
      result.max = params.max
      result.first_record = (params.offset?:0)+1;
      result.last_record = (params.offset?:0)+1+(params.max?:30)
      if ( result.last_record > result.resultsTotal ) 
        result.last_record = result.resultsTotal;

      // Evaluate result, causing it to be returned
      return result
    }
   
  }

  def atom() {

    if ( ( cached_package_atom_feed == null ) || ( System.currentTimeMillis() - last_atom_feed_check > 60000 ) ) {

      def l = Package.executeQuery('select max(p.lastUpdated) from Package as p')[0];
      last_atom_feed_check = System.currentTimeMillis();

      if ( ( most_recent_package_change = null ) || ( most_recent_package_change < l ) ) {

        def sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        // def sdf = new java.text.SimpleDateFormat('EEE, d MMM yyyy HH:mm:ss Z');

        most_recent_package_change = l

        def r = Package.executeQuery('select p from Package as p order by p.lastUpdated desc',[:],[max:200])
 
        //  Last-Modified: Tue, 15 Nov 1994 12:45:26 GMT
        response.setHeader("Last-Modified", sdf.format(l));

        def writer = new StringWriter()
        def xml = new MarkupBuilder(writer)


        xml.feed ( xmlns:'http://www.w3.org/2005/Atom' ) {
          xml.title('Jisc KB+ - Package Change Feed')
          xml.subtitle('Changes related to KB+ packages')
          xml.link(rel:'self',href:grailsApplication.config.SystemBaseURL+'/publicExport?format=atom')
          xml.author {
            xml.name('Jisc KBPlus Data Managers')
          }
          xml.id('urn:kbplus:PackageUpdateAtomFeed')
          xml.updated(sdf.format(l))
          r.each { pkg ->
            xml.entry {
              xml.title(pkg.name)
              xml.link(rel:'alternate', href:grailsApplication.config.SystemBaseURL+'/publicExport/pkg/'+pkg.id, title:'HTML')
              xml.link(rel:'related',href:grailsApplication.config.SystemBaseURL+'/publicExport/pkg/'+pkg.id+'?format=json', title:'JSON')
              xml.link(rel:'related',href:grailsApplication.config.SystemBaseURL+'/publicExport/pkg/'+pkg.id+'?format=xml', title:'XML')
              xml.link(rel:'related',href:grailsApplication.config.SystemBaseURL+'/publicExport/pkg/'+pkg.id+'?format=xml&transformId=kbplus&mode=',title:'KBPlus Ingest format')
              xml.link(rel:'related',href:grailsApplication.config.SystemBaseURL+'/publicExport/pkg/'+pkg.id+'?format=xml&transformId=kbart2&mode=', title:'KBART (Approved)')
              xml.id("urn:kbplus_pkg_update:${pkg.id}-${pkg.lastUpdated.getTime()}")
              xml.updated(sdf.format(pkg.lastUpdated))
              xml.summary('Package updated by KBPlus data managers')
            }
          }
        }

        cached_package_atom_feed = writer.toString()
        render(text: cached_package_atom_feed, contentType: "text/xml", encoding: "UTF-8")
      }
      else {
        // render cached atom feed
        log.debug("atom feed not updated since last check, Rendering cached package atom feed");
        render(text: cached_package_atom_feed, contentType: "text/xml", encoding: "UTF-8")
      }
    }
    else {
      log.debug("<60s since last check, Rendering cached package atom feed");
      render(text: cached_package_atom_feed, contentType: "text/xml", encoding: "UTF-8")
    }
  }

  def so() {
    log.debug("subscriptionDetails id:${params.id} format=${response.format}");
    def result = [:]

    def paginate_after = params.paginate_after ?: 19;
    result.max = params.max ? Integer.parseInt(params.max) : ( ( response.format == "csv" || response.format == "json" ) ? 10000 : 10 );
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

    log.debug("max = ${result.max}");
    result.subscriptionInstance = Subscription.findByIdentifier(params.id)

    if ( result.subscriptionInstance.type.value != 'Subscription Offered' ) {
      redirect action:'index'
    }

    def base_qry = null;

    def qry_params = [si:result.subscriptionInstance]

    if ( params.filter ) {
      base_qry = " from IssueEntitlement as ie where ie.subscription = :si and ( ie.status.value != 'Deleted' ) and ( ( lower(ie.tipp.title.title) like :f1 ) or ( exists ( from IdentifierOccurrence io where io.ti.id = ie.tipp.title.id and io.identifier.value like :f2 ) ) )"
      qry_params['f1'] = "%${params.filter.trim().toLowerCase()}%"
      qry_params['f2'] = "%${params.filter}%"
    }
    else {
      base_qry = " from IssueEntitlement as ie where ie.subscription = :si and ( ie.status.value != 'Deleted' ) "
    }

    if ( ( params.sort != null ) && ( params.sort.length() > 0 ) ) {
      base_qry += "order by ie.${params.sort} ${params.order} "
    }
    result.num_sub_rows = IssueEntitlement.executeQuery("select count(ie) "+base_qry, qry_params )[0]

    result.entitlements = IssueEntitlement.executeQuery("select ie "+base_qry, qry_params, [max:result.max, offset:result.offset]);

    log.debug("subscriptionInstance returning... ${result.num_sub_rows} rows ");
    withFormat {
      html result
      csv {
         def jc_id = result.subscriptionInstance.getSubscriber()?.getIdentifierByType('JC')?.value

         response.setHeader("Content-disposition", "attachment; filename=\"${result.subscriptionInstance.identifier}.csv\"")
         response.contentType = "text/csv"
         def out = response.outputStream
         out.withWriter { writer ->
           if ( ( params.omitHeader == null ) || ( params.omitHeader != 'Y' ) ) {
             writer.write("FileType,SpecVersion,JC_ID,TermStartDate,TermEndDate,SubURI,SystemIdentifier\n")
             writer.write("${result.subscriptionInstance.type.value},\"2.0\",${jc_id?:''},${result.subscriptionInstance.startDate},${result.subscriptionInstance.endDate},\"uri://kbplus/sub/${result.subscriptionInstance.identifier}\",${result.subscriptionInstance.impId}\n")
           }

           // Output the body text
           // writer.write("publication_title,print_identifier,online_identifier,date_first_issue_subscribed,num_first_vol_subscribed,num_first_issue_subscribed,date_last_issue_subscribed,num_last_vol_subscribed,num_last_issue_subscribed,embargo_info,title_url,first_author,title_id,coverage_note,coverage_depth,publisher_name\n");
           writer.write("publication_title,print_identifier,online_identifier,date_first_issue_online,num_first_vol_online,num_first_issue_online,date_last_issue_online,num_last_vol_online,num_last_issue_online,title_url,first_author,title_id,embargo_info,coverage_depth,coverage_notes,publisher_name,identifier.jusp\n");

           result.entitlements.each { e ->

             def start_date = e.startDate ? formatter.format(e.startDate) : '';
             def end_date = e.endDate ? formatter.format(e.endDate) : '';
             def title_doi = (e.tipp?.title?.getIdentifierValue('DOI'))?:''
             def publisher = e.tipp?.title?.publisher
             def print_identifier = e.tipp?.title?.getIdentifierValue('ISSN')
             if ( print_identifier == null ) 
               print_identifier = e.tipp?.title?.getIdentifierValue('ISBN')

             writer.write("\"${e.tipp.title.title}\",\"${print_identifier?:''}\",\"${e.tipp?.title?.getIdentifierValue('eISSN')?:''}\",${start_date},${e.startVolume?:''},${e.startIssue?:''},${end_date},${e.endVolume?:''},${e.endIssue?:''},\"${e.tipp?.hostPlatformURL?:''}\",,\"${title_doi}\",\"${e.embargo?:''}\",\"${e.tipp?.coverageDepth?:''}\",\"${e.tipp?.coverageNote?:''}\",\"${publisher?.name?:''}\",\"${e.tipp?.title?.getIdentifierValue('jusp')?:''}\"\n");
           }
           writer.flush()
           writer.close()
         }
         out.close()
      }
      json {
         def jc_id = result.subscriptionInstance.getSubscriber()?.getIdentifierByType('JC')?.value
         def response = [:]
         response.header = [:]
         response.entitlements = []

         response.header.type = result.subscriptionInstance.type.value
         response.header.version = "2.0"
         response.header.jcid = jc_id
         response.header.url = "uri://kbplus/sub/${result.subscriptionInstance.identifier}"

         result.entitlements.each { e ->

             def start_date = e.startDate ? formatter.format(e.startDate) : '';
             def end_date = e.endDate ? formatter.format(e.endDate) : '';
             def title_doi = (e.tipp?.title?.getIdentifierValue('DOI'))?:''
             def publisher = e.tipp?.title?.publisher

             def entitlement = [:]
             entitlement.title=e.tipp.title.title
             entitlement.issn=e.tipp?.title?.getIdentifierValue('ISSN')
             if ( entitlement.issn == null ) {
               entitlement.issn=e.tipp?.title?.getIdentifierValue('ISBN')
             }
             entitlement.eissn=e.tipp?.title?.getIdentifierValue('eISSN')
             entitlement.jusp=e.tipp?.title?.getIdentifierValue('jusp')
             entitlement.startDate=start_date;
             entitlement.endDate=end_date;
             entitlement.startVolume=e.startVolume?:''
             entitlement.endVolume=e.endVolume?:''
             entitlement.startIssue=e.startIssue?:''
             entitlement.endIssue=e.endIssue?:''
             entitlement.embargo=e.embargo?:''
             entitlement.titleUrl=e.tipp.hostPlatformURL?:''
             entitlement.doi=title_doi
             entitlement.coverageDepth = e.tipp.coverageDepth
             entitlement.coverageNote = e.tipp.coverageNote
             if ( publisher != null )
               entitlement.publisher = publisher?.name

             response.entitlements.add(entitlement);
         }
         render response as JSON
      }
    }
  }

  @Secured(['permitAll'])
  def pkg() {
    log.debug("package export id:${params.id} format=${response.format}");
    def result = [:]

    def paginate_after = params.paginate_after ?: 99;
    result.max = params.max ? Integer.parseInt(params.max) : ( ["csv","json","xml"].contains(response.format) ? 10000 : 100 );
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

    log.debug("max = ${result.max}");
    def packageInstance = Package.get(params.id)
    result.pkg = packageInstance
    
    def dateFilter = null
    def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd');
    def today = new Date()

    if(packageInstance.startDate > today){
      dateFilter = packageInstance.startDate
    }else if(packageInstance.endDate < today){
      dateFilter = packageInstance.endDate
    }else{
      dateFilter = today
    }

    result.dateFilter=dateFilter
    

    def base_qry = null;
    def tipp_status_del = RefdataCategory.lookupOrCreate(RefdataCategory.TIPP_STATUS, "Deleted")
    def publisher_org = RefdataCategory.lookupOrCreate("Organisational Role","Publisher")
    def qry_params = [pi:packageInstance]

    def filename = "publicExport_${packageInstance.name}_asAt_${sdf.format(dateFilter)}"
    
    if ( params.filter ) {
      base_qry = " from TitleInstancePackagePlatform as tipp  "+
                 " where tipp.pkg = :pi "+
                 " and ( tipp.status != :status ) "+
                 " and ( ( lower(tipp.title.title) like :qt ) or ( exists ( from IdentifierOccurrence io where io.ti.id = tipp.title.id and io.identifier.value like :f ) ) ) "
                 // " and ( ( ( ? >= tipp.accessStartDate ) or ( tipp.accessStartDate is null ) ) ) "+
                 // " and ( ( ( :ed <= tipp.accessEndDate ) or ( tipp.accessEndDate is null ) ) )"
      qry_params['status'] =  tipp_status_del

      qry_params['qt'] = "%${params.filter.trim().toLowerCase()}%"
      qry_params['f'] = "%${params.filter}%"
      // qry_params['ed'] = dateFilter
    }
    else {
      // base_qry = " from TitleInstancePackagePlatform as tipp where tipp.pkg = ?  and ( tipp.status != ? ) and ( ( ( ? <= tipp.accessEndDate ) or ( tipp.accessEndDate is null ) ) ) and ( ( ( ? >= tipp.accessStartDate ) or ( tipp.accessStartDate is null ) ) ) "
      base_qry = " from TitleInstancePackagePlatform as tipp where tipp.pkg = :pi  and ( tipp.status != :status ) and ( ( ( :df <= tipp.accessEndDate ) or ( tipp.accessEndDate is null ) ) )"
      qry_params['status'] = tipp_status_del
      // qry_params.add(dateFilter);
      qry_params['df'] = dateFilter;
    }

    if ( ( params.sort != null ) && ( params.sort.length() > 0 ) ) {
      base_qry += "order by tipp.${params.sort} ${params.order} "
    }
    
    log.debug("Base query for pkg export: ${base_qry}");
    
    result.num_pkg_rows = TitleInstancePackagePlatform.executeQuery("select count(tipp) "+base_qry, qry_params )[0]

    result.titlesList = TitleInstancePackagePlatform.executeQuery("select tipp "+base_qry+" order by tipp.title.title", qry_params, [max:result.max, offset:result.offset, readonly:true, fetchSize:50]);
    result.transforms = grailsApplication.config.packageTransforms

    log.debug("Found ${result.num_pkg_rows} tipps. These will be exported")
    

    withFormat {
      html result
      csv {
         response.setHeader("Content-disposition", "attachment; filename=${filename}.csv")
         response.contentType = "text/csv"
         def out = response.outputStream
         out.withWriter { writer ->
           if ( ( params.omitHeader == null ) || ( params.omitHeader != 'Y' ) ) {
             writer.write("FileType,SpecVersion,JC_ID,TermStartDate,TermEndDate,SubURI,SystemIdentifier\n")
             writer.write("Package,\"3.0\",,${packageInstance.startDate},${packageInstance.endDate},\"uri://kbplus/pkg/${packageInstance.id}\",${packageInstance.impId}\n")
           }

           // Output the body text
           // writer.write("publication_title,print_identifier,online_identifier,date_first_issue_subscribed,num_first_vol_subscribed,num_first_issue_subscribed,date_last_issue_subscribed,num_last_vol_subscribed,num_last_issue_subscribed,embargo_info,title_url,first_author,title_id,coverage_note,coverage_depth,publisher_name\n");
           writer.write("publication_title,print_identifier,online_identifier,date_first_issue_online,num_first_vol_online,num_first_issue_online,date_last_issue_online,num_last_vol_online,num_last_issue_online,title_url,first_author,title_id,embargo_info,coverage_depth,coverage_notes,publisher_name,identifier.jusp,hybrid_oa\n");


           result.titlesList.each{ t ->
             def start_date = t.startDate ? formatter.format(t.startDate) : '';
             def end_date = t.endDate ? formatter.format(t.endDate) : '';
             def title_doi = (t.title?.getIdentifierValue('DOI'))?:''
             def publisher = t.title?.publisher

             writer.write("\"${t.title.title}\",\"${t.title?.getIdentifierValue('ISSN')?:''}\",\"${t?.title?.getIdentifierValue('eISSN')?:''}\",${start_date},${t.startVolume?:''},${t.startIssue?:''},${end_date},${t.endVolume?:''},${t.endIssue?:''},\"${t.hostPlatformURL?:''}\",,\"${title_doi}\",\"${t.embargo?:''}\",\"${t.coverageDepth?:''}\",\"${t.coverageNote?:''}\",\"${publisher?.name?:''}\",\"${t.title?.getIdentifierValue('jusp')?:''}\",\"${t.hybridOA}\"\n");
           }
           writer.flush()
           writer.close()
         }
         out.close()
      }
      json {
        def map = exportService.getPackageMap(packageInstance, result.titlesList)
        
          response.setHeader("Content-disposition", "attachment; filename=\"${filename}.json\"")
          response.contentType = "application/json"

          response.outputStream.withWriter { w ->
            def builder = new groovy.json.StreamingJsonBuilder(w)
            // Without root element.
            builder map
          }
      }
      xml {
        def starttime = exportService.printStart("Building XML Doc")
        def doc = exportService.buildDocXML("Packages")
        exportService.addPackageIntoXML(doc, doc.getDocumentElement(), packageInstance, result.titlesList)
        exportService.printDuration(starttime, "Building XML Doc")
        
        if( ( params.transformId ) && ( result.transforms[params.transformId] != null ) ) {
          String xml = exportService.streamOutXML(doc, new StringWriter()).getWriter().toString();
          transformerService.triggerTransform(null, filename, result.transforms[params.transformId], xml, response)
        }else{ // send the XML to the user
          response.setHeader("Content-disposition", "attachment; filename=\"${filename}.xml\"")
          response.contentType = "text/xml"
          exportService.streamOutXML(doc, response.outputStream)
        }

      }
    }
  }

  /**
  * Iterate the result of indentifiers HQL query in pkg() method, and return the required ident ns.
  **/
  def getIdentFromMap(id,ns,results){
    def idents = results.get(id)
    def ident_value = null
    idents.each{ array ->
      if(array[1].toLowerCase() == ns){
        ident_value = array[0]
      }
    }
    return ident_value
  }

  // Controller methods are no longer cacheable... Implement in a service if caching needed.
  // @Cacheable(value='ApiResponses', key='"IDX"+#q?.toString()+#max?.toString()+#offset?.toString()+#lastUpdatedAfter?.toString()+#order?.toString()')
  @Secured(['permitAll'])
  def idx(String q, int max, int offset, String lastUpdatedAfter, String order) {

    log.debug("Evaluate idx call (${params})");

    def qry_params = [:]
    def base_qry = ' from Package as p ';
    def sort_clause = null;
    def sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    def where_needed = true

    params.max = params.max ? params.int('max') : 10

    if ( ( params.lastUpdatedAfter != null ) && ( params.lastUpdatedAfter.length() > 0 ) )  {
      try {
        def qry_date = sdf.parse(params.lastUpdatedAfter)
        if ( where_needed ) { base_qry += 'where '; where_needed=false; }
        base_qry += 'p.lastUpdated > :lu '
        qry_params.lu = qry_date
      }
      catch ( Exception e ) {
        log.warn("Unable to parse params.lastUpdatedAfter ${params.lastUpdatedAfter}");
 
      }
    }

    if ( ( params.startDateAfter != null ) && ( params.startDateAfter.length() > 0 ) )  {
      try {
        def qry_date = sdf.parse(params.startDateAfter)
        if ( where_needed ) { base_qry += 'where '; where_needed=false; } else { base_qry += 'and ' }
        base_qry += 'p.startDate > :startDate '
        qry_params.startDate = qry_date
      }
      catch ( Exception e ) {
        log.warn("Unable to parse params.startDateAfter ${params.startDateAfter}");

      }
    }

   if ( ( params.createDateAfter != null ) && ( params.createDateAfter.length() > 0 ) )  {
      try {
        def qry_date = sdf.parse(params.createDateAfter)
        if ( where_needed ) { base_qry += 'where '; where_needed=false; } else { base_qry += 'and ' }
        base_qry += 'p.dateCreated > :dateCreated '
        qry_params.dateCreated = qry_date
      }
      catch ( Exception e ) {
        log.warn("Unable to parse params.createDateAfter ${params.createDateAfter}");
      }
    }

    if ( ( params.q != null ) && ( params.q.trim().length() > 0 ) ) {
      if ( where_needed ) { base_qry += 'where '; where_needed=false; } else { base_qry += 'and ' }
      base_qry+= 'p.name like :q ';
      qry_params.q = '%'+params.q+'%'
    }

    if ( params.order=='lastUpdated') {
      sort_clause = 'order by p.lastUpdated asc'
    }
    else if ( params.order=='startDate') {
      sort_clause = 'order by p.startDate asc'
    }
    else {
      sort_clause = 'order by p.name asc'
    }


    def num_pkg_rows = Subscription.executeQuery("select count(p) ${base_qry}".toString(), qry_params )[0]
    def _packages = Subscription.executeQuery("select p ${base_qry} ${sort_clause}".toString(), qry_params, params);

    withFormat {
      csv {
        response.setHeader("Content-disposition", "attachment; filename=\"KBPlusExportIndex.csv\"")
        response.contentType = "text/csv"
        def out = response.outputStream

        out.withWriter { writer ->
          writer.write("name,uri,identifier,lastUpdated,dateCreated\n")
          _packages.each { p ->
            writer.write("\"${p.name}\",\"publicExport/pkg/${p.id}?format=csv\",\"${p.id}\",\"${sdf.format(p.lastUpdated)}\",\"${sdf.format(p.dateCreated)}\"\n");
          }
          writer.flush()
          writer.close()
        }
      }
      xml {
        def writer = new StringWriter()
        def xml = new MarkupBuilder(writer)
        xml.KbPlusPackages {
          _packages.each { p->
            packages {
              name(p.name)
              identifier(p.id)
              dateCreated(sdf.format(p.dateCreated))
              lastUpdated(sdf.format(p.lastUpdated))
              dateCreated(sdf.format(p.dateCreated))
              packageContentAsJson("http://www.kbplus.ac.uk/kbplus7/publicExport/pkg2/${p.id}")
              packageContentAsCsv("http://www.kbplus.ac.uk/kbplus7/publicExport/pkg/${p.id}?format=csv")
            }
          }
        }
        render(contentType:'application/xml', text: writer.toString())
      }
      json {
        def response = [:]
        response.packages = []
        response.note1="publicExport/idx?format=json&max={max}&offset={[offset]}&q={[searchterm]}&order={[lastUpdated|title]}&lastUpdatedAfter={[timestamp]}&createDateAfter={[timestamp]}"
        _packages.each { p->
          response.packages.add([
                                 name:p.name,
                                 description:p.description,
                                 listPrice:p.listPrice,
                                 titleCount:p.titleCount,
                                 identifier:p.id,
                                 startDate:p.startDate,
                                 endDate:p.endDate,
                                 lastUpdated:sdf.format(p.lastUpdated),
                                 dateCreated:sdf.format(p.dateCreated),
                                 packagePage:"http://www.kbplus.ac.uk/kbplus7/publicExport/pkg/${p.id}",
                                 packageContentAsJson:"http://www.kbplus.ac.uk/kbplus7/publicExport/pkg2/${p.id}",
                                 packageContentAsCsv:"http://www.kbplus.ac.uk/kbplus7/publicExport/pkg/${p.id}?format=csv"])
        }
        response.params=qry_params;
        render response as JSON
      }
    }

  }

  @Secured(['permitAll'])
  def pkgHistory() {
    log.debug("package export id:${params.id} format=${response.format}");
    def result = [:]
    result.pkg = Package.get(params.id)

    def exporting = params.format == 'csv' ? true : false
    result.max=100

    if ( exporting ) {
      result.max = 9999999
      params.max = 9999999
      result.offset = 0
    }
    else {
      params.max = result.max
      result.offset = params.offset ? Integer.parseInt(params.offset) : 0;
    }

    result.packageInstance = result.pkg
    def base_query = 'from AuditLogEvent as e where ( e.className = :pkgcls and e.persistedObjectId = :pkgid ) or ( e.className = :tippcls and e.persistedObjectId in ( select id from TitleInstancePackagePlatform as tipp where tipp.pkg = :pkgid ) )'

    def limits = (!params.format||params.format.equals("html"))?[max:result.max, offset:result.offset]:[offset:0]

    def query_params = [ pkgcls:'com.k_int.kbplus.Package', tippcls:'com.k_int.kbplus.TitleInstancePackagePlatform', pkgid:params.id]

    log.debug("base_query: ${base_query}, params:${query_params}, limits:${limits}");

    result.historyLines = AuditLogEvent.executeQuery('select e '+base_query+' order by e.lastUpdated desc', query_params, limits);
    result.num_hl = AuditLogEvent.executeQuery('select count(e) '+base_query, query_params)[0];
    result.formattedHistoryLines = []


    result.historyLines.each { hl ->

        def line_to_add = [:]
        def linetype = null

        switch(hl.className) {
          case 'com.k_int.kbplus.Package':
            def package_object = Package.get(hl.persistedObjectId);
            line_to_add = [ link: createLink(controller:'packageDetails', action: 'show', id:hl.persistedObjectId),
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

  @Secured(['permitAll'])
  def packageChangeLog() {
    log.debug("packageChangeLog(${params})");
    def result=[:]

    def parsed_start_date = null;  // format should be :: 2018-03-28 16:00:11
    if ( params.startDate ) {
      try {
        def sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        parsed_start_date = sdf.parse(params.startDate);
      }
      catch ( Exception e ) {
        throw new RuntimeException("Unable to parse input start date. Format must be yyyy-MM-dd'T'HH:mm:ss'Z'");
      }
    }

    // select p1.pkg_id packageId, p1.pkg_name packageName, concat(p1.date_created,":",p1.pkg_id) eventDate, 'CREATE' eventType from package p1
    // UNION  
    // select p2.pkg_id, p2.pkg_name, concat(p2.last_updated,":",p2.pkg_id,) ud2, 'UPDATE' from package p2 where p2.last_updated is not null 
    // order by eventDate
    String changes_query = 'select p1.pkg_id packageId, p1.pkg_name packageName, concat(p1.date_created,":",p1.pkg_id) eventDate, "CREATE" eventType from package p1 ' +
                           ( parsed_start_date ? 'where p1.date_created > :sd ' : '' ) +
                           'UNION '  +
                           'select p2.pkg_id, p2.pkg_name, concat(p2.last_updated,":",p2.pkg_id) ts2, "UPDATE" from package p2 where p2.last_updated is not null '+
                           ( parsed_start_date ? 'and ts2 > :sd ' : '' ) +
                           'order by eventDate, packageId';

    Map qparams = [:]
    if ( parsed_start_date ) {
      qparams['sd'] = parsed_start_date
    }

    def sql = new groovy.sql.Sql(dataSource)
    int offset = 1;
    int max_rows = params.max ? Integer.parseInt(params.max) : 200

    log.debug("${changes_query} ${qparams}");

    // Start at row 1, max 100
    if ( parsed_start_date ) {
      result.packChangeLog = sql.rows(qparams, changes_query,offset,max_rows);
    }
    else {
      result.packChangeLog = sql.rows(changes_query,offset,max_rows);
    }

    if ( result.packChangeLog.size() > 0 ) {
      def nextPageStartAfter = result.packChangeLog.get(result.packChangeLog.size()-1).getAt(4)?.toString()
      result.nextPage = createLink(controller:'publicExport', action:'packageChangeLog', params:[startDate:nextPageStartAfter])
    }

    render result as JSON;
  }

  
  /**
   * Render a package as JSON using the json package exchange format jpef
   * see http://views.grails.org/latest for info on gson and grails views
   */
  @Secured(['permitAll'])
  def pkg2() {
    def result=[:]
    log.debug("package export id:${params.id} format=${response.format}");
    def tipp_params = [ max : params.max ?: 10, offset: params.offset ?: 0 ]
    def packageInstance = Package.get(params.id)
    def packageContent = TitleInstancePackagePlatform.executeQuery('select tipp from TitleInstancePackagePlatform as tipp where tipp.pkg = :p',[p:packageInstance],tipp_params)
    def numTitles = TitleInstancePackagePlatform.executeQuery('select count(tipp) from TitleInstancePackagePlatform as tipp where tipp.pkg = :p',[p:packageInstance])[0]

    if ( packageInstance ) {
      respond(pkg:packageInstance, packageContent:packageContent, numTitles:numTitles);
    }
    else {
      response.status = 404;
    }
  }
}
