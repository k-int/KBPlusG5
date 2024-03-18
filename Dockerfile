FROM tomcat:9.0.79-jdk17

# Pull the elasticsearch apm agent in for observability. 
COPY --from=docker.elastic.co/observability/apm-agent-java:latest /usr/agent/elastic-apm-agent.jar elastic-apm-agent.jar

COPY ./kbplus/build/libs/kbplus-8.0.0-SNAPSHOT.war /usr/local/tomcat/webapps/kbplus.war