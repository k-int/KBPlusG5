# KBPlusG5
Grails5 Port of KBPlus

prerequisites:


# Testing notes

## Grails command to run for the test env

  grails -Dgrails.env=test run-app


## Ubuntu 2204+

notes 

- Snap firefox doesn't play nicely with selenium - you'll need to expunge your system of the snap firefox and install the APT version
- Selenium not playing nicely with gradle/java17 so stick with JDK11 for now
- GEB behaviour seems different today to KBPlus7 - Added autoClearCookies = false to config - see https://www.gebish.org/manual/current/
