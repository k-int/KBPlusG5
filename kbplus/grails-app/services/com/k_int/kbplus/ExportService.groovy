package com.k_int.kbplus

import java.io.File;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.OutputKeys
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import groovy.util.logging.Slf4j

/**
 * This service should contain the methods required to build the different exported files.
 * CSV methods will stream out the content of the file to a given output.
 * XML methods are provided to build the XML document
 * JSON methods build a Map object which can then be converted into Json.
 * 
 * @author wpetit
 */

@Slf4j
class ExportService {
  // def formatter = new java.text.SimpleDateFormat("yyyy-MM-dd")

  public SimpleDateFormat getDateFormatter() {
    return new java.text.SimpleDateFormat("yyyy-MM-dd");
  }
  
  /* *************
   *  CSV Exports 
   */

    def HQLCoreDates = "SELECT ca.startDate, ca.endDate FROM TitleInstitutionProvider as tip join tip.coreDates as ca WHERE tip.title.id= :ie_title AND tip.institution.id= :ie_institution AND tip.provider.id= :ie_provider"

  def StreamOutLicenceCSV(out,result,licences){
    log.debug("StreamOutLicenceCSV - ${result} - ${licences}")
    Set propertiesSet = new TreeSet();

    def custProps = licences.each{ licence ->
      propertiesSet.addAll(licence.customProperties.collect{ prop ->
        prop.type.name
      })
    }
    
    out.withWriter{writer ->
      //See if we are handling a currentLicences Search
      if(result != null && result.searchHeader ){
        writer.write("SEARCH TERMS\n")
        writer.write("Institution,ValidOn,ReferenceSearch,LicenceProperty,LicencePropertyValue\n")
        writer.write("${val(result.institution?.name)},${val(result.validOn)},${val(result.keyWord)},${val(result.propertyFilterType)},${val(result.propertyFilter)}\n" )
        writer.write("\n")  
      }
      writer.write("KB+ Licence ID, LicenceReference,NoticePeriod,LicenceURL,LicensorRef, LicenseeRef, StartDate, EndDate, Licence Category,Licence Status")
      propertiesSet.each{
        writer.write(",${val(it)}")
        writer.write(",\"${it} Notes\"")
      }
      writer.write("\n")
      licences.each{ lic ->
        writer.write("${lic.id},${val(lic.reference)},${val(lic.noticePeriod)},${val(lic.licenseUrl)},${val(lic.licensorRef)},${val(lic.licenseeRef)},${val(lic.startDate)},${val(lic.endDate)},${val(lic.licenseCategory?.value)},${val(lic.status?.value)}")
 
        propertiesSet.each{ prop_name ->
          def prop_match = lic.customProperties.find{it.type.name == prop_name}
          if(prop_match){
            writer.write(",${val(prop_match.value)},${val(prop_match.note)}")
          }else{
            writer.write(", , ")
          }
        }

        writer.write("\n")
      }
      
      writer.flush()
      writer.close()
    }
  }

  def addLicenceSubPkgXML(Document doc, Element into_elem, List licences){
    log.debug("addLicenceSubPkgXML - ${licences}")

    licences.each() { licence ->
      def licElem = addXMLElementInto(doc, into_elem, "Licence", null)
      addXMLElementInto(doc, licElem, "LicenceReference", licence.reference)
      addXMLElementInto(doc, licElem, "LicenceID", licence.id)

      def licSubs =  addXMLElementInto(doc, licElem, "Subscriptions", null)
      licence.subscriptions.each{ subscription ->
        def licSub = addXMLElementInto(doc, licSubs, "Subscription", null)

        addXMLElementInto(doc, licSub, "SubscriptionID", subscription.id)
        addXMLElementInto(doc, licSub, "SubscriptionName", subscription.name)
        addXMLElementInto(doc, licSub, "SubTermStartDate", formatDate(subscription.startDate))
        addXMLElementInto(doc, licSub, "SubTermEndDate", formatDate(subscription.endDate))
        addXMLElementInto(doc, licSub, "ManualRenewalDate", formatDate(subscription.manualRenewalDate))

        def subPkgs = addXMLElementInto(doc, licSub, "Packages", null)
        subscription.packages.each{ subPkg ->
          def pkg = subPkg.pkg
          def pkgElem = addXMLElementInto(doc, subPkgs, "Package", null)
          addXMLElementInto(doc, pkgElem, "PackageID", pkg.id)
          addXMLElementInto(doc, pkgElem, "PackageName", pkg.name)
          addXMLElementInto(doc, pkgElem, "PackageContentProvider", pkg.getContentProvider()?.name)
        }
      }
    }
  }

