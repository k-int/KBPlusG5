package com.k_int.kbplus


import grails.converters.*
import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.annotation.Secured
import grails.converters.*
import org.elasticsearch.groovy.common.xcontent.*
import groovy.xml.MarkupBuilder
import com.k_int.kbplus.auth.*;

class ProfileController {

  def springSecurityService

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def index() {
    log.debug("ProfileController::index (${springSecurityService?.principal?.id})");
    log.debug("Current user roles: ${springSecurityService.getPrincipal().getAuthorities()}");
    def result = [:]
    if ( springSecurityService.principal ) {
      result.user = User.get(springSecurityService.principal.id)

      if ( result.user == null ) {
        log.error("unable to locate USER from ${springSecurityService?.principal.id}");
      }
      else {
        log.debug("Got user ${result.user}");
        List valid_user_org_ids = result.user.authorizedOrgs.collect{ it.id }
        if ( result.user.defaultDash?.id != null ) {
          if ( valid_user_org_ids.contains(result.user.defaultDash?.id) ) {
            log.debug("All is well - user default dash is ${result.user.defaultDash?.id} possibiles are: ${valid_user_org_ids}");
          }
          else { 
            log.warn("Invalid user default dash - removing");
            result.user.defaultDash = null;
            result.user.save(flush:true, failOnError:true);
          }
        }
      }
    }
    else {
      log.error("No principal available in request...");
    }

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processJoinRequest() {
    log.debug("processJoinRequest(${params}) org with id ${params.org} role ${params.formalRole}");
    def user = User.get(springSecurityService.principal.id)
    def org = com.k_int.kbplus.Org.get(params.org)
    def formal_role = com.k_int.kbplus.auth.Role.get(params.formalRole)

    try {
      if ( ( org != null ) && ( formal_role != null ) ) {
        def existingRel = UserOrg.find( { org==org && user==user && formalRole==formal_role } )
        if ( existingRel ) {
          log.debug("existing rel");
          flash.error="You already have a relation with the requested organisation."
        }
        else {
          log.debug("Create new user_org entry....");
          def p = new UserOrg(dateRequested:System.currentTimeMillis(),
                              status:0,
                              org:org,
                              user:user,
                              formalRole:formal_role)
          p.save(flush:true, failOnError:true)
        }
      }
      else {
        log.error("Unable to locate org or role");
      }
    }
    catch ( Exception e ) {
      log.error("Problem requesting affiliation",e);
    }

    redirect(controller:'profile', action: "index")
  }


  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def updateProfile() {
    def user = User.get(springSecurityService.principal?.id)

    flash.message=""

    if ( user.display != params.userDispName ) {
      user.display = params.userDispName
      flash.message += "User display name updated"
    }

    if ( user.email != params.email ) {
      def mailPattern = /[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*(\.[A-Za-z]{2,})/
      if ( params.email ==~ mailPattern ) {
        user.email = params.email
        flash.message += "User email address updated"
      }
      else {
        flash.error = "Emails must be of the form user@domain.name"
      }
    }



    if ( params.defaultPageSize != null ) {
      try {
        long l = Long.parseLong(params.defaultPageSize);
        if ( ( l >= 5 ) && ( l <= 100 ) ) {
          Long new_long = new Long(l);
          if ( new_long != user.defaultPageSize ) {
            flash.message += "User default page size updated"
          }
          user.defaultPageSize = new_long

        }
        else {
          flash.message+="Default page size must be between 5 and 100";
        }
      }
      catch ( Exception e ) {
      }
    }

    if ( params.defaultDash != user.defaultDash?.id.toString() ) {
      flash.message+="User default dashboard updated"
      if ( params.defaultDash == '' ) {
        user.defaultDash = null
      }
      else {
        user.defaultDash = Org.get(params.defaultDash);
      }
    }

	if ( SpringSecurityUtils.ifAnyGranted('ROLE_ADMIN,ROLE_KBPLUS_EDITOR') ) {
		if (params.recAdminEmails) {
			RefdataValue rdv = RefdataValue.get(params.recAdminEmails)
			if (rdv) {
				user.recAdminEmails = rdv
			}
		}
		else {
			user.recAdminEmails = null
		}
	}

    user.save(flush:true,failOnError:true);


    redirect(action: "index")
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def addTransforms() {

    def user = User.get(springSecurityService.principal?.id)
    def transforms = Transforms.findById(params.transformId)

    if(user && transforms){
      def existing_transform = UserTransforms.findByUserAndTransforms(user,transforms);
      if ( existing_transform == null ) {
        new UserTransforms(
            user: user,
            transforms: transforms).save(failOnError: true)
        flash.message="Transformation added"
      }
      else {
        flash.error="You already have added this transform."
      }
    }else{
      log.error("Unable to locate transforms");
      flash.error="Error we could not add this transformation"
    }

    redirect(action: "index")
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def removeTransforms() {
    def user = User.get(springSecurityService.principal?.id)
    def transforms = Transforms.findById(params.transformId)

    //Check if has already transforms
    if(user && transforms){
      def existing_transform = UserTransforms.findByUserAndTransforms(user,transforms);
      if(existing_transform){
        transform.delete(failOnError: true, flush: true)
        flash.message="Transformation removed from your list."
      }else{
        flash.error="This transformation is not in your list."
      }
    }else{
      log.error("Unable to locate transforms");
      flash.error="Error we could not remove this transformation"
    }

    redirect(action: "index")
  }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def createReminder() {
        log.debug("Profile :: createReminder - ${params}")
        def result    = [:]
        def user      = User.load(springSecurityService.principal?.id)
        def trigger   = (params.int('trigger'))? RefdataValue.load(params.trigger) : RefdataCategory.lookupOrCreate("ReminderTrigger","Subscription Manual Renewal Date")
        def remMethod = (params.int('method'))?  RefdataValue.load(params.method)  : RefdataCategory.lookupOrCreate("ReminderMethod","email")
        def unit      = (params.int('unit'))?    RefdataValue.load(params.unit)    : RefdataCategory.lookupOrCreate("ReminderUnit","Day")


        def reminder = new Reminder(trigger: trigger, unit: unit, reminderMethod: remMethod, amount: params.getInt('val')?:1, user: user, active: Boolean.TRUE)
        if (reminder.save())
        {
            log.debug("Profile :: Index - Successfully saved reminder, adding to user")
            user.addToReminders(reminder)
            log.debug("User has following reminders ${user.reminders}")
            result.status   = true
            result.reminder = reminder
        } else {
            result.status = false
            flash.error="Unable to create the reminder, invalid data received"
            log.debug("Unable to save Reminder for user ${user.username}... Params as follows ${params}")
        }
        if (request.isXhr())
            render result as JSON
        else
            redirect(action: "index", fragment: "reminders")
    }


    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def updateReminder() {
        def result    = [:]
        result.status = true
        result.op     = params.op
        def user      = User.get(springSecurityService.principal?.id)
        def reminder  = Reminder.findByIdAndUser(params.id,user)
        if (reminder)
        {
            switch (result.op)
            {
                case 'delete':
                    user.reminders.clear()
                    user.reminders.remove(reminder)
                    reminder.delete(flush: true)
                    break
                case 'toggle':
                    reminder.active = !reminder.active
                    result.active   = reminder.active? 'disable':'enable'
                    break
                default:
                    result.status = false
                    log.error("Profile :: updateReminder - Unsupported operation for update reminder ${result.op}")
                    break
            }
        } else
            result.status = false

        render result as JSON
    }
}
