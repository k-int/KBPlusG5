package com.k_int.kbplus.batch

import org.springframework.scheduling.annotation.Scheduled

class NotificationsJob {

  def changeNotificationService
  def reminderService

  @Scheduled(cron="0 5 2 * * ?")
  def execute() {
    if ( grailsApplication.config?.master ?: true ) {
      changeNotificationService.aggregateAndNotifyChanges();
      log.debug("About to start the Reminders Job...");
      reminderService.runReminders()
    }
  }

}