  def addLicenceSubPkgTitleXML(Document doc, Element into_elem, List licences){
    log.debug("addLicenceSubPkgXML - ${licences}")

    licences.each() { licence ->
      def licElem = addXMLElementInto(doc, into_elem, "Licence", null)
      addXMLElementInto(doc, licElem, "LicenceReference", licence.reference)
      addXMLElementInto(doc, licElem, "LicenceID", licence.id)

      def licSubs =  addXMLElementInto(doc, licElem, "Subscriptions", null)
      licence.subscriptions.each{ subscription ->
        def licSub = addXMLElementInto(doc, licSubs, "Subscription", null)

        addXMLElementInto(doc, licSub, "SubscriptionID", subscription.id)
        addXMLElementInto(doc, licSub, "SubscriptionName", subscription.name)
        addXMLElementInto(doc, licSub, "SubTermStartDate", formatDate(subscription.startDate))
        addXMLElementInto(doc, licSub, "SubTermEndDate", formatDate(subscription.endDate))
        addXMLElementInto(doc, licSub, "ManualRenewalDate", formatDate(subscription.manualRenewalDate))

        def ieList = addXMLElementInto(doc, licSub, "TitleList", null)
        subscription.issueEntitlements.each{ ie ->
          def issue = addXMLElementInto(doc, ieList, "TitleListEntry", null)
          addXMLElementInto(doc, issue, "Title", ie.tipp.title.title)
          addXMLElementInto(doc, issue, "InternalTitleId", ie.tipp.title.id)
          def title_ids = addXMLElementInto(doc, issue, "TitleIDs", null)
          def ie_issn = addXMLElementInto(doc, title_ids, "ID", ie.tipp.title.getIdentifierValue("issn"))
          addXMLAttr(doc,ie_issn,"namespace","issn")
          def ie_eissn = addXMLElementInto(doc, title_ids, "ID", ie.tipp.title.getIdentifierValue("eissn"))
          addXMLAttr(doc,ie_eissn,"namespace","eissn")

          addXMLElementInto(doc, issue, "PackageName", ie.tipp.pkg.name)
          addXMLElementInto(doc, issue, "PackageID", ie.tipp.pkg.id)

          def ie_coverage = addXMLElementInto(doc,issue,"CoverageStatement",null)
          addXMLAttr(doc, ie_coverage, "type", "Issue Entitlement")
          addXMLElementInto(doc, ie_coverage, "SubscriptionID", subscription.id)
          addXMLElementInto(doc, ie_coverage, "SubscriptionName", subscription.name)

          addXMLElementInto(doc, ie_coverage, "StartDate", formatDate(ie.coreStatusStart))
          addXMLElementInto(doc, ie_coverage, "EndDate", formatDate(ie.coreStatusEnd))
          addXMLElementInto(doc, ie_coverage, "StartVolume", ie.startVolume)
          addXMLElementInto(doc, ie_coverage, "EndVolume", ie.endVolume)
          addXMLElementInto(doc, ie_coverage, "StartIssue", ie.startIssue)
          addXMLElementInto(doc, ie_coverage, "EndIssue", ie.endIssue)
          addXMLElementInto(doc, ie_coverage, "CoverageNote", ie.coverageNote)

        }
      }
    }
  }
  def StreamOutSubsCSV(out, sub, entitlements, header){
    def jc_id = sub.getSubscriber()?.getIdentifierByType('JC')?.value
    out.withWriter { writer ->
      def tsdate = formatDate(sub.startDate)?:' '
      def tedate = formatDate(sub.endDate)?:' '
      if ( header ) {
        writer.write("FileType,SpecVersion,JC_ID,TermStartDate,TermEndDate,SubURI,SystemIdentifier\n")
        writer.write("${sub.type?.value?:''},\"2.0\",${jc_id?:''},${tsdate},${tedate},\"uri://kbplus/sub/${sub.identifier}\",${sub.impId}\n")
      }
   
      // Output the body text
      // writer.write("publication_title,print_identifier,online_identifier,date_first_issue_subscribed,num_first_vol_subscribed,num_first_issue_subscribed,date_last_issue_subscribed,num_last_vol_subscribed,num_last_issue_subscribed,embargo_info,title_url,first_author,title_id,coverage_note,coverage_depth,publisher_name\n");
      writer.write("publication_title,print_identifier,online_identifier,date_first_issue_online,num_first_vol_online,num_first_issue_online,date_last_issue_online,num_last_vol_online,num_last_issue_online,title_url,first_author,title_id,embargo_info,coverage_depth,coverage_notes,publisher_name\n");
   
      entitlements.each { e ->
   
        def start_date = e.startDate ? getDateFormatter(e.startDate) : '';
        def end_date = e.endDate ? getDateFormatter(e.endDate) : '';
        def title_doi = (e.tipp?.title?.getIdentifierValue('DOI'))?:''
        def publisher = e.tipp?.title?.publisher
   
        writer.write("\"${e.tipp.title.title}\",\"${e.tipp?.title?.getIdentifierValue('ISSN')?:''}\",\"${e.tipp?.title?.getIdentifierValue('eISSN')?:''}\",${start_date},${e.startVolume?:''},${e.startIssue?:''},${end_date},${e.endVolume?:''},${e.endIssue?:''},\"${e.tipp?.hostPlatformURL?:''}\",,\"${title_doi}\",\"${e.embargo?:''}\",\"${e.tipp?.coverageDepth?:''}\",\"${e.tipp?.coverageNote?:''}\",\"${publisher?.name?:''}\"\n");
      }
      writer.flush()
      writer.close()
    }
  }
  
