package com.k_int.kbplus

import grails.converters.*
import grails.plugin.springsecurity.annotation.Secured
import com.k_int.kbplus.auth.*;
import org.apache.log4j.*
import java.text.SimpleDateFormat
import com.k_int.kbplus.AuditLogEvent
import grails.plugin.springsecurity.SpringSecurityUtils

class TitleDetailsController {

  def springSecurityService
  def ESSearchService


  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def findTitleMatches() { 
    // find all titles by n_title proposedTitle
    def result=[:]
    if ( params.proposedTitle ) {
      def normalised_title = com.k_int.kbplus.utils.TextUtils.generateNormTitle(params.proposedTitle)
      result.titleMatches=com.k_int.kbplus.TitleInstance.findAllByNormTitleLike("${normalised_title}%")
    }
    result
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def createTitle() {
    log.debug("Create new title for ${params.title}");
    def new_title = new TitleInstance(title:params.title, impId:java.util.UUID.randomUUID().toString())
    
    if ( new_title.save(flush:true) ) {
      log.debug("New title id is ${new_title.id}");
    if (params.defaultInstShortcode) {
    redirect action: 'show', id: new_title.id, params: [defaultInstShortcode: params.defaultInstShortcode]
    }
    else {
    redirect action: 'show', id: new_title.id
    }
    }
    else {
      log.error("Problem creating title: ${new_title.errors}");
      flash.message = "Problem creating title: ${new_title.errors}"
    if (params.defaultInstShortcode) {
        redirect controller: 'myInstitutions', action: 'currentTitles', params: [defaultInstShortcode: params.defaultInstShortcode]
    }
    else {
    redirect controller: 'titleDetails', action: 'index'
    }
    }
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def editTitle() {
    def result = [:]

  log.debug('getting edit modal: ' + params)

  result.user = User.get(springSecurityService.principal.id)
  result.ti = TitleInstance.get(params.id)
  
  render(template:"editTitle", model:[ti:result.ti])
  }
  
  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def processEditTitle(){
	  log.debug('params: ' + params)
	  
	  def ti = TitleInstance.get(params.id)
	  
	  def sdf = new SimpleDateFormat('yyyy-MM-dd')
	  
	  if(params.title) {
		  ti.title = params.title
	  }
	  else {
		  ti.title = null
	  }
	  
	  if(params?.publishedFrom) {
		  ti.publishedFrom = sdf.parse(params.publishedFrom)
	  }
	  else {
		  ti.publishedFrom = null
	  }
	  
	  if(params?.publishedTo) {
		  ti.publishedTo = sdf.parse(params.publishedTo)
	  }
	  else {
		  ti.publishedTo = null
	  }
	  
	  if(params.firstAuthor) {
		  ti.firstAuthor = params.firstAuthor
	  }
	  else {
		  ti.firstAuthor = null
	  }
	  
	  if(params.publicationType) {
		  ti.publicationType = params.publicationType
	  }
	  else {
		  ti.publicationType = null
	  }
	  
	  if(params.dateMonographPublishedPrint) {
		  ti.dateMonographPublishedPrint = sdf.parse(params.dateMonographPublishedPrint)
	  }
	  else {
		  ti.dateMonographPublishedPrint = null
	  }
	  
	  if(params.dateMonographPublishedOnline) {
		  ti.dateMonographPublishedOnline = sdf.parse(params.dateMonographPublishedOnline)
	  }
	  else {
		  ti.dateMonographPublishedOnline = null
	  }
	  
	  if(params.monographVolume) {
		  ti.monographVolume = params.monographVolume
	  }
	  else {
		  ti.monographVolume = null
	  }
	  
	  if(params.monographEdition) {
		  ti.monographEdition = params.monographEdition
	  }
	  else {
		  ti.monographEdition = null
	  }
	  
	  if(params.firstEditor) {
		  ti.firstEditor = params.firstEditor
	  }
	  else {
		  ti.firstEditor = null
	  }
	  
	  log.debug('attempting to save edited title with id: ' + params.id)
	  ti.save(flush:true, failOnError:true)
	  log.debug('saved edited title with id: ' + params.id)
	  
	  //redirect action: 'show', id:params.id, params:[defaultInstShortcode:params.defaultInstShortcode]
	  redirect(url: request.getHeader('referer'))
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def show() {
    def result = [:]
    
    if ( SpringSecurityUtils.ifAnyGranted('ROLE_ADMIN') ) {
      result.editable=true
    }
    else {
      result.editable=false
    }
    
    result.ti = TitleInstance.get(params.id)
    
    result.duplicates = reusedIdentifiers(result.ti);

    result.titleHistory = TitleHistoryEvent.executeQuery("select distinct thep.event from TitleHistoryEventParticipant as thep where thep.participant = :p",[p:result.ti]);
  
    def user = User.get(springSecurityService.principal.id)
    result.max = params.max ? Integer.parseInt(params.max) : user.defaultPageSize
    params.max = result.max
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;
  
    def base_query = 'from AuditLogEvent as e where ( e.className = :instCls and e.persistedObjectId = :instId )'
  
    def limits = (!params.format||params.format.equals("html"))?[max:result.max, offset:result.offset]:[offset:0]
  
    def query_params = [ instCls:'com.k_int.kbplus.TitleInstance', instId:params.id]
  
    log.debug("base_query: ${base_query}, params:${query_params}, limits:${limits}");
  
    result.historyLines = AuditLogEvent.executeQuery('select e '+base_query+' order by e.lastUpdated desc', query_params, limits);
    result.num_hl = AuditLogEvent.executeQuery('select count(e) '+base_query, query_params)[0];
    result.formattedHistoryLines = []
  
  
    result.historyLines.each { hl ->
  
      def line_to_add = [:]
      def linetype = null
  
      switch(hl.className) {
      case 'com.k_int.kbplus.TitleInstance':
        def instance_obj = TitleInstance.get(hl.persistedObjectId);
        line_to_add = [ link: createLink(controller:'titleInstance', action: 'show', id:hl.persistedObjectId),
                name: instance_obj.title,
                lastUpdated: hl.lastUpdated,
                propertyName: hl.propertyName,
                actor: User.findByUsername(hl.actor),
                  oldValue: hl.oldValue,
                newValue: hl.newValue
              ]
        linetype = 'TitleInstance'
        break;
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
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def appearsIn() {
  def result = [:]

  log.debug('getting occurences of title: ' + params)

  result.user = User.get(springSecurityService.principal.id)
  result.ti = TitleInstance.get(params.id)
  
  render(template:"appearsIn", model:[ti:result.ti])
  }

  def reusedIdentifiers(title){
    // Test for identifiers that are used accross multiple titles
    def duplicates = [:]
    
    if (  title?.ids ) {
      def identifiers = title.ids.collect{it.identifier}
      identifiers.each{ident ->
        ident.occurrences.each{
          if(it.ti != title && it.ti!=null){
            if(duplicates."${ident.ns.ns}:${ident.value}"){
              duplicates."${ident.ns.ns}:${ident.value}" += [it.ti]
            }else{
              duplicates."${ident.ns.ns}:${ident.value}" = [it.ti]
            }
          }
        }
      }
    }
    return duplicates
  }
  
  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def batchEditTIPPsModal() {
    def result = [:]
    result
  }
  
  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def batchUpdate() {
    log.debug("batchUpdate(): ${params}");
    def formatter = new java.text.SimpleDateFormat("yyyy-MM-dd")
    def user = User.get(springSecurityService.principal.id)

      params.each { p ->
      if ( p.key.startsWith('_bulkflag.')&& (p.value=='on'))  {
        def tipp_id_to_edit = p.key.substring(10);
        def tipp_to_bulk_edit = TitleInstancePackagePlatform.get(tipp_id_to_edit)
        boolean changed = false

        if ( tipp_to_bulk_edit != null ) {
            def bulk_fields = [
                    [ formProp:'start_date', domainClassProp:'startDate', type:'date'],
                    [ formProp:'start_volume', domainClassProp:'startVolume'],
                    [ formProp:'start_issue', domainClassProp:'startIssue'],
                    [ formProp:'end_date', domainClassProp:'endDate', type:'date'],
                    [ formProp:'end_volume', domainClassProp:'endVolume'],
                    [ formProp:'end_issue', domainClassProp:'endIssue'],
                    [ formProp:'coverage_depth', domainClassProp:'coverageDepth'],
                    [ formProp:'coverage_note', domainClassProp:'coverageNote'],
                    [ formProp:'hostPlatformURL', domainClassProp:'hostPlatformURL']
            ]

            bulk_fields.each { bulk_field_defn ->
                if ( params["clear_${bulk_field_defn.formProp}"] == 'on' ) {
                    log.debug("Request to clear field ${bulk_field_defn.formProp}");
                    tipp_to_bulk_edit[bulk_field_defn.domainClassProp] = null
                    changed = true
                }
                else {
                    def proposed_value = params['bulk_'+bulk_field_defn.formProp]
                    if ( ( proposed_value != null ) && ( proposed_value.length() > 0 ) ) {
                        log.debug("Set field ${bulk_field_defn.formProp} to ${proposed_value}");
                        if ( bulk_field_defn.type == 'date' ) {
                            tipp_to_bulk_edit[bulk_field_defn.domainClassProp] = formatter.parse(proposed_value)
                        }
                        else {
                            tipp_to_bulk_edit[bulk_field_defn.domainClassProp] = proposed_value
                        }
                        changed = true
                    }
                }
            }
          if (changed)
             tipp_to_bulk_edit.save(flush:true, failOnError:true);
        }
      }
    }

    def shortcode_params = []
    if (params.defaultInstShortcode)  {
      shortcode_params = [defaultInstShortcode:params.defaultInstShortcode]
    }
    redirect(controller:'titleDetails', action:'show', id:params.id, params:shortcode_params);
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def index() {
    log.debug("titleSearch : ${params}");
    def result=[:]
    params.rectype = 'Title' // Tells ESSearchService what to look for
    result.user = springSecurityService.getCurrentUser()
    params.max = result.user.defaultPageSize
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;
    def old_q = params.q

    if(!params.q ){
      params.remove('q');
    }
    else{
      if (!params.q.startsWith("\"")){
        params.q = "\"" + params.q
      }
      
      if (!params.q.endsWith("\"")){
        params.q = params.q + "\""
      }
      
      params.q = "\"" + old_q + "\"";
    }
	
  	if(!params.sort){
      log.debug("Sorting by default _score");
  	  params.sort = '_score'
  	  params.order = 'DESC'
    }
  	else{
  	  def sortOpts = params.sort.tokenize(':')
  	  if (sortOpts.size() == 2){
        log.debug("Sorting ${sortOpts}");
    		params.sort = sortOpts[0]
    		params.order = sortOpts[1]
      }
      else {
        log.debug("leave params.sort opts ${params.sort}")
      }
  	}
  
    if(params.filter) params.q ="${params.filter}:${params.q}";

    result =  ESSearchService.search(params)//ESSearchService.phraseSearch(params)  
    //Double-Quoted search strings wont display without this
    params.q = old_q?.replace("\"","&quot;") 
    result  
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def history() {
    def result = [:]
    def exporting = params.format == 'csv' ? true : false

    if ( exporting ) {
      result.max = 9999999
      params.max = 9999999
      result.offset = 0
    }
    else {
      def user = User.get(springSecurityService.principal.id)
      result.max = params.max ? Integer.parseInt(params.max) : user.defaultPageSize
      params.max = result.max
      result.offset = params.offset ? Integer.parseInt(params.offset) : 0;
    }

    result.titleInstance = TitleInstance.get(params.id)
    def base_query = 'from org.codehaus.groovy.grails.plugins.orm.auditable.AuditLogEvent as e where ( e.className = :instCls and e.persistedObjectId = :instId )'

    def limits = (!params.format||params.format.equals("html"))?[max:result.max, offset:result.offset]:[offset:0]

    def query_params = [ instCls:'com.k_int.kbplus.TitleInstance', instId:params.id]

    log.debug("base_query: ${base_query}, params:${query_params}, limits:${limits}");

    result.historyLines = org.codehaus.groovy.grails.plugins.orm.auditable.AuditLogEvent.executeQuery('select e '+base_query+' order by e.lastUpdated desc', query_params, limits);
    result.num_hl = org.codehaus.groovy.grails.plugins.orm.auditable.AuditLogEvent.executeQuery('select count(e) '+base_query, query_params)[0];
    result.formattedHistoryLines = []


    result.historyLines.each { hl ->

        def line_to_add = [:]
        def linetype = null

        switch(hl.className) {
          case 'com.k_int.kbplus.TitleInstance':
            def instance_obj = TitleInstance.get(hl.persistedObjectId);
            line_to_add = [ link: createLink(controller:'titleInstance', action: 'show', id:hl.persistedObjectId),
                            name: instance_obj.title,
                            lastUpdated: hl.lastUpdated,
                            propertyName: hl.propertyName,
                            actor: User.findByUsername(hl.actor),
                            oldValue: hl.oldValue,
                            newValue: hl.newValue
                          ]
            linetype = 'TitleInstance'
            break;
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

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def availability() {
    def result = [:]
    result.ti = TitleInstance.get(params.id)
    result.availability = IssueEntitlement.executeQuery("select ie from IssueEntitlement as ie where ie.tipp.title = :t",[t:result.ti]);

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def dmIndex() {

    log.debug("dmIndex ${params}");
    if(SpringSecurityUtils.ifNotGranted('ROLE_KBPLUS_EDITOR,ROLE_ADMIN,KBPLUS_EDITOR')){
      flash.error = message(code:"default.access.error")
      response.sendError(401)
      return;
    }
    if(params.search == "yes"){
      params.offset = 0
      params.remove("search")
    }
    def user = User.get(springSecurityService.principal.id)
    def result = [:]
    result.max = params.max ? Integer.parseInt(params.max) : user.defaultPageSize
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;
    
    def ti_cat = RefdataCategory.findByDesc(RefdataCategory.TI_STATUS)

    result.availableStatuses = RefdataValue.findAllByOwner(ti_cat).collect{it.toString()}
    def ti_status = null
    if(params.status){
      if(result.availableStatuses.contains(params.status)){
        ti_status = RefdataCategory.lookupOrCreate( RefdataCategory.TI_STATUS, params.status )
      }
    }
    
    def criteria = TitleInstance.createCriteria()
    result.hits = criteria.list(max: result.max, offset:result.offset){
        if(params.q){
          ilike("title","${params.q}%")
        }
        if(ti_status){
          eq('status',ti_status)
        }
        order("sortTitle", params.order?:'asc')
    }

    result.totalHits = result.hits.totalCount

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def clearParent() {
    def ti = TitleInstance.get(params.id)
    if ( ti ) {
      ti.parentPublication = null;
      ti.save(flush:true, failOnError:true);
    }
    redirect(controller:'titleDetails', action:'show', id:params.id);
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def deleteTHParticipant() {
    def evt= TitleHistoryEvent.get(params.event)
    if ( evt ) {
      evt.delete()
    }
    redirect(controller:'titleDetails', action:'show', id:params.id);
  }

}
