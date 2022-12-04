package com.k_int.kbplus

import org.springframework.dao.DataIntegrityViolationException
import grails.plugin.springsecurity.annotation.Secured
import grails.converters.*
import org.elasticsearch.groovy.common.xcontent.*
import groovy.xml.MarkupBuilder
import com.k_int.kbplus.auth.*;
import grails.plugin.springsecurity.SpringSecurityUtils
import com.k_int.custprops.PropertyDefinition

class OrganisationsController {

    def springSecurityService

    static allowedMethods = [create: ['GET', 'POST'], edit: ['GET', 'POST'], delete: 'POST']

    @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
    def index() {
        redirect action: 'list', params: params
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def config() {
      def result = [:]
      result.user = User.get(springSecurityService.principal.id)
      def orgInstance = Org.get(params.id)

      if ( SpringSecurityUtils.ifAllGranted('ROLE_ADMIN') ) {
        result.editable = true
      }
      else {
        result.editable = orgInstance.hasUserWithRole(result.user,'INST_ADM');
      }
      if(! orgInstance.customProperties){
        grails.util.Holders.config.customProperties.org.each{ 
          def entry = it.getValue()
          def type = PropertyDefinition.lookupOrCreateType(entry.name,entry.class,PropertyDefinition.ORG_CONF)
          def prop = PropertyDefinition.createPropertyValue(orgInstance,type)
          prop.note = entry.note
          prop.save()
        }
      }

      if (!orgInstance) {
        flash.message = message(code: 'default.not.found.message', args: [message(code: 'org.label', default: 'Org'), params.id])
        redirect action: 'list'
        return
      }

      result.orgInstance=orgInstance
      result
    }
	
    @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
    def list() {

      def result = [:]
      result.user = User.get(springSecurityService.principal.id)

      //params.max = Math.min(params.max ? params.int('max') : 10, 100)
	  result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;
	  result.offset = params.offset ? Integer.parseInt(params.offset) : 0;
      def results = null;
      def count = null;

      def base_qry = "from Org o "
      def qry_params = [:]

      if ( ( params.orgNameContains != null ) && ( params.orgNameContains.length() > 0 ) ) {
        base_qry += "where lower(o.name) like :orgname or exists ( from o.variantNames vn where lower(vn.variantName) like :orgname ) "
        qry_params.orgname = "%${params.orgNameContains.toLowerCase()}%"
      }

      if ( ( params.orgRole != null ) && ( params.orgRole.length() > 0 ) ) {
        if ( base_qry.contains('where') ) {
          base_qry += ' AND '
        }
        else {
          base_qry += ' where '
        }
        base_qry += " exists ( from o.links r where r.roleType.id = :roltype ) "
        qry_params.roltype = Long.parseLong(params.orgRole)
      }

      if ( ( params.orgStatus != null ) && ( params.orgStatus.length() > 0 ) ) {
       if ( base_qry.contains('where') ) {
          base_qry += ' AND '
        }
        else {
          base_qry += ' where '
        }
        base_qry += " o.status.id = :status ) "
        qry_params.status = Long.parseLong(params.orgStatus)
      }
	  
	  if ((params.sort != null) && (params.sort.length() > 0)) {
		  def sortOpts = params.sort.tokenize(':')
		  if (sortOpts.size() == 2) {
			  base_qry += " order by o.${sortOpts[0]} ${sortOpts[1]}"
		  }
		  else {
			  base_qry += " order by o.name asc"
		  }
	  } else {
		  base_qry += " order by o.name asc"
	  }

      results = Org.findAll(base_qry, qry_params, [max: result.max, offset: result.offset]);
      count = Org.executeQuery("select count(o) ${base_qry}".toString(), qry_params)[0]

      result.orgInstanceList = results;
      result.orgInstanceTotal=count

      result
    }

    @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
    def create() {
    switch (request.method) {
    case 'GET':
        if (!params.name && !params.sector) {
        params.sector = 'Higher Education'
        }
          [orgInstance: new Org(params)]
      break
    case 'POST':
          def orgInstance = new Org(params)
          if (!orgInstance.save(flush: true)) {
              render view: 'create', model: [orgInstance: orgInstance]
              return
          }

      flash.message = message(code: 'default.created.message', args: [message(code: 'org.label', default: 'Org'), orgInstance.id])
          redirect action: 'show', id: orgInstance.id
      break
    }
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def show() {
      def result = [:]
      result.user = User.get(springSecurityService.principal.id)
      def orgInstance = Org.get(params.id)

      if ( SpringSecurityUtils.ifAllGranted('ROLE_ADMIN') ) {
        result.editable = true
      }
      else {
        result.editable = orgInstance.hasUserWithRole(result.user,'INST_ADM');
      }

      if (!orgInstance) {
        flash.message = message(code: 'default.not.found.message', args: [message(code: 'org.label', default: 'Org'), params.id])
        redirect action: 'list'
        return
      }
	  
	  def tracked_roles = ["ROLE_KBPLUS_EDITOR":"KB+ Editor","ROLE_ADMIN":"KB+ Administrator"]
	  result.users = orgInstance.affiliations.collect{ userOrg ->
        def admin_roles = []
		userOrg.user.roles.each{
          if (tracked_roles.keySet().contains(it.role.authority)){
		    def role_match = tracked_roles.get(it.role.authority)+" (${it.role.authority})"
		    admin_roles += role_match
		  }
		}
		// log.debug("Found roles: ${admin_roles} for user ${userOrg.user.displayName}")
		return [userOrg,admin_roles?:null]
	  }

      result.orgInstance=orgInstance
      result
    }
	
	@Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
	def updateOrgDetails() {
		log.debug("params: " + params)
		
		def user = User.get(springSecurityService.principal.id)
		def org = Org.get(params.id)
		def editable = false
		
		if ( SpringSecurityUtils.ifAllGranted('ROLE_ADMIN') ) {
			editable = true
		}
		else {
			editable = org.hasUserWithRole(user,'INST_ADM');
		}
		
		if (editable) {
			org.name = params.name
			org.address = params.address
			if (params.orgType) {
				org.orgType = RefdataValue.get(params.orgType)
			}
			else {
				org.orgType = null
			}
			org.ipRange = params.ipRange
			org.scope = params.scope
			org.membershipOrganisation = params.membershipOrganisation
			org.sector = params.sector
			
			org.save(flush:true, failOnError:true)
		}
		
		redirect(url: request.getHeader('referer'))
	}
	
	@Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
	def addOrgIdentifier() {
		log.debug("params: " + params)
		def result = [:]
		result.user = User.get(springSecurityService.principal.id)
		result.orgInstance = Org.get(params.id)
		
		if (params.anchor) {
			result.anchor = params.anchor
		}
		
		result
	}

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def users() {
      def result = [:]
      result.user = User.get(springSecurityService.principal.id)
      def orgInstance = Org.get(params.id)
	  
      
      if ( orgInstance.hasUserWithRole(result.user,'INST_ADM') ) {
        result.editable = true
      }
      def tracked_roles = ["ROLE_KBPLUS_EDITOR":"KB+ Editor","ROLE_ADMIN":"KB+ Administrator"]

      if (!orgInstance) {
        flash.message = message(code: 'default.not.found.message', args: [message(code: 'org.label', default: 'Org'), params.id])
        redirect action: 'list'
        return
      }
      result.users = orgInstance.affiliations.collect{ userOrg ->
        def admin_roles = []
        userOrg.user.roles.each{ 
          if (tracked_roles.keySet().contains(it.role.authority)){
            def role_match = tracked_roles.get(it.role.authority)+" (${it.role.authority})"
            admin_roles += role_match
          }
        }
        // log.debug("Found roles: ${admin_roles} for user ${userOrg.user.displayName}")

        return [userOrg,admin_roles?:null]

      }
      // log.debug(result.users)
      result.orgInstance=orgInstance
      result
    }


    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def info() {
      def result = [:]

      result.user = User.get(springSecurityService.principal.id)

      def orgInstance = Org.get(params.id)
      if (!orgInstance) {
        flash.message = message(code: 'default.not.found.message', args: [message(code: 'org.label', default: 'Org'), params.id])
        redirect action: 'info'
        return
      }

      result.orgInstance=orgInstance
      result
    }


    @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
    def edit() {
    switch (request.method) {
    case 'GET':
          def orgInstance = Org.get(params.id)
          if (!orgInstance) {
              flash.message = message(code: 'default.not.found.message', args: [message(code: 'org.label', default: 'Org'), params.id])
              redirect action: 'list'
              return
          }

          [orgInstance: orgInstance, editable:true]
      break
    case 'POST':
          def orgInstance = Org.get(params.id)
          if (!orgInstance) {
              flash.message = message(code: 'default.not.found.message', args: [message(code: 'org.label', default: 'Org'), params.id])
              redirect action: 'list'
              return
          }

          if (params.version) {
              def version = params.version.toLong()
              if (orgInstance.version > version) {
                  orgInstance.errors.rejectValue('version', 'default.optimistic.locking.failure',
                            [message(code: 'org.label', default: 'Org')] as Object[],
                            "Another user has updated this Org while you were editing")
                  render view: 'edit', model: [orgInstance: orgInstance]
                  return
              }
          }

          orgInstance.properties = params

          if (!orgInstance.save(flush: true)) {
              render view: 'edit', model: [orgInstance: orgInstance, editable:true]
              return
          }

      flash.message = message(code: 'default.updated.message', args: [message(code: 'org.label', default: 'Org'), orgInstance.id])
          redirect action: 'show', id: orgInstance.id
      break
    }
    }

    @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
    def delete() {
        def orgInstance = Org.get(params.id)
        if (!orgInstance) {
      flash.message = message(code: 'default.not.found.message', args: [message(code: 'org.label', default: 'Org'), params.id])
            redirect action: 'list'
            return
        }

        try {
            orgInstance.delete(flush: true)
      flash.message = message(code: 'default.deleted.message', args: [message(code: 'org.label', default: 'Org'), params.id])
            redirect action: 'list'
        }
        catch (DataIntegrityViolationException e) {
      flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'org.label', default: 'Org'), params.id])
            redirect action: 'show', id: params.id
        }
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def revokeRole() {
      def result = [:]
      result.user = User.get(springSecurityService.principal.id)
      UserOrg uo = UserOrg.get(params.grant)
      if ( uo.org.hasUserWithRole(result.user,'INST_ADM') ) {
        uo.status = 2;
        uo.save(flush:true, failOnerror:true);
      }
	  
	  def referer = request.getHeader('referer')
	  if (params.anchor) {
		  referer += params.anchor
	  }
	  
	  redirect(url: referer)
      //redirect action: 'users', id: params.id
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def enableRole() {
      def result = [:]
      result.user = User.get(springSecurityService.principal.id)
      UserOrg uo = UserOrg.get(params.grant)
      if ( uo.org.hasUserWithRole(result.user,'INST_ADM') ) {
        uo.status = 1;
        uo.save(flush:true, failOnerror:true);
      }
	  
	  def referer = request.getHeader('referer')
	  if (params.anchor) {
		  referer += params.anchor
	  }
	  
	  redirect(url: referer)
      //redirect action: 'users', id: params.id
    }


    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def deleteRole() {
      def result = [:]
      result.user = User.get(springSecurityService.principal.id)
      UserOrg uo = UserOrg.get(params.grant)
      if ( uo.org.hasUserWithRole(result.user,'INST_ADM') ) {
        uo.delete(flush:true);
      }
	  
	  def referer = request.getHeader('referer')
	  if (params.anchor) {
		  referer += params.anchor
	  }
	  
	  redirect(url: referer)
      //redirect action: 'users', id: params.id
    }

    @Secured(['ROLE_KBPLUS_EDITOR','ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
    def removeVariant() {
      log.debug("removeVariant(${params})");
      if ( params.v ) {
        OrgVariantName ovn = OrgVariantName.get(params.v) 
        if ( ovn.owner.id == params.long('id') ) {
          ovn.delete(flush:true, failOnError:true);
        }
        else {
          log.error("Identified org does not match variant name");
        }
      }
      redirect(url: request.getHeader('referer'))

    }

}
