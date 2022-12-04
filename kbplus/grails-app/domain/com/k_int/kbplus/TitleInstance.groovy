package com.k_int.kbplus

import java.util.Iterator;
import java.util.TreeSet;
import java.util.regex.Pattern;
import org.apache.commons.lang.StringUtils;
import javax.persistence.Transient
 
import org.apache.commons.logging.*
import java.text.Normalizer
import groovy.util.logging.*
import org.apache.commons.logging.LogFactory

@Log4j
class TitleInstance {

  @Transient
  def grailsApplication

  static Log static_logger = LogFactory.getLog(TitleInstance)

  static auditable = true

  String title
  String normTitle
  String keyTitle
  String sortTitle
  String impId
  RefdataValue status
  RefdataValue type
  Date dateCreated
  Date lastUpdated
  String firstAuthor
  String publicationType
  Date dateMonographPublishedPrint
  Date dateMonographPublishedOnline
  String monographVolume
  String monographEdition
  String firstEditor
  TitleInstance parentTitle
  Date publishedFrom
  Date publishedTo

  static mappedBy = [
                     tipps: 'title',
                     ids: 'ti',
                     orgs: 'title',
                     historyEvents: 'participant',
                     childTitles:'parentTitle']

  static hasMany = [
                    tipps: TitleInstancePackagePlatform,
                    ids: IdentifierOccurrence,
                    orgs: OrgRole,
                    historyEvents: TitleHistoryEventParticipant,
                    childTitles: TitleInstance]


  static mapping = {
                                id column:'ti_id'
                             title column:'ti_title'
                         normTitle column:'ti_norm_title'
                          keyTitle column:'ti_key_title'
                           version column:'ti_version'
                             impId column:'ti_imp_id', index:'ti_imp_id_idx'
                            status column:'ti_status_rv_fk'
                              type column:'ti_type_rv_fk'
                             tipps sort:'startDate', order: 'asc'
                         sortTitle column:'sort_title'
                       parentTitle column:'parent_title_fk'
                       firstAuthor column:'ti_first_author'
                   publicationType column:'ti_pubtype'
       dateMonographPublishedPrint column:'ti_mono_date_pub_print'
      dateMonographPublishedOnline column:'ti_mono_date_pub_online'
                   monographVolume column:'ti_mono_vol'
                  monographEdition column:'ti_mono_ed'
                       firstEditor column:'ti_first_editor'
  }

  static constraints = {
    status(nullable:true, blank:false);
    type(nullable:true, blank:false);
    title(nullable:true, blank:false,maxSize:1024);
    normTitle(nullable:true, blank:false,maxSize:1024);
    sortTitle(nullable:true, blank:false,maxSize:1024);
    keyTitle(nullable:true, blank:false,maxSize:1024);
    parentTitle(nullable:true, blank:false,maxSize:1024);
    firstAuthor(nullable:true, blank:false,maxSize:1024);
    publicationType(nullable:true, blank:false,maxSize:1024);
    dateMonographPublishedPrint(nullable:true, blank:false,maxSize:1024);
    dateMonographPublishedOnline(nullable:true, blank:false,maxSize:1024);
    monographVolume(nullable:true, blank:false,maxSize:1024);
    monographEdition(nullable:true, blank:false,maxSize:1024);
    firstEditor(nullable:true, blank:false,maxSize:1024);
    publishedFrom(nullable:true, blank:false,maxSize:1024);
    publishedTo(nullable:true, blank:false,maxSize:1024);
  }

  // Create a default no-args constructor
  public TitleInstance() {
  }

  String getIdentifierValue(String idtype) {
    
    // def result=null
    // ids?.each { id ->
    //   if ( id.identifier?.ns?.ns?.toLowerCase() == idtype.toLowerCase() )
    //     result = id.identifier?.value
    // }
    def identifier = ids.find { it.identifier?.ns?.ns?.equalsIgnoreCase(idtype) }
    identifier?.identifier?.value
  }

  Org getPublisher() {
    def result = null;
    orgs.each { o ->
      if ( o.roleType?.value == 'Publisher' ) {
        result = o.org
      }
    }
    result
  }

