package kbplus

import com.k_int.kbplus.*

import com.k_int.kbplus.auth.*
import com.k_int.custprops.PropertyDefinition
import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.SecurityFilterPosition

import groovy.util.logging.Slf4j

@Slf4j
class BootStrap {

  def dataloadService
  def ejectService
  def grailsApplication

  def init = { servletContext ->
    RefdataCategory.withTransaction { status ->
      wrappedInit(servletContext);
    }
  }

  def wrappedInit(servletContext) {

    println("Sys id: ${grailsApplication.config.kbplusSystemId}, cfg validation: ${grailsApplication.config.configValidation}, skin: ${grailsApplication.config.skin}...");
    println("Attempt connect: ${grailsApplication.config.dataSource.username} ${grailsApplication.config.dataSource.url}");
    println("v2")
  
    if ( grailsApplication.config.kbplusSystemId != null ) {
      def system_object = SystemObject.findBySysId(grailsApplication.config.kbplusSystemId) ?: new SystemObject(sysId:grailsApplication.config.kbplusSystemId).save(flush:true);
    }

    def evt_startup = new EventLog(event:'kbplus.startup',message:'Normal startup',tstp:new Date(System.currentTimeMillis())).save(flush:true)

    def so_filetype = DataloadFileType.findByName('Subscription Offered File') ?: new DataloadFileType(name:'Subscription Offered File');
    def plat_filetype = DataloadFileType.findByName('Platforms File') ?: new DataloadFileType(name:'Platforms File');

    // Permissions
    def edit_permission = Perm.findByCode('edit') ?: new Perm(code:'edit').save(failOnError: true)
    def view_permission = Perm.findByCode('view') ?: new Perm(code:'view').save(failOnError: true)

    RefdataCategory.lookupOrCreate("YN","Yes")
    RefdataCategory.lookupOrCreate("YN","No")
    RefdataCategory.lookupOrCreate("YNO","Yes")
    RefdataCategory.lookupOrCreate("YNO","No")
    RefdataCategory.lookupOrCreate("YNO","Other")
    RefdataCategory.lookupOrCreate("YNO","Not applicable")
    RefdataCategory.lookupOrCreate("YNO","Unknown")

    RefdataCategory.lookupOrCreate('CoreStatus', 'Yes');
    RefdataCategory.lookupOrCreate('CoreStatus', 'Print');
    RefdataCategory.lookupOrCreate('CoreStatus', 'Electronic');
    RefdataCategory.lookupOrCreate('CoreStatus', 'Print+Electronic');
    RefdataCategory.lookupOrCreate('CoreStatus', 'No');

    RefdataCategory.lookupOrCreate("ConcurrentAccess","Specified")
    RefdataCategory.lookupOrCreate("ConcurrentAccess","Not Specified")
    RefdataCategory.lookupOrCreate("ConcurrentAccess","No limit")
    RefdataCategory.lookupOrCreate("ConcurrentAccess","Other")

    RefdataCategory.lookupOrCreate("YNO","No")
    RefdataCategory.lookupOrCreate("YNO","Yes")
    RefdataCategory.lookupOrCreate("YNO","Other")
    RefdataCategory.lookupOrCreate("YNO","Unknown")

    RefdataCategory.lookupOrCreate("FactType","JUSP:JR1")
    RefdataCategory.lookupOrCreate("FactType","JUSP:JR1a")
    RefdataCategory.lookupOrCreate("FactType","JUSP:JR1-JR1a")
    RefdataCategory.lookupOrCreate("FactType","JUSP:JR1GOA")

    RefdataCategory.lookupOrCreate("ServiceProvider","Highwire Press")
    RefdataCategory.lookupOrCreate("ServiceProvider","Metapress")
    RefdataCategory.lookupOrCreate("ServiceProvider","Ingentaconnect")
    RefdataCategory.lookupOrCreate("ServiceProvider","Unknown")

    RefdataCategory.lookupOrCreate("SoftwareProvider","Atypon")
    RefdataCategory.lookupOrCreate("SoftwareProvider","Highwire Press")
    RefdataCategory.lookupOrCreate("SoftwareProvider","Metapress")
    RefdataCategory.lookupOrCreate("SoftwareProvider","Unknown")

    def cons_combo = RefdataCategory.lookupOrCreate('Combo Type', 'Consortium');

    def or_licensee_role = RefdataCategory.lookupOrCreate('Organisational Role', 'Licensee');
    def or_subscriber_role = RefdataCategory.lookupOrCreate('Organisational Role', 'Subscriber');
    def or_sc_role = RefdataCategory.lookupOrCreate('Organisational Role', 'Subscription Consortia');
 

    OrgPermShare.assertPermShare(view_permission, or_licensee_role);
    OrgPermShare.assertPermShare(edit_permission, or_licensee_role);
    OrgPermShare.assertPermShare(view_permission, or_subscriber_role);
    OrgPermShare.assertPermShare(edit_permission, or_subscriber_role);
    OrgPermShare.assertPermShare(view_permission, or_sc_role);
    OrgPermShare.assertPermShare(edit_permission, or_sc_role);
    OrgPermShare.assertPermShare(view_permission, cons_combo);


    // Global System Roles
    def userRole = Role.findByAuthority('ROLE_USER') ?: new Role(authority: 'ROLE_USER', roleType:'global').save(failOnError: true)
    def editorRole = Role.findByAuthority('ROLE_EDITOR') ?: new Role(authority: 'ROLE_EDITOR', roleType:'global').save(failOnError: true)
    def adminRole = Role.findByAuthority('ROLE_ADMIN') ?: new Role(authority: 'ROLE_ADMIN', roleType:'global').save(failOnError: true)
    def kbplus_editor = Role.findByAuthority('ROLE_KBPLUS_EDITOR') ?: new Role(authority: 'ROLE_KBPLUS_EDITOR', roleType:'global').save(failOnError: true)
    def apiRole = Role.findByAuthority('ROLE_API') ?: new Role(authority: 'ROLE_API', roleType:'global').save(failOnError: true)
    def sysadminRole = Role.findByAuthority('ROLE_SYSADMIN') ?: new Role(authority: 'ROLE_SYSADMIN', roleType:'global').save(failOnError: true)

    // Institutional Roles
    def institutionalAdmin = Role.findByAuthority('INST_ADM')
    if ( !institutionalAdmin ) {
      institutionalAdmin = new Role(authority: 'INST_ADM', roleType:'user').save(failOnError: true)
    }
    ensurePermGrant(institutionalAdmin,edit_permission);
    ensurePermGrant(institutionalAdmin,view_permission);

    def institutionalUser = Role.findByAuthority('INST_USER') 
    if ( !institutionalUser ) {
      institutionalUser = new Role(authority: 'INST_USER', roleType:'user').save(failOnError: true)
    }
    ensurePermGrant(institutionalUser,view_permission);

    // Allows values to be added to the vocabulary control list by passing an array with RefdataCategory as the key
    // and a list of values to be added to the RefdataValue table.
    grailsApplication.config.refdatavalues.each { rdc, rdvList ->
        rdvList.each { rdv ->
            RefdataCategory.lookupOrCreate(rdc, rdv);
        }
    }

  // Transforms types and formats Refdata 
  // !!! HAS TO BE BEFORE the script adding the Transformers as it is used by those tables !!!
   RefdataCategory.lookupOrCreate('Transform Format', 'json');
   RefdataCategory.lookupOrCreate('Transform Format', 'xml');
   RefdataCategory.lookupOrCreate('Transform Format', 'url');
   RefdataCategory.lookupOrCreate('Transform Type', 'subscription');
   RefdataCategory.lookupOrCreate('Transform Type', 'licence');
   RefdataCategory.lookupOrCreate('Transform Type', 'title');
   RefdataCategory.lookupOrCreate('Transform Type', 'package');
  
  // Add Transformers and Transforms define in the demo-config.groovy
  grailsApplication.config.systransforms.each { tr ->
    def transformName = tr.transforms_name //"${tr.name}-${tr.format}-${tr.type}"
    
    def transforms = Transforms.findByName("${transformName}")
    def transformer = Transformer.findByName("${tr.transformer_name}")
    if ( transformer ) {
      if ( transformer.url != tr.url ) {
        log.debug("Change transformer [${tr.transformer_name}] url to ${tr.url}");
        transformer.url = tr.url;
        transformer.save(failOnError: true, flush: true)
      }
      else {
        log.debug("${tr.transformer_name} present and correct");
      }
    } else {
      log.debug("Create transformer ${tr.transformer_name}...");
      transformer = new Transformer(
            name: tr.transformer_name,
            url: tr.url).save(failOnError: true, flush: true)
    }
    
    log.debug("Create transform ${transformName}...");
    def types = RefdataValue.findAllByOwner(RefdataCategory.findByDesc('Transform Type'))
    def formats = RefdataValue.findAllByOwner(RefdataCategory.findByDesc('Transform Format'))
    
    if ( transforms ) {
      
      if( tr.type ){
        // split values
        def type_list = tr.type.split(",")
        type_list.each { new_type ->
          if( !transforms.accepts_types.any { f -> f.value == new_type } ){
            log.debug("Add transformer [${transformName}] type: ${new_type}");
            def type = types.find{ t -> t.value == new_type }
            transforms.addToAccepts_types(type)
          }
        }
      }
      if ( transforms.accepts_format.value != tr.format ) {
        log.debug("Change transformer [${transformName}] format to ${tr.format}");
        def format = formats.findAll{ t -> t.value == tr.format }
        transforms.accepts_format = format[0]
      }
      if ( transforms.return_mime != tr.return_mime ) {
        log.debug("Change transformer [${transformName}] return format to ${tr.'mime'}");
        transforms.return_mime = tr.return_mime;
      }
      if ( transforms.return_file_extention != tr.return_file_extension ) {
        log.debug("Change transformer [${transformName}] return format to ${tr.'return'}");
        transforms.return_file_extention = tr.return_file_extension;
      }
      if ( transforms.path_to_stylesheet != tr.path_to_stylesheet ) {
        log.debug("Change transformer [${transformName}] return format to ${tr.'path'}");
        transforms.path_to_stylesheet = tr.path_to_stylesheet;
      }
      transforms.save(failOnError: true, flush: true)
    }
    else {
      def format = formats.findAll{ t -> t.value == tr.format }
      
      assert format.size()==1
      
      transforms = new Transforms(
        name: transformName,
        accepts_format: format[0],
        return_mime: tr.return_mime,
        return_file_extention: tr.return_file_extension,
        path_to_stylesheet: tr.path_to_stylesheet,
        transformer: transformer).save(failOnError: true, flush: true)
        
      def type_list = tr.type.split(",")
      type_list.each { new_type ->
        def type = types.find{ t -> t.value == new_type }
        transforms.addToAccepts_types(type)
      }
    }
  }
  
  
    if ( grailsApplication.config.localauth ) { 
      List bootstrap_accounts = grailsApplication.config.getProperty('sysusers', List, []);
      log.debug("localauth is set.. ensure user accounts present (From local config file) ${bootstrap_accounts}");
      if ( bootstrap_accounts.size() > 0 ) {
        bootstrap_accounts.each { su ->
          log.debug("test ${su.name} ${su.pass} ${su.display} ${su.roles}");
          def user = User.findByUsername(su.name)
          if ( user ) {
            log.debug("${su.name} present and correct");
            user.password = su.pass;
            user.email = su.email;
            user.display = su.display;
            user.save(flush:true, failOnError:true);
          }
          else {
            log.debug("Create user...");
            user = new User(
                          username: su.name,
                          password: su.pass,
                          display: su.display,
                          email: su.email,
                          enabled: true).save(failOnError: true)
          }
  
          log.debug("Add roles for ${su.name}");
          su.roles.each { r ->
            def role = Role.findByAuthority(r)
            if ( ! ( user.authorities.contains(role) ) ) {
              log.debug("  -> adding role ${role}");
              UserRole.create user, role
            }
            else {
              log.debug("  -> ${role} already present");
            }
          }
        }
      }
      else {
        log.debug("No bootstrap accounts to set up");
      }
    }
    else {
      log.debug("localauth not configured -- shib mode");
    }
    

    def auto_approve_memberships = Setting.findByName('AutoApproveMemberships') ?: new Setting(name:'AutoApproveMemberships', tp:1, defvalue:'true', value:'true').save();
	
    def feature_zendesk = Setting.findByName('feature.zendesk') ?: new Setting(name:'feature.zendesk', tp:1, defvalue:'true', value:'true').save();

    SpringSecurityUtils.clientRegisterFilter('ediauthFilter', SecurityFilterPosition.PRE_AUTH_FILTER) 

    def uo_with_null_role = UserOrg.findAllByFormalRoleIsNull()
    if ( uo_with_null_role.size() > 0 ) {
      log.warn("There are user org rows with no role set. Please update the table to add role FKs");
    }

    setupRefdata();
    log.debug("refdata setup completed");

    addDefaultJasperReports()
    addDefaultPageMappings()
    createLicenceProperties()
    initializeDefaultSettings()
    tidyDuplicateOrgs()
    updateSystemSavedQueries()
    
    def org_ids_to_update = Org.executeQuery('select o.id from Org as o where o.keyName is null')
    org_ids_to_update.each { org_id ->
      Org.withNewTransaction {
        def org = Org.get(org_id)
        org.keyName = com.k_int.kbplus.utils.TextUtils.generateKeyName(org.name)
        log.debug("Updated org key name to ${org.name} :: ${org.keyName}");
        org.save(flush:true, failOnError:true);
      }
    }

    grailsApplication.config.features.each { k,v ->
      log.info("Feature flag ${k} = ${v}");
    }

    log.debug("Init completed....");
  }

