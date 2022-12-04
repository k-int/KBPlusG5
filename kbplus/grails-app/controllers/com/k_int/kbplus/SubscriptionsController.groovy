package com.k_int.kbplus

import org.springframework.dao.DataIntegrityViolationException
import grails.converters.*
import org.elasticsearch.groovy.common.xcontent.*
import groovy.xml.MarkupBuilder
import grails.plugin.springsecurity.annotation.Secured
import com.k_int.kbplus.auth.*;



class SubscriptionsController {

  def springSecurityService

  static allowedMethods = [create: ['GET', 'POST'], edit: ['GET', 'POST'], delete: 'POST']

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def index() {
      redirect action: 'list', params: params
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def list() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    result.subscriptionInstanceList=Subscription.list(params)
    result.subscriptionInstanceTotal=Subscription.count()
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def detail() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    result.subscriptionInstanceList=Subscription.list(params)
    result.subscriptionInstanceTotal=Subscription.count()
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def imported() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    result.subscriptionInstanceList=Subscription.list(params)
    result.subscriptionInstanceTotal=Subscription.count()
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def listtwo() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    result.subscriptionInstanceList=Subscription.list(params)
    result.subscriptionInstanceTotal=Subscription.count()
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def link() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    result.subscriptionInstanceList=Subscription.list(params)
    result.subscriptionInstanceTotal=Subscription.count()
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def platform() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    result.subscriptionInstanceList=Subscription.list(params)
    result.subscriptionInstanceTotal=Subscription.count()
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def platformDetail() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    result.subscriptionInstanceList=Subscription.list(params)
    result.subscriptionInstanceTotal=Subscription.count()
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def issueEnts() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    result.subscriptionInstanceList=Subscription.list(params)
    result.subscriptionInstanceTotal=Subscription.count()
    result
  }

  // List of controller methods removed -- NOte to designers -- Please do not add proxy methods to this controller class as a place to
  // hang screen wireframes. Please create screen wireframes in the correct controller location, or if you aren't sure, talk to k-int
  // about doing this for you. It's really hard to weed these things out after they are created, and all the side effects that this kind
  // of practice creates. For example -- financeList should be added under a proper finance controller so that the controller/view can be
  // fleshed out later
  //
  // ALso -- please don't create controller methods that represent new functionality unless we have discussed this is OK and we know where
  // in the URL structure those new features will live.
  //
  // PLEASE don't do this any more - financeList left here as an example of what not to do, other method will be removed as I audit them
  // and undo any side effects.
  //
  // @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  // def financeList() {
  //   def result = [:]
  //   result.user = User.get(springSecurityService.principal.id)
  //   params.max = Math.min(params.max ? params.int('max') : 10, 100)
  //   result.subscriptionInstanceList=Subscription.list(params)
  //   result.subscriptionInstanceTotal=Subscription.count()
  //   result
  // }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def financeDetail() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    result.subscriptionInstanceList=Subscription.list(params)
    result.subscriptionInstanceTotal=Subscription.count()
    result
  }

}
