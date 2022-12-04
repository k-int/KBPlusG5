package com.k_int.kbplus

import com.k_int.kbplus.*
import org.hibernate.ScrollMode
import java.nio.charset.Charset
import java.util.GregorianCalendar
import au.com.bytecode.opencsv.CSVReader

import groovy.util.logging.Slf4j


@Slf4j
class DataloadService {

  def stats = [:]

  def update_stages = [
    'Organisations Data',
    'Subscriptions Offered Data',
    'Subscriptions Taken Data',
    'License Data'
  ]

  def executorService
  def ESWrapperService
  def sessionFactory
  def edinaPublicationsAPIService
  def grailsApplication

  String es_index
  def dataload_running=false
  def dataload_stage=-1
  def dataload_message=''
  def update_running = false
  def lastIndexUpdate = null

  @javax.annotation.PostConstruct
  def init () {
    log.debug("DataloadService::init");
    es_index= grailsApplication.config.aggr_es_index ?: 'kbplus'
  }

  def updateFTIndexes() {
    log.debug("updateFTIndexes hashcode:${this.hashCode()} - submitting to executor service CurrentStatus:${update_running}");
    new EventLog(event:'kbplus.updateFTIndexes',message:'Update FT indexes',tstp:new Date(System.currentTimeMillis())).save(flush:true)
    // def future = executorService.submit({
    runAsync{
      try {
        log.debug("testing executor thread access to logger");
        doFTUpdate()
      }
      catch ( Exception e ) {
        log.error("Problem in doFTUpdate()",e);
      }
      finally {
        log.debug("updateFTIndexes completed");
      }
    }

    log.debug("updateFTIndexes returning");
  }

  def fullESReset() {
    log.debug("DataloadService::fullESReset");
    FTControl.executeUpdate('update FTcontrol set lastTimestamp=0');
    doFTUpdate()
  }

