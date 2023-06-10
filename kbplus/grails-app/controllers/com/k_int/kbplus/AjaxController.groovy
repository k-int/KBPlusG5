package com.k_int.kbplus

import org.springframework.dao.DataIntegrityViolationException
import com.k_int.kbplus.auth.User
import grails.plugin.springsecurity.annotation.Secured
import grails.converters.*
import com.k_int.custprops.PropertyDefinition
import org.grails.orm.hibernate.cfg.GrailsHibernateUtil

class AjaxController {
    def refdata_config = [
    "ContentProvider" : [
      domain:'Org',
      countQry:'select count(o) from Org as o where lower(o.name) like :n  or exists ( from o.variantNames vn where lower(vn.variantName) like :n )',
      rowQry:'select o from Org as o where lower(o.name) like :n or exists ( from o.variantNames vn where lower(vn.variantName) like :n ) order by o.name asc',
      qryParams:[
              [
                param:'sSearch',
                bv:'n',
                clos:{ value ->
                    def result = '%'
                    if ( value && ( value.length() > 0 ) )
                        result = "%${value.trim().toLowerCase()}%"
                    result
                }
              ]
      ],
      cols:['name'],
      format:'map'
    ],
    "Licenses" : [
      domain:'License',
      countQry:"select count(l) from License as l",
      rowQry:"select l from License as l",
      qryParams:[],
      cols:['reference'],
      format:'simple'
    ],
    'Currency' : [
      domain:'RefdataValue',
      countQry:"select count(rdv) from RefdataValue as rdv where rdv.owner.desc='Currency'",
      rowQry:"select rdv from RefdataValue as rdv where rdv.owner.desc='Currency'",
      qryParams:[
                   [
                      param:'iDisplayLength',
                      value: 200
                   ]
      ],
      cols:['value'],
      format:'simple'
    ]
  ]


  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def setValue() {
    // [id:1, value:JISC_Collections_NESLi2_Lic_IOP_Institute_of_Physics_NESLi2_2011-2012_01012011-31122012.., type:License, action:inPlaceSave, controller:ajax
    // def clazz=grailsApplication.domainClasses.findByFullName(params.type)
    // log.debug("setValue ${params}");
    def domain_class=grailsApplication.getArtefact('Domain',"com.k_int.kbplus.${params.type}")
    if ( domain_class ) {
      def instance = domain_class.getClazz().get(params.id) 
      if ( instance ) {
        // log.debug("Got instance ${instance}");
        def binding_properties = [ "${params.elementid}":params.value ]
        // log.debug("Merge: ${binding_properties}");
        // see http://grails.org/doc/latest/ref/Controllers/bindData.html
        if ( binding_properties[params.elementid] == '__NULL__' ) {
          binding_properties[params.elementid] = null;
        }
        bindData(instance, binding_properties)
        instance.save(flush:true);
      }
      else {
        log.debug("no instance");
      }
    }
    else {
      log.debug("no type");
    }

    response.setContentType('text/plain')
    def outs = response.outputStream
    outs << params.value
    outs.flush()
    outs.close()
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def setRef() {
    def rdv = RefdataCategory.lookupOrCreate(params.cat, params.value)
    def domain_class=grailsApplication.getArtefact('Domain',"com.k_int.kbplus.${params.type}")
    if ( domain_class ) {
      def instance = domain_class.getClazz().get(params.id)
      if ( instance ) {
        // log.debug("Got instance ${instance}");
        // Lookup refdata value
        def binding_properties = [ "${params.elementid}":rdv ]
        // see http://grails.org/doc/latest/ref/Controllers/bindData.html
        bindData(instance, binding_properties)
        instance.save(flush:true);
      }
      else {
        log.debug("no instance");
      }
    }
    else {
      log.debug("no type");
    }

    response.setContentType('text/plain')
    def outs = response.outputStream
    if ( rdv.icon ) {
      outs << "<span class=\"select-icon ${rdv.icon}\">&nbsp;</span><span>${rdv.value}</span>"
    }
    else {
      outs << "<span>${params.value}</span>"
    }
    outs.flush()
    outs.close()

  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def setFieldNote() {
    def domain_class=grailsApplication.getArtefact('Domain',"com.k_int.kbplus.${params.type}")
    if ( domain_class ) {
      def instance = domain_class.getClazz().get(params.id)
      if ( instance ) {
        if ( params.elementid?.startsWith('__fieldNote_') ) {
          def note_domain = params.elementid.substring(12)
          instance.setNote(note_domain, params.value);
          instance.save(flush:true)
        }
      }
    }
    else {
      log.error("no type");
    }

    response.setContentType('text/plain')
    def outs = response.outputStream
    outs << params.value
    outs.flush()
    outs.close()
  }

   @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def setFieldTableNote() {
    // log.debug("setFieldTableNote(${params})")
    def domain_class=grailsApplication.getArtefact('Domain',"com.k_int.kbplus.${params.type}")
    if ( domain_class ) {
      def instance = domain_class.getClazz().get(params.id)
       
      if ( instance ) {
        String temp = '__fieldNote_'+params.name
        if ( temp?.startsWith('__fieldNote_') ) {
          def note_domain = temp.substring(12)
          // log.debug("note_domain: " + note_domain +" : \""+ params.value+"\"")
          instance.setNote(note_domain, params.value);
          instance.save(flush:true)
        }
      }
    }
    else {
      log.error("no type");
    }

    response.setContentType('text/plain')
    def outs = response.outputStream
    outs << params.value
    outs.flush()
    outs.close()
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def genericSetValue() {
    // [id:1, value:JISC_Collections_NESLi2_Lic_IOP_Institute_of_Physics_NESLi2_2011-2012_01012011-31122012.., type:License, action:inPlaceSave, controller:ajax
    // def clazz=grailsApplication.domainClasses.findByFullName(params.type)
    // log.debug("genericSetValue:${params}");

    // params.elementid (The id from the html element)  must be formed as domain:pk:property:otherstuff
    String[] oid_components = params.elementid.split(":");

    def domain_class=grailsApplication.getArtefact('Domain',"com.k_int.kbplus.${oid_components[0]}")
    def result = params.value

    if ( domain_class ) {
      def instance = domain_class.getClazz().get(oid_components[1])
      if ( instance ) {

        def value = params.value;
        if ( value == '__NULL__' ) {
           value=null;
           result='';
        }
        else {
          if ( params.dt == 'date' ) {
            // log.debug("Special date processing, idf=${params.idf}");
            def formatter = new java.text.SimpleDateFormat(params.idf)
            value = formatter.parse(params.value)
            if ( params.odf ) {
              def of = new java.text.SimpleDateFormat(params.odf)
              result=of.format(value);
            }
            else {
              def of = new java.text.SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
              result=of.format(value)
            }
          }
        }
        // log.debug("Got instance ${instance}");
        def binding_properties = [ "${oid_components[2]}":value ]
        // log.debug("Merge: ${binding_properties}");
        // see http://grails.org/doc/latest/ref/Controllers/bindData.html
        bindData(instance, binding_properties)
        instance.save(flush:true);
      }
      else {
        log.debug("no instance");
      }
    }
    else {
      log.debug("no type");
    }

    response.setContentType('text/plain')
    def outs = response.outputStream
    outs << result
    outs.flush()
    outs.close()
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def genericSetRel() {
    String[] target_components = params.pk.split(":");
    def result = ''

    def target=resolveOID(target_components);
    if ( target ) {
      if ( params.value == '' ) {
        // Allow user to set a rel to null be calling set rel ''
        target[params.name] = null
        target.save(flush:true);
      }
      else {
        String[] value_components = params.value.split(":");
        def value=resolveOID(value_components);

  
        if ( target && value ) {
          def binding_properties = [ "${params.name}":value ]
          bindData(target, binding_properties)
          target.save(flush:true);
          
          // We should clear the session values for a user if this is a user to force reload of the,
          // parameters.
          if (target instanceof User) {
            session.userPereferences = null
          }
          
          if ( params.resultProp ) {
            result = value[params.resultProp]
          }
          else {
            if ( value ) {
              result = renderObjectValue(value);
              // result = value.toString()
            }
          }
        }
        else {
          log.debug("no value (target=${target_components}, value=${value_components}");
        }
      }
    }
    else {
      log.error("no target (target=${target_components}, value=${value_components}");
    }

    // response.setContentType('text/plain')
    def resp = [ newValue: result ]
    // log.debug("return ${resp as JSON}");
    render resp as JSON
    //def outs = response.outputStream
    //outs << result
    //outs.flush()
    //outs.close()
  }

  def resolveOID(oid_components) {
    def result = null;

    def domain_class=null;

    if ( oid_components[0].startsWith("com.k_int.kbplus") ) 
      domain_class = grailsApplication.getArtefact('Domain',oid_components[0])
    else 
      domain_class = grailsApplication.getArtefact('Domain',"com.k_int.kbplus.${oid_components[0]}")


    if ( domain_class ) {
      result = domain_class.getClazz().get(oid_components[1])
    }
    else {
      log.error("resolve OID failed to identify a domain class. Input was ${oid_components}");
    }
    result
  }

  def orgs() {
    // log.debug("Orgs: ${params}");

    def result = [
      options:[]
    ]

    def query_params = [name:"%${params.query.trim().toLowerCase()}%"];
    def ol = Org.executeQuery("select o from Org as o where lower(o.name) like :name order by o.name asc",query_params,[max:10,offset:0]);

    ol.each {
      result.options.add(it.name);
    }

    render result as JSON
  }

  def validatePackageId() {
    def result = [:]
    result.response = false;
    if( params.id ) {
      def p = Package.findByIdentifier(params.id)
      if ( !p ) {
        result.response = true
      }
    }

    render result as JSON
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def refdataSearch() {

    // log.debug("refdataSearch params: ${params}");
    
    def result = [:]
    //we call toString in case we got a GString
    def config = refdata_config.get(params.id?.toString())

    if ( config == null ) {
      // If we werent able to locate a specific config override, assume the ID is just a refdata key
      config = [
        domain:'RefdataValue',
        countQry:"select count(rdv) from RefdataValue as rdv where rdv.owner.desc='${params.id}'",
        rowQry:"select rdv from RefdataValue as rdv where rdv.owner.desc='${params.id}'",
        qryParams:[],
        cols:['value'],
        format:'simple'
      ]
    }

    if ( config ) {

      // result.config = config

      def query_params = [:]
      config.qryParams.each { qp ->
        log.debug("Processing query param ${qp} value will be ${params[qp.param]}");
        if ( qp.clos ) {
          query_params[qp.bv] = (qp.clos(params[qp.param]?:''));
        }
        else {
          query_params[qp.bv] = params[qp.param];
        }
      }

      def cq = Org.executeQuery(config.countQry,query_params);    

      def rq = Org.executeQuery(config.rowQry,
                                query_params,
                                [max:params.iDisplayLength?:10,offset:params.iDisplayStart?:0]);

      if ( config.format=='map' ) {
        result.aaData = []
        result.sEcho = params.sEcho
        result.iTotalRecords = cq[0]
        result.iTotalDisplayRecords = cq[0]
    
        rq.each { it ->
          def rowobj = GrailsHibernateUtil.unwrapIfProxy(it)
          int ctr = 0;
          def row = [:]
          config.cols.each { cd ->
            // log.debug("Processing result col ${cd} pos ${ctr}");
            row["${ctr++}"] = rowobj[cd]
          }
          row["DT_RowId"] = "${rowobj.class.name}:${rowobj.id}"
          result.aaData.add(row)
        }
      }
      else {
        rq.each { it ->
          def rowobj = GrailsHibernateUtil.unwrapIfProxy(it)
          result["${rowobj.class.name}:${rowobj.id}"] = rowobj[config.cols[0]];
        }
      }
    }

    // log.debug("refdataSearch returning ${result as JSON}");
    withFormat {
      html {
        result
      }
      json {
        render result as JSON
      }
    }
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def sel2RefdataSearch() {

    // log.debug("sel2RefdataSearch params: ${params}");
    
    def result = []
    //we call toString in case we got a GString
    def config = refdata_config.get(params.id?.toString())

    if ( config == null ) {
      // If we werent able to locate a specific config override, assume the ID is just a refdata key
      config = [
        domain:'RefdataValue',
        countQry:"select count(rdv) from RefdataValue as rdv where rdv.owner.desc='${params.id}'",
        rowQry:"select rdv from RefdataValue as rdv where rdv.owner.desc='${params.id}'",
        qryParams:[],
        cols:['value'],
        format:'simple'
      ]
    }

    if ( config ) {

      def query_params = []
      config.qryParams.each { qp ->
        if ( qp?.clos) {
          query_params.add(qp.clos(params[qp.param]?:''));
        }
        else if(qp?.value) {
            params."${qp.param}" = qp?.value
        }
        else {
          query_params.add(params[qp.param]);
        }
      }

      def cq = Org.executeQuery(config.countQry,query_params);    
      def rq = Org.executeQuery(config.rowQry,
                                query_params,
                                [max:params.iDisplayLength?:10,offset:params.iDisplayStart?:0]);

      rq.each { it ->
        def rowobj = GrailsHibernateUtil.unwrapIfProxy(it)
        result.add([value:"${rowobj.class.name}:${rowobj.id}",text:"${rowobj[config.cols[0]]}"]);
      }
    }
    else {
      log.error("No config for refdata search ${params.id}");
    }

    withFormat {
      html {
        result
      }
      json {
        render result as JSON
      }
    }
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def getAddOrgLinkView() {
    /*def domainInstance = null
    if (params.linkType && params.domainid) {
      def domain_class = grailsApplication.getArtefact('Domain', params.linkType)
      if (domain_class) {
        domainInstance = domain_class.getClazz().get(params.domainid)
      }
    }
    else {
      //redirect? do soemthing else
    }*/
    render(template: "/templates/orgLinksModal", model:[linkType:params.linkType, /*roleLinks:domainInstance?.orgRelations,*/ parent:params.linkType+':'+params.domainid, property:params.property, recip_prop:params.recip_prop, theme:params.theme, descText:params.descText])
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def addOrgRole() {
    log.debug("addOrgRole ${params}");
  if (params.orm_orgoid) {
    if (params.orm_orgoid instanceof String) {
        def org_to_link = resolveOID(params.orm_orgoid?.split(":"))
        def owner = resolveOID(params.parent?.split(":"))
        def rel = RefdataValue.get(params.orm_orgRole);
    
        // log.debug("Add link to ${org_to_link} from ${owner} rel is ${rel} recip_prop is ${params.recip_prop}");
        def new_link = new OrgRole(org:org_to_link,roleType:rel)
        new_link[params.recip_prop] = owner
        if ( new_link.save(flush:true) ) {
          // log.debug("Org link added");
        }
        else {
          log.error("Problem saving new org link...");
          new_link.errors.each { e ->
            log.error(e);
          }
        }
    }
    else if (params.orm_orgoid instanceof String[]) {
      def owner = resolveOID(params.parent?.split(":"))
      def rel = RefdataValue.get(params.orm_orgRole);
      params.orm_orgoid.each { orgoid ->
        def org_to_link = resolveOID(orgoid?.split(":"))
      
        // log.debug("Add link to ${org_to_link} from ${owner} rel is ${rel} recip_prop is ${params.recip_prop}");
        def new_link = new OrgRole(org:org_to_link,roleType:rel)
        new_link[params.recip_prop] = owner
        if ( new_link.save(flush:true) ) {
          // log.debug("Org link added");
        }
        else {
          log.error("Problem saving new org link...");
          new_link.errors.each { e ->
          log.error(e);
          }
        }
      }
    }
    else {
      log.debug("unknown instance of")
    }
  }
  
  def referer = request.getHeader('referer')
  if (params.anchor) {
    referer += params.anchor
  }
    redirect(url: referer)
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def addCustPropertyType(){
    def newProp
    def error 
    def ownerClass = params.ownerClass // we might need this for addCustomPropertyValue
    def owner =  grailsApplication.getArtefact("Domain",ownerClass?.replace("class ",""))?.getClazz()?.get(params.ownerId)
    if(params.cust_prop_type.equals(RefdataValue.class.name)){
        if(params.refdatacategory){
          newProp = PropertyDefinition.lookupOrCreateType(params.cust_prop_name, params.cust_prop_type, params.cust_prop_desc)
          def cat = RefdataCategory.get(params.refdatacategory)
          newProp.setRefdataCategory(cat.desc)
          newProp.save(flush:true)    
        }else{
          error = "Type creation failed. Please select a ref data type."
        }
    }else{
        newProp = PropertyDefinition.lookupOrCreateType(params.cust_prop_name, params.cust_prop_type, params.cust_prop_desc)
    }
     if(newProp?.hasErrors()){
        log.error(newProp.errors)
    }else{
        if(params.autoAdd == "on" && newProp){
          params.propIdent = newProp.id.toString()
          chain( action: "addCustomPropertyValue", params:params)    
        }
    }
    request.setAttribute("editable",params.editable == "true")
    if(params.redirect){
      flash.newProp = newProp
      flash.error = error
      redirect(controller:"propertyDefinition",action:"create")
    }else{
      render(template: "/templates/custom_props", model:[ownobj:owner, newProp:newProp, error:error])        
    }
  }

  def addCustomPropertyValue(){
    def error
    def newProp
    def owner =  grailsApplication.getArtefact("Domain",params.ownerClass?.replace("class ",""))?.getClazz()?.get(params.ownerId)
    def type = PropertyDefinition.get(params.propIdent.toLong())

    def existingProp = owner.customProperties.find{it.type.name == type.name }

    if( existingProp == null ){
      newProp = PropertyDefinition.createPropertyValue( owner, type)    
      if(newProp.hasErrors()){
        log.error(newProp.errors)
      }else{
        log.debug("New Property created: "+newProp.type.name)
      }
    }else{
      error = "A property of this type is already added."
    }

    owner.refresh()
    request.setAttribute("editable",params.editable == "true")
    render(template: "/templates/custom_props",model:[ownobj:owner,newProp:newProp,error:error ])  
  }  
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def addCustomPropertyModal() {
    log.debug("params: " + params)
    def p = [:]
    def propList = []
    p.max = params.max ?: 1000;
    p.desc = params.prop_desc
    p.q = ''
    def domain_class = grailsApplication.getArtefact('Domain',params.propBaseClass)
    if ( domain_class ) {
    propList = domain_class.getClazz().refdataFind(p);
    }
    else {
    log.error("Unable to locate domain class ${params.baseClass}");
    }
    render (template: "/templates/addCustomPropertyModal", model:[prop_desc:params.prop_desc, ownerId:params.ownerId, ownerClass:params.ownerClass, propId:params?.propId, editable:params.editable, propList:propList, theme:params.theme, anchor:params.anchor, descText:params.descText])
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def newCustomPropertyModal() {
    log.debug("params: " + params)
    render (template: "/templates/newCustomPropertyModal", model:[prop_desc:params.prop_desc, propBaseClass:params.propBaseClass, ctxType:params.ctxType, ownerId:params.ownerId, ownerClass:params.ownerClass, editable:params.editable, theme:params.theme, anchor:params.anchor])
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def editCustomProperty() {
    log.debug("AjaxController::editCustomProperty params: " + params)
    def className = params.propclass.split(" ")[1]
    def propClass = Class.forName(className)
    def property = propClass.get(params.id)
    
    render (template: "/templates/editCustomPropertyModal", model:[property: property, propclass: params.propclass, editable:params.editable, theme:params.theme])
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processEditCustomProperty() {
    log.debug("AjaxController::processEditCustomProperty params: " + params)

    def className = params.propclass.split(" ")[1]
    def propClass = Class.forName(className)
    def property = propClass.get(params.id)
    
    if (property) {
      if (params.notes) {
        log.debug("Set notes to ${params.notes}");
        property.setNote(params.notes)
      }
      else {
        log.debug("Clear notes");
        property.setNote("")
      }
      
      if (params.stringValue) {
        property.stringValue = params.stringValue
      }
      else if (params.intValue) {
        property.intValue = Integer.parseInt(params.intValue)
      }
      else if (params.decValue) {
        property.decValue = new BigDecimal(params.decValue)
      }
      else if (params.refValue) {
        def rdv = RefdataValue.get(params.refValue.toLong())
        if (rdv) {
          property.refValue = rdv
        }
        else {
          log.warn("Unable to locate refdata value ${params.refValue}");
        }
      }
      
      property.save(flush:true, failOnError:true)
      log.debug("Saved property : ${property}, errors: ${property.errors}");
    }
    else {
      log.warn("Unable to locate property ${params.id}");
    }
    
    def referer = request.getHeader('referer')
    if (params.anchor) {
      referer += params.anchor
    }

    log.debug("AjaxController::processEditCustomProperty redirecting to ${referer}");
    redirect(url: referer)
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def lookupProperty() {
    log.debug("params: " + params)
    def result = [:]
    def prop
    def domain_class = grailsApplication.getArtefact('Domain',params.propBaseClass)
    if ( domain_class ) {
      prop = domain_class.getClazz().get(params.propId)
    }
    
    if (prop) {
      result.propId = prop.id
      result.propName = prop.name
      result.propType = prop.type
      if (prop.type == RefdataValue.class.name) {
        log.debug("this property is a ref data value!!!")
        result.refdataCat = prop.refdataCategory
        
        def rdv_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc=:desc"
        def rdv_values = RefdataValue.executeQuery(rdv_qry,[desc:prop.refdataCategory])
        def refdataValues = []
        rdv_values.each { rdv ->
          def v = [:]
          v.id = rdv.id
          v.value = rdv.value
          refdataValues.add(v)
        }
        result.refdataValues = refdataValues
      }
    }
    
    render result as JSON
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processAddCustomProperty() {
    log.debug("AjaxController::processAddCustomProperty params: " + params)

    def error
    def newProp
    def owner = grailsApplication.getArtefact("Domain",params.ownerClass?.replace("class ",""))?.getClazz()?.get(params.ownerId)
    def type = PropertyDefinition.get(params.property.toLong())

    log.debug("Got owner: ${owner} proptype: ${type}");
  
    def existingProp = owner.customProperties.find{it.type.name == type.name }
  
    if( existingProp == null ) {

      log.debug("No existing property - create a new one");
      newProp = PropertyDefinition.createPropertyValue( owner, type)

      if(newProp.hasErrors()) {
        log.error("Problem creating new property");
        log.error(newProp.errors)
      } else {
        log.debug("New Property created: "+newProp.type.name)
      
        if (params.notes) {
          newProp.setNote(params.notes)
          log.debug("Setting notes to ${params.notes} == ${newProp.note}");
        }
        
        if (params.stringValue != null) {
          newProp.stringValue = params.stringValue
          log.debug("str value found")
        }
        else if (params.intValue != null ) {
          newProp.intValue = Integer.parseInt(params.intValue)
          log.debug("int value found")
        }
        else if (params.decValue != null ) {
          newProp.decValue = new BigDecimal(params.decValue)
          log.debug("dec value found")
        }
        else if (params.refValue != null ) {
          def rdv = RefdataValue.get(params.refValue.toLong())
          if (rdv) {
            newProp.refValue = rdv
          }
          log.debug("Prop is refdata - lookup returned ${rdv} ${newProp.refValue}");
        }
        else {
          log.warn("No value found.....");
        }
        
        newProp.save(flush:true, failOnError:true)
        log.debug("Saved new prop: id:${newProp.id} owner:${newProp.owner} note:${newProp.note} - ${newProp}");
      }
    } else {
      flash.error = "A property of this type is already added."
    }
    
    def referer = request.getHeader('referer')
    if (params.anchor) {
      referer += params.anchor
    }

    log.debug("AjaxController::processAddCustomProperty complete - redirecting to ${referer}");
    redirect(url: referer)
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processNewCustomPropertyType() {
    def newProp
    def error
    if(params.cust_prop_type.equals(RefdataValue.class.name)){
      if(params.refdatacategory){
      newProp = PropertyDefinition.lookupOrCreateType(params.cust_prop_name, params.cust_prop_type, params.cust_prop_desc)
      def cat = RefdataCategory.get(params.refdatacategory)
      newProp.setRefdataCategory(cat.desc)
      newProp.save(flush:true)
      }else{
      error = "Type creation failed. Please select a ref data type."
      }
    }else{
      newProp = PropertyDefinition.lookupOrCreateType(params.cust_prop_name, params.cust_prop_type, params.cust_prop_desc)
    }
    
    if(newProp?.hasErrors()){
      log.error(newProp.errors)
    }
    request.setAttribute("editable",params.editable == "true")
    
    if (params.ajax && params.ajax=="Y") {
      render newProp.id
    }
    else {
      def referer = request.getHeader('referer')
      if (params.anchor) {
        referer += params.anchor
      }
      redirect(url: referer)
    }
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def delOrgRole() {
    // log.debug("delOrgRole ${params}");
    def or = OrgRole.get(params.id)
    or.delete(flush:true);
    // log.debug("Delete link: ${or}");
  
  def referer = request.getHeader('referer')
  if (params.anchor) {
    referer += params.anchor
  }
  
    redirect(url: referer)
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def delCustomProperty(){
      def className = params.propclass.split(" ")[1]
      def propClass = Class.forName(className)
      def property = propClass.get(params.id)
      def owner =  grailsApplication.getArtefact("Domain",params.ownerClass?.replace("class ",""))?.getClazz()?.get(params.ownerId)
      owner.customProperties.remove(property)
      property.delete(flush:true)

      if(property.hasErrors()){
        log.error(property.errors)
      }else{
        log.debug("Deleted Custom Property: "+property.type.name)
      }
      request.setAttribute("editable", params.editable == "true")
    if ((params.referer) && (params.referer.contentEquals('Y'))) {
      def referer = request.getHeader('referer')
      if (params.anchor) {
        referer += params.anchor
      }
  
      redirect(url: referer)
    }
    else {
      render(template: "/templates/custom_props",model:[ownobj:owner, newProp:property])
    }
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def coreExtend(){
    log.debug("ajax::coreExtend:: ${params}")
    def tipID = params.tipID
    try{
      def sdf = new java.text.SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
      def startDate = sdf.parse(params.coreStartDate)
      def endDate = params.coreEndDate? sdf.parse(params.coreEndDate) : null
      if(tipID && startDate){
        def tip = TitleInstitutionProvider.get(tipID)
    log.debug('tip: ' + tip)
        log.debug("Extending tip ${tip.id} with start ${startDate} and end ${endDate}")
        tip.extendCoreExtent(startDate, endDate)
        params.message = "Core Dates extended"
      }
    }catch (Exception e){
        log.error("Error while extending core dates",e)
        params.message = "Extending of core date failed."
    }
    redirect(action:'getTipCoreDates',controller:'ajax',params:params)
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def getTipCoreDates(){
    log.debug("ajax::getTipCoreDates:: ${params}")
    def tipID = params.tipID ?:params.id
    def tip = null
    if(tipID) tip = TitleInstitutionProvider.get(tipID);
    if(tip){
      def dates = tip.coreDates
      log.debug("Returning ${dates}")
      request.setAttribute("editable",params.editable?:true)
      render(template:"/templates/coreAssertionsModal",model:[message:params.message,coreDates:dates,tipID:tip.id,tip:tip, theme:params.theme]);
    }
  } 
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def deleteCoreDate(){
    log.debug("ajax:: deleteCoreDate::${params}")
    def date = CoreAssertion.get(params.coreDateID)
    if(date) date.delete(flush:true)
    redirect(action:'getTipCoreDates',controller:'ajax',params:params)
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def lookup() {
    // log.debug("AjaxController::lookup ${params}");
    def result = [:]
    params.max = params.max ?: 20;
    def domain_class = grailsApplication.getArtefact('Domain',params.baseClass)
    if ( domain_class ) {
      result.values = domain_class.getClazz().refdataFind(params);
    }
    else {
      log.error("Unable to locate domain class ${params.baseClass}");
      result.values=[]
    }
    //result.values = [[id:'Person:45',text:'Fred'],
    //                 [id:'Person:23',text:'Jim'],
    //                 [id:'Person:22',text:'Jimmy'],
    //                 [id:'Person:3',text:'JimBob']]
    render result as JSON
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def addToCollection() {
    // log.debug("AjaxController::addToCollection ${params}");

    def contextObj = resolveOID2(params.__context)
    def domain_class = grailsApplication.getArtefact('Domain',params.__newObjectClass)
    if ( domain_class ) {

      if ( contextObj ) {
        // log.debug("Create a new instance of ${params.__newObjectClass}");

        def new_obj = domain_class.getClazz().newInstance();

        domain_class.getPersistentProperties().each { p -> // list of GrailsDomainClassProperty
          // log.debug("${p.name} (assoc=${p.isAssociation()}) (oneToMany=${p.isOneToMany()}) (ManyToOne=${p.isManyToOne()}) (OneToOne=${p.isOneToOne()})");
          if ( params[p.name] ) {
            if ( p.isAssociation() ) {
              if ( p.isManyToOne() || p.isOneToOne() ) {
                // Set ref property
                // log.debug("set assoc ${p.name} to lookup of OID ${params[p.name]}");
                // if ( key == __new__ then we need to create a new instance )
                def new_assoc = resolveOID2(params[p.name])
                if(new_assoc){
                  new_obj[p.name] = new_assoc
                }
              }
              else {
                // Add to collection
                // log.debug("add to collection ${p.name} for OID ${params[p.name]}");
                new_obj[p.name].add(resolveOID2(params[p.name]))
              }
            }
            else {
              // log.debug("Set simple prop ${p.name} = ${params[p.name]}");
              new_obj[p.name] = params[p.name]
            }
          }
        }

        if ( params.__recip ) {
          // log.debug("Set reciprocal property ${params.__recip} to ${contextObj}");
          new_obj[params.__recip] = contextObj
        }

        // log.debug("Saving ${new_obj}");
        try{
          if ( new_obj.save(flush:true, failOnError:true) ) {
            log.debug("Saved OK");
          }
          else {
            flash.domainError = new_obj
            new_obj.errors.each { e ->
              log.error("Problem ${e}");
            }
          }
        }catch(Exception ex){

            flash.domainError = new_obj
            new_obj.errors.each { e ->
            log.error("Problem ${e}");
            }
        }
      }
      else {
        log.error("Unable to locate instance of context class with oid ${params.__context}");
      }
    }
    else {
      log.error("Unable to lookup domain class ${params.__newObjectClass}");
    }
  
  if (params?.jsonreturn){
    def result = [:]
    result.confirm = true
    render result as JSON
  }
  else{
      redirect(url: request.getHeader('referer'))
  }
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def validateIdentifierUniqueness(){
    log.debug("validateIdentifierUniqueness - ${params}")
    def result = [:]
    def owner = resolveOID2(params.owner)
    def identifier = resolveOID2(params.identifier)
    def owner_type = null
    switch(owner.class){
      case Subscription:
        owner_type = "sub"
        break;
      case(TitleInstance):
        owner_type = "ti"
        break;
      case (Package):
        owner_type = "pkg"
        break;
      case TitleInstancePackagePlatform:
        owner_type = "tipp"
        break;
      case Org:
        owner_type = "org"
        break
      default:
        log.error("Unexpected Identifier Owner ${owner.class}")
        return null
    }    
    def duplicates = identifier?.occurrences.findAll{it."${owner_type}" != owner && it."${owner_type}" != null}?.collect{it."${owner_type}"}
    if(duplicates){
      result.duplicates = duplicates
    }
    else{
      result.unique=true
    }
    log.debug("validateIdentifierUniqueness - ${result}")
    render result as JSON
  }

  def resolveOID2(oid) {
    def oid_components = oid.split(':');
    def result = null;
    def domain_class=null;
    domain_class = grailsApplication.getArtefact('Domain',oid_components[0])
    if ( domain_class ) {
      if ( oid_components[1]=='__new__' ) {
        result = domain_class.getClazz().refdataCreate(oid_components)
        // log.debug("Result of create ${oid} is ${result?.id}");
      }
      else {
        result = domain_class.getClazz().get(oid_components[1])
      }
    }
    else {
      log.error("resolve OID failed to identify a domain class. Input was ${oid_components}");
    }
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def deleteThrough() {
    // log.debug("deleteThrough(${params})");
    def context_object = resolveOID2(params.contextOid)
    def target_object = resolveOID2(params.targetOid)
    if ( context_object."${params.contextProperty}".contains(target_object) ) {
      def otr = context_object."${params.contextProperty}".remove(target_object)
      target_object.delete()
      context_object.save(flush:true);
    }
  
  if (params?.jsonreturn) {
    def result = [:]
    result.confirm = true
    render result as JSON  
  }
  else {
      redirect(url: request.getHeader('referer'))
  }

  }

  def deleteManyToMany() {
    // log.debug("deleteManyToMany(${params})");
    def context_object = resolveOID2(params.contextOid)
    def target_object = resolveOID2(params.targetOid)
    if ( context_object."${params.contextProperty}".contains(target_object) ) {
      context_object."${params.contextProperty}".remove(target_object)
      context_object.save(flush:true);
    }
    redirect(url: request.getHeader('referer'))    
  }
  def validationException(final grails.validation.ValidationException exception){
    log.error(exception)
    response.status = 400
    response.setContentType('text/plain')
    def outs = response.outputStream
    outs << "Value validation failed"
  }

  def editableSetValue() {
    log.debug("editableSetValue ${params}");
    def target_object = resolveOID2(params.pk)
    
    if ( target_object ) {
      if ( params.type=='date' ) {
        target_object."${params.name}" = params.date('value','yyyy-MM-dd')
      }
      else {
        def binding_properties = [:]
        binding_properties[ params.name ] = params.value
        bindData(target_object, binding_properties)
        // target_object."${params.name}" = params.value
      }
        target_object.save(failOnError:true,flush:true);

    }

    response.setContentType('text/plain')

    def outs = response.outputStream

    outs << target_object."${params.name}"
    
    outs.flush()
    outs.close()
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def removeUserRole() {
    def user = resolveOID2(params.user);
    def role = resolveOID2(params.role);
    if ( user && role ) {
      com.k_int.kbplus.auth.UserRole.remove(user,role,true);
    }
    redirect(url: request.getHeader('referer'))    
  }

  /**
   * ToDo: This function is a duplicate of the one found in InplaceTagLib, both should be moved to a shared static utility
   */
  def renderObjectValue(value) {
    def result=''
    if ( value ) {
      switch ( value.class ) {
        case com.k_int.kbplus.RefdataValue.class:
          if ( value.icon != null ) {
            result="<span class=\"select-icon ${value.icon}\"></span>${value.value}"
          }
          else {
            result=value.value
          }
          break;
        default:
          result=value.toString();
          break;
      }
    }
    // log.debug("Result of render: ${value} : ${result}");
    result;
  }

}
