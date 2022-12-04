package com.k_int.kbplus

import groovyx.net.http.*
import org.apache.http.entity.mime.*
import static groovyx.net.http.Method.GET
import static groovyx.net.http.Method.POST
import static groovyx.net.http.ContentType.TEXT
import static groovyx.net.http.ContentType.JSON
import org.apache.http.entity.mime.content.*
import java.nio.charset.Charset
import org.apache.http.*
import org.apache.http.protocol.*
import java.text.SimpleDateFormat
import au.com.bytecode.opencsv.CSVReader
import groovy.util.logging.Slf4j

@Slf4j
class JuspSyncService {

  static transactional = false
  def FIXED_THREAD_POOL_SIZE = grails.util.Holders.config.juspThreadPoolSize ?: 10
  def executorService
  def factService
  def sessionFactory

  static int submitCount=0
  static int completedCount=0
  static int newFactCount=0
  static int totalTime=0
  static int queryTime=0
  static int exceptionCount=0
  static long syncStartTime=0
  static int syncElapsed=0
  static def activityHistogram = [:]

  // Change to static just to be super sure
  static boolean running = false;

  def synchronized doSync() {
    log.debug("JuspSyncService::doSync ${this.hashCode()}");

    if ( this.running == true ) {
      log.debug("Skipping sync.. task already running");
      return
    }

    log.debug("Mark JuspSyncTask as running...");
    this.running = true

    submitCount=0
    completedCount=0
    newFactCount=0
    totalTime=0
    queryTime=0
    syncStartTime=System.currentTimeMillis()
    log.debug("Launch jusp sync at ${syncStartTime} ( ${System.currentTimeMillis()} )");
    syncElapsed=0
    activityHistogram = [:]

    def future = executorService.submit({ internalDoSync() } as java.lang.Runnable)

    log.debug("Jusp task submitted");
  }

  def internalDoSync() {

    def ftp = null
    try {
      log.debug("create thread pool");
      ftp = java.util.concurrent.Executors.newFixedThreadPool(FIXED_THREAD_POOL_SIZE)

      def jusp_api = grails.util.Holders.config.JuspApiUrl
      if ( ( jusp_api == null ) || ( jusp_api == '' ) ) {
        log.error("JUSP API Not set in config");
        return
      }

      def c = new GregorianCalendar()
      c.add(Calendar.MONTH,-2)

      // Remember months are zero based - hence the +1 in this line!
      def most_recent_closed_period = "${c.get(Calendar.YEAR)}-${String.format('%02d',c.get(Calendar.MONTH)+1)}"
      def start_time = System.currentTimeMillis()

      // Select distinct list of Title+Provider (TIPP->Package-CP->ID[jusplogin] with jusp identifiers
      // def q = "select distinct tipp.title, po.org, tipp.pkg from TitleInstancePackagePlatform as tipp " +
      //           "join tipp.pkg.orgs as po where po.roleType.value='Content Provider' " +
      //           "and exists ( select tid from tipp.title.ids as tid where tid.identifier.ns.ns = 'jusp' ) " +
      //           "and exists ( select oid from po.org.ids as oid where oid.identifier.ns.ns = 'juspsid' ) "
      // def q = "select distinct ie.tipp.title, po.org, orgrel.org, jusptid from IssueEntitlement as ie " +

      int org_counter = 0;
      def active_jusp_institutions = "select o from Org as o where exists ( select oid from o.ids as oid where oid.identifier.ns.ns = 'jusplogin' )"
      Org.executeQuery(active_jusp_institutions).each { o ->

        log.debug("Process org [${org_counter++}] ${o.name} - everything up to ${most_recent_closed_period}");

        // Get a distinct list of titles ids, the content provider, subscribing organisation and the jusp title identifier
        def q = "select distinct ie.tipp.title.id, po.org.id, orgrel.org.id, jusptid.id from IssueEntitlement as ie " +
                "join ie.tipp.pkg.orgs as po " +
                "join ie.subscription.orgRelations as orgrel "+
                "join ie.tipp.title.ids as jusptid "+
                "where orgrel.org.id = :o "+
                "and jusptid.identifier.ns.ns = 'jusp' "+
                "and po.roleType.value='Content Provider' "+
                "and exists ( select oid from po.org.ids as oid where oid.identifier.ns.ns = 'juspsid' ) " +
                "and orgrel.roleType.value = 'Subscriber' " +
                "and exists ( select sid from orgrel.org.ids as sid where sid.identifier.ns.ns = 'jusplogin' ) "

        log.debug("JUSP Sync Task - Find titles for org ${o.id}(${o.name}) ${q}");
  
        def l1 = IssueEntitlement.executeQuery(q,[o:o.id])
  
        queryTime = System.currentTimeMillis() - start_time
  
        log.debug("JUSP Sync query completed.... (${} ${queryTime})");
  
        l1.each { to ->
          log.debug("Submit job ${++submitCount} to fixed thread pool");
          ftp.submit( { processTriple(to[0],to[1],to[2],to[3], most_recent_closed_period) } as java.lang.Runnable )
        }
      }
    }
    catch ( Exception e ) {
      log.error("Problem",e);
    }
    finally {
      log.debug("internalDoSync complete");
      if ( ftp != null ) {
        ftp.shutdown()
        if ( ftp.awaitTermination(48,java.util.concurrent.TimeUnit.HOURS) ) {
          log.debug("FTP cleanly terminated");
        }
        else {
          log.debug("FTP still running.... Calling shutdown now to terminate any outstanding requests");
          ftp.shutdownNow()
        }
      }
      log.debug("Mark JuspSyncTask as not running...");
      this.running = false
    }
  }

