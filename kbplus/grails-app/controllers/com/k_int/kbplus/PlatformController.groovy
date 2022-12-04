package com.k_int.kbplus

import grails.plugin.springsecurity.SpringSecurityUtils

import org.springframework.dao.DataIntegrityViolationException

import grails.converters.*

import org.elasticsearch.groovy.common.xcontent.*

import groovy.xml.MarkupBuilder
import grails.plugin.springsecurity.annotation.Secured

import com.k_int.kbplus.auth.*;

class PlatformController {

    def springSecurityService

    static allowedMethods = [create: ['GET', 'POST'], edit: ['GET', 'POST'], delete: 'POST']

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def index() {
        redirect action: 'list', params: params
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def list() {

      log.debug("list(${params})");

      def result = [:]

      result.user = User.get(springSecurityService.principal.id)
      result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;

      result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

        def deleted_platform_status =  RefdataCategory.lookupOrCreate( 'Platform Status', 'Deleted' );
        def qry_params = []

        // def base_qry = " from Platform as p where ( (p.status is null ) OR ( p.status = ? ) )"
        def base_qry = " from Platform as p "
        def have_where = false

        if ( params.q?.length() > 0 ) {
            have_where = true
            base_qry += "where p.normname like ?"
            qry_params.add("%${params.q.trim().toLowerCase()}%");
        }

        if( params.deletedRecordHandling?.length() > 0 ) {
          switch ( params.deletedRecordHandling.trim().toLowerCase() ) {

            case 'all':
               break;

            case 'only':
               if ( !have_where ) {
                 base_qry += 'where '
                 have_where = true
               }
               else {
                 base_qry += 'and '
               }
               base_qry += 'p.status = ?'
               qry_params.add(deleted_platform_status);
               break;
              
            case 'exclude':
               if ( !have_where ) {
                 base_qry += 'where '
                 have_where = true
               }
               else {
                 base_qry += 'and '
               }
               base_qry += '( (p.status is null ) OR ( p.status = ? ) )'
               qry_params.add(deleted_platform_status)
               break;
          }
        }

        if ( params.sort ) {
          base_qry += "order by p.${params.sort} ${params.order?:'asc'}"
        }
        else {
          base_qry += "order by p.name asc"
        }

        log.debug('base query: ' + base_qry)
        log.debug('qry params: ' + qry_params)

        result.platformInstanceTotal = Subscription.executeQuery("select count(p) ${base_qry}".toString(), qry_params )[0]
        result.platformInstanceList = Subscription.executeQuery("select p ${base_qry}".toString(), qry_params, [max:result.max, offset:result.offset]);

      result
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def create() {
    switch (request.method) {
    case 'GET':
          [platformInstance: new Platform(params)]
      break
    case 'POST':
          def platformInstance = new Platform(params)
          if (!platformInstance.save(flush: true)) {
              render view: 'create', model: [platformInstance: platformInstance]
              return
          }

		  def params_sc = []
		  if (params.defaultInstShortcode) {
			  params_sc = [defaultInstShortcode:params.defaultInstShortcode]
		  }
          flash.message = message(code: 'default.created.message', args: [message(code: 'platform.label', default: 'Platform'), platformInstance.id])
          redirect action: 'show', id: platformInstance.id, params:params_sc
      break
    }
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def show() {
      def editable
      def platformInstance = Platform.get(params.id)
      if (!platformInstance) {
        flash.message = message(code: 'default.not.found.message', 
                                args: [message(code: 'platform.label', default: 'Platform'), params.id])
        redirect action: 'list'
        return
      }

      if ( SpringSecurityUtils.ifAllGranted('ROLE_ADMIN') ) {
          editable = true
      }
      else {
          editable = false
      }
	  
	  def packages = [:]
	  def package_list = []
	  int pkg_count = 0;

	  log.debug("Adding packages");
	  // Find all packages
	  platformInstance.tipps.each{ tipp ->
		  // log.debug("Consider ${tipp.title.title}")
		  if ( !packages.keySet().contains(tipp.pkg.id) ) {
			  package_list.add(tipp.pkg)
			  packages[tipp.pkg.id] = [position:pkg_count++, pkg:tipp.pkg]
		  }
	  }

      [platformInstance: platformInstance, editable: editable, packages: package_list]

    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def template() {
      def editable
      def platformInstance = Platform.get(params.id)
      if (!platformInstance) {
        flash.message = message(code: 'default.not.found.message', args: [message(code: 'platform.label', default: 'Platform'), params.id])
        redirect action: 'list'
        return
      }

      if ( SpringSecurityUtils.ifAllGranted('ROLE_ADMIN') ) {
          editable = true
      }
      else {
          editable = false
      }

      if ( request.method=="POST" ) {

          if (params.startDate && params.tmplate) {
              def sdf = new java.text.SimpleDateFormat('yyyy-MM-dd');
              def new_start_date = sdf.parse(params.startDate)

              def put = new PlatformUrlTemplate(
                      startsOn: new_start_date,
                      templateUrl: params.tmplate,
                      platform: platformInstance).save(flush: true, failOnError: true)

              platformInstance.refresh()
          } else {
              if (params.startDate) {
                  flash.message = message(code: 'default.blank.message', args: ["Template URL", message(code: 'platform.label', default: 'Platform')])
              } else {
                  flash.message = message(code: 'default.blank.message', args: ["Start date", message(code: 'platform.label', default: 'Platform')])
              }
          }
      }

      def demotipp = null;
      if ( platformInstance.tipps?.size() > 0 ) {
        demotipp = platformInstance.tipps.getAt(0)
      }
  

      [platformInstance: platformInstance, editable: editable, demotipp:demotipp]

    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def removeTemplate() {
      def t = PlatformUrlTemplate.get(params.id)
      if (t ) {
        t.delete(flush:true, failOnError:true)
      }
	  
	  if (params.reload && params.reload=='yes') {
	    def platformInstance = Platform.get(params.platformId)
		def editable
		if ( SpringSecurityUtils.ifAllGranted('ROLE_ADMIN') ) {
			editable = true
		}
		else {
			editable = false
		}
		
		def demotipp = null;
		if ( platformInstance.tipps?.size() > 0 ) {
		  demotipp = platformInstance.tipps.getAt(0)
		}
		
		render(view: "template", model: [platformInstance: platformInstance, editable: editable, demotipp: demotipp])
	  }
	  else {
        redirect(url: request.getHeader('referer'))
	  }
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def tipp() {
        def editable
        def platformInstance = Platform.get(params.id)
        if (!platformInstance) {
            flash.message = message(code: 'default.not.found.message',
                    args: [message(code: 'platform.label', default: 'Platform'), params.id])
            redirect action: 'list'
            return
        }

        if ( SpringSecurityUtils.ifAllGranted('ROLE_ADMIN') ) {
            editable = true
        }
        else {
            editable = false
        }

        // Build up a crosstab array of title-platforms under this package
        def packages = [:]
        def package_list = []
        def titles = [:]
        def title_list = []
        int pkg_count = 0;
        int title_count = 0;

        log.debug("Adding packages");
        // Find all platforms
        platformInstance.tipps.each{ tipp ->
            // log.debug("Consider ${tipp.title.title}")
            if ( !packages.keySet().contains(tipp.pkg.id) ) {
                package_list.add(tipp.pkg)
                packages[tipp.pkg.id] = [position:pkg_count++, pkg:tipp.pkg]
            }
        }

        // Find all titles
        platformInstance.tipps.each{ tipp ->
            if ( !titles.keySet().contains(tipp.title.id) ) {
                title_list.add([title:tipp.title])
                titles[tipp.title.id] = [:]
            }
        }

        title_list.sort{it.title.title}
        title_list.each { t ->
            // log.debug("Add title ${t.title.title}")
            t.position = title_count
            titles[t.title.id].position = title_count++
        }

        def crosstab = new Object[title_list.size()][package_list.size()]

        // Now iterate through all tipps, puttint them in the right cell
        platformInstance.tipps.each{ tipp ->
            int pkg_col = packages[tipp.pkg.id].position
            int title_row = titles[tipp.title.id].position
            if ( crosstab[title_row][pkg_col] != null ) {
                log.error("Warning - already a value in this cell.. it needs to be a list!!!!!");
            }
            else {
                crosstab[title_row][pkg_col] = tipp;
            }
        }

        [platformInstance: platformInstance, packages:package_list, crosstab:crosstab, titles:title_list, editable: editable]
    }
	
	@Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
	def editPlatform(){
		def result = [:]
		log.debug('getting edit modal: ' + params)
		result.platformInstance = Platform.get(params.id)
		
		def rdv_qry = "select rdv from RefdataValue as rdv where rdv.owner.desc=:desc"
		def service_values = RefdataValue.executeQuery(rdv_qry,[desc:'ServiceProvider'])
		def software_values = RefdataValue.executeQuery(rdv_qry,[desc:'SoftwareProvider'])
		
		render(template:"editPlatform", model:[platformInstance:result.platformInstance, service_values:service_values, software_values:software_values])
	}
	
	@Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
	def processEditPlatform(){
		log.debug('params: ' + params)
		
		def platform = Platform.get(params.id)
		
		platform.name = params.platformName
		
		platform.primaryUrl = params.primaryUrl
		
		if (params.status) {
			def status =  RefdataValue.get(params.status)
			if (status) {
				platform.status = status
			}
		}
		
		if (params.serviceProvider) {
			def serviceProvider =  RefdataValue.get(params.serviceProvider)
			if (serviceProvider) {
				platform.serviceProvider = serviceProvider
			}
		}
		
		if (params.softwareProvider) {
			def softwareProvider =  RefdataValue.get(params.softwareProvider)
			if (softwareProvider) {
				platform.softwareProvider = softwareProvider
			}
		}
		
		log.debug('attempting to save edited platform with id: ' + params.id)
		platform.save(flush:true, failOnError:true)
		log.debug('saved edited platform with id: ' + params.id)
		
		redirect(url: request.getHeader('referer'))
	}

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def edit() {
    switch (request.method) {
    case 'GET':
          def platformInstance = Platform.get(params.id)
          if (!platformInstance) {
              flash.message = message(code: 'default.not.found.message', args: [message(code: 'platform.label', default: 'Platform'), params.id])
              redirect action: 'list'
              return
          }

          [platformInstance: platformInstance]
      break
    case 'POST':
          def platformInstance = Platform.get(params.id)
          if (!platformInstance) {
              flash.message = message(code: 'default.not.found.message', args: [message(code: 'platform.label', default: 'Platform'), params.id])
              redirect action: 'list'
              return
          }

          if (params.version) {
              def version = params.version.toLong()
              if (platformInstance.version > version) {
                  platformInstance.errors.rejectValue('version', 'default.optimistic.locking.failure',
                            [message(code: 'platform.label', default: 'Platform')] as Object[],
                            "Another user has updated this Platform while you were editing")
                  render view: 'edit', model: [platformInstance: platformInstance]
                  return
              }
          }

          platformInstance.properties = params

          if (!platformInstance.save(flush: true)) {
              render view: 'edit', model: [platformInstance: platformInstance]
              return
          }

      flash.message = message(code: 'default.updated.message', args: [message(code: 'platform.label', default: 'Platform'), platformInstance.id])
          redirect action: 'show', id: platformInstance.id
      break
    }
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def delete() {
        def platformInstance = Platform.get(params.id)
        if (!platformInstance) {
      flash.message = message(code: 'default.not.found.message', args: [message(code: 'platform.label', default: 'Platform'), params.id])
            redirect action: 'list'
            return
        }

        try {
            platformInstance.delete(flush: true)
      flash.message = message(code: 'default.deleted.message', args: [message(code: 'platform.label', default: 'Platform'), params.id])
            redirect action: 'list'
        }
        catch (DataIntegrityViolationException e) {
      flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'platform.label', default: 'Platform'), params.id])
            redirect action: 'show', id: params.id
        }
    }
}
