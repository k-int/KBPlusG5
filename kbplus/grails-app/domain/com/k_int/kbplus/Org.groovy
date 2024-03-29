package com.k_int.kbplus

import com.k_int.kbplus.auth.*;
import org.apache.commons.logging.LogFactory
import groovy.util.logging.*
import groovy.transform.EqualsAndHashCode
import javax.persistence.Transient
import groovy.util.logging.Slf4j

@Slf4j
@EqualsAndHashCode(includes=['id','name'])
class Org {

  String name
  String keyName
  String impId
  String address
  String ipRange
  String sector
  String scope
  Date dateCreated
  Date lastUpdated
  String categoryId
  String membershipOrganisation

  RefdataValue orgType
  RefdataValue status
  String nonce

  // Used to generate friendly semantic URLs
  String shortcode

  String exportStatus
  Date currentExportDate
  String exportUUID
  String batchMonitorUUID

  Set ids = []

  static mappedBy = [ids: 'org', 
                     outgoingCombos: 'fromOrg', 
                     incomingCombos:'toOrg',
                     links: 'org',
                     affiliations: 'org',
                     variantNames:'owner' ]

  static hasMany = [ids: IdentifierOccurrence, 
                    outgoingCombos: Combo,  
                    incomingCombos:Combo,
                    links: OrgRole,
                    affiliations: UserOrg,
                    customProperties:OrgCustomProperty,
                    variantNames:OrgVariantName]

  static mapping = {
                        id column:'org_id'
                   version column:'org_version'
                     impId column:'org_imp_id', index:'org_imp_id_idx'
                      name column:'org_name', index:'org_name_idx'
                   address column:'org_address'
                   ipRange column:'org_ip_range'
                 shortcode column:'org_shortcode', index:'org_shortcode_idx'
                     scope column:'org_scope'
                categoryId column:'org_cat'
                   orgType column:'org_type_rv_fk'
                    status column:'org_status_rv_fk'
                   keyName column:'org_key_name', index:'org_key_name_idx'
    membershipOrganisation column:'org_membershipyn'
                     nonce column:'org_nonce'
              exportStatus column:'org_export_status'
         currentExportDate column:'org_current_export_date'
                exportUUID column:'org_export_uuid'
          batchMonitorUUID column:'org_batch_monitor_uuid'
  }

  static constraints = {
                     impId(nullable:true, blank:true,maxSize:256);
                   address(nullable:true, blank:true,maxSize:256);
                   ipRange(nullable:true, blank:true, maxSize:1024);
                    sector(nullable:true, blank:true, maxSize:128);
                 shortcode(nullable:true, blank:true, maxSize:128);
                     scope(nullable:true, blank:true, maxSize:128);
                categoryId(nullable:true, blank:true, maxSize:128);
                   orgType(nullable:true, blank:true, maxSize:128);
                    status(nullable:true, blank:true);
                   keyName(nullable:true, blank:true);
    membershipOrganisation(nullable:true, blank:true);
                     nonce(nullable:true, blank:true);
              exportStatus(nullable:true, blank:true);
         currentExportDate(nullable:true, blank:true);
                exportUUID(nullable:true, blank:true);
          batchMonitorUUID(nullable:true, blank:true);
  }

  def beforeInsert() {
    if ( !shortcode ) {
      shortcode = generateShortcode(name);
    }
    if ( name != null ) {
      keyName = com.k_int.kbplus.utils.TextUtils.generateKeyName(name)
    }
    if ( membershipOrganisation == null ) {
      membershipOrganisation='No';
    }
  }

  def beforeUpdate() {
    if ( !shortcode ) {
      shortcode = generateShortcode(name);
    }
    if ( name != null ) {
      keyName = com.k_int.kbplus.utils.TextUtils.generateKeyName(name)
    }
  }

  def generateShortcode(name) {
    def candidate = name.trim().replaceAll(" ","_")
    return incUntilUnique(candidate);
  }

  def incUntilUnique(name) {
    def result = name;
    if ( Org.findByShortcode(result) ) {
      // There is already a shortcode for that identfier
      int i = 2;
      while ( Org.findByShortcode("${name}_${i}") ) {
        i++
      }
      result = "${name}_${i}"
    }

    result;
  }