  static def lookupByIdentifierString(idstr) {

    println("lookupByIdentifierString(${idstr})");

    def result = null;
    def qr = null;
    def idstr_components = idstr.split(':');

    switch ( idstr_components.size() ) {
      case 1:
        qr = TitleInstance.executeQuery('select t from TitleInstance as t join t.ids as io where io.identifier.value = ?',[idstr_components[0]])
        break;
      case 2:
        qr = TitleInstance.executeQuery('select t from TitleInstance as t join t.ids as io where io.identifier.value = ? and lower(io.identifier.ns.ns) = ?',[idstr_components[1],idstr_components[0]?.toLowerCase()])
        break;
      default:
        // println("Unable to split");
        break;
    }

    // println("components: ${idstr_components} : ${qr}");

    if ( qr ) {
      switch ( qr.size() ) {
        case 0:
          log.debug("No matches - trying to locate via identifier group");
          switch ( idstr_components.size() ) {
            case 1:
              qr = TitleInstance.executeQuery('select t from TitleInstance as t join t.ids as io where exists ( select i from Identifier where i.value = ? and i.ig = io.identifier.ig )',[idstr_components[0]])
              break;
            case 2:
              qr = TitleInstance.executeQuery('select t from TitleInstance as t join t.ids as io where exists ( select i from Identifier where i.value = ? and i.ns.ns = ? and i.ig = io.identifier.ig )',[idstr_components[1],idstr_components[0]?.toLowerCase()])
              break;
            default:
              // println("Unable to split");
              break;
          }

          break;
        case 1:
          result = qr.get(0);
          break;
        default:
          log.error("WARNING:: Identifier '${idstr}' matched multiple rows");
          break;
      }
    }

    result
  }

  /**
   * Attempt to look up a title instance which has any of the listed identifiers
   * @param candidate_identifiers A list of maps containing identifiers and namespaces [ { namespace:'ISSN', value:'Xnnnn-nnnn' }, {namespace:'ISSN', value:'Xnnnn-nnnn'} ]
   */
  static def findByIdentifier(candidate_identifiers) {
    def matched = []
    candidate_identifiers.each { i ->
      def id = Identifier.lookupOrCreateCanonicalIdentifier(i.namespace, i.value)
      def io = IdentifierOccurrence.findByIdentifier(id)
      if ( ( io != null ) && ( io.ti != null ) ) {
        if ( matched.contains(io.ti) ) {
          // Already in the list
        }
        else {
          matched.add(io.ti);
        }
      }
    }

    // Didn't match anything - see if we can match based on identifier without namespace [In case of duff supplier data]
    if ( matched.size() == 0 ) {
      candidate_identifiers.each { i ->
        def id1 = Identifier.executeQuery('Select io from IdentifierOccurrence as io where io.identifier.value = ?',[i.value]);
        id1.each {
          if ( it.ti != null ) {
            if ( matched.contains(it.ti) ) {
              // Already in the list
            }
            else {
              matched.add(it.ti);
            }
          }
        }
      }
    }

    def result = null;
    if ( matched.size() == 1 ) {
      result = matched.get(0);
    }
    else if ( matched.size() > 1 ) {
      result = matched.get(0);
    }

    return result;
  }

  static def lookupOrCreate(candidate_identifiers, title) {
    lookupOrCreate(candidate_identifiers, title, false)
  }

