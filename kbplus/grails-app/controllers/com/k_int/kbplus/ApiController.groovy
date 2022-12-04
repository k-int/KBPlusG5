package com.k_int.kbplus

import com.k_int.custprops.PropertyDefinition
import grails.rest.*
import grails.converters.*
import com.k_int.kbplus.auth.User;
import grails.transaction.*
import java.security.MessageDigest

class ApiController {

  public static String TITLE_LOOKUP_BASE_QRY = '''select distinct(t)
from TitleInstance as t 
join t.ids as io 
where ''';  /// For each ID, add [OR] io.identifier.value = ? and lower(io.identifier.ns.ns) = ?

  public static String FIND_LICENSE_QRY = '''select l from License as l where l.reference = :ref
and exists ( select orl from OrgRole as orl where orl.lic = l and orl.org = :o and orl.roleType.value = 'Licensee')
'''

  static responseFormats = ['json', 'xml']

  def index() {
    def result=[:]
    respond result
  }

  def resolvePublication() {
    log.debug("resolvePublication() ${request.JSON}");
    def title_citation = request.JSON
    def result=[:]

    if ( title_citation ) {
      if ( title_citation.identifiers && title_citation.identifiers.size() > 0 ) {
        List query_params = []
        StringWriter title_by_identifiers_sw = new StringWriter()
        title_by_identifiers_sw.write(TITLE_LOOKUP_BASE_QRY)
        int counter = 0;
        title_citation.identifiers.each { idref ->
          if ( counter==0 ) {
            counter++
          }
          else {
            title_by_identifiers_sw.write( ' OR ' )
          }

          // If it's an issn or an eissn, do cross-matching
          if ( idref.namespace.equalsIgnoreCase('issn') || idref.namespace.equalsIgnoreCase('issn') ) {
            title_by_identifiers_sw.write(  '( io.identifier.value = ? and ( lower(io.identifier.ns.ns) = ? or lower(io.identifier.ns.ns) = ? ) )' )
            query_params.add(idref.value)
            query_params.add('issn');
            query_params.add('eissn');
          }
          else {
            title_by_identifiers_sw.write(  '( io.identifier.value = ? and lower(io.identifier.ns.ns) = ? )' )
            query_params.add(idref.value)
            query_params.add(idref.namespace)
          }
        }

        def title_matches = TitleInstance.executeQuery(title_by_identifiers_sw.toString(), query_params);
        result.count=title_matches.size()

        switch ( title_matches.size() ) {
          case 0:
            result.confidence='high'
            result.message = 'Matched no title for this identifier'
            break;
          case 1:
            result.confidence='high'
            result.message = 'Matched a single title via an identifier'
            result.titleData = getTitleData(title_matches.get(0));
            break;
          default:
            result.confidence='zero'
            result.message = "Citation matched ${title_matches.size()} titles by identifier. Unable to match, please refer to data managers. Title list: ${title_matches.collect{it.id}}"
            break;

        }
      }
      else {
        // No identifiers
        result.count = 0
        result.confidence='low'
        result.confidenceMessage='The title citation does not seem to have any identifiers'
      }

    }
    else {
      result.count = 0
      result.confidence='N/A'
      result.message='No title citation provided. Please post a json object structured as { title:title, identifiers:[ { namespace:ns, value:val }, { namespace:ns, value:val} ] }'
    }

    // Step 1 - attempt first class identifier lookup
    

    respond result
  }

  private Map getTitleData(TitleInstance ti) {
    log.debug("getTitleData for ${ti.id}");
    def result = [:]

    result.id = ti.id;
    result.title = ti.title;
    result.identifiers = [];
    result.availability = [];

    ti.ids.each {  dbid ->
      result.identifiers.add ( [namespace:dbid.identifier.ns.ns, value:dbid.identifier.value ] ) 
    }

    def sorted_tipps = TitleInstance.executeQuery('select tipp from TitleInstancePackagePlatform as tipp where tipp.title.id = ? order by tipp.pkg.startDate desc',[ti.id]);

    // ti.tipps.each { tipp ->
    sorted_tipps.each { tipp ->
      result.availability.add( [id:tipp.id, 
                                pkg:tipp.pkg.id, 
                                pkgStatus:tipp.pkg.packageListStatus?.value,
                                pkgScope:tipp.pkg.packageScope?.value,
                                nominalPlatform: tipp.pkg.nominalPlatform?.id
                                ] )
    }

    return result;
  }


  // see https://bitbucket.org/b_c/jose4j/wiki/JWT%20Examples
  // and https://stackoverflow.com/questions/11691462/verifying-a-signature-with-a-public-key



