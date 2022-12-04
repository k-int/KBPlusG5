package kbplus

import com.k_int.kbplus.Org
import com.k_int.kbplus.auth.*;

import groovy.util.logging.Slf4j

@Slf4j
class PreferencesInterceptor {

  def springSecurityService

  PreferencesInterceptor() {
    matchAll()
  }

  boolean before() { 
    if ( springSecurityService.isLoggedIn() ) {

      if ( springSecurityService.principal instanceof String ) {
        log.debug("User is string: ${springSecurityService.principal}");
      }
      else if (springSecurityService.principal?.id != null ) {
        log.debug("Set request.user to ${springSecurityService.principal?.id}");
        request.user = User.get(springSecurityService.principal.id);
  
        // Just set the user preferences equal to those of the current user.
        if ( session.userPereferences == null ) {
          session.userPereferences = request.user.getUserPreferences()
        }
      }
      else {
        log.debug("unable to get principal");
      }
    }

    if ( params.defaultInstShortcode ) {
      log.debug("Got default institution shortcode ${params.defaultInstShortcode}");
      def inst = Org.findByShortcode(params.defaultInstShortcode)
      if ( inst ) {
        request.setAttribute('institution', inst);
      }
      else {
        log.error("No such shortcode: ${params.defaultInstShortcode} - Not setting");
      }
    }

    if ( session.sessionPreferences == null ) {
      log.debug('session preferences null')
      session.sessionPreferences = grailsApplication.config.appDefaultPrefs
      log.debug('session preferences set: ' + session?.sessionPreferences)
    }
    else {
      log.debug("Set session preferences to user(${springSecurityService?.principal}) defaults ${session.userPereferences}");
    }

    true 
  }

  boolean after() { 
    true 
  }

  void afterView() {
      // no-op
  }

}