  /**
   * This function will stream out the list of titles in a CSV format.
   * 
   * @param out - the {@link #java.io.OutputStream OutputStream}
   * @param entitlements - the list of {@link #com.k_int.kbplus.IssueEntitlement IssueEntitlement}
   */
  def StreamOutTitlesCSV(out, entitlements){
     def starttime = printStart("Get Namespaces and max IE")
    // Get distinct ID.Namespace and the maximum of entitlements for one title

    def namespaces = []
    def current_title_id = -1
    def current_nb_ie = 0
    def max_nb_ie = 1
    entitlements.each(){ ie ->
      def ti = ie.tipp.title
      if(ti.id != current_title_id){
        current_title_id = ti.id
        if(max_nb_ie<current_nb_ie) max_nb_ie = current_nb_ie
        current_nb_ie = 1
        //Add namespace
        ti.ids.each(){ id -> namespaces.add(id.identifier.ns.ns) }
      }else{
        current_nb_ie ++
      }
    }
    namespaces.unique()
    printDuration(starttime, "Get Namespaces and max IE=${max_nb_ie}")
    
    out.withWriter { writer ->
      // Output the header
      writer.write("Title,")
      namespaces.each(){ ns -> writer.write("${ns},") }
      writer.write("Earliest date,Latest date")
      (1..max_nb_ie).each(){
        writer.write(",IE.${it}.Subscription name,")
        writer.write("IE.${it}.Start date,")
        writer.write("IE.${it}.Start Volume,")
        writer.write("IE.${it}.Start Issue,")
        writer.write("IE.${it}.End date,")
        writer.write("IE.${it}.End Volume,")
        writer.write("IE.${it}.End Issue,")
        writer.write("IE.${it}.Embargo,")
        writer.write("IE.${it}.Coverage,")
        writer.write("IE.${it}.Coverage note,")
        writer.write("IE.${it}.platform.host.name,")
        writer.write("IE.${it}.platform.host.url,")
        writer.write("IE.${it}.platform.admin.name,")
        writer.write("IE.${it}.Core date list,")
        writer.write("IE.${it}.Core medium")
      }
      writer.write("\n")

      // result.titles.each { title ->
      // def ti = title[0]
      current_title_id = -1
      String entitlements_str
      def earliest_date
      def latest_date
      entitlements.each { e ->
        if(e.tipp.title.id != current_title_id){
          if(current_title_id != -1){
            //Write earliest and latest dates
            writer.write("\"${earliest_date?getDateFormatter(earliest_date):''}\",");
            writer.write("\"${latest_date?getDateFormatter(latest_date):''}\"");
            //Write entitlements
            writer.write("${entitlements_str}");
            writer.write("\n");
          }
          
          //Start a new title
          current_title_id = e.tipp.title.id
          def ti = e.tipp.title
          entitlements_str = ""
          
          writer.write("\"${ti.title}\",");
          namespaces.each(){ ns ->
            writer.write("\"${ti.getIdentifierValue(ns)?:''}\",");
          }
          earliest_date = e.startDate?:null
          latest_date = e.endDate?:null
        }
        
        if(e.startDate && (!earliest_date || earliest_date>e.startDate)) earliest_date = e.startDate
        if(e.endDate && (!latest_date || latest_date<e.endDate)) latest_date = e.endDate
        
//                    grouped_ies[ti[0].id].each(){ ie ->
        entitlements_str += ",\"${e.subscription.name}\","
        entitlements_str += "${e.startDate?getDateFormatter(e.startDate):''},"
        entitlements_str += "\"${e.startVolume?:''}\","
        entitlements_str += "\"${e.startIssue?:''}\","
        entitlements_str += "${e.endDate?getDateFormatter(e.endDate):''},"
        entitlements_str += "\"${e.endVolume?:''}\","
        entitlements_str += "\"${e.endIssue?:''}\","
        entitlements_str += "\"${e.embargo?:''}\","
        entitlements_str += "\"${e.coverageDepth?:''}\","
        entitlements_str += "\"${e.coverageNote?:''}\","
        entitlements_str += "\"${e.tipp?.platform?.name?:''}\","
        entitlements_str += "\"${e.tipp?.combinedPlatformUrl?:''}\","
        entitlements_str += "\""
        e.tipp?.additionalPlatforms.eachWithIndex(){ ap, i ->
          if(i>0) entitlements_str += ", "
          entitlements_str += "${ap.platform.name}"
        }
        entitlements_str += "\","
        def coreDateList = ""
        for(Date[] coreDate : getIECoreDates(e)){
          coreDateList += formatCoreDates(coreDate) + " - "
        }
        entitlements_str += "\"${coreDateList}\","
        entitlements_str += "\"${e.coreStatus?:''}\""
//                    }
      }
      
      //Write earliest and latest dates for last title
      writer.write("\"${earliest_date?getDateFormatter(earliest_date):''}\",");
      writer.write("\"${latest_date?getDateFormatter(latest_date):''}\"");
      //Write entitlements for last title
      writer.write("${entitlements_str}");
      writer.write("\n");
      
      printDuration(starttime, "Finished Export.Closing")

      writer.flush()
      writer.close()
    }
  }
  
  /**
   * This function will stream out the list of core titles in a CSV format.
   *
   * @param out - the {@link #java.io.OutputStream OutputStream}
   * @param entitlements - the list of {@link #com.k_int.kbplus.TitleInstitutionProvider TitleInstitutionProvider}
   */
  def StreamOutCoreTitlesCSV(out, tips){
	 def starttime = printStart("Get Namespaces and max tip")
	// Get distinct ID.Namespace and the maximum of tips for one title

	def namespaces = []
	def current_title_id = -1
	def current_nb_tip = 0
	def max_nb_tip = 1
	tips.each(){ tip ->
	  def ti = tip.title
	  if(ti.id != current_title_id){
		current_title_id = ti.id
		if(max_nb_tip<current_nb_tip) max_nb_tip = current_nb_tip
		current_nb_tip = 1
		//Add namespace
		ti.ids.each(){ id -> namespaces.add(id.identifier.ns.ns) }
	  }else{
		current_nb_tip ++
	  }
	}
	namespaces.unique()
	printDuration(starttime, "Get Namespaces and max tip=${max_nb_tip}")
	
	out.withWriter { writer ->
	  // Output the header
	  writer.write("Title")
	  namespaces.each(){ ns -> writer.write(",${ns}") }
	  (1..max_nb_tip).each(){
		writer.write(",tip.${it}.Provider name,")
		writer.write("tip.${it}.Core date list,")
		writer.write("tip.${it}.Core Status")
	  }
	  writer.write("\n")

	  current_title_id = -1
	  String tips_str
	  tips.each { t ->
		if(t.title.id != current_title_id){
		  if(current_title_id != -1){
			//Write tips
			writer.write("${tips_str}");
			writer.write("\n");
		  }
		  
		  //Start a new title
		  current_title_id = t.title.id
		  def ti = t.title
		  tips_str = ""
		  
		  writer.write("\"${ti.title}\"");
		  namespaces.each(){ ns ->
			writer.write(",\"${ti.getIdentifierValue(ns)?:''}\"");
		  }
		}
		
		tips_str += ",\"${t.provider?.name?:''}\","
		tips_str += "\"${t.coreDates}\","
		
		def cs = t.coreStatus(null)?'Core':t.coreStatus(null)==null?'Not Core':'Was/Will Be Core';
		
		tips_str += "\"${cs}\""
	  }
	  
	  //Write tips for last title
	  writer.write("${tips_str}");
	  writer.write("\n");
	  
	  printDuration(starttime, "Finished Export.Closing")

	  writer.flush()
	  writer.close()
	}
  }
  
  /* ************
   * XML Exports
   */
  