  /**
   * Client signs the shared secret using their private key and sends the sig to us for validation.
   * If valid, issue a JWT
   */
  def getToken(userid,token) {
    log.debug("exchangeToken ${token}");
    def result=[:]
    def user = User.findByUsername(userid)
    if ( user ) {
      // Validate the signature of the shared secret
      if ( true ) {
        // Issue JWT
      }
      else {
        // Issue random JWT that will never work
      }
    }
    else {
      // Issue a random JWT that will never work. Security by obscurity, but why provide people with a way to
      // work out what usernames we have.
      result.token='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
    }
    respond result
  }


  private User preauth(json) {
    User result = null;

    if ( ( json.reqts ) && ( json.reqts instanceof Long ) ) {

      long elapsed = System.currentTimeMillis() - json.reqts
      // If the request was made between 0 and 60s ago
      if ( ( 0 < elapsed ) && ( elapsed < 60000 ) ) { 

        User u = User.findByUsername(json.user)
        if ( u ) {

          MessageDigest md5_digest = MessageDigest.getInstance("MD5");
          md5_digest.update(grailsApplication.config.preathSalt?:'')
          md5_digest.update('.');
          md5_digest.update(json.reqts)
          md5_digest.update('.');
          md5_digest.update(u.apiKey)
          byte[] md5sum = md5_digest.digest();

          def fingerprint = new BigInteger(1, md5sum).toString(16);

          if ( json.apikey == fingerprint ) {
            result = u;
          }
        }
      }
    }
    else {
      log.error("No reqts or ts of wrong type ${json.reqts?.class?.name}");
    }

    return result;
  }