  static def lookupByIdentifierString(idstr) {

    LogFactory.getLog(this).debug("lookupByIdentifierString(${idstr})");

    def result = null;
    def qr = null;
    def idstr_components = idstr.split(':');
    switch ( idstr_components.size() ) {
      case 1:
        qr = Org.executeQuery('select t from Org as t join t.ids as io where io.identifier.value = :oid',['oid':idstr_components[0]])
        break;
      case 2:
        qr = Org.executeQuery('select t from Org as t join t.ids as io where io.identifier.value = :oid and io.identifier.ns.ns = :ons',
                              ['oid':idstr_components[1],'ons':idstr_components[0]])
        break;
      default:
        break;
    }

    LogFactory.getLog(this).debug("components: ${idstr_components} : ${qr}");

    if ( ( qr ) && ( qr.size() == 1 ) ) {
      result = qr.get(0);
    }

    result
  }

  def getIdentifierByType(idtype) {
    def result = null
    ids.each { id ->
      if ( id.identifier.ns.ns == idtype ) {
        result = id.identifier;
      }
    }
    result
  }

  static def refdataFind(params) {
    def result = [];
    def ql = null;
    ql = Org.findAllByNameIlike("%${params.q}%",params)

    if ( ql ) {
      ql.each { id ->
        def o = com.k_int.ClassUtils.deproxy(id)
        result.add([id:"${o.class.name}:${o.getId()}",text:"${o.name} (${o.shortcode})"])
      }
    }

    result
  }

  static def refdataCreate(value) {
    return new Org(name:value);
  }

  public boolean hasUserWithRole(com.k_int.kbplus.auth.User user, String rolename) {
    def role = com.k_int.kbplus.auth.Role.findByAuthority(rolename)
    return hasUserWithRole(user,role);
  }

  /**
   *  Does user have perm against this org?
   */
  public boolean hasUserWithRole( com.k_int.kbplus.auth.User user, com.k_int.kbplus.auth.Role formalRole ) {
    def result = false;
    def userOrg = com.k_int.kbplus.auth.UserOrg.findByUserAndOrgAndFormalRole(user,this,formalRole)
	  if( userOrg && ( userOrg.status==1 || userOrg.status==3  )){
		  result = true
    }
    return result;
  }


  static def lookupOrCreate(name, sector, consortium, identifiers, iprange, membership_org='No') {

    def result = null;

    // See if we can uniquely match on any of the identifiers
    identifiers.each { k,v ->
      if ( v != null ) {
        def o = Org.executeQuery("select o from Org as o join o.ids as io where io.identifier.ns.ns = :ns and io.identifier.value = :id",['ns':k,'id':v])
        if ( o.size() > 0 ) {
          result = o[0]
        }
      }
    }

    // No match by identifier, try and match by name
    if ( result == null ) {
      // log.debug("Match by name ${name}");
      def o = Org.executeQuery("select o from Org as o where lower(o.name) = :n",['n':name.toLowerCase()])
      if ( o.size() > 0 ) {
        result = o[0]
      }
    }

    if ( result == null ) {
      log.debug("Create new org for ${name}");
      result = new Org(
                       name:name, 
                       sector:sector,
                       ipRange:iprange,
                       impId:java.util.UUID.randomUUID().toString(),
                       membershipOrganisation:membership_org).save(flush:true, failOnError:true)

      identifiers.each { k,v ->
        if ( ( v ) && ( v.trim().length() > 0 ) ) {
          def io = new IdentifierOccurrence(org:result, identifier:Identifier.lookupOrCreateCanonicalIdentifier(k,v)).save(flush:true, failOnError:true)
        }
      }

      if ( ( consortium != null ) && ( consortium.length() > 0 ) ) {
        def db_consortium = Org.lookupOrCreate(consortium, null, null, [:], null)
        def consLink = new Combo(fromOrg:result,
                                 toOrg:db_consortium,
                                 status:null,
                                 type: RefdataCategory.lookupOrCreate('Organisational Role', 'Package Consortia')).save(flush:true, failOnError:true)
      }
    }
 
    result 
  }



  @Transient
  static def oaiConfig = [
    id:'orgs',
    textDescription:'Org repository for KBPlus',
    query:" from Org as o ",
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
        builder.'org' (['id':(id)]) {
          builder.'name' (name)
        }
        builder.'identifiers' () {
          ids?.each { id_oc ->
            builder.identifier([namespace:id_oc.identifier?.ns.ns, value:id_oc.identifier?.value])
          }
        }
        builder.'variantNames' () {
          variantNames?.each { id_oc ->
            builder.variantName([value:id_oc.variantName])
          }
        }
      }
    }
    catch ( Exception e ) {
      log.error(e);
    }

  }

}