  /**
   * Create the document and with the root Element of the XML file
   * 
   * @param root - the name of the root {@link #org.w3c.dom.Element Element}
   * @return the {@link #org.w3c.dom.Document Document} created
   */
  def buildDocXML(root) {
    DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
    DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
 
    // root elements
    Document doc = docBuilder.newDocument();
    Element rootElement = doc.createElement(root);
    doc.appendChild(rootElement);
    
    return doc
  }
  def getIECoreDates(ie){
//    def coreDates = TitleInstitutionProvider.executeQuery(hqlCoreDates,[ie:ie,cp_role:role_cprov,sub_role:role_subscriber])
    def inst = ie.subscription?.getSubscriber()
    def title = ie.tipp?.title
    def provider = ie.tipp?.pkg?.getContentProvider()
    
    def coreDates = null
    
    if (inst && title && provider) {
      coreDates = TitleInstitutionProvider.executeQuery(HQLCoreDates,[ie_title: title.id, ie_institution: inst.id, ie_provider: provider.id])
    }
    return coreDates
  }
  def formatCoreDates(dates){
      return "${dates[0]?getDateFormatter(dates[0]):''} : ${dates[1]?getDateFormatter(dates[1]):''}"
  }
  /**
   * Add a list of titles from a given entitlement list into a given Element
   * 
   * @param doc - the {@link #org.w3c.dom.Document Document}
   * @param into_elem - the {@link #org.w3c.dom.Element Element} into which we want to insert the list of titles
   * @param entries - the list of {@link com.k_int.kbplus.IssueEntitlement} or {@link com.k_int.kbplus.TitleInstancePackagePlatform}
   * @param type -  either "TIPP" or default "Issue Entitlement"
   */
    def addTitleListXML(Document doc, Element into_elem, List entries, String type = "Issue Entitlement") {
    def current_title_id = -1
    def starttime = printStart("Add TitleListXML")

    Element titlelistentry
    entries.each { e ->
      // There is a few distinction between TIPP and IE objects, they are handled here
      def tipp = (type=="Issue Entitlement")?e.tipp:e
      def sub  = (type=="Issue Entitlement")?e.subscription:e.sub
      def status  = (type=="Issue Entitlement")?e.coreStatus:e.status
      def statusColumnHeader = (type == "Issue Entitlement") ? "CoreMedium" : "TIPPStatus"
      
      if(tipp.title.id != current_title_id){
        current_title_id = tipp.title.id
        def ti = tipp.title
        
        // TitleListEntry elements
        titlelistentry = addXMLElementInto(doc, into_elem, "TitleListEntry", null)
        // Title elements
        Element title = addXMLElementInto(doc, titlelistentry, "Title", ti.title)
                                addXMLElementInto(doc, titlelistentry, "titleId", ti.id)
                                addXMLElementInto(doc, titlelistentry, "publicationType", ti.publicationType)
                                addXMLElementInto(doc, titlelistentry, "dateMonographPublishedPrint", ti.dateMonographPublishedPrint)
                                addXMLElementInto(doc, titlelistentry, "dateMonographPublishedOnline", ti.dateMonographPublishedOnline)
                                addXMLElementInto(doc, titlelistentry, "monographVolume", ti.monographVolume)
                                addXMLElementInto(doc, titlelistentry, "monographEdition", ti. monographEdition)
                                addXMLElementInto(doc, titlelistentry, "firstAuthor", ti.firstAuthor)
                                addXMLElementInto(doc, titlelistentry, "firstEditor", ti.firstEditor)
                                if ( ti.parentTitle ) {
                                  addXMLElementInto(doc, titlelistentry, "parentPublicationTitleId", ti.parentTitle.id)
                                }

                                // addXMLElementInto(doc, titlelistentry, "precedingPublicationTitleId", ti.precedingPublicationTitleId);

        // TitleIDs elements
        Element titleids = addXMLElementInto(doc, titlelistentry, "TitleIDs", null)
        
        ti.ids.each(){ id ->
          def value = id.identifier.value
          def ns = id.identifier.ns.ns
          Element titleid = addXMLElementInto(doc, titleids, "ID", value)
          // set attribute to titleid element
          addXMLAttr(doc, titleid, "namespace", ns)
        }
      }


      
      // CoverageStatement elements
      Element coveragestatement = addXMLElementInto(doc, titlelistentry, "CoverageStatement", null)
      addXMLAttr(doc, coveragestatement, "type", type)
      
      addXMLElementInto(doc, coveragestatement, "SubscriptionID", sub?.id?:'')
      addXMLElementInto(doc, coveragestatement, "SubscriptionName", sub?.name?:'')
      addXMLElementInto(doc, coveragestatement, "StartDate", e.startDate?getDateFormatter(e.startDate):'')
      addXMLElementInto(doc, coveragestatement, "StartVolume", e.startVolume?:'')
      addXMLElementInto(doc, coveragestatement, "StartIssue", e.startIssue?:'')
      addXMLElementInto(doc, coveragestatement, "EndDate", e.endDate?getDateFormatter(e.endDate):'')
      addXMLElementInto(doc, coveragestatement, "EndVolume", e.endVolume?:'')
      addXMLElementInto(doc, coveragestatement, "EndIssue", e.endIssue?:'')
      addXMLElementInto(doc, coveragestatement, "Embargo", e.embargo?:'')
      addXMLElementInto(doc, coveragestatement, "Coverage", e.coverageDepth?:'')
      addXMLElementInto(doc, coveragestatement, "CoverageNote", e.coverageNote?:'')
      addXMLElementInto(doc, coveragestatement, "HostPlatformName", tipp?.platform?.name?:'')
      addXMLElementInto(doc, coveragestatement, "HybridOA", tipp?.hybridOA?.value?:'')
      addXMLElementInto(doc, coveragestatement, "DelayedOA", tipp?.delayedOA?.value?:'')
      addXMLElementInto(doc, coveragestatement, "Payment", tipp?.payment?.value?:'')
      addXMLElementInto(doc, coveragestatement, "HostPlatformURL", tipp?.combinedPlatformUrl?:'')
      
      tipp.additionalPlatforms.each(){ ap ->
        def platform = addXMLElementInto(doc, coveragestatement, "Platform", null)
        addXMLElementInto(doc, platform, "PlatformName", ap.platform?.name?:'')
        addXMLElementInto(doc, platform, "PlatformRole", ap.rel?:'')
        addXMLElementInto(doc, platform, "PlatformURL", ap.platform?.primaryUrl?:'')
      }
      
      addXMLElementInto(doc, coveragestatement, statusColumnHeader, status?.value?:'')
      if(type == "Issue Entitlement"){
        Element coreDateList = addXMLElementInto(doc,coveragestatement,"CoreDateList",null)
        getIECoreDates(e)?.each{
          Element coreDate = addXMLElementInto(doc,coreDateList,"CoreDate",null)
          addXMLElementInto(doc,coreDate,"CoreStart",it[0]?getDateFormatter(it[0]):'')
          if(it[1]){
            addXMLElementInto(doc,coreDate,"CoreEnd",it[1]?getDateFormatter(it[1]):'')
          }
        }
      }
      addXMLElementInto(doc, coveragestatement, "PackageID", tipp?.pkg?.id?:'')
      addXMLElementInto(doc, coveragestatement, "PackageName", tipp?.pkg?.name?:'')
            addXMLElementInto(doc, coveragestatement, "AccessStatus", tipp?.getAvailabilityStatusAsString()?:'')
            addXMLElementInto(doc, coveragestatement, "AccessFrom",  tipp?.accessStartDate?:'')
            addXMLElementInto(doc, coveragestatement, "AccessTo", tipp?.accessEndDate?:'')
        }

    printDuration(starttime, "Add TitleListXML")
    }
	
