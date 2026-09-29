FROM tomcat:9-jdk17-openjdk
RUN rm -rf /usr/local/tomcat/webapps/*
COPY postsales-os.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]