  static def lookupOrCreate(candidate_identifiers, title, enrich) {
    def result = null;
    def lu_ids = []

    candidate_identifiers.each { i ->
      def id = Identifier.lookupOrCreateCanonicalIdentifier(i.namespace, i.value)
      static_logger.debug("processing candidate identifier ${i} as ${id}");

      def io = IdentifierOccurrence.findByIdentifier(id)
      if ( io && io.ti ) {
        static_logger.debug("located existing titie: ${io.ti.id}");
        result = io.ti;
      }
      else {
        static_logger.debug("No trace of ${id} - add to list to process later on");
        lu_ids.add(id);
      }
    }

    if (!result) {
      static_logger.debug("No result - creating new title");
      result = new TitleInstance(title:title, impId:java.util.UUID.randomUUID().toString());
      result.save(flush:true);

      result.ids=[]
      lu_ids.each {
        def new_io = new IdentifierOccurrence(identifier:it, ti:result)
        if ( new_io.save(flush:true) ) {
          log.debug("Created new IO");
        }
        else {
          log.error("Problem creating new IO");
        }
        // result.ids.add(new IdentifierOccurrence(identifier:it, ti:result));
      }
      if ( ! result.save(flush:true) ) {
        throw new RuntimeException("Problem creating title instance : ${result.errors?.toString()}");
      }
    }
    else {
      static_logger.debug("Found existing title check for enrich...");
      if ( enrich ) {
        static_logger.debug("enrich... current ids = ${result.ids}, non-matching ids = ${lu_ids}");
        // println("Checking that all identifiers are already present in title");
        boolean modified = false;
        // Check that all the identifiers listed are present
        lu_ids.each { identifier ->
          static_logger.debug("adding identifier ${identifier.ns.ns}:${identifier.value} - adding");
          def new_io = new IdentifierOccurrence(identifier:identifier, ti:result).save();
          modified=true;
        }
        if ( modified ) {
          result.save();
        }
      }
    }

    return result;

  }

  /**
   *  Caller passes in a map like {issn:'nnnn-nnnn',doi:'quyeihdj'} and expects to get back a new title
   *  or one matching any of the identifiers
   */
  static def lookupOrCreateViaIdMap(candidate_identifiers, title) {
    def result = null;
    def ids = []

    candidate_identifiers.each { i ->

      if ( ( i.key != null ) &&
           ( i.value != null ) &&
           ( i.key.length() > 0 ) &&
           ( i.value.length() > 0 ) ) {

        def id = Identifier.lookupOrCreateCanonicalIdentifier(i.key, i.value)
        if ( id != null ) {
          ids.add(id);

          // If the namespace is marked as non-unique, we allow repeats. otherwise check for uniqueness
          if ( id.ns.nonUnique==Boolean.TRUE ) {
            // Namespace is marked as non-unique, don't perform a uniqueness check
          }
          else {
            def io = IdentifierOccurrence.findByIdentifier(id)
            if ( io && io.ti ) {
              if ( result == null ) {
                result = io.ti;
              }
              else {
                if ( result != io.ti ) {
                  throw new RuntimeException("Identifiers(${candidate_identifiers}) reference multiple titles [Already located title with id ${result.id}, also located title with id ${io.ti.id}]");
                }
              }
            }
          }
        }
      }
    }

    // We were not able to match on any identifier, but we have a title.
    if (!result && title) {

      String norm_title = com.k_int.kbplus.utils.TextUtils.generateNormTitle(title)

      // No identifier match - before we go crazy, lets just try a simple title match
      // If we match multiple, just pick the first one
      log.debug("Unable to locate a title using identifiers - attempte title match ${title}/${norm_title}");
      def title_list = TitleInstance.findAllByNormTitle(norm_title)
      if ( title_list.size() > 0 ) {
        result = title_list[0];
      }
      if ( title_list.size() > 1 ) {
        throw new RuntimeException("Lookup/Create title failed on title string match - Multiple titles match ${title}/${norm_title}");
      }
      
      if ( result == null ) {
        result = new TitleInstance(title:title, impId:java.util.UUID.randomUUID().toString());

        result.ids=[]
        ids.each {
          result.ids.add(new IdentifierOccurrence(identifier:it, ti:result));
        }
        if ( ! result.save() ) {
          throw new RuntimeException("Problem creating title instance : ${result.errors?.toString()}");
        }
      }
    }
    else {
      //println("Checking that all identifiers are already present in title (${ids})");
      boolean modified = false;
      // Check that all the identifiers listed are present
      ids.each { identifier ->
        // it == an ID
        // Does result.ids contain an identifier occurrence that matches this ID
        // def existing_id = result.ids.find { it -> it.identifier == identifier }
        def existing_id = IdentifierOccurrence.findByIdentifierAndTi(identifier,result)

        if ( existing_id == null ) {
          //println("Adding additional identifier ${identifier}");
          result.ids.add(new IdentifierOccurrence(identifier:identifier, ti:result));
          modified=true;
        }
        else {
          //println("Identifier ${identifier} already present in existing title ${result}");
        }
      }

      if ( modified ) {
        result.save();
      }
    }

    return result;

  }

