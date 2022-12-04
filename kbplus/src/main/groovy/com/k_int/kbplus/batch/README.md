Convert all these to 

import org.springframework.scheduling.annotation.Scheduled

  // at 18:20 (second, min, hr, dom, mon, dow)
  @Scheduled(cron="0 20 05,06,12,16,18,19,20,21 * * *")
  public void checkForUpdates() {