  def tidyDuplicateOrgs() {
    def deleted_org = RefdataCategory.lookupOrCreate(RefdataCategory.ORG_STATUS, "Deleted")
    Org.executeQuery('select lower(o.name), count(*) from Org as o group by lower(o.name) having count(*) > 1').each { r ->
      log.debug("Handle duplicated org : ${r[0]} with count ${r[1]}");
      def canonical_org_id = Org.executeQuery('select min(o.id) from Org as o where lower(o.name) like :n',[n:r[0]]);
      def canonical_org = Org.get(canonical_org_id)
      int ctr = 0;
      Org.executeQuery('select o from Org as o where lower(o.name) like :n and o.id <> :c',[n:r[0], c:canonical_org_id]).each { doid ->
        log.debug("Remap ${doid.id} -> ${canonical_org.id}");
        Alert.executeUpdate('update Alert set org = :neu where org = :old',[neu:canonical_org, old: doid]);
        Combo.executeUpdate('update Combo set fromOrg = :neu where fromOrg = :old',[neu:canonical_org, old: doid]);
        Combo.executeUpdate('update Combo set toOrg = :neu where toOrg = :old',[neu:canonical_org, old: doid]);
        CostItem.executeUpdate('update CostItem set owner = :neu where owner = :old',[neu:canonical_org, old: doid]);
        Fact.executeUpdate('update Fact set supplier = :neu where supplier = :old',[neu:canonical_org, old: doid]);
        Fact.executeUpdate('update Fact set inst = :neu where inst = :old',[neu:canonical_org, old: doid]);
        IdentifierOccurrence.executeUpdate('update IdentifierOccurrence set org = :neu where org = :old',[neu:canonical_org, old: doid]);
        Invoice.executeUpdate('update Invoice set owner = :neu where owner = :old',[neu:canonical_org, old: doid]);
        Order.executeUpdate('update Order set owner = :neu where owner = :old',[neu:canonical_org, old: doid]);
        OrgCustomProperty.executeUpdate('update OrgCustomProperty set owner = :neu where owner = :old',[neu:canonical_org, old: doid]);
        OrgRole.executeUpdate('update OrgRole set org = :neu where org = :old',[neu:canonical_org, old: doid]);
        OrgTitleStats.executeUpdate('update OrgTitleStats set org = :neu where org = :old',[neu:canonical_org, old: doid]);
        OrgVariantName.executeUpdate('update OrgVariantName set owner = :neu where owner = :old',[neu:canonical_org, old: doid]);
        PendingChange.executeUpdate('update PendingChange set owner = :neu where owner = :old',[neu:canonical_org, old: doid]);
        TitleInstitutionProvider.executeUpdate('update TitleInstitutionProvider set institution = :neu where institution = :old',[neu:canonical_org, old: doid]);
        TitleInstitutionProvider.executeUpdate('update TitleInstitutionProvider set provider = :neu where provider = :old',[neu:canonical_org, old: doid]);

        doid.name= '__DELETED_' + (ctr++) +'__'+doid.name
        doid.status = deleted_org
        doid.save(flush:true, failOnError:true);
      }

    }
  }

