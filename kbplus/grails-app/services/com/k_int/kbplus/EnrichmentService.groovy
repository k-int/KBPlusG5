package com.k_int.kbplus

import com.k_int.kbplus.*
import com.k_int.kbplus.auth.*
import org.hibernate.ScrollMode
import java.nio.charset.Charset
import java.util.GregorianCalendar
import org.gokb.GOKbTextUtils
import groovy.text.SimpleTemplateEngine

import org.springframework.context.ApplicationContext
import org.springframework.context.ApplicationContextAware
import groovy.text.Template 
import groovy.text.SimpleTemplateEngine
import grails.converters.*

import groovy.util.logging.Slf4j

@Slf4j
class EnrichmentService implements ApplicationContextAware {

  ApplicationContext applicationContext

  def executorService
  def grailsApplication
  def mailService
  def sessionFactory

  def initiateHousekeeping() {
    log.debug("initiateHousekeeping");
    def future = executorService.submit({
      doHousekeeping()
    } as java.lang.Runnable)
    log.debug("initiateHousekeeping returning");
  }

  def doHousekeeping() {
    log.debug("Running housekeeping");
    try {
      def result = [:]
      result.possibleDuplicates = []
      result.packagesInLastWeek = []
      
      // Information about identifiers
      result.identifiers=[:]
      result.identifiers.withinNS=[:]
      
      // log.debug("housekeeping::doDuplicateTitleDetection");
      // doDuplicateTitleDetection(result)
      log.debug("housekeeping::addPackagesAddedInLastWeek");
      addPackagesAddedInLastWeek(result)

      log.debug("housekeeping::handleDuplicatesWithinNamespace");
      Identifier.withNewTransaction() { status ->
        handleDuplicatesWithinNamespace('issn', result.identifiers.withinNS) 
        handleDuplicatesWithinNamespace('eissn', result.identifiers.withinNS) 
        handleDuplicatesWithinNamespace('doi', result.identifiers.withinNS) 
        handleDuplicatesWithinNamespace('isbn', result.identifiers.withinNS) 
      }

      log.debug("Handle unlinked");
      Identifier.withNewTransaction() { status ->
        handleUnlinkedIdentifiers(result)
      }

      log.debug("Handle Titles linked to multiped IDs");
      Identifier.withNewTransaction() { status ->
        titlesLinkedToMultipleNamespacedIdentifiers(result);
      }

      log.debug("Handle Orgs linked to multiped IDs");
      Identifier.withNewTransaction() { status ->
        orgsLinkedToMultipleNamespacedIdentifiers(result);
      }

      log.debug("Handle IDs linked to multiped Items");
      Identifier.withNewTransaction() { status ->
        identifiersLinkedToMultipleItems(result);
      }

      log.debug("Handle redundant tipps");
      Identifier.withNewTransaction() { status ->
        multipleTippTest(result);
      }

      log.debug("Handle identifier family tests");
      Identifier.withNewTransaction() { status ->
        identifierFamilyTest(result)
      }

      log.debug("Duplicate Organisations");
      Identifier.withNewTransaction() { status ->
        findDuplicateOrgs(result)
      }

      sendEmail(result)
    }
    catch ( Exception e ) {
      log.error("Problem in housekeeping",e);
    }
  }

  def findDuplicateOrgs(result) {
    result.duplicateOrgs = [:]
    def duplicate_org_names = Org.executeQuery('select o.name from Org as o group by lower(o.name) having count(*) > 1');
    duplicate_org_names.each { orgname ->
      def dup_orgs = []
      def orgs = Org.executeQuery('select o from Org as o where o.name = :o',[o:orgname]);
      orgs.each { dup_org ->
        dup_orgs.add([id:dup_org.id, name:dup_org.name])
      }
      result.duplicateOrgs[orgname] = dup_orgs;
    }
    
  }

  def doDuplicateTitleDetection(result) {
    log.debug("Duplicate Title Detection");
    def initial_title_list = TitleInstance.executeQuery("select title.id, title.normTitle from TitleInstance as title order by title.id asc",[], [readOnly:true]);
    initial_title_list.each { title ->
      // Compare this title against every other title
      def inner_title_list = TitleInstance.executeQuery("select title.id, title.normTitle from TitleInstance as title where title.id > :t order by title.id asc", [t:title[0]]);
      inner_title_list.each { inner_title ->
        def similarity = GOKbTextUtils.cosineSimilarity(title[1], inner_title[1])
        if ( similarity > ( ( grailsApplication.config.cosine?.good_threshold ) ?: 0.925 ) ) {
          log.debug("Possible Duplicate:  ${title[1]} and ${inner_title[1]} : ${similarity}");
          result.possibleDuplicates.add([title[0], title[1], inner_title[0], inner_title[1],similarity]);
        }
      }
    }
  }