  /**
   * Create a subscription if needed for the given reference.
   * Validate TitleId.
   * Add the title to package #packageId if no tipp exists already. Use the package nominal platform if no platform specified for the tipp.
   * Add an IE to the sub for the tipp if none exists
   * CREATE NO DUPLICATES - Just skip records that already exist. Should be commutative.
   */
  def addTitleToSub() {
    def result=[:]
    log.debug(request.JSON?.toString())
    def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd')

    def user = preauth(request.JSON);

    if ( user ) {
  
      def default_start_date = null;
      def default_end_date = null;

      if ( ( request.JSON.startDate != null ) && ( request.JSON.startDate.length() > 0 ) ) {
        default_start_date = sdf.parse(request.JSON.startDate)
      }
      else {
        default_start_date = sdf.parse('1900-01-01');
      }

      if ( ( request.JSON.endDate != null ) && ( request.JSON.endDate.length() > 0 ) ) {
        default_end_date = sdf.parse(request.JSON.endDate)
      }
  
      // log.debug("addTitleToSub(${params.accessToken},${titleId},${subscriptionName},${subscriptionReference},${platformId},${packageId},${startDate},${endDate})");
  
  
      if ( 1==1 ) {
        def institution = fuzzyOrgLookup(request.JSON.institutionShortcode.trim())
        if ( institution ) {
          def sub = null;
          def sub_list = Subscription.executeQuery('select s from Subscription as s join s.orgRelations as rels where s.impId = :subref and rels.roleType.value=:sub and rels.org = :inst',
                                              [subref:request.JSON.subscriptionReference, sub:'Subscriber', inst:institution]);
          if ( sub_list.size() == 1 ) {
            log.debug("got sub");
            sub = sub_list.get(0);
          }
          else if ( sub_list.size() == 0 ) {
            log.debug("Create sub");
            sub = new Subscription(impId:request.JSON.subscriptionReference,
                                   name:request.JSON.subscriptionName,
                                   startDate:default_start_date,
                                   endDate:default_end_date,
                                   lastUpdated:new Date(),
                                   dateCreated:new Date(),
                                   status: RefdataCategory.lookupOrCreate('Subscription Status', 'Current'),
                                   type: RefdataCategory.lookupOrCreate('Subscription Type', 'Subscription Taken'),
                                   identifier:request.JSON.subscriptionReference).save(flush:true, failOnError:true);
            sub.setInstitution(institution)
            sub.save(flush:true, failOnError:true);

            request.JSON.each { k, v ->
              if ( k.toString().toLowerCase().startsWith('identifier:') ) {
                def namespace = k.toString().substring(11, k.length())
                if ( ( namespace.length() > 0 ) && ( v.toString().length() > 0 ) ) {
                  log.debug("Processing identifier ${k}(${namespace})=${v}");
                  IdentifierOccurrence io = new IdentifierOccurrence()
                  io.sub = sub;
                  io.identifier = Identifier.lookupOrCreateCanonicalIdentifier(namespace, v);
                  io.save(flush:true, failOnError:true);
                }
              }
            }

          }
          else {
            throw new RuntimeException("Found too many subscriptions with the same impId");
          }

          // Look up the title
          def title = TitleInstance.get(request.JSON.titleId)

          // Look up package
          def pkg = Package.get(request.JSON.packageId)
  
          if ( ( sub != null ) && 
               ( pkg != null ) &&
               ( title  != null ) ) {

            // Proceed - we have all we need
  
            // Check Subscription has the specified package as a subscription package, if not create one and save it
            def sp = SubscriptionPackage.findBySubscriptionAndPkg(sub,pkg) ?: new SubscriptionPackage(subscription:sub, pkg:pkg).save(flush:true, failOnError:true);
  
            if ( title && pkg ) {
              log.debug("got title ${title.title} processing TIPP");
  
              // Get tipp 
              def tipp = TitleInstancePackagePlatform.findByTitleAndPkg(title,pkg)
  
              if ( tipp ) {
                log.debug("Found correspionding tipp : ${tipp}");
              }
              else {
                log.debug("Need to create tipp");
                def plat = null;

                if (  ( request.JSON.platformId != null ) && ( request.JSON.platformId.length() > 0 ) ) {
                  try { plat = Platform.get(request.JSON.platformId) } catch ( Exception e ) { }
                }

                if ( plat == null ) {
                  // Failed to get platform, try nominal platform
                  if ( pkg.nominalPlatform == null ) {
                    pkg.updateNominalPlatform()
                  }
                  plat = pkg.nominalPlatform
                }
  
                if ( plat ) {
                  log.debug("Create tipp");
                  tipp = new TitleInstancePackagePlatform(title:title, pkg:pkg, platform:plat).save(flush:true, failOnError:true)
                }
                else {
                  result.message = "Unable to locate platform for id ${request.JSON.platformId}"
                  log.error("Unable to locate platform for id ${request.JSON.platformId}");
                }
              }
  
              // See if sub already has an IE for tipp
              log.debug("Processing IE");
              if ( tipp && sub ) {
                def existing_ie = IssueEntitlement.findBySubscriptionAndTipp(sub, tipp)
                if ( existing_ie ) {
                  result.message="Subscription already has IE for the tipp";
                }
                else {
                  log.debug("Creating new IE");
                  def parsed_start_date = null;
                  existing_ie = new IssueEntitlement(subscription:sub, 
                                                     startDate:parsed_start_date,
                                                     status:RefdataCategory.lookupOrCreate('Entitlement Issue Status', 'Live'),
                                                     accessStartDate:default_start_date,
                                                     accessEndDate:default_end_date,
                                                     tipp:tipp).save(flush:true, failOnError:true)
                }
              }
              else {
                log.error("unable to proceed - tipp(${tipp}) or sub(${sub}) missing");
              }
  
  
              log.debug("Processing core dates....");
              def provider = pkg.getContentProvider()
              if ( institution && title && provider ) {
                log.debug("lookup tip(${title},${institution},${provider})");
                def tiinp = TitleInstitutionProvider.findByTitleAndInstitutionAndprovider(title, institution, provider)
                if ( tiinp == null ) {
                  log.debug("Creating new TitleInstitutionProvider");
                  tiinp = new TitleInstitutionProvider(title:title, institution:institution, provider:provider).save(flush:true, failOnError:true)
                }
                else {
                  // Making sure that new tiinp contains stated core dates (Start date)
                }
  
                log.debug("Asserting core dates");
                tiinp.extendCoreExtent(default_start_date, null);
              }
            }
            else {
              result.message="Unable to locate title with ID ${request.JSON.titleId}(=${title}) or package with ID ${request.JSON.packageId}(=${pkg})";
            }
          }
          else {
            result.message = "One of Title(${title}), Sub(${sub}) or Pkg(${pkg}) missing. Unable to continue"
          }
        }
        else {
          log.warn("addTitleToSub request for unknown institution ${request.JSON.institutionShortcode}");
          result.message="unable to locate institution for shortcode ${request.JSON.institutionShortcode}";
        }
      }
      else {
        log.warn("addTitleToSub request with invalid access token");
        result.message="Invalid accessToken"
      }
    }
    else {
       log.warn("invalid apikey");
       response.status = 401;
    }

    respond result
  }

