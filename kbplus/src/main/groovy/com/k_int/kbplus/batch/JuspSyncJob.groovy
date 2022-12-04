package com.k_int.kbplus.batch

import org.springframework.scheduling.annotation.Scheduled



class JuspSyncJob {

  def juspSyncService

  @Scheduled(cron="0 5 2 1 * ?")
  def execute() {
    log.debug("Execute::JuspSyncJob");
    if ( grailsApplication.config?.master ?: true ) {
      log.debug("This server is marked as KBPlus master. Running JUSP SYNC batch job");
      juspSyncService.doSync()
    }
    else {
      log.debug("This server is NOT marked as KBPlus master. NOT Running JUSP SYNC batch job");
    }
  }

}
