package com.k_int.kbplus

import grails.plugin.springsecurity.annotation.Secured

class PendingChangeController {

 def genericOIDService
 def pendingChangeService
 def executorService

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def accept() {
    log.debug("Accept");
    pendingChangeService.performAccept(params.id,request);
	
	def referer = true
	if (params.referer && params.referer=='no') {
	  referer = false
	}
	
	if (referer) {
	  redirect(url: request.getHeader('referer'))
	}
	else {
	  render 'Pending Change Accepted.'
	}
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def reject() {
    log.debug("Reject");
    pendingChangeService.performReject(params.id,request);
	
	def referer = true
	if (params.referer && params.referer=='no') {
	  referer = false
	}
	
	if (referer) {
	  redirect(url: request.getHeader('referer'))
	}
	else {
	  render 'Pending Change Rejected.'
	}
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def acceptAll() {
    log.debug("acceptAll - ${params}")
    def owner = genericOIDService.resolveOID(params.id)

    log.debug("Looked up the following owner for ${params.id} : ${owner} ${owner.class.name} ${owner.id} Size of owner pending changes is ${owner.pendingChanges?.size()}");

    if ( owner ) {
      def changes_to_accept = []
      def pending_change_pending_status = RefdataCategory.lookupOrCreate("PendingChangeStatus", "Pending")

      def pendingChanges = owner.pendingChanges.findAll {(it.status == pending_change_pending_status) || it.status == null}

      changes_to_accept = pendingChanges.collect{it.id}

      log.debug("Collected pending changes: ${pendingChanges}");
      def user= [user:request.user]

      if ( pendingChanges.size() > 0 ) {
        executorService.execute({
          changes_to_accept.each { pc ->
            pendingChangeService.performAccept(pc,user)
          }
        } as java.util.concurrent.Callable)

        flash.message = "Accepting ${changes_to_accept.size()} changes in the background. Please check back later"
      }
      else {
        log.warn("Unable to locate any pending changes for ${params.id} - this shouldn't happen.");
      }
    }
    else {
      throw new RuntimeException("Failed to locate change owner (${params.id}) - please take a screenshot and notify support.");
    }
    redirect(url: request.getHeader('referer'))
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def rejectAll() {
    log.debug("rejectAll ${params}")
    def owner = genericOIDService.resolveOID(params.id)

    def changes_to_reject = []
    def pending_change_pending_status = RefdataCategory.lookupOrCreate("PendingChangeStatus", "Pending")
    def pendingChanges = owner.pendingChanges.findAll {(it.status == pending_change_pending_status) || it.status == null}
    changes_to_reject = pendingChanges.collect{it.id}
    
    def user= [user:request.user]

    executorService.execute( {
      asyncRejectAll(changes_to_reject, user);
    } as java.util.concurrent.Callable )

    flash.message = "Rejecting ${changes_to_reject.size()} changes in the background. Please check back later"

    log.debug("rejectAll complete");
    redirect(url: request.getHeader('referer'))
  }  

  private void asyncRejectAll(changes,user) {
    log.debug("start");
    try {
      changes.each { pc ->
        log.debug("Reject ${pc}");
        pendingChangeService.performReject(pc,user)
      }
      log.debug("end");
    }
    catch ( Exception e ) {
        e.printStackTrace();
    }
  }
}