  def processTriple(a,b,c,d,most_recent_closed_period) {

    def jusp_api = grails.util.Holders.config.JuspApiUrl

    // REST endpoint for JUSP
    log.debug("JUSP Endpoint: ${jusp_api}");
    // def jusp_api_endpoint = new RESTClient(jusp_api)
    // jusp_api_endpoint.ignoreSSLIssues()

    def juspTimeStampFormat = new SimpleDateFormat('yyyy-MM')
    def start_time = System.currentTimeMillis();

    Fact.withNewTransaction { status ->

      //log.debug("processTriple");

      def title_inst = TitleInstance.get(a);
      def supplier_inst = Org.get(b);
      def org_inst = Org.get(c);
      def title_io_inst = IdentifierOccurrence.get(d);

      //log.debug("Processing titile/provider/org triple: ${title_inst.title}, ${supplier_inst.name}, ${org_inst.name}");

      def jusp_supplier_id = supplier_inst.getIdentifierByType('juspsid').value
      def jusp_login = org_inst.getIdentifierByType('jusplogin').value
      def jusp_title_id = title_io_inst.identifier.value

      // log.debug(" -> Title jusp id: ${jusp_title_id}");
      // log.debug(" -> Suppllier jusp id: ${jusp_supplier_id}");
      // log.debug(" -> Subscriber jusp id: ${jusp_login}");

      def csr = JuspTripleCursor.findByTitleIdAndSupplierIdAndJuspLogin(jusp_title_id,jusp_supplier_id,jusp_login)
      if ( csr == null ) {
        csr = new JuspTripleCursor(titleId:jusp_title_id,supplierId:jusp_supplier_id,juspLogin:jusp_login,haveUpTo:null)
      }

      if ( ( csr.haveUpTo == null ) || ( csr.haveUpTo < most_recent_closed_period ) ) {
        def from_period = csr.haveUpTo ?: '1800-01'
        log.debug("Cursor for ${jusp_title_id}(${title_inst.id}):${jusp_supplier_id}(${supplier_inst.id}):${jusp_login}(${org_inst.id}) is ${csr.haveUpTo} and is null or < ${most_recent_closed_period}. Will be requesting data from ${from_period}");
        try {
          //log.debug("Making JUSP API Call");
          def request_url = jusp_api+"/api/v1/Journals/Statistics/?jid=${jusp_title_id}&sid=${jusp_supplier_id}&loginid=${jusp_login}&startrange=${from_period}&endrange=${most_recent_closed_period}&granularity=monthly"

          log.debug(" -> Requesting ${request_url}");
          def jusp_url = new java.net.URL(request_url)
          def json = new groovy.json.JsonSlurper().parseText(jusp_url.text)

          //log.debug("Got JUSP Result");
          if ( ( json ) && ( json instanceof Map ) ) {
            def cal = new GregorianCalendar();
            if ( json.ReportPeriods != null ) {
              if ( json.ReportPeriods.equals(net.sf.json.JSONNull) ) {
                log.debug("report periods jsonnull");
              }
              else {
                // log.debug("Report Periods present: ${json.ReportPeriods}");
                json.ReportPeriods.each { p ->
                  if ( p instanceof net.sf.json.JSONNull ) {
                    // Safely ignore
                  }
                  else {
                    def fact = [:]
                    fact.from=juspTimeStampFormat.parse(p.Start)
                    fact.to=juspTimeStampFormat.parse(p.End)
                    cal.setTime(fact.to)
                    fact.reportingYear=cal.get(Calendar.YEAR)
                    fact.reportingMonth=cal.get(Calendar.MONTH)+1
                    p.Reports.each { r ->
                      fact.type = "JUSP:${r.key}"
                      fact.value = r.value
                      fact.uid = "${jusp_title_id}:${jusp_supplier_id}:${jusp_login}:${p.End}:${r.key}"
                      fact.title = title_inst
                      fact.supplier = supplier_inst
                      fact.inst =  org_inst
                      fact.juspio =  title_io_inst
                      if ( factService.registerFact(fact) ) {
                        ++newFactCount
                      }
                    }
                  }
                }
              }
            }
            else {
              // log.debug("No report periods");
            }
          }
          else {
            log.error("JUSP Returned \"${json}\" but we expected a map");
          }

          // log.debug("Update csr");
          csr.haveUpTo=most_recent_closed_period
          csr.save(flush:true);
        }
        catch ( Exception e ) {
          log.error("Problem fetching JUSP data",e);
          log.error("URL giving error(${e.message}): ${jusp_api}${app_path}?jid=${jusp_title_id}&sid=${jusp_supplier_id}&loginid=${jusp_login}&startrange=${from_period}&endrange=${most_recent_closed_period}&granularity=monthly");
          exceptionCount++
        }
        finally {
        }
      }

      csr.save(flush:true);
      cleanUpGorm();
      def elapsed = System.currentTimeMillis() - start_time;
      totalTime+=elapsed
      incrementActivityHistogram();
      synchronized(this) {
        Thread.yield()
      }
      log.debug("jusp triple completed and updated.. ${completedCount} tasks completed out of ${submitCount}. Elasped=${elapsed}. Average=${totalTime/completedCount}");
    }
  }