  def beforeInsert() {
    if ( title != null ) {
      normTitle = com.k_int.kbplus.utils.TextUtils.generateNormTitle(title)
      keyTitle = com.k_int.kbplus.utils.TextUtils.generateKeyTitle(title)
      sortTitle = com.k_int.kbplus.utils.TextUtils.generateSortTitle(title)
    }
  }

  def beforeUpdate() {
    if ( title != null ) {
      normTitle = com.k_int.kbplus.utils.TextUtils.generateNormTitle(title)
      keyTitle = com.k_int.kbplus.utils.TextUtils.generateKeyTitle(title)
      sortTitle = com.k_int.kbplus.utils.TextUtils.generateSortTitle(title)
    }
  }

  static def refdataFind(params) {
    def result = [];
    def ql = null;
    if ( params.sort==null ) {
      params.sort="title"
      params.order="desc"
    }

    // If the search without a wildcard returns items, return those, otherwise if a case insensitive search
    // without a wildcard returns 0, add a wildcard and use that
    def num_titles = TitleInstance.countByTitleIlike("${params.q}",params)
    if ( num_titles == 0 ) {
      ql = TitleInstance.findAllByTitleIlike("${params.q}%",params)
    }
    else {
      ql = TitleInstance.findAllByTitleIlike("${params.q}",params)
    }

    int i = 1;
    if ( ql ) {
      ql.each { t ->
        result.add([id:"${t.class.name}:${t.id}",text:"[${i++}] ${t.title} (${t.identifiersAsString()})"])
      }
    }

    result
  }


  @Transient
  def identifiersAsString() {
    def result = new StringWriter()
    ids.each { id ->
      result.write("${id.identifier.ns.ns}:${id.identifier.value} ");
    }
    return result.toString()
  }

  @Transient
  def onChange = { oldMap,newMap ->

    // static_logger.debug("onChange")

    def changeNotificationService = grailsApplication.mainContext.getBean("changeNotificationService")
    def controlledProperties = ['title']

    controlledProperties.each { cp ->
      if ( oldMap[cp] != newMap[cp] ) {
        changeNotificationService.notifyChangeEvent([
                                                     OID:"${this.class.name}:${this.id}",
                                                     event:'TitleInstance.propertyChange',
                                                     prop:cp,
                                                     old:oldMap[cp],
                                                     new:newMap[cp]
                                                    ])
      }
    }
  }

  @Transient
  def notifyDependencies(changeDocument) {
    // static_logger.debug("notifyDependencies(${changeDocument})");

    def changeNotificationService = grailsApplication.mainContext.getBean("changeNotificationService")
    tipps.each { tipp ->
      // Notify each package that a component title has changed
      changeNotificationService.broadcastEvent("${tipp.pkg.class.name}:${tipp.pkg.id}", changeDocument);
    }

    changeNotificationService.broadcastEvent("${this.class.name}:${this.id}", changeDocument);
  }

  def getInstitutionalCoverageSummary(institution, dateformat) {
    getInstitutionalCoverageSummary(institution, dateformat, null);
  }

