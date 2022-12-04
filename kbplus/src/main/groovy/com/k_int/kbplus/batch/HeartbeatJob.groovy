package com.k_int.kbplus.batch

import org.springframework.scheduling.annotation.Scheduled
 

class HeartbeatJob {

  @Scheduled(cron="0 0/10 * * * ?")
  def execute() {
    log.debug("Heartbeat Job");
    grailsApplication.config.quartzHeartbeat = new Date()
  }

}