  def doFTUpdate() {

    synchronized(this) {
      if ( update_running == true ) {
        log.debug("Update already running - return");
        return
      }
      else {
        log.debug("Starting FT Update");
        update_running = true;
      }
    }

    log.debug("doFTUpdate");
    
    // log.debug("Execute IndexUpdateJob starting at ${new Date()}");
    // updateSiteMapping()
    
    def start_time = System.currentTimeMillis();


    updateES(com.k_int.kbplus.Org.class) { org ->
      log.debug("updateES for org ${org.id}");
      Map result = [:]
      result.status = org.status?.value
      result._id = "org-${org.id}".toString();
      result.name = org.name
      result.sector = org.sector
      result.dbId = org.id
      result.visible = ['Public']
      result.rectype = 'Organisation'
      result.variantNames = []
      org.variantNames.each { vn ->
        result.variantNames.add(vn.variantName);
      }
      result.identifiers = []
      org.ids?.each { id ->
        result.identifiers.add([type:id.identifier?.ns?.ns, value:id.identifier?.value])
      }
      result
    }

    updateES(com.k_int.kbplus.TitleInstance.class) { ti ->
      Map result = [:]
        if ( ti.title != null ) {
          def new_key_title = com.k_int.kbplus.utils.TextUtils.generateKeyTitle(ti.title)
          if ( ti.keyTitle != new_key_title ) {
            ti.normTitle = com.k_int.kbplus.utils.TextUtils.generateNormTitle(ti.title)
            ti.keyTitle = com.k_int.kbplus.utils.TextUtils.generateKeyTitle(ti.title)
            //
            // This alone should trigger before update to do the necessary...
            //
            ti.save()
          }
          else {
          }
          result.status = ti.status?.value
          result._id = "title-${ti.id}".toString();
          result.title = ti.title
          result.sortTitle = ti.sortTitle
          result.normTitle = ti.normTitle
          result.keyTitle = ti.keyTitle
          result.publisher = ti.getPublisher()?.name ?:''
          result.pubVariantNames = []
          ti.getPublisher()?.variantNames.each { vn ->
            result.pubVariantNames.add(vn.variantName);
          }
          result.dbId = ti.id
          result.visible = ['Public']
          result.rectype = 'Title'
          result.identifiers = []
          ti.ids?.each { id ->
            try{
              result.identifiers.add([type:id.identifier.ns.ns, value:id.identifier.value])
            }catch(Exception e){
              log.error(e)
            }
          }
        }
        else {
          log.warn("Title with no title string - ${ti.id}");
        }
      result
    }
    
    updateES(com.k_int.kbplus.Package.class) { pkg ->
      Map result = [:]

      result.status = pkg.packageStatus?.value
      result._id = "pkg-${pkg.id}".toString();
      result.name = pkg.name
      result.sortname = pkg.sortName
      result.tokname = result.name.replaceAll(':',' ')
      result.dbId = pkg.id
      result.visible = ['Public']
      result.rectype = 'Package'
      result.isPublic = pkg?.isPublic?.value?:'No'
      result.consortiaId = pkg.getConsortia()?.id
      result.consortiaName = pkg.getConsortia()?.name
      result.cpname = pkg.contentProvider?.name
      result.cp = [ variantNames : [] ]
      pkg.contentProvider?.variantNames.each { vn ->
        result.cp.variantNames.add(vn.variantName);
      }
      result.cpid = pkg.contentProvider?.id
      // result.titleCount = pkg.tipps.size()

      String tipp_qry = '''
select count(tipp) 
from TitleInstancePackagePlatform as tipp 
where tipp.pkg.id = :pid AND tipp.status.value <> :deleted
and ( ( :asAt >= coalesce(tipp.accessStartDate, tipp.pkg.startDate) ) and ( ( :asAt <= tipp.accessEndDate ) or ( tipp.accessEndDate is null ) ) )
'''
      result.titleCount = Package.executeQuery(tipp_qry,[pid:pkg.id, deleted:'Deleted', asAt:new Date()]).get(0);

      result.startDate = pkg.startDate?.toString()
      result.endDate = pkg.endDate?.toString()
      result.pkg_scope = pkg.packageScope?.value ?: 'Scope Undefined'
      result.identifiers = pkg.ids.collect{"${it?.identifier?.ns?.ns} : ${it?.identifier?.value}".toString() }
      result.products = pkg.products.collect{it.product?.identifier}
      def lastmod = pkg.lastUpdated ?: pkg.dateCreated
      if ( lastmod != null ) {
        result.lastModified = lastmod.toString()
      }

      if ( pkg.startDate ) {
        GregorianCalendar c = new GregorianCalendar()
        c.setTime(pkg.startDate) 
        result.startYear = "${c.get(Calendar.YEAR)}".toString()
        // result.startYearAndMonth = "${c.get(Calendar.YEAR)}-${(c.get(Calendar.MONTH))+1}".toString()
        result.startYearAndMonth = sprintf('%04d-%02d',c.get(Calendar.YEAR), c.get(Calendar.MONTH)+1);
      }

      if ( pkg.endDate ) {
        GregorianCalendar c = new GregorianCalendar()
        c.setTime(pkg.endDate) 
        result.endYear = "${c.get(Calendar.YEAR)}".toString()
        // result.endYearAndMonth = "${c.get(Calendar.YEAR)}-${(c.get(Calendar.MONTH))+1}".toString()
        result.endYearAndMonth = sprintf('%04d-%02d',c.get(Calendar.YEAR), c.get(Calendar.MONTH)+1);
      }

      result
    }

    updateES(com.k_int.kbplus.License.class) { lic ->

      Map result = null;
      
      if ( ( lic != null ) && 
           ( lic.type?.value?.equals('Template') ) ) {

        result = [:]
        result.name = lic.reference
        result.status = lic.status?.value
        result.type = lic.type?.value
        result._id = "lic-${lic.id}".toString();
        result.dbId = lic.id
        result.visible = ['Public']
        result.rectype = 'License'
        result.availableToOrgs = lic.orgLinks.find{it.roleType?.value == 'Licensee'}?.org?.id

        result.noticePeriod = lic.noticePeriod
        result.licenseUrl = lic.licenseUrl
        result.licensorRef = lic.licensorRef
        result.licenseeRef = lic.licenseeRef
        result.licenseType = lic.licenseType
        result.licenseStatus = lic.licenseStatus
        result.impId = lic.impId
        result.contact = lic.contact
        result.jiscLicenseId = lic.jiscLicenseId

        result.licenseTerms = []
        lic.customProperties.each { cp ->
          // log.debug("Add license prop : ${cp}");
          result.licenseTerms.add( [ name: cp.type.name, value: cp.getCustpropValueAsString(), note: cp.note ] )
        }
      }
      else {
        // log.debug("Skipping non template license ${lic?.id} ${lic?.type?.value}");
      }

      result
    }

    updateES(com.k_int.kbplus.Platform.class) { plat ->
      Map result = [:]
      result._id = "platform-${plat.id}".toString()
      result.status = plat.status?.value
      result.name = plat.name
      result.dbId = plat.id
      result.visible = ['Public']
      result.rectype = 'Platform'
      result
    }

    updateES(com.k_int.kbplus.Subscription.class) { sub ->
      
      Map result = null;

      // Don't send institutional subscriptions
      if ( sub.type?.value?.equals('Subscription Offered') ) {
        result = [:]
        result._id = "sub_${sub.id}".toString()
        result.name = sub.name
  
        // There really should only be one here? So think od this as SubscriptionOrg, but easier
        // to leave it as availableToOrgs I guess.
        result.status = sub.status?.value

        result.availableToOrgs = sub.orgRelations.find{it.roleType?.value == 'Subscriber' }?.org?.id
        result.identifier = sub.identifier
        result.dbId = sub.id
        result.visible = ['Public']
        result.consortiaId = sub.getConsortia()?.id
        result.consortiaName = sub.getConsortia()?.name
        result.packages = []

        if ( sub.startDate ) {
          GregorianCalendar c = new GregorianCalendar()
          c.setTime(sub.startDate) 
          result.startYear = "${c.get(Calendar.YEAR)}".toString()
          // result.startYearAndMonth = "${c.get(Calendar.YEAR)}-${(c.get(Calendar.MONTH))+1}".toString()
          result.startYearAndMonth = sprintf('%04d-%02d',c.get(Calendar.YEAR), c.get(Calendar.MONTH)+1);
        }

        sub.packages.each { sp ->
          def pgkinfo = [:]
          if ( sp.pkg != null ) {
            // Defensive - it appears that there can be a SP without a package. 
            pgkinfo.pkgname = sp.pkg.name
            pgkinfo.pkgidstr= sp.pkg.identifier
            pgkinfo.pkgid= sp.pkg.id
            pgkinfo.cpname = sp.pkg.contentProvider?.name
            pgkinfo.cpid = sp.pkg.contentProvider?.id
            result.packages.add(pgkinfo);
          }
        }

        if ( sub.subscriber ) {
          result.visible.add(sub.subscriber.shortcode)
        }

        result.subtype = sub.type?.value
        result.rectype = 'Subscription'
      }

      result
    }

    update_running = false;
    def elapsed = System.currentTimeMillis() - start_time;
    lastIndexUpdate = new Date(System.currentTimeMillis())
    log.debug("IndexUpdateJob completed in ${elapsed}ms at ${new Date()} ");

  }