  def initializeDefaultSettings(){
    def admObj = SystemAdmin.list()
    if(!admObj){
        log.debug("No SystemAdmin object found, creating new.");
        admObj = new SystemAdmin(name:"demo").save();
    }else{
      admObj = admObj.first()
    }
    //Will not overwrite any existing database properties.
    createDefaultSysProps(admObj);
    admObj.refresh()
    log.debug("Finished updating config from SystemAdmin")
  }

  def createDefaultSysProps(admObj){
    def requiredProps = [
    [propname:"onix_ghost_licence",descr:PropertyDefinition.SYS_CONF,type:String.toString(),val:"Jisc Collections Model Journals Licence 2015",note:"Default licence used for comparison when viewing a single onix licence."],
    [propname:"net.sf.jasperreports.export.csv.exclude.origin.keep.first.band.1",descr:PropertyDefinition.SYS_CONF,type:String.toString(),val:"columnHeader",note:"Only show 1 column header for csv"],
    [propname:"net.sf.jasperreports.export.xls.exclude.origin.keep.first.band.1",descr:PropertyDefinition.SYS_CONF,type:String.toString(),val:"columnHeader",note:"Only show 1 column header for xls"],
    [propname:"net.sf.jasperreports.export.xls.exclude.origin.band.1",descr:PropertyDefinition.SYS_CONF,type:String.toString(),val:"pageHeader",note:" Remove header/footer from csv/xls"],
    [propname:"net.sf.jasperreports.export.xls.exclude.origin.band.2",descr:PropertyDefinition.SYS_CONF,type:String.toString(),val:"pageFooter",note:" Remove header/footer from csv/xls"],
    [propname:"net.sf.jasperreports.export.csv.exclude.origin.band.1",descr:PropertyDefinition.SYS_CONF,type:String.toString(),val:"pageHeader",note:" Remove header/footer from csv/xls"],
    [propname:"net.sf.jasperreports.export.csv.exclude.origin.band.2",descr:PropertyDefinition.SYS_CONF,type:String.toString(),val:"pageFooter",note:" Remove header/footer from csv/xls"]
    ]
    createCustomProperties(requiredProps)
    requiredProps.each{
      def type = PropertyDefinition.findByNameAndDescr(it.propname,it.descr)
      if(!SystemAdminCustomProperty.findByType(type)){
        def newProp = new SystemAdminCustomProperty(type:type,owner:admObj,stringValue:it.val,note:it.note)
        newProp.save()
      }
    }
  }


