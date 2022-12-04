package com.k_int.kbplus.batch

import org.springframework.scheduling.annotation.Scheduled


class WeeklyTasksJob {

  def dataloadService

  @Scheduled(cron="0 5 5 ? * Sun")
  def execute() {
    log.debug("WeeklyTasksJob");
    if ( grailsApplication.config?.master ?: true ) {
      log.debug("This server is marked as KBPlus master. Running WeeklyTasksJob batch job");
      dataloadService.fullESReset()
    }
    else {
      log.debug("This server is NOT marked as KBPlus master. NOT Running WeeklyTasksJob SYNC batch job");
    }
  }

}