  def addPackagesAddedInLastWeek(result) {
    def last_week = new Date(System.currentTimeMillis() - (1000*60*60*24*7))
    def packages_in_last_week = Package.executeQuery("select p from Package as p where p.dateCreated > :d order by p.dateCreated",[d:last_week], [readOnly:true])
    packages_in_last_week.each {
      result.packagesInLastWeek.add(it);
    }
  }

  def sendEmail(result) {

    log.debug("sendEmail....");

    def rq = User.executeQuery('select u.email from User as u where u.recAdminEmails.value=:yes',[yes:'Yes']);
    log.debug("User list: ${rq}");

    def emailTemplateFile = applicationContext.getResource("WEB-INF/mail-templates/housekeeping.gsp").file
    def engine = new SimpleTemplateEngine()
    def tmpl = engine.createTemplate(emailTemplateFile).make(result)
    def content = tmpl.toString()

    if ( rq.size() > 0 ) {
      log.debug("Sending emails to ${rq.toArray()}");
      try {
        mailService.sendMail {
          // to grailsApplication.config.housekeeping.recipients.toArray()
          to rq.toArray()
          from 'GlobalOpenKB@gmail.com'
          subject "${grailsApplication.config.housekeeping.subject} - ${new Date()}"
          html content
        }
      }
      catch ( Exception e ) {
        log.warn("Problem sending email",e);
      }
    }
    else {
      log.warn("No users located with u.recAdminEmails.value=yes");
    }

    log.debug("Send email complete");
  }

  def initiateCoreMigration() {
    log.debug("initiateCoreMigration");
    def future = executorService.submit({
      log.debug("Submit job....");
      doCoreMigration()
    } as java.lang.Runnable )
    log.debug("initiateCoreMigration returning");
  }

  def doCoreMigration() {
    log.debug("Running core migration....");
    try {
      def ie_ids_count = IssueEntitlement.executeQuery('select count(ie.id) from IssueEntitlement as ie')[0];
      def ie_ids = IssueEntitlement.executeQuery('select ie.id from IssueEntitlement as ie');
      def start_time = System.currentTimeMillis();
      int counter=0

      ie_ids.each { ieid ->

        IssueEntitlement.withNewTransaction {

          log.debug("Get ie ${ieid}");

          def ie = IssueEntitlement.get(ieid);

          if ( ( ie != null ) && ( ie.subscription != null ) && ( ie.tipp != null ) ) {

            def elapsed = System.currentTimeMillis() - start_time
            def avg = counter > 0 ? ( elapsed / counter ) : 0
            log.debug("Processing ie_id ${ieid} ${counter++}/${ie_ids_count} - ${elapsed}ms elapsed avg=${avg}");
            def inst = ie.subscription.getSubscriber()
            def title = ie.tipp.title
            def provider = ie.tipp.pkg.getContentProvider()
    
            if ( inst && title && provider ) {
              def tiinp = TitleInstitutionProvider.findByTitleAndInstitutionAndprovider(title, inst, provider)
              if ( tiinp == null ) {
                log.debug("Creating new TitleInstitutionProvider");
                tiinp = new TitleInstitutionProvider(title:title, institution:inst, provider:provider).save(flush:true, failOnError:true)
              }
        
              log.debug("Got tiinp:: ${tiinp}");
              if ( ie.coreStatusStart != null ) {
                tiinp.extendCoreExtent(ie.coreStatusStart, ie.coreStatusEnd );
              }
              else {
                log.debug("No core start date - skip");
              }
            }
            else {
              log.error("Missing title(${title}), provider(${provider}) or institution(${inst})");
            }
          }
          else {
            log.error("IE ${ieid} is null, has no subscription or tipp.");
          }
        }

        if ( counter % 5000 == 0 ) {
          log.debug("Clean up gorm");
          cleanUpGorm();
        }

      }
    }
    catch ( Exception e ) {
      log.error("Problem",e);
    }
  }