  /**
   * For a given subscription, assert that the given date range must be core
   *   @param params.subid Subscription Id - Mandatory
   *   @param params.startDate - Mandatory - Format yyyy-mm-dd
   *   @param params.endDate - Optional - Format yyyy-mm-dd
   */
  def makeEntitlementsCore() {
    def result=[:]
    log.debug("makeEntitlementsCore(${params}) - ${request.JSON?.toString()}");
    def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd')

    def user = preauth(request.JSON);

    if ( user ) {
      java.util.Date start_date = ( params.startDate && ( params.startDate.length() > 0 ) ) ? sdf.parse(params.startDate) : null;
      java.util.Date end_date = ( params.endDate && ( params.endDate.length() > 0 ) ) ? sdf.parse(params.endDate) : null;

      Long long_subid = Long.parseLong(params.subid);

      if ( ( start_date != null ) && ( long_subid != null ) && ( long_subid > 0 ) ) {
        log.debug("Got start date-- process");

        def query_params = [subid:long_subid]
        def query_str = 'select ie.id from IssueEntitlement as ie where ie.subscription.id = :subid'

        if ( ( params.issn ) && ( params.issn.length() > 0 ) ) {
          log.debug("makeEntitlementsCore includes ISSN: ${params.issn}");
          query_str += ' and exists ( select io from IdentifierOccurrence as io where io.ti = ie.tipp.title and io.identifier.value = :issn ) '
          query_params.issn = params.issn
        }
		else if ( ( params.eissn ) && (params.eissn.length() > 0 ) ) {
		  log.debug("makeEntitlementsCore includes eISSN: ${params.eissn}");
		  query_str += ' and exists ( select io from IdentifierOccurrence as io where io.ti = ie.tipp.title and io.identifier.value = :eissn ) '
		  query_params.eissn = params.eissn
		}

        log.debug("makeEntitlementsCore for ${query_str}");
        def ie_ids = IssueEntitlement.executeQuery(query_str,query_params);
        ie_ids.each { ie_id ->
          IssueEntitlement.withNewTransaction() {
            IssueEntitlement ie = IssueEntitlement.read(ie_id);
            def tip = ie.getTIP()
            log.debug("Extend core dates ${ie_id} start:${start_date} end:${end_date} ie_id:${ie.id} tip_id:${tip.id}");
            tip.extendCoreExtent(start_date,end_date);
          }
        }
      }
      else {
        result.message="Missing start date or sub. ${params}";
      }
    }
    else {
      result.message="nope"
      response.status = 401;
    }

    log.debug("Complete");
    respond result
  }

  def fuzzyOrgLookup(name) {
    def institution = null;

    if ( name?.length() > 1 ) {

      institution = Org.findByShortcode(name)

      if ( institution == null ) {
        institution = Org.findByName(name)
      }

      if ( institution == null ) {
        def qr = Org.executeQuery('select o from Org as o where lower(o.shortcode) = :c',[c:name.toLowerCase().replaceAll(' ','_')]);
        if ( qr.size() == 1 ) {
          institution = qr.get(0);
        }
      }
  
      if ( institution == null ) {
        def qr = Org.executeQuery('select o from Org as o where lower(o.shortcode) like :c',[c:name.toLowerCase().replaceAll(' ','_')+'%']);
        if ( qr.size() == 1 ) {
          institution = qr.get(0);
        }
      }
    }

    return institution
  }

