import grails.plugin.springsecurity.userdetails.*;
import org.springframework.security.core.userdetails.*;
import grails.plugin.springsecurity.*;
import org.springframework.security.web.authentication.preauth.*;
import com.k_int.utils.DatabaseMessageSource;
import org.grails.spring.context.support.PluginAwareResourceBundleMessageSource;

beans = {
  userDetailsService(GormUserDetailsService) {
    grailsApplication = ref('grailsApplication')
  }

  userDetailsByNameServiceWrapper(UserDetailsByNameServiceWrapper) {
    userDetailsService = ref('userDetailsService')
  }

  preAuthenticatedAuthenticationProvider(PreAuthenticatedAuthenticationProvider) {
    preAuthenticatedUserDetailsService = ref('userDetailsByNameServiceWrapper')
  }

  // securityContextPersistenceFilter(org.springframework.security.web.context.SecurityContextPersistenceFilter){
  // }

  ediAuthTokenMap(java.util.HashMap) {
  }

  ediauthFilter(com.k_int.kbplus.filter.EdiauthFilter){
    grailsApplication = ref('grailsApplication')
    authenticationManager = ref('authenticationManager')
    ediAuthTokenMap = ref('ediAuthTokenMap')
  }

  messageSource(DatabaseMessageSource) {
    messageBundleMessageSource = ref("messageBundleMessageSource")
  }

  messageBundleMessageSource(PluginAwareResourceBundleMessageSource) {
    basenames = "WEB-INF/grails-app/i18n/messages"
  }
}