	/**
	 * Add a list of titles from a given core titles list into a given Element
	 *
	 * @param doc - the {@link #org.w3c.dom.Document Document}
	 * @param into_elem - the {@link #org.w3c.dom.Element Element} into which we want to insert the list of titles
	 * @param entries - the list of {@link com.k_int.kbplus.TitleInstitutionProvider}
	 */
	def addCoreTitleListXML(Document doc, Element into_elem, List entries) {
	  def current_title_id = -1
	  def starttime = printStart("Add CoreTitleListXML")
  
	  Element titlelistentry
	  entries.each { e ->
		def cs = e.coreStatus(null)?'Core':e.coreStatus(null)==null?'Not Core':'Was/Will Be Core';
		
		if(e.title.id != current_title_id){
		  current_title_id = e.title.id
		  def ti = e.title
		  
		  // TitleListEntry elements
		  titlelistentry = addXMLElementInto(doc, into_elem, "TitleListEntry", null)
		  // Title elements
		  Element title = addXMLElementInto(doc, titlelistentry, "Title", ti.title)
								  addXMLElementInto(doc, titlelistentry, "titleId", ti.id)
								  addXMLElementInto(doc, titlelistentry, "publicationType", ti.publicationType)
								  addXMLElementInto(doc, titlelistentry, "dateMonographPublishedPrint", ti.dateMonographPublishedPrint)
								  addXMLElementInto(doc, titlelistentry, "dateMonographPublishedOnline", ti.dateMonographPublishedOnline)
								  addXMLElementInto(doc, titlelistentry, "monographVolume", ti.monographVolume)
								  addXMLElementInto(doc, titlelistentry, "monographEdition", ti. monographEdition)
								  addXMLElementInto(doc, titlelistentry, "firstAuthor", ti.firstAuthor)
								  addXMLElementInto(doc, titlelistentry, "firstEditor", ti.firstEditor)
								  if ( ti.parentTitle ) {
									addXMLElementInto(doc, titlelistentry, "parentPublicationTitleId", ti.parentTitle.id)
								  }
  
								  // addXMLElementInto(doc, titlelistentry, "precedingPublicationTitleId", ti.precedingPublicationTitleId);
  
		  // TitleIDs elements
		  Element titleids = addXMLElementInto(doc, titlelistentry, "TitleIDs", null)
		  
		  ti.ids.each(){ id ->
			def value = id.identifier.value
			def ns = id.identifier.ns.ns
			Element titleid = addXMLElementInto(doc, titleids, "ID", value)
			// set attribute to titleid element
			addXMLAttr(doc, titleid, "namespace", ns)
		  }
		}
		
		// CoverageStatement elements
		Element coveragestatement = addXMLElementInto(doc, titlelistentry, "CoverageStatement", null)
		
		addXMLElementInto(doc, coveragestatement, "ProviderID", e.provider?.id?:'')
		addXMLElementInto(doc, coveragestatement, "ProviderName", e.provider?.name?:'')
		
		Element coreDateList = addXMLElementInto(doc,coveragestatement,"CoreDateList",null)
		e.coreDates.each {
			addXMLElementInto(doc,coreDateList,"CoreDate",it?it:'')
		}
		
		addXMLElementInto(doc, coveragestatement, "CoreStatus", cs)
		}
  
	  printDuration(starttime, "Add TitleListXML")
	}
  
  /**
   * Add the licences of a given list into a given XML element.
   * 
   * @param doc - the {@link #org.w3c.dom.Document Document} to update
   * @param into_elem - the {@link #org.w3c.dom.Element Element} we want to put the list of licence(s) in.
   * @param lics - the {@link com.k_int.kbplus.License} list
   */
  def addLicencesIntoXML(Document doc, Element into_elem, List lics) {
    lics.each() { licence ->
      def licElem = addXMLElementInto(doc, into_elem, "Licence", null)
      addXMLElementInto(doc, licElem, "LicenceReference", licence.reference)
      addXMLElementInto(doc, licElem, "NoticePeriod", licence.noticePeriod)
      addXMLElementInto(doc, licElem, "LicenceURL", licence.licenseUrl)
      addXMLElementInto(doc, licElem, "LicensorRef", licence.licensorRef)
      addXMLElementInto(doc, licElem, "LicenseeRef", licence.licenseeRef)
      
      addRelatedOrgsIntoXML(doc, licElem, licence.orgLinks)
      
      def licPropElem = addXMLElementInto(doc, licElem, "LicenceProperties", null)
      
      licence.customProperties.each{ prop ->
        def propertyType = addXMLElementInto(doc, licPropElem, "${prop.type.name.replaceAll("\\s","").replaceAll("/","_").replaceAll("\\(","").replaceAll("\\)","").replaceAll(":","")}", null)
        addXMLElementInto(doc, propertyType, "Value","${prop.getValue()}")
        addXMLElementInto(doc, propertyType, "Note","${prop.note?:''}")

      }
      def licenceNotes = addXMLElementInto(doc, licElem, "LicenceNotes", null)
        licence.documents.each{docctx->
            if(docctx.owner?.contentType == 0 && (docctx.status == null || docctx.status?.value != 'Deleted')){
                def note_val = docctx.owner?.content
                if(note_val){
                addXMLElementInto(doc, licenceNotes, "Note","${note_val}")
              }
            }
        }
    }
  }
  