  def createSubscription() {
    def result=[status:'OK']
    log.debug("createSubscription(${params}) - ${request.JSON?.toString()}");
    def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd')

    def user = preauth(request.JSON);

    def default_start_date = null;
    def default_end_date = null;

    if ( ( request.JSON.startDate != null ) && ( request.JSON.startDate.length() > 0 ) ) {
      default_start_date = sdf.parse(request.JSON.startDate)
    }
    else {
      default_start_date = sdf.parse('1900-01-01');
    }

    if ( ( request.JSON.endDate != null ) && ( request.JSON.endDate.length() > 0 ) ) {
      default_end_date = sdf.parse(request.JSON.endDate)
    }


    if ( ( request.JSON.subscriptionReference?.length() > 0 ) && 
         ( user ) &&
         ( request.JSON.institutionShortcode != null ) ) {
      // Incoming request containing 
      // institutionShortcode
      // startDate - Date sub is to start on
      // endDate - Date sub is valid until
      // subscriptionName - Name of subscription to create under Institution
      // subscriptionReference - reference for the sub
      // identifier:js - 1234  - Any column identifier: will add an identifier in the namespace after the colon in the field name
      def institution = fuzzyOrgLookup(request.JSON.institutionShortcode.trim())

      if ( institution ) {
        try {
          def sub = null;
          def sub_list = Subscription.executeQuery('select s from Subscription as s join s.orgRelations as rels where s.impId = :subref and rels.roleType.value=:sub and rels.org = :inst',
                                                [subref:request.JSON.subscriptionReference, sub:'Subscriber', inst:institution]);
          if ( sub_list.size() == 1 ) {
            log.debug("got sub");
            sub = sub_list.get(0);
          }
          else if ( sub_list.size() == 0 ) {
            log.debug("Create sub");
            sub = new Subscription(impId:request.JSON.subscriptionReference,
                                   name:request.JSON.subscriptionName,
                                   startDate:default_start_date,
                                   endDate:default_end_date,
                                   lastUpdated:new Date(),
                                   dateCreated:new Date(),
                                   status: RefdataCategory.lookupOrCreate('Subscription Status', 'Current'),
                                   type: RefdataCategory.lookupOrCreate('Subscription Type', 'Subscription Taken'),
                                   identifier:request.JSON.subscriptionReference).save(flush:true, failOnError:true);
            sub.setInstitution(institution)
            sub.save(flush:true, failOnError:true);
  
            request.JSON.each { k, v ->
              if ( k.toString().toLowerCase().startsWith('identifier:') ) {
                def namespace = k.toString().substring(11, k.length())
                if ( ( namespace.length() > 0 ) && ( v.toString().length() > 0 ) ) {
                  log.debug("Processing identifier ${k}(${namespace})=${v}");
                  IdentifierOccurrence io = new IdentifierOccurrence()
                  io.sub = sub;
                  io.identifier = Identifier.lookupOrCreateCanonicalIdentifier(namespace, v);
                  io.save(flush:true, failOnError:true);
                }
              }
            }

          }
          else {
            result.message="Found too many subscriptions with the same subscriptionReference/impId";
            result.status="ERROR"
          }
        }
        catch ( java.text.ParseException pe ) {
          result.message="Unable to parse dates in request";
          result.status="ERROR"
        }
        catch ( Exception e ) {
          result.message="unexpected error processing sub info"
          result.status="ERROR"
        }
      }
      else {
        result.message="Unable to locate org with name or shortcode for "+request.JSON.institutionShortcode;
        result.status="ERROR"
      }
    }
    else {
      result.message="User null OR no subscription reference supplied"
      result.status="ERROR"
      response.status = 401;
    }

    log.debug("Complete (${result})");
    respond result
  }

  def oai() {
    def result = [:]

    log.debug("oai (${params})");

    if ( params.id ) {

      // Work out if we have any config for listing these kinds of objects (Packages)

      if ( result.oaiConfig ) {
        switch ( params.verb?.toLowerCase() ) {
          case 'getrecord':
            // getRecord(result);
            break;
          case 'identify':
            // identify(result);
            break;
          case 'listidentifiers':
            // listIdentifiers(result);
            break;
          case 'listmetadataformats':
            // listMetadataFormats(result);
            break;
          case 'listrecords':
            listRecords(result);
            break;
          case 'listsets':
            // listSets(result);
            break;
          defaut:
            break;
        }
        log.debug("done");
      }
      else {
        // Unknown OAI config
      }
    }

    result.msg='hello world'

    respond(result)
  }

  def listRecords(result) {
  }

  // def assertCore(accessToken, titleId, platformId, startDate, endDate) {
  //   def result=[:]
  //   log.debug("assertCore(${accessToken},${titleId},${platformId},${startDate},${endDate})");
  //   respond result
  // }