  def getInstitutionalCoverageSummary(institution, dateformat, date_restriction) {
    def sdf = new java.text.SimpleDateFormat(dateformat)

    def qry = "select ie from IssueEntitlement as ie JOIN ie.subscription.orgRelations as o where ie.tipp.title = :title and o.org = :institution AND o.roleType.value = 'Subscriber' "+
              "AND ie.subscription.status.value != 'Deleted' "
    def qry_params = ['title':this, institution:institution]

    if ( date_restriction ) {
      qry += " AND ie.subscription.startDate <= :date_restriction AND ie.subscription.endDate >= :date_restriction "
      qry_params.date_restriction = date_restriction
    }

    def ies = IssueEntitlement.executeQuery(qry,qry_params)
    def earliest = null
    def latest = null
    boolean open = false
    ies.each { ie ->
      if ( earliest == null ) { earliest = ie.startDate } else { if ( ie.startDate < earliest ) { earliest = ie.startDate } }
      if ( latest == null ) { latest = ie.endDate } else { if ( ie.endDate > latest ) { latest = ie.endDate } }
      if ( ie.endDate == null ) open = true;
    }

    [
      earliest:earliest?sdf.format(earliest):'',
      latest: open ? '': (latest?sdf.format(latest):''),
      ies:ies
    ]
  }

  def checkAndAddMissingIdentifier(ns,value) {
    boolean found = false
    this.ids.each {
      if ( it.identifier.ns.ns == ns && it.identifier.value == value ) {
        found = true
      }
    }

    if ( ! found ) {
      def id = Identifier.lookupOrCreateCanonicalIdentifier(ns, value)
      def existing_occurrence = IdentifierOccurrence.findAllByIdentifier(id)
      if ( existing_occurrence.size() > 0 ) {
        // Do nothing - already present
      }
      else {
        static_logger.debug("Create new identifier occurrence for tid:${getId()} ns:${ns} value:${value}");
        new IdentifierOccurrence(identifier:id, ti:this).save(flush:true)
      }
    }
  }

  @Transient
  def distinctEventList() {
    def result = []
    historyEvents.each { he ->
      if ( result.find { it.event.id == he.event.id} ) {
      }
      else {
        result.add(he)
      }
    }
    result
  }

  @Transient
  def isInPackage(pkg) {
    def result = false
    def tipp = TitleInstancePackagePlatform.findByTitleAndPkg(this,pkg)
    if(tipp)
      result=true
    result
  }

  static def expunge(title_id) {
    try {
      log.debug("  -> IEs");
      TitleInstance.executeUpdate('delete from IssueEntitlement ie where ie.tipp in ( select tipp from TitleInstancePackagePlatform tipp where tipp.title.id = ? )',[title_id])
      log.debug("  -> TIPPs");
      TitleInstance.executeUpdate('delete from TitleInstancePackagePlatform tipp where tipp.title.id = ?',[title_id])
      log.debug("  -> IdentifierOccurrence");
      TitleInstance.executeUpdate('delete from IdentifierOccurrence io where io.ti.id = ?',[title_id])
      log.debug("  -> OrgRole");
      TitleInstance.executeUpdate('delete from OrgRole orl where orl.title.id = ?',[title_id])
      log.debug("  -> TitleHistoryEventParticipant");
      TitleInstance.executeUpdate('delete from TitleHistoryEventParticipant he where he.participant.id = ?',[title_id])
      log.debug("  -> CoreAssertion");
      TitleInstance.executeUpdate('delete from CoreAssertion ca where ca.tiinp in (select tip from TitleInstitutionProvider tip where tip.title.id = ?)',[title_id])
      log.debug("  -> TitleInstitutionProvider");
      TitleInstance.executeUpdate('delete from TitleInstitutionProvider tip where tip.title.id = ?',[title_id])
      log.debug("  -> Fact");
      TitleInstance.executeUpdate('delete from Fact fact where fact.relatedTitle.id = ?',[title_id])
      log.debug("  -> OrgTitleStats");
      TitleInstance.executeUpdate('delete from OrgTitleStats ots where ots.title.id = ?',[title_id])
      log.debug("  -> TI itself");
      TitleInstance.executeUpdate('delete from TitleInstance ti where ti.id = ?',[title_id])
      log.debug("  -> DONE");
    }
    catch ( Exception e ) {
      log.error("Problem expunging title",e);
    }
  }

