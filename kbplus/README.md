

# Build and deploy
./gradlew -x integrationTest clean build

scp ./build/libs/kbplus-8.0.0-SNAPSHOT.war kbplus_3_test:


SSH to server as root

cd /srv/kbplus/apache-tomcat-9.0.73
cd bin
./shutdown.sh
rm -Rf ../webapps/test2*
cp ~/wherever/kbplus-8.0.0-SNAPSHOT.war ../webapps
./startup.sh
