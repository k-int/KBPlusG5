package com.k_int.kbplus

import com.k_int.kbplus.auth.User
import com.k_int.kbplus.auth.UserOrg

import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.annotation.Secured
import com.k_int.custprops.PropertyDefinition
import java.text.SimpleDateFormat
import groovy.sql.Sql

class ManageTitlesController {
  
  def springSecurityService
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def index() {
    log.debug("manage titles index : ${params}");
    def result = [:]
    
    result.user = User.get(springSecurityService.principal.id)
    result.institution = request.getAttribute('institution')
    
    result.editable = false
    if (result.institution) {
      result.editable = result.institution.hasUserWithRole(result.user, 'INST_ADM')
    }
    else if ( SpringSecurityUtils.ifAnyGranted('ROLE_ADMIN,ROLE_KBPLUS_EDITOR') ) {
      result.editable = true
    }
    
    //offset and max to show
    result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;
    
    //check for sort
    def sortOpts
    if (params.sort) {
      sortOpts = params.sort.tokenize(':')
    }
    
    //check for subscription filter
    if (params.sub && params.sub?.startsWith("com.k_int.kbplus.Subscription:")) {
      def subid = params.sub.split(":")[1]
      def sub = Subscription.get(subid)
      if (sub) {
        result.subtext = sub.name
        
        def ie_qry_params = [:]
        ie_qry_params.sub = sub
        def ie_base_qry = "select ie from IssueEntitlement as ie where ie.subscription=:sub group by ie.tipp"
        def ie_sort_clause = " order by "
        if (sortOpts && sortOpts.size() == 2) {
          ie_sort_clause += "ie.tipp.${sortOpts[0]} ${sortOpts[1]}"
        }
        else {
          ie_sort_clause += "ie.tipp.title.title asc"
        }
        
        def ie_qry = ie_base_qry + ie_sort_clause
        //def ie_count_qry = "select count(*) from (${ie_base_qry} ) as iecnt".toString()
        
        def ies = IssueEntitlement.executeQuery(ie_qry, ie_qry_params, [max: result.max, offset: result.offset])
        result.total_tips = IssueEntitlement.executeQuery(ie_qry, ie_qry_params).size() ?: 0
        
        result.tips = []
        ies.each { ie ->
          def tip = ie.getTIP()
          if (tip) {
            result.tips.add(tip)
          }
        }
      }
    }
    else {
      def qry_params = [:]
      def base_qry = "select t from TitleInstitutionProvider as t "
      def count_base_qry = "select count(t) from TitleInstitutionProvider as t "
      def where_clause
      
      if (result.institution) {
        if (!where_clause) {
          where_clause = "WHERE "
        }
        where_clause += "t.institution=:inst "
        qry_params.inst = result.institution
      }
      
      def sort_clause = "order by "
      if (sortOpts && sortOpts.size() == 2) {
        sort_clause += "t.${sortOpts[0]} ${sortOpts[1]}"
      }
      else {
        sort_clause += "t.title.title asc"
      }
      
      def qry = base_qry + (where_clause ?: "") + sort_clause
      def count_qry = count_base_qry + (where_clause ?: "")
      result.tips = TitleInstitutionProvider.executeQuery(qry, qry_params, [max: result.max, offset: result.offset])
      result.total_tips = TitleInstitutionProvider.executeQuery(count_qry, qry_params)[0]
    }
    
    result
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def addCoreDate() {
    log.debug("manage titles addCoreDate : ${params}");
    def result = [:]
    result
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processCoreDate() {
    log.debug("manage titles processCoreDate : ${params}");
    
    def sub
    def params_sub = []
    
    def sdf = new java.text.SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
    def startDate = sdf.parse(params.coreStartDate)
    def endDate = params.coreEndDate? sdf.parse(params.coreEndDate) : null
    
    if (params.sub && params.sub?.startsWith("com.k_int.kbplus.Subscription:")) {
      def subid = params.sub.split(":")[1]
      sub = Subscription.get(subid)
      params_sub = [sub:params.sub]
    }
    
    def ok = true
    if (params.allinsub && params.allinsub=='yes') {
      if (sub) {
        def ie_base_qry = "select ie from IssueEntitlement as ie where ie.subscription=:sub group by ie.tipp"
        def ies = IssueEntitlement.executeQuery(ie_base_qry, [sub:sub])
        ies.each { ie ->
          log.debug("checking tip with id: ${ie.getTIP().id}")
          ie.extendCoreDates(startDate, endDate)
        }
      }
      else {
        ok = false
        flash.error = "Error: Could not find Subscription"
      }
    }
    else {
      params.each { p ->
        if ( p.key.startsWith('_tip.') && (p.value=='on')) {
          def tipid = p.key.substring(5)
          if (tipid) {
            def tip = TitleInstitutionProvider.get(tipid)
            if (tip) {
              log.debug("checking tip with id: ${tip.id}")
              tip.extendCoreExtent(startDate, endDate)
            }
          }
        }
      }
    }
    
    if (ok) {
      flash.message = "Success: Core Dates extended"
    }
    else {
      flash.error = "Error: Something went wrong"
    }
    
    def params_sc = []
    if (params.defaultInstShortcode) {
      params_sc = [defaultInstShortcode:params.defaultInstShortcode]
    }
    redirect action: 'index', params:[sort:params.sort,offset:params.offset,max:params.max] + params_sub + params_sc
  }
  
  def processTIPDates(tip, coreStartDate, coreEndDate) {
    def message = [:]
    try {
      def sdf = new java.text.SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
      def startDate = sdf.parse(coreStartDate)
      def endDate = coreEndDate? sdf.parse(coreEndDate) : null
      if(startDate) {
        log.debug('tip: ' + tip)
        log.debug("Extending tip ${tip.id} with start ${startDate} and end ${endDate}")
        tip.extendCoreExtent(startDate, endDate)
        
        message.message = "Success: Core Dates extended"
        message.success = true
      }
    } catch (Exception e) {
        log.error("Error while extending core dates",e)
        message.message = "Error: Extending of core date failed."
        message.success = false
    }
    
    message
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def closeOutCore() {
    log.debug("closeOutCore(${params})");
    try {
      if ( ( params.id != null ) && ( params.coreEndDate != null ) ) {
        TitleInstitutionProvider tip = TitleInstitutionProvider.get(params.id)
        def sdf = new java.text.SimpleDateFormat(session.sessionPreferences?.globalDateFormat)
        def end_date = sdf.parse(params.coreEndDate)
        tip.coreDates.each { cd ->
          if (cd.endDate == null) {
            cd.endDate=end_date
            cd.save(flush:true, failOnError:true);
          }
        }
      }
    }
    catch ( Exception e ) {
      log.error("problem",e);
      flash.message=e.message()
    }

    def referer = request.getHeader('referer')
    redirect(url: referer)
  }
}
