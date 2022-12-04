package com.k_int.kbplus.batch

import org.springframework.scheduling.annotation.Scheduled


class GlobalDataSyncJob {

  def globalSourceSyncService

  @Scheduled(cron="0 5 5 * * ?")
  def execute() {
    log.debug("GlobalDataSyncJob");
    if ( grailsApplication.config?.master ?: true ) {
      log.debug("This server is marked as KBPlus master. Running GlobalDataSyncJob batch job");
      globalSourceSyncService.runAllActiveSyncTasks()
    }
    else {
      log.debug("This server is NOT marked as KBPlus master. NOT Running GlobalDataSyncJob SYNC batch job");
    }
  }

}