  // Assert a core status against a title/institution. Creates TitleInstitutionProvider objects
  // For all known combinations.
  // @Secured(['ROLE_API', 'IS_AUTHENTICATED_FULLY'])
  def assertCore() {
    // Params:     inst - [namespace:]code  Of an org [mandatory]
    //            title - [namespace:]code  Of a title [mandatory]
    //         provider - [namespace:]code  Of an org [optional]
    log.debug("assertCore(${params})");
    def result = [:]
    if ( request.getRemoteAddr() == '127.0.0.1' ) {
      if ( ( params.inst?.length() > 0 ) && ( params.title?.length() > 0 ) ) {
        def inst = Org.lookupByIdentifierString(params.inst);
        def title = TitleInstance.lookupByIdentifierString(params.title);
        def provider = params.provider ? Org.lookupByIdentifierString(params.provider) : null;
        def year = params.year?.trim()

        log.debug("assertCore ${params.inst}:${inst} ${params.title}:${title} ${params.provider}:${provider}");

        if ( title && inst ) {

          def sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

          if ( provider ) {
          }
          else {
            log.debug("Calculating all known providers for this title");
            def providers = TitleInstancePackagePlatform.executeQuery('''select distinct orl.org 
from TitleInstancePackagePlatform as tipp join tipp.pkg.orgs as orl
where tipp.title = ? and orl.roleType.value=?''',[title,'Content Provider']);

            providers.each {
              log.debug("Title ${title} is provided by ${it}");
              def tiinp = TitleInstitutionProvider.findByTitleAndInstitutionAndprovider(title, inst, it) 
              if ( tiinp == null ) {
                log.debug("Creating new TitleInstitutionProvider");
                tiinp = new TitleInstitutionProvider(title:title, institution:inst, provider:it).save(flush:true, failOnError:true)
              }

              log.debug("Got tiinp:: ${tiinp}");
              def startDate = sdf.parse("${year}-01-01T00:00:00");
              def endDate = sdf.parse("${year}-12-31T23:59:59");
              tiinp.extendCoreExtent(startDate, endDate);
            }
          }
        }
      }
      else {
        result.message="ERROR: missing mandatory parameter: inst or title";
      }
    }
    else {
      result.message="ERROR: this call is only usable from within the KB+ system network"
    }
    render result as JSON
  }
  /*
  * Create a CSV containing all JUSP title IDs with the institution they belong to
  */
  def fetchAllTips(){

    def jusp_ti_inst = TitleInstitutionProvider.executeQuery("""
   select jusp_institution_id.identifier.value, jusp_title_id.identifier.value, dates,tip_ti.id, 
   (select jusp_provider_id.identifier.value from tip_ti.provider.ids as jusp_provider_id where jusp_provider_id.identifier.ns.ns='juspsid' )
    from TitleInstitutionProvider tip_ti
      join tip_ti.institution.ids as jusp_institution_id,
    TitleInstitutionProvider tip_inst
      join tip_inst.title.ids as jusp_title_id,
    TitleInstitutionProvider tip_date
      join tip_date.coreDates as dates
    where jusp_title_id.identifier.ns.ns='jusp'
        and tip_ti = tip_inst
        and tip_inst = tip_date
        and jusp_institution_id.identifier.ns.ns='jusplogin' order by jusp_institution_id.identifier.value 
     """)

    def date = new java.text.SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
    date = date.format(new Date())
    response.setHeader("Content-disposition", "attachment; filename=\"kbplus_jusp_export_${date}.csv\"")
    response.contentType = "text/csv"
    def out = response.outputStream
    def currentTip = null
    def dates_concat = ""
    out.withWriter { writer ->
      writer.write("JUSP Institution ID,JUSP Title ID,JUSP Provider, Core Dates\n")
      Iterator iter = jusp_ti_inst.iterator()
      while(iter.hasNext()){
        def it = iter.next()
        if(currentTip == it[3]){
          dates_concat += ", ${it[2]}"
        }else if(currentTip){
          writer.write("\"${dates_concat}\"\n\"${it[0]}\",\"${it[1]}\",\"${it[4]?:''}\",")
          dates_concat = "${it[2]}"
          currentTip = it[3]
        }else{
          writer.write("\"${it[0]}\",\"${it[1]}\",\"${it[4]?:''}\",")
          dates_concat = "${it[2]}"
          currentTip = it[3]
        }
        if (!iter.hasNext()){
          writer.write("\"${dates_concat}\"\n")
        }
      }

       writer.flush()
       writer.close()
     }
     out.close()   
  }

  // Accept a single mandatorty parameter which is the namespace:code for an institution
  // If found, return a JSON report of each title for that institution
  // Also accept an optional parameter esn [element set name] with values full of brief[the default]
  // Example:  http://localhost:8080/demo/api/institutionTitles?orgid=jusplogin:shu
  def institutionTitles() {

    def result = [:]
    result.titles = []

    if ( params.orgid ) {
      def name_components = params.orgid.split(':')
      if ( name_components.length == 2 ) {
        // Lookup org by ID
        def orghql = "select org from Org org where exists ( select io from IdentifierOccurrence io, Identifier id, IdentifierNamespace ns where io.org = org and id.ns = ns and io.identifier = id and ns.ns = ? and id.value like ? )"
        def orgs = Org.executeQuery(orghql, [name_components[0],name_components[1]])
        if ( orgs.size() == 1 ) {
          def org = orgs[0]

          def today = new Date()

          // Find all TitleInstitutionProvider where institution = org
          def titles = TitleInstitutionProvider.executeQuery('select tip.title.title, tip.title.id, count(cd) from TitleInstitutionProvider as tip left join tip.coreDates as cd where tip.institution = ? and cd.startDate < ? and cd.endDate > ?',
                                                             [org, today, today]);
          titles.each { tip ->
            result.titles.add([title:tip[0], tid:tip[1], isCore:tip[2]]);
          }
        }
        else {
          log.message="Unable to locate Org with ID ${params.orgid}";
        }
      }
      else {
        result.message="Invalid orgid. Format orgid as namespace:value, for example jusplogin:shu"
      }
    }

    render result as JSON
  }

