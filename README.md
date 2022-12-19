# KBPlusG5
Grails5 Port of KBPlus

prerequisites:


# Testing notes

## Grails command to run for the test env

  grails -Dgrails.env=test run-app


## Ubuntu 2204+

notes 

- Snap firefox doesn't play nicely with selenium - you'll need to expunge your system of the snap firefox and install the APT version
-- https://www.omgubuntu.co.uk/2022/04/how-to-install-firefox-deb-apt-ubuntu-22-04
-- sudo snap remove --purge firefox
-- sudo add-apt-repository ppa:mozillateam/ppa
-- sudo apt install firefox
- Selenium not playing nicely with gradle/java17 so stick with JDK11 for now
- GEB behaviour seems different today to KBPlus7 - Added autoClearCookies = false to config - see https://www.gebish.org/manual/current/