  def handleDuplicatesWithinNamespace(ns, result) {

    log.debug("handleDuplicatesWithinNamespace(${ns},result)");

    def q = Identifier.executeQuery('select i.value from Identifier as i where i.ns.ns = :ns group by i.value having count(i.value) > 1',[ns:ns], [readOnly:true])
    result[ns] = [:]
    result[ns].message = "Found ${q.size} identifiers in ${ns} namespace where the identifier was duplicated in that namespace."
    log.debug(result[ns].message )

    result[ns].details = []
    q.each { idval ->
      def detail_record = [:]
      detail_record.identifier_value = "${ns}:${idval}"
      detail_record.duplicates = []

      def d = Identifier.executeQuery('select i from Identifier as i where i.ns.ns = :ns and i.value = :v order by i.id',[ns:ns, v:idval],[readOnly:true])

      def first_id = null
      d.each { id ->
         if ( first_id == null ) {
           first_id = id
           detail_record.first = id
         }
         else {
           detail_record.duplicates.add(id);
           Identifier.executeUpdate("update IdentifierOccurrence set identifier=:main where identifier = :duplicate",[main:first_id,duplicate:id]);
         }

      }

      detail_record.titles = TitleInstance.executeQuery('select ti from TitleInstance as ti join ti.ids as ids where ids.identifier = :id',[id:first_id],[readOnly:true])

      result[ns].details.add(detail_record);
    }
  }

  def handleUnlinkedIdentifiers(result) {
    def q = Identifier.executeQuery('select i from Identifier as i where not exists ( select io from IdentifierOccurrence as io where io.identifier = i )',[],[readOnly:true]);
    result.floatingIdentifiers = []
    q.each { id ->
      result.floatingIdentifiers.add(id)
      id.delete(flush:true, failOnError:true);
    }
  }

  def titlesLinkedToMultipleNamespacedIdentifiers(result) {
    log.debug("Finding all titles with multiple identifiers in a single namespace");
    def q = TitleInstance.executeQuery('select ti, ids.identifier.ns, count(*) from TitleInstance as ti join ti.ids as ids group by ti, ids.identifier.ns having count(*) > 1',[],[readOnly:true])
    result.titlesWithMultipleIdsInSingleNS = []
    q.each { row ->
      result.titlesWithMultipleIdsInSingleNS.add(row);
    }
    log.debug("Done");
  }

  def orgsLinkedToMultipleNamespacedIdentifiers(result) {
    log.debug("Finding all orgs with multiple identifiers in a single namespace");
    def q = TitleInstance.executeQuery('select org, ids.identifier.ns, count(*) from Org as org join org.ids as ids group by org, ids.identifier.ns having count(*) > 1',[],[readOnly:true])
    result.orgsWithMultipleIdsInSingleNS = []
    q.each { row ->
      result.orgsWithMultipleIdsInSingleNS.add(row);
    }
    log.debug("Done");
  }

  def identifiersLinkedToMultipleItems(result) {
    def ids = IdentifierOccurrence.executeQuery('select io.identifier, count(*) from IdentifierOccurrence as io group by io.identifier having count(*) > 1',[],[readOnly:true])
    result.identifiersLinkedToMultipleItems = []
    ids.each {
      result.identifiersLinkedToMultipleItems.add(it);
    }
  }

  def multipleTippTest(result) {
    def deleted_tipp_status = RefdataCategory.lookupOrCreate(RefdataCategory.TIPP_STATUS, "Deleted")
    def tipps = TitleInstancePackagePlatform.executeQuery('select tipp.title, tipp.pkg, tipp.platform, count(*) from TitleInstancePackagePlatform as tipp left outer join tipp.status as status where ( status is null OR status <> :delstatus ) group by tipp.title, tipp.pkg, tipp.platform having count(*) > 1 order by tipp.pkg',[delstatus:deleted_tipp_status],[readOnly:true])
    result.multipleTipps = []
    tipps.each {
      result.multipleTipps.add(it)
    }
  }

  def identifierFamilyTest(result) {
    def ids = Identifier.executeQuery('select id.value, count(*) from Identifier as id where id.ns.ns in :idlist group by id.value having count(*) > 1',[idlist:['issn','isbn','eissn','issnl','eisbn','issn-l']],[readOnly:true])
    result.isxnFamilyDuplicates=[]
    ids.each {
      result.isxnFamilyDuplicates.add(it)
    }
  }

  def cleanUpGorm() {
    log.debug("Clean up GORM");
    def session = sessionFactory.currentSession
    session.flush()
    session.clear()
  }

}