  /**
   *
   * @param shortcode - shortcode of institution
   * @param reference - Reference of new license
   */
  def addInstitutionLicenses() {
    log.debug("addInstitutionLicenses(${params}) - ${request.JSON?.toString()}");

    //Initialise result map
    def result = [:]
    def user = preauth(request.JSON);
    def json = request.JSON

    //If we have a shortcode and reference...
    if (user) {
      if (json.getAt("shortCode") && json.getAt("licenceReference")) {
        def shortcode = json.getAt("shortCode")
		def licenceId = json.getAt("licenceId")
        def licenceReference = json.getAt("licenceReference")

        //Find the org by its shortcode
        def inst = Org.findByShortcode(shortcode);

        //If we find one...
        if (inst) {
          log.debug("Found org: " + inst)

          if (licenceId == '#') {
            log.debug("Creating a new licence")
			result.message = "Creating new licence... "
            //Create a new basic licence using the reference provided and save it.
            def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd')

            def licence_type = RefdataCategory.lookupOrCreate("License Type", "Content")
            def licence_status = RefdataCategory.lookupOrCreate("License Status", "Current")
            def licence_category = RefdataCategory.lookupOrCreate("License Category", json.getAt("licenceCategory"))
            def licence_url = json.getAt("licenceUrl")
            def licensor_ref = json.getAt("licensorRef")
            def licensee_ref = json.getAt("licenseeRef")
			def start_date
			def end_date
			if (json.getAt("startDate")) {
				start_date = sdf.parse(json.getAt("startDate"))
			}
			else {
				result.message += "WARN - Start Date not provided for new licence... "
			}
			if (json.getAt("endDate")) {
				end_date = sdf.parse(json.getAt("endDate"))
			}
			else {
				result.message += "WARN - End Date not provided for new licence... "
			}

            def lic = new License(
                    reference: licenceReference,
                    type: licence_type,
                    status: licence_status,
                    licenseCategory: licence_category,
                    licensorRef: licensor_ref,
                    licenseeRef: licensee_ref,
                    licenseUrl: licence_url,
                    endDate: end_date,
                    startDate: start_date
            )

            if (!lic.save(flush: true, failOnError: true)) {
              log.debug("Licence ${lic} failed to save")
			  result.message += "ERROR - New licence ${licenceReference} failed to save... "
            } else {
              log.debug("Licence save ${lic} ok")
			  result.message += "New licence ${licenceReference} with ID ${lic.id} created... "

              //Set additional values on the licence

              def role_licensee = RefdataCategory.lookupOrCreate("Organisational Role", 'Licensee')
              //Create a new org role for the licence, inst and licensee that was defined
              inst.links.add(new OrgRole(lic: lic, org: inst, roleType: role_licensee))
              if (inst.save(flush: true, failOnError: true)) {
              } else {
                log.error("Problem saving org links to license ${org.errors}")
              }

              //Assigning additional data to licence
              assignCustomPropsToLicense(json, lic, false)

            }
          }
          //If the licence is not null, look at updating it
          else {
			if (licenceId) {
              //If they want to amend existing licences, the code should be added here if we're not creating a new one
              log.debug("Attempting to find licence for reference ${licenceReference} and institution ${shortcode}")
              result.message = "Match existing license with reference ${licenceReference} and institution ${shortcode}... "
			
			  def licMap = License.executeQuery(FIND_LICENSE_QRY, [ref: licenceReference, o: inst])
			  if (licMap.size == 0){
				  result.message += "ERROR - No Licence found with name ${licenceReference}... "
			  }
			  else if (licMap.size > 1){
				  result.message += "WARN - Multiple matches for Licence with name ${licenceReference}... "
			  }
			
			  Long licId = Long.parseLong(json.getAt("licenceId"))

              log.debug("About to edit licence ${licId}")
			
			  licMap.each { lic ->
                log.debug("Iterating licence map ${licMap.size()}")
				  if (lic.id == licId) {
					  log.debug("Existing License with ID ${lic.id} will be updated")
					  result.message += "Updating existing license with ID ${lic.id}... "
					  assignCustomPropsToLicense(json, lic, true)
				  } else {
                    log.debug("Licence ID doesn't match supplied ID (Licence ${lic.id}, Supplied ${licId})")
					result.message += "WARN - Skip updating Licence with ID ${lic.id}... "
                  }
			  }
			}
			else {
			  result.message = "ERROR - Licence ID field is blank... "
			}
          }
        } else {
          log.debug("Unable to locate org for shortcode ${shortcode}")
          result.message = "ERROR - Unable to locate org for shortcode ${shortcode}... "
        }
      }
      respond result
    } else {
      log.debug("User not found or null")
      response.status = 401;
    }
  }