  def updateSiteMapping() {

    log.debug("Updating ES site mapping...")

    SitePage.findAll().each{ site ->
      def result = [:]
      def record_id = site.id.toString()
      result.alias = site.alias
      result.action = site.action
      result.controller = site.controller
      result.rectype = site.rectype
    
      ESWrapperService.index(es_index,site.class.name,record_id,result)
    }
    log.debug("updateSiteMapping() complete");
  }



  def updateES(domain, recgen_closure) {

    // def esclient = ESWrapperService.getClient()

    def count = 0;
    try {
      log.debug("updateES - ${domain.name} + ES5.5Index");

      def latest_ft_record = FTControl.findByDomainClassNameAndActivity(domain.name,'ES5.5Index')

      log.debug("result of findByDomain: ${latest_ft_record}");
      if ( !latest_ft_record) {
        log.debug("No record found, create a new one");
        latest_ft_record=new FTControl(domainClassName:domain.name,activity:'ES5.5Index',lastTimestamp:0)
        log.debug("And save it...");
        latest_ft_record.save(flush:true, failOnError:true);
      }

      log.debug("updateES ${domain.name} since ${latest_ft_record.lastTimestamp}");
      def total = 0;
      Date from = new Date(latest_ft_record.lastTimestamp);
      // def qry = domain.findAllByLastUpdatedGreaterThan(from,[sort:'lastUpdated']);

      def results = domain.executeQuery("select o.id from ${domain.name} as o where o.lastUpdated > :ts or o.lastUpdated is null order by o.lastUpdated, o.id".toString(), [ts:from])
      log.debug("Query completed.. processing rows...");

      results.each { o_id ->

        Object r = domain.get(o_id);

        Map idx_record = recgen_closure(r)

        // A closure can now legitimately elect NOT to submit a record to the ES index. It can indicate this a number
        // of ways, but the most explicit is to return NULL from the recgen_closure.
        if ( idx_record != null ) {
          if(idx_record['_id'] == null) {
            log.error("******** Record without an ID: ${idx_record} Obj:${r} ******** ")
          }
          else {
            def record_id = idx_record['_id']
            idx_record.remove('_id');
  
            if ( idx_record?.status?.toLowerCase() == 'deleted' || idx_record?.status?.toLowerCase() == 'deprecated' ) {
              ESWrapperService.doDelete(es_index, '_doc', record_id)
            }
            else {
              ESWrapperService.doIndex(es_index, '_doc', record_id, idx_record)
            }
          
            latest_ft_record.lastTimestamp = r.lastUpdated?.getTime()
  
            count++
            total++
          }
        }
        else {
          // Not indexing - closure returned null
        }

        if ( count > 100 ) {
          count = 0;
          log.debug("processed ${++total} records (${domain.name})");
          latest_ft_record.save(flush:true, failOnError:true);
          cleanUpGorm();
        }
      }

      log.debug("Processed ${total} records for ${domain.name}");

      // update timestamp
      latest_ft_record.save(flush:true, failOnError:true);
    }
    catch ( Exception e ) {
      log.error("Problem with FT index",e);
    }
    finally {
      log.debug("Completed processing on ${domain.name} - saved ${count} records");
    }
  }