  def createLicenceProperties() {
    log.debug("createLicenceProperties()");
    // def existingProps = LicenseCustomProperty.findAll() -- Comment this out - it seems not to be used.

    log.debug("Define required props");
    def requiredProps = [[propname:"Concurrent Access", descr:PropertyDefinition.LIC_PROP,type:RefdataValue.class.name, cat:'ConcurrentAccess'],
                         [propname:"Concurrent Users", descr:PropertyDefinition.LIC_PROP,type: Integer.class.name],
                         [propname:"Remote Access", descr:PropertyDefinition.LIC_PROP,type: RefdataValue.class.name, cat:'YNO'],
                         [propname:"Walk In Access", descr:PropertyDefinition.LIC_PROP,type: RefdataValue.class.name, cat:'YNO'],
                         [propname:"Multi Site Access", descr:PropertyDefinition.LIC_PROP,type: RefdataValue.class.name, cat:'YNO'],
                         [propname:"Partners Access", descr:PropertyDefinition.LIC_PROP,type: RefdataValue.class.name, cat:'YNO'],
                         [propname:"Alumni Access", descr:PropertyDefinition.LIC_PROP,type: RefdataValue.class.name, cat:'YNO'],
                         [propname:"ILL - InterLibraryLoans", descr:PropertyDefinition.LIC_PROP,type: RefdataValue.class.name, cat:'YNO'],
                         [propname:"Include In Coursepacks", descr:PropertyDefinition.LIC_PROP,type: RefdataValue.class.name, cat:'YNO'],
                         [propname:"Include in VLE", descr:PropertyDefinition.LIC_PROP,type: RefdataValue.class.name, cat:'YNO'],
                         [propname:"Enterprise Access", descr:PropertyDefinition.LIC_PROP,type: RefdataValue.class.name, cat:'YNO'],
                         [propname:"Post Cancellation Access Entitlement", descr:PropertyDefinition.LIC_PROP,type: RefdataValue.class.name, cat:'YNO'], 
                         [propname:"Cancellation Allowance", descr:PropertyDefinition.LIC_PROP,type: String.class.name], 
                         [propname:"Notice Period", descr:PropertyDefinition.LIC_PROP,type: String.class.name], 
                         [propname:"Signed", descr:PropertyDefinition.LIC_PROP,type: RefdataValue.class.name, cat:'YNO']]

    createCustomProperties(requiredProps)
    log.debug("createLicenceProperties completed");
  }
    
  def createCustomProperties(requiredProps){

    requiredProps.each{ default_prop ->

      log.debug("Checking ${default_prop.propname}");

      def existing_prop = PropertyDefinition.findByName(default_prop.propname)
      if ( existing_prop ) {
          if ( ( existing_prop.type != default_prop.type ) || ( existing_prop.descr != default_prop.descr ) ) {
            log.debug("Exists - updating");
            existing_prop.type = default_prop.type
            existing_prop.descr = default_prop.descr
            existing_prop.save()
          }
          else {
            log.debug("Exists - OK");
          }
      } else {
          log.debug("Unable to locate property definition for ${default_prop.propname}.. Creating");
          def newProp = new PropertyDefinition(name: default_prop.propname, 
                                               type: default_prop.type, 
                                               descr: default_prop.descr)
          if ( default_prop.cat != null )
            newProp.setRefdataCategory(default_prop.cat);

          newProp.save(failOnError:true)
       }
    }
  }

  def addDefaultPageMappings(){
      if(! SitePage.findAll()){
        def home = new SitePage(alias:"Home", action:"index",controller:"home").save()
        def profile = new SitePage(alias:"Profile", action:"index",controller:"profile").save()
        def pages = new SitePage(alias:"Pages", action:"managePages",controller:"spotlight").save()

        // dataloadService.updateSiteMapping()
      }

  }
  def addDefaultJasperReports(){
        //Add default Jasper reports, if there are currently no reports in DB
    log.debug("Query database for jasper reports")
    def reportsFound = JasperReportFile.findAll()
    def defaultReports = ["floating_titles",
                          "match_coverage",
                          "no_identifiers",
                          "title_no_url",
                          "previous_expected_sub",
                          "previous_expected_pkg",
                          "duplicate_titles",
                          "duplicate_orgs"]
    defaultReports.each { reportName ->

      def path = "jasper_reports/"
      def filePath = path + reportName + ".jrxml"
      def inputStreamBytes = grailsApplication.parentContext.getResource("classpath:$filePath").inputStream.bytes
      def newReport = reportsFound.find{ it.name == reportName }
      if( newReport ){
        newReport.setReportFile(inputStreamBytes)
        newReport.save()
      }else{
        newReport = new JasperReportFile(name:reportName, reportFile: inputStreamBytes).save()
      }
      if(newReport.hasErrors()){
        log.error("Jasper Report creation for "+reportName+".jrxml failed with errors: \n")
        newReport.errors.each{
          log.error(it+"\n")
        }
      }   
    } 

    // Subscription.metaClass.static.methodMissing = { String methodName, args ->
    //   if ( methodName.startsWith('setNsId') ) {
    //     log.debug("methodMissing ${methodName}, ${args}");
    //   }
    //   else {
    //     throw new groovy.lang.MissingMethodException(methodName);
    //   }
    // }
  }
  def destroy = {
  }

  def ensurePermGrant(role,perm) {
    log.debug("ensurePermGrant(${role},${perm})");
    def existingPermGrant = PermGrant.findByRoleAndPerm(role,perm)
    if ( !existingPermGrant ) {
      log.debug("Create new perm grant for ${role}, ${perm}");
      def new_grant = new PermGrant(role:role, perm:perm).save();
    }
    else {
      log.debug("grant already exists ${role}, ${perm}");
    }
  }