  def assignCustomPropsToLicense(json, lic, existing) {
    //RefdataValue fields
	  
	def newPropsName = ['Alumni Access', 'APC/Offset Offer', 'ILL - InterLibraryLoans', 'ILL - Print', 'ILL - Electronic', 'Include In Coursepacks', 'Include in VLE',
		'Multi Site Access', 'Partners Access', 'Post Cancellation Access Entitlement', 'Remote Access', 'Walk In Access', 'Concurrent Access', 'Enterprise Access',
		'Text and Data Mining', 'Authorised Users', 'Concurrent Users', 'Notice Period']
	  
	def newPropsHeader = ["alumniAccess", "apcOffset", "interLibraryLoans", "illPrint", "illElectronic", "includeInCoursepacks", "includeInVle",
		"multiSiteAccess", "partnersAccess", "postCancellationAE", "remoteAccess", "walkInAccess", "concurrentAccess", "enterpriseAccess",
		"textAndDataMining", "authorisedUsers", "concurrentUsers", "noticePeriod"]
	
	def noMatch
	String newPropVal
	String newPropNote
	String newPropName
	
	for (int i=0; i < newPropsHeader.size(); i++) {
		noMatch = true
		newPropName = newPropsName[i]
		log.debug("Adding ${newPropName} property")
		if (existing) {
			//iterate through existing license properties to see if property already exists, skip addition if it does
			lic.customProperties.each {prop ->
				if (prop.type?.name == newPropName) {
					log.debug("Property ${newPropName} already exists")
					noMatch = false
					//output to error file
				}
			}
		}
		if (noMatch) {
			newPropVal = json.getAt(newPropsHeader[i])
			newPropNote = json.getAt(newPropsHeader[i] + "Note")
			log.debug("Property ${newPropName} with value ${newPropVal} and note ${newPropNote}")
			assignPropertyWithNoteToLicense(lic, newPropVal, newPropName, newPropNote)
		}
	}
  }

  def assignPropertyWithNoteToLicense(lic, propValue, propName, note) {

    //Can be string or rdv
    def val = null
    PropertyDefinition pd = null

    if(propValue != null) {
      pd = PropertyDefinition.findByName(propName)
      if(pd != null) {
        log.debug(" -- Using propName ${propName} and value ${propValue}")

        if(pd.type == "java.lang.String"){
          //If the value is a string
          log.debug("It's a string ${pd.type}")
          val = propValue
        } else if (pd.type == "com.k_int.kbplus.RefdataValue" ){
          //Otherwise, if it's RDV
          String catName = pd.refdataCategory
          log.debug("It's a rdv ${pd.type}. Assigning catName ${catName}")
          val = RefdataCategory.lookupOrCreate(catName, propValue)
        } else if (pd.type == "java.lang.Integer"){
          log.debug("It's an integer ${pd.type}")
          val = Integer.parseInt(propValue)
        } else {
          log.debug("Val is falling through here...")
        }

        log.debug("val is ${val}")
      } else {
        log.debug("Property Definition is null for propertyName: ${propName}")
      }
    }

    //If we managed to get a value from the DB
    def lcp = null

    if(val != null) {
      log.debug("Setting property value on lic ${lic.reference} (${lic.id}). Type: ${pd}, owner ${lic}. Val is ${val}")
      lcp = new LicenseCustomProperty(type: pd, owner: lic)

      if(pd.type == "com.k_int.kbplus.RefdataValue") {
        //If our property is a refdatavalue
        log.debug("Setting as rdv")
        lcp.setProperty("refValue", val)
      } else if(pd.type == "java.lang.String") {
        //If our property is a string
        log.debug("Setting as string")
        lcp.setProperty("stringValue", val)
      } else if(pd.type == "java.lang.Integer") {
        //If our property is an Integer
        log.debug("Setting as an integer")
        lcp.setProperty("intValue", val)
      } else {
        log.debug("Val is not string, rdv or integer: ${val}")
      }

      //Set the note on the property. This should only happen if we have a property in the first place
      if(note != null && lcp != null) {
        log.debug("Setting note as: ${note.trim()}")
        lcp.setProperty("note", note.trim())
      }

      //Save the custom property
      if(lcp) {
        lcp.save(flush: true, failOnError: true)
      } else {
        log.debug("LicenseCustomProperty is null")
      }
    } else {
      log.debug("Custom property value is null for ${propValue}, ${propName}, ${note}")
    }
  }

}