  def getReconStatus() {
    
    def result = [
      active:dataload_running,
      stage:dataload_stage,
      stats:stats
    ]

    result
  }



  def possibleNote(content, type, license, note_title) {
    if ( content && content.toString().length() > 0 ) {
      def doc_content = new Doc(content:content.toString(), 
                                title: "${type} note",
                                type: lookupOrCreateRefdataEntry('Doc Type','Note') ).save()
      def doc_context = new DocContext(license:license,
                                       domain:type,
                                       owner:doc_content,
                                       doctype:lookupOrCreateRefdataEntry('Document Type','Note')).save();
    }
  }

  def nvl(val,defval) {
    def result = defval
    if ( ( val ) && ( val.toString().trim().length() > 0 ) )
      result = val

    result
  }

  def lookupOrCreateCanonicalIdentifier(ns, value) {
    log.debug("lookupOrCreateCanonicalIdentifier(${ns},${value})");
    def namespace = IdentifierNamespace.findByNs(ns) ?: new IdentifierNamespace(ns:ns).save();
    Identifier.findByNsAndValue(namespace,value) ?: new Identifier(ns:namespace, value:value).save();
  }


  def lookupOrCreateRefdataEntry(refDataCategory, refDataCode) {
    def category = RefdataCategory.findByDesc(refDataCategory) ?: new RefdataCategory(desc:refDataCategory).save(flush:true)
    def result = RefdataValue.findByOwnerAndValue(category, refDataCode) ?: new RefdataValue(owner:category,value:refDataCode).save(flush:true)
    result;
  }

  def assertOrgTitleLink(porg, ptitle, prole) {
    // def link = OrgRole.findByTitleAndOrgAndRoleType(ptitle, porg, prole) ?: new OrgRole(title:ptitle, org:porg, roleType:prole).save();
    def link = OrgRole.find{ title==ptitle && org==porg && roleType==prole }
    if ( ! link ) {
      link = new OrgRole(title:ptitle, org:porg, roleType:prole)
      if ( !porg.links )
        porg.links = [link]
      else
        porg.links.add(link)

      porg.save();
    }
  }