  def isValidCoverage(start, end) {
    def result = true

    // Dates assumed to be value unless.........

    if ( start ) {
      if ( publishedFrom ) {
        if ( start.getTime() < publishedFrom.getTime() ) {
          // Date present, and publishedFrom on title - the date supplied predates the title date - so reject
          result = false
        }
      }
      else {
      }
    }
    else {
      if ( publishedFrom ) {
        // no start date supplied, but we know about the publishedFrom date, user must manually set the date so reject
        result = false;
      }
    }

    if ( end ) {
      if ( publishedTo ) {
        if ( end.getTime() > publishedTo.getTime() ) {
          // coverage end date exceeds publishedTo date - error, reject.
          result = false;
        }
      }
    }
    else {
      if ( publishedTo ) {
        // No end date supplied, but we have a publishedTo date, reject, user must supply a date.
        result = false;
      }
    }

    result
  }

  /**
   * Validate a tipp start and end date by ensuring that the date range lies within known dates when this Title
   * was published. Null start dates are only valid when there is no earliest published dates.
  */
  def oldIsValidCoverage(start, end) {

    def result = true;
    def published_from = null;
    def published_to = null;

    orgs.each { o ->
      if ( o.roleType?.value == 'Publisher' ) {
        if ( ( o.startDate != null ) && ( ( published_from == null ) || ( o.startDate < published_from ) ) ) {
          published_from = o.startDate
        }
        if ( ( o.endDate != null ) && ( ( published_to == null ) || ( o.endDate > published_to ) ) ) {
          published_to = o.endDate
        }
      }
    }

    // Start date checks - It's valid if published from and start are null, otherwise they must match
    if ( ( published_from == null ) && ( start == null ) ) {
      result = result & true
    }
    else if ( ( published_from == null ) && ( start != null ) ) {
      // We allow if the tipp has a date, but the publisher link does not.
      result = result & true
    }
    else if ( ( published_from == null ) || ( start == null ) ) {
      result = result & false
    }
    else { // We have a start date and a published from date - make sure the range matches
      result = result & ( start > published_from )
    }

    // End date checks
    if ( ( published_to == null ) && ( end == null ) ) {
      result = result & true
    }
    else if ( ( published_to == null ) && ( end != null ) ) {
      // We allow if the tipp has a date, but the publisher link does not.
      result = result & true
    }
    else if ( ( published_to == null ) || ( end == null ) ) {
      result = result & false
    }
    else { // We have a start date and a published from date - make sure the range matches
      result = result & ( end  < published_to )
    }

    result
  }

  @Transient
  static def oaiConfig = [
    id:'titles',
    textDescription:'Title repository for KBPlus',
    query:" from TitleInstance as o ",
    pageSize:20
  ]

  /**
   *  Render this title as OAI_dc
   */
  @Transient
  def toOaiDcXml(builder, attr) {
    builder.'dc'(attr) {
      'dc:title' (name)
    }
  }

  /**
   *  Render this Title as KBPlusXML
   */
  @Transient
  def toKBPlus(builder, attr) {

    def sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    def pub = getPublisher()

    try {
      builder.'kbplus' (attr) {
        builder.'title' (['id':(id)]) {
          builder.'title' (title)
        }
        builder.'identifiers' () {
          ids?.each { id_oc ->
            builder.identifier([namespace:id_oc.identifier?.ns.ns, value:id_oc.identifier?.value])
          }
        }
        if ( pub ) {
          builder.'publisher' ([id:(pub.id)]) {
            builder.'name' (pub.name)
          }
        }
      }
    }
    catch ( Exception e ) {
      log.error(e);
    }

  }

  @Transient
  getIssn() {
    return getIdentifierValue('issn')
  }

  @Transient
  getIsbn() {
    return getIdentifierValue('isbn')
  }

  @Transient
  getEissn() {
    return getIdentifierValue('eissn')
  }

  @Transient
  getDoi() {
    return getIdentifierValue('doi')
  }

  @Transient
  def hasIdentifier(namespace, value) {
    def result = false;
    ids.each {
      if ( it.identifier.ns.ns.equalsIgnoreCase(namespace) && it.identifier.value.equalsIgnoreCase(value) ) {
        result = true;
      }
    }
    return result
  }
}