  /**
   * Add a subscription into a XML file
   * It will also add the Licence (owner) and Titles of that subscription
   * 
   * @param doc - the {@link #org.w3c.dom.Document Document} to update
   * @param into_elem - the {@link #org.w3c.dom.Element Element} we want to put the list of licence(s) in.
   * @param sub - the {@link com.k_int.kbplus.Subscription}
   * @param entitlements - the list of {@link com.k_int.kbplus.IssueEntitlement}
   */
  def addSubIntoXML(Document doc, Element into_elem, sub, entitlements) {
    def subElem = addXMLElementInto(doc, into_elem, "Subscription", null)
    addXMLElementInto(doc, subElem, "SubscriptionID", sub.id.toString())
    addXMLElementInto(doc, subElem, "SubscriptionName", sub.name)
    addXMLElementInto(doc, subElem, "SubTermStartDate", sub.startDate?getDateFormatter(sub.startDate):'')
    addXMLElementInto(doc, subElem, "SubTermEndDate", sub.endDate?getDateFormatter(sub.endDate):'')
    
    addRelatedOrgsIntoXML(doc, subElem, sub.orgRelations)
    
    if(sub.owner) addLicencesIntoXML(doc, subElem, [sub.owner])
    
    def titlesElem = addXMLElementInto(doc, subElem, "TitleList", null)
    addTitleListXML(doc, titlesElem, entitlements)
  }
  
  /**
   * Add a package into a XML file
   * It will also add the Licence and the Titles of that subscription
   * 
   * @param doc - the {@link #org.w3c.dom.Document Document} to update
   * @param into_elem - the {@link #org.w3c.dom.Element Element} we want to put the list of licence(s) in.
   * @param pck - the {@link com.k_int.kbplus.Package}
   * @param tipps - the list of {@link com.k_int.kbplus.TitleInstancePackagePlatform}
   */
  def addPackageIntoXML(Document doc, Element into_elem, pck, tipps) {
    def subElem = addXMLElementInto(doc, into_elem, "Package", null)
    addXMLElementInto(doc, subElem, "PackageID", pck.id.toString())
    addXMLElementInto(doc, subElem, "PackageName", pck.name)
    addXMLElementInto(doc, subElem, "PackageTermStartDate", pck.startDate?getDateFormatter(pck.startDate):'')
    addXMLElementInto(doc, subElem, "PackageTermEndDate", pck.endDate?getDateFormatter(pck.endDate):'')
    
    addRelatedOrgsIntoXML(doc, subElem, pck.orgs)
    
    if(pck.license) addLicencesIntoXML(doc, subElem, [pck.license])
    
    def titlesElem = addXMLElementInto(doc, subElem, "TitleList", null)
    addTitleListXML(doc, titlesElem, tipps, "TIPP")
  }
  
  /**
   * Add Organisation into a given Element.
   * 
   * @param doc - the {@link #org.w3c.dom.Document Document} to update
   * @param into_elem - the {@link #org.w3c.dom.Element Element} we want to put the list of licence(s) in.
   * @param orgs - list of {@link com.k_int.kbplus.Organisations}
   */
  private addRelatedOrgsIntoXML(Document doc, Element into_elem, orgs){
    orgs.each { or ->
      def orgElem = addXMLElementInto(doc, into_elem, "RelatedOrg", null)
      addXMLAttr(doc, orgElem, "id", or.org.id.toString())
      addXMLElementInto(doc, orgElem, "OrgName", or.org.name)
      addXMLElementInto(doc, orgElem, "OrgRole", or.roleType?.value?:'')
      
      def orgIDsElem = addXMLElementInto(doc, orgElem, "OrgIDs", null)
      or.org.ids.each(){ id ->
        def value = id.identifier.value
        def ns = id.identifier.ns.ns
        def idElem = addXMLElementInto(doc, orgIDsElem, "ID", value)
        addXMLAttr(doc, idElem, "namespace", ns)
      }
    }
  }
  
  /**
   * Stream out a given Document into a given output.
   * This function is using TransformerFactory to create the XML output.
   * It will use UTF-8 and add line break and space to get a readable XML architecture.
   * 
   * @param doc - the {@link #org.w3c.dom.Document Document} to stream
   * @param out - the {@link java.io.OutputStream}
   * @return - the {@link javax.xml.transform.stream.StreamResult} created
   */
  def streamOutXML(doc, out) {
    TransformerFactory transformerFactory = TransformerFactory.newInstance();
    Transformer transformer = transformerFactory.newTransformer();
//    transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
    transformer.setOutputProperty(OutputKeys.METHOD, "xml");
    transformer.setOutputProperty(OutputKeys.ENCODING,"UTF-8");
    transformer.setOutputProperty(OutputKeys.INDENT, "yes"); //add line break
    transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "1"); //add spaces for xml architecture
    DOMSource source = new DOMSource(doc);
    
    StreamResult streamout = new StreamResult(out);
    transformer.transform(source, streamout);
    