  def assertOrgPackageLink(porg, ppkg, prole) {
    // def link = OrgRole.findByPkgAndOrgAndRoleType(pkg, org, role) ?: new OrgRole(pkg:pkg, org:org, roleType:role).save();
    log.debug("assertOrgPackageLink()");
    def link = OrgRole.find{ pkg==ppkg && org==porg && roleType==prole }
    if ( ! link ) {
      link = new OrgRole(pkg:ppkg, org:porg, roleType:prole);
      if ( !porg.links )
        porg.links = [link]
      else
        porg.links.add(link)
      porg.save();
    }
    log.debug("assertOrgPackageLink() complete");
  }

  def assertOrgLicenseLink(porg, plic, prole) {
    def link = OrgRole.find{ lic==plic && org==porg && roleType==prole }
    if ( ! link ) {
      link = new OrgRole(lic:plic, org:porg, roleType:prole);
      if ( !porg.links )
        porg.links = [link]
      else
        porg.links.add(link)
      porg.save();
    }

  }



  def dataCleanse() {
    log.debug("dataCleanse");

    def future = executorService.execute({
      doDataCleanse()
    } as java.lang.Runnable)
    log.debug("dataCleanse returning");
  }

  def doDataCleanse() {
    log.debug("dataCleansing");
    // 1. Find all packages that do not have a nominal platform
    Package.findAllByNominalPlatformIsNull().each { p ->
      def platforms = [:]
      p.tipps.each{ tipp ->
        if ( !platforms.keySet().contains(tipp.platform.id) ) {
          platforms[tipp.platform.id] = [count:1, platform:tipp.platform]
        }
        else {
          platforms[tipp.platform.id].count++
        }
      }

      def selected_platform = null;
      def largest = 0;
      platforms.values().each { pl ->
        log.debug("Processing ${pl}");
        if ( pl['count'] > largest ) {
          selected_platform = pl['platform']
        }
      }

      log.debug("Nominal platform is ${selected_platform} for ${p.id} - updating");
      p.refresh();
      p.nominalPlatform = selected_platform
      p.save(flush:true, failOnError:true)
    }

    // Fill out any missing sort keys on titles, packages or licenses
    def num_rows_updated = 0
    def sort_str_start_time = System.currentTimeMillis()
    def rows_updated = true

    while ( rows_updated ) {
      rows_updated = false

      log.debug("Filling out sort keys on titles");
      TitleInstance.findAllBySortTitle(null,[max:100]).each {
        log.debug("Normalise Title ${it.title}");
        it.sortTitle = it.generateSortTitle(it.title) ?: 'AAA_Error'
        if ( it.sortTitle != null ) {
          it.save(flush:true, failOnError:true)
          num_rows_updated++;
          rows_updated = true
        }
      }

      log.debug("Generate Missing Sort Package Names Rows_updated:: ${rows_updated} ${num_rows_updated}");
      Package.findAllBySortName(null,[max:100]).each {
        log.debug("Normalise Package Name ${it.name}");
        it.sortName = it.generateSortName(it.name) ?: 'AAA_Error'
        if ( it.sortName != null ) {
          it.save(flush:true, failOnError:true)
          num_rows_updated++;
          rows_updated = true
        }
      }

      log.debug("Generate Missing Sortable License References Rows_updated:: ${rows_updated} ${num_rows_updated}");
      License.findAllBySortableReference(null,[max:100]).each {
        log.debug("Normalise License Reference Name ${it.reference}");
        it.sortableReference = it.generateSortableReference(it.reference) ?: 'AAA_Error'
        if( it.sortableReference != null ) {
          it.save(flush:true, failOnError:true)
          num_rows_updated++;
          rows_updated = true
        }
      }
      
      println("Rows_updated:: ${rows_updated} ${num_rows_updated}");

      cleanUpGorm()
    }

    log.debug("Completed normalisation step... updated ${rows_updated} rows in ${System.currentTimeMillis()-sort_str_start_time}ms");

  }

  def titleAugment() {
    // edinaPublicationsAPIService.lookup('Acta Crystallographica. Section F, Structural Biology and Crystallization Communications');
    def future = executorService.submit({
      doTitleAugment()
    } as java.lang.Runnable)
    log.debug("titleAugment returning");
  }

