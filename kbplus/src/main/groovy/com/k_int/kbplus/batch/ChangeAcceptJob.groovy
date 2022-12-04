package com.k_int.kbplus.batch
import com.k_int.kbplus.auth.User
import com.k_int.kbplus.RefdataCategory
import com.k_int.kbplus.PendingChange
import org.springframework.scheduling.annotation.Scheduled



class ChangeAcceptJob {

  def pendingChangeService

  /**
   * Accept pending chnages from master subscriptions on slave subscriptions 
  **/
  @Scheduled(cron="0 5 3 * * ?")
  def execute(){
    log.debug("****Running Change Accept Job****")
  
    if ( grailsApplication.config?.master ?: true ) {
      def pending_change_pending_status = RefdataCategory.lookupOrCreate("PendingChangeStatus", "Pending")
      def user = User.findByDisplay("Admin")
      def httpRequestMock = [:]
      httpRequestMock.user = user
      // Get all changes associated with slaved subscriptions
      def subQueryStr = "select pc.id from PendingChange as pc where subscription.isSlaved.value = 'Yes' and ( pc.status is null or pc.status = ? ) order by pc.ts desc"
      def subPendingChanges = PendingChange.executeQuery(subQueryStr, [ pending_change_pending_status ]);
      log.debug(subPendingChanges.size() +" pending changes have been found for slaved subscriptions")
      subPendingChanges.each {
          pendingChangeService.performAccept(it,httpRequestMock)
      }
  
      def licQueryStr = "select pc.id from PendingChange as pc join pc.license.incomingLinks lnk where lnk.isSlaved.value = 'Yes' and ( pc.status is null or pc.status = ? ) order by pc.ts desc"
      def licPendingChanges = PendingChange.executeQuery(licQueryStr, [ pending_change_pending_status ]);
      log.debug( licPendingChanges.size() +" pending changes have been found for slaved licences")
      licPendingChanges.each {
          pendingChangeService.performAccept(it,httpRequestMock)
      }
    }
    else {
      log.debug("Node is not master - no action taken");
    }
 
    log.debug("****Change Accept Job Complete*****")
  }
}