    return streamout
  }
  
  /* 
   * A few useful method to build XML document 
   */
  
  /**
   * Add an attribute into a given Element
   * 
   * @param doc - the {@link #org.w3c.dom.Document Document}
   * @param e - the {@link #org.w3c.dom.Element Element} to update
   * @param name - name of the attribute
   * @param val - value of the attribute
   */
  private Element addXMLAttr(Document doc, Element e, String name, String val){
    Attr attr = doc.createAttribute(name);
    attr.setValue(val);
    e.setAttributeNode(attr);
  }
  
  /**
   * Add XML Element into another given Element
   * 
   * @param doc - the {@link #org.w3c.dom.Document Document}
   * @param p - parent {@link #org.w3c.dom.Element Element}
   * @param name - name of the element
   * @param content - text content of the element 
   * @return the {@link #org.w3c.dom.Element Element} created
   */
  private Element addXMLElementInto(def doc, Element p, String name, def content){
    Element e = doc.createElement(name);
    if(content)
      e.appendChild(doc.createTextNode("${content}"));
    p.appendChild(e)
    return e
  }
  
  /* *************
   * JSON EXPORTS
   */
  
  /**
   * Add a list of titles from a given entitlement list into a given Map.
   * The Map created with this function has the purpose to be transformed into JSON.
   * 
   * @param into_map - Map which will contain the list
   * @param ie_list - list of {@link com.k_int.kbplus.IssueEntitlement}
   */
  def addTitlesToMap(into_map, ie_list, String type = "Issue Entitlement"){
    def starttime = printStart("Add titles to MAP")

    def current_title_id = -1
    def titles = []
    def title
    ie_list.each { e ->
      // There is a few distinction between TIPP and IE objects, they are handled here
      def tipp = (type=="Issue Entitlement")?e.tipp:e
      def sub  = (type=="Issue Entitlement")?e.subscription:e.sub
      def status  = (type=="Issue Entitlement")?e.coreStatus:e.status
      def statusColumnHeader = (type=="Issue Entitlement")? "CoreMedium" : "TIPPStatus"

      log.debug("Processing ie tipp.title.id=${tipp.title.id}, current_title_id=${current_title_id}");

      if(tipp.title.id != current_title_id){

        log.debug("New title");

        //start new title
        if(current_title_id!=-1) {
          log.debug("Add pending title ${title}");
          titles.add(title) // not the first time
        }
        title = [:]
        title['CoverageStatements'] = []
        
        current_title_id = tipp.title.id
        def ti = tipp.title
        
        title."Title" = ti.title
        title."InternalTitleId" = ti.id
      
        def ids = [:]
        ti.ids.each(){ id ->
          def value = id.identifier.value
          def ns = id.identifier.ns.ns
          if(ids.containsKey(ns)){
            def current = ids[ns]
            def newval = []
            newval << current
            newval << value
            ids[ns] = newval
          } else {
            ids[ns]=value
          }
        }
        title."TitleIDs" = ids
                                title.publicationType = ti.publicationType
                                title.dateMonographPublishedPrint = ti.dateMonographPublishedPrint
                                title.dateMonographPublishedOnline = ti.dateMonographPublishedOnline
                                title.monographVolume = ti.monographVolume
                                title.monographEdition = ti.monographEdition
                                title.firstEditor = ti.firstEditor

      }
      
      def ie = [:]

      log.debug("Create new ie line -- ${e.id}");

      ie."CoverageStatementType" = type
      ie."SubscriptionID" = sub?.id
      ie."SubscriptionName" = sub?.name
      ie."StartDate" = e.startDate?getDateFormatter(e.startDate):''
      ie."StartVolume" = e.startVolume?:''
      ie."StartIssue" = e.startIssue?:''
      ie."EndDate" = e.endDate?getDateFormatter(e.endDate):''
      ie."EndVolume" = e.endVolume?:''
      ie."EndIssue" = e.endIssue?:''
      ie."Embargo" = e.embargo?:''
      ie."Coverage" = e.coverageDepth?:''
      ie."CoverageNote" = e.coverageNote?:''
      ie."HostPlatformName" = tipp?.platform?.name?:''
      ie."HostPlatformURL" = tipp?.hostPlatformURL?:''
      ie."HybridOA" =  tipp?.hybridOA?.value?:''
      ie."DelayedOA"= tipp?.delayedOA?.value?:''
      ie."Payment" = tipp?.payment?.value?:''

      ie."AdditionalPlatforms" = []

      tipp?.additionalPlatforms.each(){ ap ->
        def platform = [:]
        platform.PlatformName = ap.platform?.name?:''
        platform.PlatformRole = ap.rel?:''
        platform.PlatformURL = ap.platform?.primaryUrl?:''
        ie."AdditionalPlatforms" << platform
      }

      ie."${statusColumnHeader}" = status?.value?:''

      if(type == "Issue Entitlement"){
        def dateList = []
        getIECoreDates(e)?.each{
          def dates = [:]
          dates."startDate" = it[0] ? getDateFormatter(it[0]) :''
          dates."endDate" = it[1] ? getDateFormatter(it[1]) : ''
          dateList.add(dates)
        }
        ie."CoreDateList" = dateList
      }
      ie."PackageID" = tipp?.pkg?.id?:''
      ie."PackageName" = tipp?.pkg?.name?:''
                        ie."AccessFrom" = tipp?.accessStartDate?:''
                        ie."AccessTo" = tipp?.accessEndDate?:''
                        ie."AccessStatus" = tipp?.getAvailabilityStatus().toString()?:''

      log.debug("Adding entitlement ${ie} to existing set size=${title['CoverageStatements'].size()}");
      title['CoverageStatements'].add(ie)
    }

    log.debug("Adding last title ${title}");
    titles.add(title) // add last title

    into_map."TitleList" = titles
    printDuration(starttime, "Add titles to MAP")

  }
  
  /**
   * Add a list of titles from a given tip list into a given Map.
   * The Map created with this function has the purpose to be transformed into JSON.
   *
   * @param into_map - Map which will contain the list
   * @param tip_list - list of {@link com.k_int.kbplus.TitleInstitutionPlatform}
   */
  def addCoreTitlesToMap(into_map, tip_list){
	def starttime = printStart("Add titles to MAP")

	def current_title_id = -1
	def titles = []
	def title
	tip_list.each { e ->
	  def cs = e.coreStatus(null)?'Core':e.coreStatus(null)==null?'Not Core':'Was/Will Be Core';

	  log.debug("Processing tip e.title.id=${e.title.id}, current_title_id=${current_title_id}");

	  if(e.title.id != current_title_id){

		log.debug("New title");

		//start new title
		if(current_title_id!=-1) {
		  log.debug("Add pending title ${title}");
		  titles.add(title) // not the first time
		}
		title = [:]
		title['CoverageStatements'] = []
		
		current_title_id = e.title.id
		def ti = e.title
		
		title."Title" = ti.title
		title."InternalTitleId" = ti.id
	  
		def ids = [:]
		ti.ids.each(){ id ->
		  def value = id.identifier.value
		  def ns = id.identifier.ns.ns
		  if(ids.containsKey(ns)){
			def current = ids[ns]
			def newval = []
			newval << current
			newval << value
			ids[ns] = newval
		  } else {
			ids[ns]=value
		  }
		}
		title."TitleIDs" = ids
								title.publicationType = ti.publicationType
								title.dateMonographPublishedPrint = ti.dateMonographPublishedPrint
								title.dateMonographPublishedOnline = ti.dateMonographPublishedOnline
								title.monographVolume = ti.monographVolume
								title.monographEdition = ti.monographEdition
								title.firstEditor = ti.firstEditor

	  }
	  
	  def tip = [:]

	  log.debug("Create new tip line -- ${e.id}");

	  tip."ProviderID" = e.provider.id
	  tip."ProviderName" = e.provider.name

	  def dateList = []
	  def dates
	  e.coreDates.each{
		dates = it?it:''
		dateList.add(dates)
	  }
	  tip."CoreDateList" = dateList
	  tip."CoreStatus" = cs

	  log.debug("Adding tip ${tip} to existing set size=${title['CoverageStatements'].size()}");
	  title['CoverageStatements'].add(tip)
	}

	log.debug("Adding last title ${title}");
	titles.add(title) // add last title

	into_map."TitleList" = titles
	printDuration(starttime, "Add titles to MAP")

  }
  
  /**
   * Add Organisations into a given Map.
   * The Map created with this function has the purpose to be transformed into JSON.
   * 
   * @param into_map - map which will contain the list of organisation
   * @param orgs - list of {@link com.k_int.kbplus.Org}
   */
  def addOrgMap(into_map, orgs){
    orgs.each { or ->
      def org = [:]
      org."OrgID" = or.org.id
      org."OrgName" = or.org.name
      org."OrgRole" = or.roleType?.value?:''
      
      def ids = [:]
      or.org.ids.each(){ id ->
        def value = id.identifier.value
        def ns = id.identifier.ns.ns
        if(ids.containsKey(ns)){
          def current = ids[ns]
          def newval = []
          newval << current
          newval << value
          ids[ns] = newval
        } else {
          ids[ns]=value
        }
      }
      org."OrgIDs" = ids
      
      into_map."RelatedOrgs" << org
    }
  }
  
  /**
   * Add Licences into a given Map.
   * The Map created with this function has the purpose to be transformed into JSON.
   * 
   * @param into_map - map which will contain the list of licences
   * @param lics - list of {@link com.k_int.kbplus.License}
   * @return the Map created
   */
  def addLicensesToMap(into_map, lics){
    def licences = []
    
    lics.each { licence ->
      def lic = [:]
      
      lic."LicenceReference" = licence.reference
      lic."NoticePeriod" = licence.noticePeriod
      lic."LicenceURL" = licence.licenseUrl
      lic."LicensorRef" = licence.licensorRef
      lic."LicenseeRef" = licence.licenseeRef
        
      lic."RelatedOrgs" = []
      addOrgMap(lic, licence.orgLinks)
      
      def prop = lic."LicenceProperties" = [:]
      licence.customProperties.each{
        def custprop = prop."${it.type.name}" = [:]
        custprop."Status" = it.getValue()?:""
        custprop."Notes" = it.getNote()?:""
      }

      licences << lic
    }
    into_map."Licences" = licences
    
    return into_map
  }
  
  
  /**
   * Create a Subscription Map which has the purpose to be transformed into JSON.
   * 
   * @param sub - the {@link com.k_int.kbplus.Subscription}
   * @param entitlements - list of {@link com.k_int.kbplus.IssueEntitlement}
   * @return the Map created
   */
  def getSubscriptionMap(sub, entitlements){
    def map = [:]
    def subscriptions = []
    
    def subscription = [:]
    subscription."SubscriptionID" = sub.id
    subscription."SubscriptionName" = sub.name
    subscription."SubTermStartDate" = sub.startDate?getDateFormatter(sub.startDate):''
    subscription."SubTermEndDate" = sub.endDate?getDateFormatter(sub.endDate):''
    
    subscription."RelatedOrgs" = []
    
    addOrgMap(subscription, sub.orgRelations)
    
    if(sub.owner) addLicensesToMap(subscription, [sub.owner])
    
    addTitlesToMap(subscription, entitlements)
          
    subscriptions.add(subscription)
    
    map."Subscriptions" = subscriptions
    
    return map
  }
  
  /**
   * Create a Package Map which has the purpose to be transformed into JSON.
   * 
   * @param pck - the {@link com.k_int.kbplus.Package}
   * @param tipps - the list of {@link com.k_int.kbplus.TitleInstancePackagePlatform}
   * @return the Map created
   */
  def getPackageMap(pck, tipps){
    def map = [:]
    def packages = []
    
    def pckage = [:]
    pckage."PackageID" = pck.id
    pckage."PackageName" = pck.name
    pckage."PackageTermStartDate" = pck.startDate?getDateFormatter(pck.startDate):''
    pckage."PackageTermEndDate" = pck.endDate?getDateFormatter(pck.endDate):''
        
    pckage."RelatedOrgs" = []
    
    addOrgMap(pckage, pck.orgs)
    
    if(pck.license) addLicensesToMap(pckage, [pck.license])
    
    addTitlesToMap(pckage, tipps, "TIPP")
          
    packages.add(pckage)
    
    map."Packages" = packages
    
    return map
  }
  
  /* **************
   * OTHER METHODS
   */
  
  /**
   * This function has been created to track the time taken by the different methods provided by this service
   * It's suppose to be run at the start of an event and it will catch the time and display it.
   * 
   * @param event - text which will be print out, describing the event
   * @return time when the method is called
   */
  def printStart(event){
    def starttime = new Date();
    log.debug("******* Start ${event}: ${starttime} *******")
    return starttime
  }
  
  /**
   * This function has been created to track the time taken by the different methods provided by this service.
   * It's suppose to be run at the end of an event.
   * It will print the duration between the given time and the current time.
   * 
   * @param starttime - the time when the event started
   * @param event - text which will be print out, describing the event
   */
  def printDuration(starttime, event){
    use(groovy.time.TimeCategory) {
      def duration = new Date() - starttime
      log.debug("******* End ${event}: ${new Date()} *******")
      log.debug("Duration: ${(duration.hours*60)+duration.minutes}m ${duration.seconds}s")
    }
  }
  def formatDate(date){
    if(date){
      return getDateFormatter(date)
    }else
      return null
  }
  /**
  * @return the value in the required format for CSV exports.
  **/
  def val(val){
    if(val instanceof java.sql.Timestamp || val instanceof Date){
      return val?getDateFormatter(val):" "
    }else{
      val = val? val.replaceAll('"',"'") :" "
      return "\"${val}\""
    }
  }  
}