  def cleanUpGorm() {
    // log.debug("Clean up GORM");
    def session = sessionFactory.currentSession
    session.flush()
    session.clear()
  }

  public synchronized void incrementActivityHistogram() {
    def sdf = new SimpleDateFormat('yyyy/MM/dd HH:mm')
    def col_identifier = sdf.format(new Date())

    completedCount++

    if ( activityHistogram[col_identifier] == null ) {
      activityHistogram[col_identifier] = [ counter: new Long(1), message: null, startTime:System.currentTimeMillis(), lastUpdate:null, elapsed:0, avg:0 ]
    }
    else {
      activityHistogram[col_identifier].counter++
      activityHistogram[col_identifier].lastUpdate = System.currentTimeMillis()
      activityHistogram[col_identifier].elapsed = activityHistogram[col_identifier].lastUpdate - activityHistogram[col_identifier].startTime
      activityHistogram[col_identifier].avg = activityHistogram[col_identifier].elapsed / activityHistogram[col_identifier].counter
      activityHistogram[col_identifier].submitCount = submitCount
      activityHistogram[col_identifier].completedCount = completedCount
    }

    log.debug("JUSP Activity: ${col_identifier} ${activityHistogram[col_identifier]}");

    syncElapsed = System.currentTimeMillis() - syncStartTime
  }

  public Map readAndValidateUsageDataFile(InputStream usage_data_file) {
    Map result = [:]
    log.debug("validateUsageDataFile");

    CSVReader r = new CSVReader( new InputStreamReader(input_stream, java.nio.charset.Charset.forName('UTF-8') ) )
    String[] nl;
    def first = true

    while (nl = r.readNext()) {
      if ( first ) {
        analyseHeaderRow(nl, result);
        log.debug("Result of analyseHeaderRow: ${result}");
        first = false; // Skip header
      }
      else {
      }
    }

    result.isValid=true;
    return result;
  }

  public Map loadUsageDataFile(Map parsed_usage_data) {
    Map result = [:]
    log.debug("loadUsageDataFile");
    return result;
  }

  private analyseHeaderRow(String[] header, Map result) {
    log.debug("analyseHeaderRow(${header},...)");
    result.isValid = true;
    result.metadata = [
      usage_type_col: getColumn('usage.type', header),
      title_id_col: getColumn('title.id', header),
      supplier_id_col: getColumn('supplier.id', header),
      institution_id_col: getColumn('institution.id', header),
      reportingYearCol: getColumn('reportingYear', header),
      reportingMonthCol: getColumn('reportingMonth', header),
      usageDataCol: getColumn('usage', header)
    ]

    // Check that we have all the columns
    boolean have_all_columns = true

    if ( have_all_columns ) {
      // Work out the prefixes for identifier namespaces
      result.metadata.titleIdNamespace=getNamespace(result.metadata.title_id_col, header);
      result.metadata.supplierIdNamespace=getNamespace(result.metadata.supplier_id_col, header);
      result.metadata.institutionIdNamespace=getNamespace(result.metadata.institution_id_col, header);
    }
    else {
      result.isValid = false;
    }

  }

  /**
   * Return the namespace of the give identifier, or NULL if not present. EG
   * given supplier.juspsid and the prefix "supplier" return "juspsid"
   */
  private String getNamespace(Long col, String[] header) {
    String[] values = header[col].split('\\.');
    return values[1]
  }

  /**
   *  Return the column matching the regex. Eg given a file like
   *  usage.type      title._id       supplier._id    institution._id reportingYear   reportingMonth  usage
   *  return 0 for getColumn(usage.type), 1 for getColumn(title) etc
   */
  private getColumn(String colname, String[] header) {
    Long result = null;
    Long i=0;
    header.each { it ->
      if ( it.startsWith(colname) ) {
        result = i;
      }
      else {
        i++;
      }
    }

    return result;
  }


}
