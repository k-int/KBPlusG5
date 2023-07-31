# KBPlusG5
Grails5 Port of KBPlus

prerequisites:

# Deploy

## Build

    ./gradlew clean build -x integrationTest
    scp ./build/libs/kbplus-8.0.0-SNAPSHOT.war IP:/tmp
    ssh IP
    cd /srv/kbplus/apache-tomcat-9.0.73/webapps#
    ../bin/shutdown.sh
    rm -Rf ./test2*
    cp /tmp/kbplus-8.0.0-SNAPSHOT.war ./test2.war
    ../bin/startup.sh


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
