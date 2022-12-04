package com.k_int.kbplus.batch

import org.springframework.scheduling.annotation.Scheduled

class NightlyJob {

  def dataloadService
  def docstoreService

  @Scheduled(cron="0 0 * * * ?")
  def execute() {
    log.debug("****Running NightlyJob ****")

    // This will set up nominal platforms
    dataloadService.dataCleanse()

    // Update any text indexes
    dataloadService.doFTUpdate()

    // Migrate any documents
    // docstoreService.doMigration()
  }
}