  /**
  * RefdataValue.group is used only for OrgRole to filter the types of role available in 'Add Role' action 
  * This is done by providing 'linkType' (using instance class) to the '_orgLinksModal' template.
  */
  def setOrgRoleGroups() {
    def lic = License.name
    def sub = Subscription.name
    def pkg = Package.name
    def valMap = ["Licensor":lic,"Licensee":lic,"Licensing Consortium":lic,"Negotiator":lic,"Subscriber":sub,
    "Provider":sub,"Subscription Agent":sub,"Subscription Consortia":sub,"Content Provider":pkg,"Package Consortia":pkg]
    valMap.each{role,group->
      def val = RefdataCategory.lookupOrCreate("Organisational Role",role)
      val.setGroup(group)
      val.save()
    }
  }
  // Setup extra refdata
  def setupRefdata = { 
    setOrgRoleGroups()
    // -------------------------------------------------------------------
    // ONIX-PL Additions
    // -------------------------------------------------------------------
    // New document type
    RefdataCategory.lookupOrCreate('Document Type','ONIX-PL Licence')
    RefdataCategory.lookupOrCreate('Document Type','Licence')

    // Controlled values from the <UsageType> element.

    RefdataCategory.lookupOrCreate('UsageStatus', 'greenTick',      'UseForDataMining')
    RefdataCategory.lookupOrCreate('UsageStatus', 'greenTick',      'InterpretedAsPermitted')
    RefdataCategory.lookupOrCreate('UsageStatus', 'redCross',       'InterpretedAsProhibited')
    RefdataCategory.lookupOrCreate('UsageStatus', 'greenTick',      'Permitted')
    RefdataCategory.lookupOrCreate('UsageStatus', 'redCross',       'Prohibited')
    RefdataCategory.lookupOrCreate('UsageStatus', 'purpleQuestion', 'SilentUninterpreted')
    RefdataCategory.lookupOrCreate('UsageStatus', 'purpleQuestion', 'NotApplicable')

    RefdataCategory.lookupOrCreate("TitleInstancePackagePlatform.DelayedOA", "No").save()
    RefdataCategory.lookupOrCreate("TitleInstancePackagePlatform.DelayedOA", "Unknown").save()
    RefdataCategory.lookupOrCreate("TitleInstancePackagePlatform.DelayedOA", "Yes").save()

    RefdataCategory.lookupOrCreate("TitleInstancePackagePlatform.HybridOA", "No").save()
    RefdataCategory.lookupOrCreate("TitleInstancePackagePlatform.HybridOA", "Unknown").save()
    RefdataCategory.lookupOrCreate("TitleInstancePackagePlatform.HybridOA", "Yes").save()

    RefdataCategory.lookupOrCreate("Tipp.StatusReason", "Transfer Out").save()
    RefdataCategory.lookupOrCreate("Tipp.StatusReason", "Transfer In").save()

    RefdataCategory.lookupOrCreate("TitleInstancePackagePlatform.PaymentType", "Complimentary").save()
    RefdataCategory.lookupOrCreate("TitleInstancePackagePlatform.PaymentType", "Limited Promotion").save()
    RefdataCategory.lookupOrCreate("TitleInstancePackagePlatform.PaymentType", "Paid").save()
    RefdataCategory.lookupOrCreate("TitleInstancePackagePlatform.PaymentType", "OA").save()
    RefdataCategory.lookupOrCreate("TitleInstancePackagePlatform.PaymentType", "Opt Out Promotion").save()
    RefdataCategory.lookupOrCreate("TitleInstancePackagePlatform.PaymentType", "Uncharged").save()
    RefdataCategory.lookupOrCreate("TitleInstancePackagePlatform.PaymentType", "Unknown").save()
  
    RefdataCategory.lookupOrCreate(RefdataCategory.TIPP_STATUS, "Current").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.TIPP_STATUS, "Expected").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.TIPP_STATUS, "Deleted").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.TIPP_STATUS, "Transferred").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.TIPP_STATUS, "Unknown").save()

    RefdataCategory.lookupOrCreate(RefdataCategory.ORG_STATUS, "Unknown").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.ORG_STATUS, "Current").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.ORG_STATUS, "Deleted").save()

    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_LIST_STAT, "Checked").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_LIST_STAT, "In Progress").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_BREAKABLE, "No").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_BREAKABLE, "Yes").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_BREAKABLE, "Unknown").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_CONSISTENT, "No").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_CONSISTENT, "Yes").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_CONSISTENT, "Unknown").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_FIXED, "No").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_FIXED, "Yes").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_FIXED, "Unknown").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_SCOPE, "Aggregator").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_SCOPE, "Front File").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_SCOPE, "Back File").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_SCOPE, "Master File").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.PKG_SCOPE, "Scope Undefined").save()

    RefdataCategory.lookupOrCreate("PendingChangeStatus", "Pending").save()
    RefdataCategory.lookupOrCreate("PendingChangeStatus", "Accepted").save()
    RefdataCategory.lookupOrCreate("PendingChangeStatus", "Rejected").save()

    RefdataCategory.lookupOrCreate("LicenseCategory", "Content").save()
    RefdataCategory.lookupOrCreate("LicenseCategory", "Software").save()
    RefdataCategory.lookupOrCreate("LicenseCategory", "Other").save()

    RefdataCategory.lookupOrCreate(RefdataCategory.TI_STATUS, "Current").save()
    RefdataCategory.lookupOrCreate(RefdataCategory.TI_STATUS, "Deleted").save()

    RefdataCategory.lookupOrCreate("License Status", "In Progress").save()

    RefdataCategory.lookupOrCreate('OrgType', 'Consortium').save();
    RefdataCategory.lookupOrCreate('OrgType', 'Institution').save();
    RefdataCategory.lookupOrCreate('OrgType', 'Other').save();

	RefdataCategory.lookupOrCreate('IEMedium', 'Print').save();
    RefdataCategory.lookupOrCreate('IEMedium', 'Electronic').save();
    RefdataCategory.lookupOrCreate('IEMedium', 'Print and Electronic').save();
	
	RefdataCategory.lookupOrCreate('Relationship', 'Manual').save();
	RefdataCategory.lookupOrCreate('Relationship', 'Auto').save();
	RefdataCategory.lookupOrCreate('Relationship', 'Independent').save();

    log.debug("validate content items...");
    // The default template for a property change on a title
    ContentItem.lookupOrCreate('ChangeNotification.TitleInstance.propertyChange','','''
Title change - The <strong>${evt.prop}</strong> field was changed from  "<strong>${evt.oldLabel?:evt.old}</strong>" to "<strong>${evt.newLabel?:evt.new}</strong>".
''');

    ContentItem.lookupOrCreate('ChangeNotification.TitleInstance.identifierAdded','','''
An identifier was added to title ${OID?.title}.
''');

    ContentItem.lookupOrCreate('ChangeNotification.TitleInstance.identifierRemoved','','''
An identifier was removed from title ${OID?.title}.
''');

    ContentItem.lookupOrCreate('ChangeNotification.TitleInstancePackagePlatform.updated','','''
TIPP change for title ${OID?.title?.title} - The <strong>${evt.prop}</strong> field was changed from  "<strong>${evt.oldLabel?:evt.old}</strong>" to "<strong>${evt.newLabel?:evt.new}</strong>".
''');

    ContentItem.lookupOrCreate('ChangeNotification.TitleInstancePackagePlatform.added','','''
TIPP Added for title ${OID?.title?.title} ${evt.linkedTitle} on platform ${evt.linkedPlatform} .
''');

    ContentItem.lookupOrCreate('ChangeNotification.TitleInstancePackagePlatform.deleted','','''
TIPP Deleted for title ${OID?.title?.title} ${evt.linkedTitle} on platform ${evt.linkedPlatform} .
''');

    ContentItem.lookupOrCreate('ChangeNotification.Package.created','','''
New package added with id ${OID.id} - "${OID.name}".
''');

    ContentItem.lookupOrCreate('kbplus.noHostPlatformURL','','''
No Host Platform URL Content
''');

    ContentItem.lookupOrCreate('kbplus.cookies','','Placeholder - cookies');
    ContentItem.lookupOrCreate('kbplus.privacy','','Placeholder - privacy');
    ContentItem.lookupOrCreate('kbplus.accessibility','','Placeholder - accessibility');

    ContentItem.lookupOrCreate('dash.export.title','','KB+ Export');
    ContentItem.lookupOrCreate('dash.export.brief','','Export all your KB+ data to a zip file');

   RefdataCategory.lookupOrCreate('CostItemStatus', 'Estimated').save();
   RefdataCategory.lookupOrCreate('CostItemStatus', 'Ordered').save();
   RefdataCategory.lookupOrCreate('CostItemStatus', 'Pending').save();
   RefdataCategory.lookupOrCreate('CostItemStatus', 'Paid').save();

   RefdataCategory.lookupOrCreate('CostItemCategory', 'Debit').save();
   RefdataCategory.lookupOrCreate('CostItemCategory', 'Credit').save();

   RefdataCategory.lookupOrCreate('CostItemElement', 'Admin Fee').save();
   RefdataCategory.lookupOrCreate('CostItemElement', 'Content Fee').save();
   RefdataCategory.lookupOrCreate('CostItemElement', 'Platform Fee').save();
   RefdataCategory.lookupOrCreate('CostItemElement', 'Bank Charge').save();
   RefdataCategory.lookupOrCreate('CostItemElement', 'Other').save();

   RefdataCategory.lookupOrCreate('TaxType', 'On Invoice').save();
   RefdataCategory.lookupOrCreate('TaxType', 'Self Declared').save();

   RefdataCategory.lookupOrCreate('Currency','AED - United Arab Emirates Dirham').save()
   RefdataCategory.lookupOrCreate('Currency','AFN - Afghanistan Afghani').save()
   RefdataCategory.lookupOrCreate('Currency','ALL - Albania Lek').save()
   RefdataCategory.lookupOrCreate('Currency','AMD - Armenia Dram').save()
   RefdataCategory.lookupOrCreate('Currency','ANG - Netherlands Antilles Guilder').save()
   RefdataCategory.lookupOrCreate('Currency','AOA - Angola Kwanza').save()
   RefdataCategory.lookupOrCreate('Currency','ARS - Argentina Peso').save()
   RefdataCategory.lookupOrCreate('Currency','AUD - Australia Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','AWG - Aruba Guilder').save()
   RefdataCategory.lookupOrCreate('Currency','AZN - Azerbaijan New Manat').save()
   RefdataCategory.lookupOrCreate('Currency','BAM - Bosnia and Herzegovina Convertible Marka').save()
   RefdataCategory.lookupOrCreate('Currency','BBD - Barbados Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','BDT - Bangladesh Taka').save()
   RefdataCategory.lookupOrCreate('Currency','BGN - Bulgaria Lev').save()
   RefdataCategory.lookupOrCreate('Currency','BHD - Bahrain Dinar').save()
   RefdataCategory.lookupOrCreate('Currency','BIF - Burundi Franc').save()
   RefdataCategory.lookupOrCreate('Currency','BMD - Bermuda Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','BND - Brunei Darussalam Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','BOB - Bolivia Boliviano').save()
   RefdataCategory.lookupOrCreate('Currency','BRL - Brazil Real').save()
   RefdataCategory.lookupOrCreate('Currency','BSD - Bahamas Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','BTN - Bhutan Ngultrum').save()
   RefdataCategory.lookupOrCreate('Currency','BWP - Botswana Pula').save()
   RefdataCategory.lookupOrCreate('Currency','BYR - Belarus Ruble').save()
   RefdataCategory.lookupOrCreate('Currency','BZD - Belize Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','CAD - Canada Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','CDF - Congo/Kinshasa Franc').save()
   RefdataCategory.lookupOrCreate('Currency','CHF - Switzerland Franc').save()
   RefdataCategory.lookupOrCreate('Currency','CLP - Chile Peso').save()
   RefdataCategory.lookupOrCreate('Currency','CNY - China Yuan Renminbi').save()
   RefdataCategory.lookupOrCreate('Currency','COP - Colombia Peso').save()
   RefdataCategory.lookupOrCreate('Currency','CRC - Costa Rica Colon').save()
   RefdataCategory.lookupOrCreate('Currency','CUC - Cuba Convertible Peso').save()
   RefdataCategory.lookupOrCreate('Currency','CUP - Cuba Peso').save()
   RefdataCategory.lookupOrCreate('Currency','CVE - Cape Verde Escudo').save()
   RefdataCategory.lookupOrCreate('Currency','CZK - Czech Republic Koruna').save()
   RefdataCategory.lookupOrCreate('Currency','DJF - Djibouti Franc').save()
   RefdataCategory.lookupOrCreate('Currency','DKK - Denmark Krone').save()
   RefdataCategory.lookupOrCreate('Currency','DOP - Dominican Republic Peso').save()
   RefdataCategory.lookupOrCreate('Currency','DZD - Algeria Dinar').save()
   RefdataCategory.lookupOrCreate('Currency','EGP - Egypt Pound').save()
   RefdataCategory.lookupOrCreate('Currency','ERN - Eritrea Nakfa').save()
   RefdataCategory.lookupOrCreate('Currency','ETB - Ethiopia Birr').save()
   RefdataCategory.lookupOrCreate('Currency','EUR - Euro Member Countries').save()
   RefdataCategory.lookupOrCreate('Currency','FJD - Fiji Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','FKP - Falkland Islands (Malvinas) Pound').save()
   RefdataCategory.lookupOrCreate('Currency','GBP - United Kingdom Pound').save()
   RefdataCategory.lookupOrCreate('Currency','GEL - Georgia Lari').save()
   RefdataCategory.lookupOrCreate('Currency','GGP - Guernsey Pound').save()
   RefdataCategory.lookupOrCreate('Currency','GHS - Ghana Cedi').save()
   RefdataCategory.lookupOrCreate('Currency','GIP - Gibraltar Pound').save()
   RefdataCategory.lookupOrCreate('Currency','GMD - Gambia Dalasi').save()
   RefdataCategory.lookupOrCreate('Currency','GNF - Guinea Franc').save()
   RefdataCategory.lookupOrCreate('Currency','GTQ - Guatemala Quetzal').save()
   RefdataCategory.lookupOrCreate('Currency','GYD - Guyana Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','HKD - Hong Kong Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','HNL - Honduras Lempira').save()
   RefdataCategory.lookupOrCreate('Currency','HRK - Croatia Kuna').save()
   RefdataCategory.lookupOrCreate('Currency','HTG - Haiti Gourde').save()
   RefdataCategory.lookupOrCreate('Currency','HUF - Hungary Forint').save()
   RefdataCategory.lookupOrCreate('Currency','IDR - Indonesia Rupiah').save()
   RefdataCategory.lookupOrCreate('Currency','ILS - Israel Shekel').save()
   RefdataCategory.lookupOrCreate('Currency','IMP - Isle of Man Pound').save()
   RefdataCategory.lookupOrCreate('Currency','INR - India Rupee').save()
   RefdataCategory.lookupOrCreate('Currency','IQD - Iraq Dinar').save()
   RefdataCategory.lookupOrCreate('Currency','IRR - Iran Rial').save()
   RefdataCategory.lookupOrCreate('Currency','ISK - Iceland Krona').save()
   RefdataCategory.lookupOrCreate('Currency','JEP - Jersey Pound').save()
   RefdataCategory.lookupOrCreate('Currency','JMD - Jamaica Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','JOD - Jordan Dinar').save()
   RefdataCategory.lookupOrCreate('Currency','JPY - Japan Yen').save()
   RefdataCategory.lookupOrCreate('Currency','KES - Kenya Shilling').save()
   RefdataCategory.lookupOrCreate('Currency','KGS - Kyrgyzstan Som').save()
   RefdataCategory.lookupOrCreate('Currency','KHR - Cambodia Riel').save()
   RefdataCategory.lookupOrCreate('Currency','KMF - Comoros Franc').save()
   RefdataCategory.lookupOrCreate('Currency','KPW - Korea (North) Won').save()
   RefdataCategory.lookupOrCreate('Currency','KRW - Korea (South) Won').save()
   RefdataCategory.lookupOrCreate('Currency','KWD - Kuwait Dinar').save()
   RefdataCategory.lookupOrCreate('Currency','KYD - Cayman Islands Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','KZT - Kazakhstan Tenge').save()
   RefdataCategory.lookupOrCreate('Currency','LAK - Laos Kip').save()
   RefdataCategory.lookupOrCreate('Currency','LBP - Lebanon Pound').save()
   RefdataCategory.lookupOrCreate('Currency','LKR - Sri Lanka Rupee').save()
   RefdataCategory.lookupOrCreate('Currency','LRD - Liberia Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','LSL - Lesotho Loti').save()
   RefdataCategory.lookupOrCreate('Currency','LYD - Libya Dinar').save()
   RefdataCategory.lookupOrCreate('Currency','MAD - Morocco Dirham').save()
   RefdataCategory.lookupOrCreate('Currency','MDL - Moldova Leu').save()
   RefdataCategory.lookupOrCreate('Currency','MGA - Madagascar Ariary').save()
   RefdataCategory.lookupOrCreate('Currency','MKD - Macedonia Denar').save()
   RefdataCategory.lookupOrCreate('Currency','MMK - Myanmar (Burma) Kyat').save()
   RefdataCategory.lookupOrCreate('Currency','MNT - Mongolia Tughrik').save()
   RefdataCategory.lookupOrCreate('Currency','MOP - Macau Pataca').save()
   RefdataCategory.lookupOrCreate('Currency','MRO - Mauritania Ouguiya').save()
   RefdataCategory.lookupOrCreate('Currency','MUR - Mauritius Rupee').save()
   RefdataCategory.lookupOrCreate('Currency','MVR - Maldives (Maldive Islands) Rufiyaa').save()
   RefdataCategory.lookupOrCreate('Currency','MWK - Malawi Kwacha').save()
   RefdataCategory.lookupOrCreate('Currency','MXN - Mexico Peso').save()
   RefdataCategory.lookupOrCreate('Currency','MYR - Malaysia Ringgit').save()
   RefdataCategory.lookupOrCreate('Currency','MZN - Mozambique Metical').save()
   RefdataCategory.lookupOrCreate('Currency','NAD - Namibia Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','NGN - Nigeria Naira').save()
   RefdataCategory.lookupOrCreate('Currency','NIO - Nicaragua Cordoba').save()
   RefdataCategory.lookupOrCreate('Currency','NOK - Norway Krone').save()
   RefdataCategory.lookupOrCreate('Currency','NPR - Nepal Rupee').save()
   RefdataCategory.lookupOrCreate('Currency','NZD - New Zealand Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','OMR - Oman Rial').save()
   RefdataCategory.lookupOrCreate('Currency','PAB - Panama Balboa').save()
   RefdataCategory.lookupOrCreate('Currency','PEN - Peru Nuevo Sol').save()
   RefdataCategory.lookupOrCreate('Currency','PGK - Papua New Guinea Kina').save()
   RefdataCategory.lookupOrCreate('Currency','PHP - Philippines Peso').save()
   RefdataCategory.lookupOrCreate('Currency','PKR - Pakistan Rupee').save()
   RefdataCategory.lookupOrCreate('Currency','PLN - Poland Zloty').save()
   RefdataCategory.lookupOrCreate('Currency','PYG - Paraguay Guarani').save()
   RefdataCategory.lookupOrCreate('Currency','QAR - Qatar Riyal').save()
   RefdataCategory.lookupOrCreate('Currency','RON - Romania New Leu').save()
   RefdataCategory.lookupOrCreate('Currency','RSD - Serbia Dinar').save()
   RefdataCategory.lookupOrCreate('Currency','RUB - Russia Ruble').save()
   RefdataCategory.lookupOrCreate('Currency','RWF - Rwanda Franc').save()
   RefdataCategory.lookupOrCreate('Currency','SAR - Saudi Arabia Riyal').save()
   RefdataCategory.lookupOrCreate('Currency','SBD - Solomon Islands Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','SCR - Seychelles Rupee').save()
   RefdataCategory.lookupOrCreate('Currency','SDG - Sudan Pound').save()
   RefdataCategory.lookupOrCreate('Currency','SEK - Sweden Krona').save()
   RefdataCategory.lookupOrCreate('Currency','SGD - Singapore Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','SHP - Saint Helena Pound').save()
   RefdataCategory.lookupOrCreate('Currency','SLL - Sierra Leone Leone').save()
   RefdataCategory.lookupOrCreate('Currency','SOS - Somalia Shilling').save()
   RefdataCategory.lookupOrCreate('Currency','SPL* - Seborga Luigino').save()
   RefdataCategory.lookupOrCreate('Currency','SRD - Suriname Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','STD - São Tomé and Príncipe Dobra').save()
   RefdataCategory.lookupOrCreate('Currency','SVC - El Salvador Colon').save()
   RefdataCategory.lookupOrCreate('Currency','SYP - Syria Pound').save()
   RefdataCategory.lookupOrCreate('Currency','SZL - Swaziland Lilangeni').save()
   RefdataCategory.lookupOrCreate('Currency','THB - Thailand Baht').save()
   RefdataCategory.lookupOrCreate('Currency','TJS - Tajikistan Somoni').save()
   RefdataCategory.lookupOrCreate('Currency','TMT - Turkmenistan Manat').save()
   RefdataCategory.lookupOrCreate('Currency','TND - Tunisia Dinar').save()
   RefdataCategory.lookupOrCreate('Currency','TOP - Tonga Pa\'anga').save()
   RefdataCategory.lookupOrCreate('Currency','TRY - Turkey Lira').save()
   RefdataCategory.lookupOrCreate('Currency','TTD - Trinidad and Tobago Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','TVD - Tuvalu Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','TWD - Taiwan New Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','TZS - Tanzania Shilling').save()
   RefdataCategory.lookupOrCreate('Currency','UAH - Ukraine Hryvnia').save()
   RefdataCategory.lookupOrCreate('Currency','UGX - Uganda Shilling').save()
   RefdataCategory.lookupOrCreate('Currency','USD - United States Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','UYU - Uruguay Peso').save()
   RefdataCategory.lookupOrCreate('Currency','UZS - Uzbekistan Som').save()
   RefdataCategory.lookupOrCreate('Currency','VEF - Venezuela Bolivar').save()
   RefdataCategory.lookupOrCreate('Currency','VND - Viet Nam Dong').save()
   RefdataCategory.lookupOrCreate('Currency','VUV - Vanuatu Vatu').save()
   RefdataCategory.lookupOrCreate('Currency','WST - Samoa Tala').save()
   RefdataCategory.lookupOrCreate('Currency','XAF - Communauté Financière Africaine (BEAC) CFA Franc BEAC').save()
   RefdataCategory.lookupOrCreate('Currency','XCD - East Caribbean Dollar').save()
   RefdataCategory.lookupOrCreate('Currency','XDR - International Monetary Fund (IMF) Special Drawing Rights').save()
   RefdataCategory.lookupOrCreate('Currency','XOF - Communauté Financière Africaine (BCEAO) Franc').save()
   RefdataCategory.lookupOrCreate('Currency','XPF - Comptoirs Français du Pacifique (CFP) Franc').save()
   RefdataCategory.lookupOrCreate('Currency','YER - Yemen Rial').save()
   RefdataCategory.lookupOrCreate('Currency','ZAR - South Africa Rand').save()
   RefdataCategory.lookupOrCreate('Currency','ZMW - Zambia Kwacha').save()
   RefdataCategory.lookupOrCreate('Currency','ZWD - Zimbabwe Dollar').save()
 
    // def gokb_record_source = GlobalRecordSource.findByIdentifier('gokbPackages') ?: new GlobalRecordSource(
    //                                                                                       identifier:'gokbPackages',
    //                                                                                       name:'GOKB',
    //                                                                                       type:'OAI',
    //                                                                                       haveUpTo:null,
    //                                                                                       uri:'https://gokb.kuali.org/gokb/oai/packages',
    //                                                                                       listPrefix:'oai_dc',
    //                                                                                       fullPrefix:'gokb',
    //                                                                                       principal:null,
    //                                                                                       credentials:null,
    //                                                                                       rectype:0)
    // gokb_record_source.save(flush:true, stopOnError:true);
    // log.debug("New gokb record source: ${gokb_record_source}");

    // Sort string generation moved to admin - cleanse

      //Reminders for Cron
      RefdataCategory.lookupOrCreate("ReminderMethod","email")

      RefdataCategory.lookupOrCreate("ReminderUnit","Day")
      RefdataCategory.lookupOrCreate("ReminderUnit","Week")
      RefdataCategory.lookupOrCreate("ReminderUnit","Month")

      RefdataCategory.lookupOrCreate("ReminderTrigger","Subscription Manual Renewal Date")

  }
 
  def updateSystemSavedQueries() {

    def admin_user = User.findByUsername('admin')
    if ( admin_user != null ) {
      // Add any default system queries here by adding  well known reference and some sql. Formatting is important as the data managers
      // will want to modify and extend this SQL, so please make sure it's readable. Column aliases are used for display.
      def sq_info_list = [
        [
          ref:'DupTitle',
          query:'''
  select dt.ti_id TitleId, 
         dt.ti_title Title, 
         tis.ids TitleIds
  from duplicate_titles dt, 
       title_identifiers tis 
  where tis.ti_id = dt.ti_id
  ''',
          type:'sql',
          owner:'admin'
        ]
      ]
  
      sq_info_list.each { sq_info ->
        log.debug("SavedQuery ${sq_info.ref}");
        def sq = SavedQuery.findByRef(sq_info.ref) 
  
        if ( sq == null ) {
          // Could not look up existing query to update - create
          sq = new SavedQuery(
                              ref:sq_info.ref, 
                              query:sq_info.query,
                              type:sq_info.type,
                              owner:User.findByUsername(sq_info.owner)).save(flush:true, failOnError:true);
        }
        else {
          // Found an existing saved query - update it
          if ( ( sq.query != sq_info.query ) || ( sq.type != sq_info.type ) ) {
            sq.query = sq_info.query
            sq.type = sq_info.type
            sq.save(flush:true, failOnError:true);
          }
        }
      }
    }
    else {
      log.error("No admin user present - unable to update");
    }
  }
  
}