  def doTitleAugment() {
    TitleInstance.findAll().each { ti ->
      if ( ti.getIdentifierValue('SUNCAT' ) == null ) {
        def lookupResult = edinaPublicationsAPIService.lookup(ti.title)
        if ( lookupResult ) {
          def record = lookupResult.records.record
          if ( record ) {
            boolean matched = false;
            def suncat_identifier = null;
            record.modsCollection.mods.identifier.each { id ->
              if ( id.text().equalsIgnoreCase(ti.getIdentifierValue('ISSN')) || id.text().equalsIgnoreCase(ti.getIdentifierValue('eISSN'))  ) {
                matched = true
              }

              if ( id.@type == 'suncat' ) {
                suncat_identifier = id.text();
              }
            }

            if ( matched && suncat_identifier ) {
              log.debug("set suncat identifier to ${suncat_identifier}");
              def canonical_identifier = Identifier.lookupOrCreateCanonicalIdentifier('SUNCAT',suncat_identifier);
              ti.ids.add(new IdentifierOccurrence(identifier:canonical_identifier, ti:ti));
              ti.save(flush:true);
            }
            else {
              log.debug("No match for title ${ti.title}, ${ti.id}");
            }
          }
          else {
          }
        }
        else {
        }
        synchronized(this) {
          Thread.sleep(250);
        }
      }
    }
  }

  def cleanUpGorm() {
    log.debug("Clean up GORM");
    def session = sessionFactory.currentSession
    session.flush()
    session.clear()
  }

  def clearDownAndInitES() {
    log.debug("Clear down and init ES");
  }

    def performUploadISSNL(f) {
        CSVReader r = new CSVReader( new FileReader(f), '\t' as char )
        log.debug("performUploadISSNL ${r}");
        def ctr = 0;
        def start_time = System.currentTimeMillis()
        String[] nl;
        String[] types;
        def first = true
        log.debug("Process file");
        while ((nl = r.readNext()) != null) {
            log.debug("ISSN-L Line");
            def elapsed = System.currentTimeMillis() - start_time
            def avg = 0;
            if ( ctr > 0 ) {
                avg = elapsed / 1000 / ctr
            }

            if ( nl.length == 2 ) {
                if ( first ) {
                    first = false; // Skip header
                    log.debug('Header :'+nl);
                    types=nl
                }
                else {
                    Identifier.withNewTransaction {
                        // log.debug("[seq ${ctr++} - avg=${avg}] ${types[0]}:${nl[0]} == ${types[1]}:${nl[1]}");
                        def id1 = Identifier.lookupOrCreateCanonicalIdentifier(types[0],nl[0]);
                        def id2 = Identifier.lookupOrCreateCanonicalIdentifier(types[1],nl[1]);


                        // Do either of our identifiers have a group set
                        if ( id1.ig == id2.ig ) {
                            if ( id1.ig == null ) {
                                // log.debug("Both identifiers have a group of null - so create a new group and relate them")
                                def identifier_group = new IdentifierGroup().save(flush:true);
                                id1.ig = identifier_group
                                id2.ig = identifier_group
                                id1.save(flush:true);
                                id2.save(flush:true);
                            }
                            else {
                                log.debug("Identifiers already belong to same identifier group");
                            }
                        }
                        else {
                            if ( ( id1.ig != null ) && ( id2.ig != null ) ) {
                                log.error("Conflicting identifier group for same as ${id1} ${id2}");
                            }
                            else if ( id1.ig != null ) {
                                // log.debug("Adding identifier ${id2} to same group (${id1.ig}) as ${id1}");
                                id2.ig = id1.ig
                                id2.save(flush:true);
                            }
                            else {
                                // log.debug("Adding identifier ${id1} to same group (${id1.ig}) as ${id2}");
                                id1.ig = id2.ig
                                id1.save(flush:true);
                            }
                        }
                    }
                }
            }
            else {
                log.error("uploadIssnL expected 2 values");
            }

            ctr++
        }
        log.debug("Upload ISSN-l Complete");
        return true
    }

}
