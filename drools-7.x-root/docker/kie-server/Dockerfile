#################################################################################
# Dockerfile that provides the image for JBoss KIE Server 7.12.0.Final
#################################################################################

####### BASE ############
FROM jboss/wildfly:11.0.0.Final

####### MAINTAINER ############
MAINTAINER "xijin.zeng" "xjin.zeng@bkjk.com"

####### ENVIRONMENT ############
ENV MATERIALS_PATH server-release
ENV JBOSS_BIND_ADDRESS 0.0.0.0
ENV KIE_REPOSITORY https://repository.jboss.org/nexus/content/groups/public-jboss
ENV KIE_CONTEXT_PATH kie-server
ENV MAVEN_REPO /home/artifacts/.m2

# ENV KIE_SERVER_ID kie-server
#ENV KIE_SERVER_LOCATION http://localhost:8080/kie-server/services/rest/server
#ENV KIE_SERVER_USER kieserver
#ENV KIE_SERVER_PWD bkjk@123
#ENV KIE_SERVER_CONTROLLER_USER kieadmin
#ENV KIE_SERVER_CONTROLLER_PWD bkjk@123
#ENV KIE_MAVEN_REPO_USER kieadmin
#ENV KIE_MAVEN_REPO_PASSWORD bkjk@123
# FOR settings.xml
#ENV KIE_MAVEN_REPO http://localhost:8080/kie-wb/maven2

ENV JAVA_OPTS -Xms512m -Xmx8192m -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8

USER root
RUN mkdir -p $MAVEN_REPO

USER jboss
####### Drools KIE Server CUSTOM CONFIGURATION ############
ADD $MATERIALS_PATH/standalone-full-kie-server.xml $JBOSS_HOME/standalone/configuration/standalone-full-kie-server.xml
#ADD $MATERIALS_PATH/settings.xml $MAVEN_REPO/settings.xml
RUN rm -rf $JBOSS_HOME/standalone/configuration/application-roles.properties && rm -rf $JBOSS_HOME/standalone/configuration/application-users.properties
ADD $MATERIALS_PATH/application-roles.properties $JBOSS_HOME/standalone/configuration/application-roles.properties
ADD $MATERIALS_PATH/application-users.properties $JBOSS_HOME/standalone/configuration/application-users.properties
ADD $MATERIALS_PATH/start_kie-server.sh $JBOSS_HOME/bin/start_kie-server.sh

###### SWITCH USER root ######
USER root

###### INSTALL PACKAGES ######
RUN yum install -y net-tools

##### SWITCH BACK TO jboss ####
USER jboss
ADD $MATERIALS_PATH/$KIE_CONTEXT_PATH.war $JBOSS_HOME/standalone/deployments/$KIE_CONTEXT_PATH.war

####### SCRIPTS ############
USER root
RUN chown jboss:jboss $JBOSS_HOME/bin/start_kie-server.sh
RUN chown jboss:jboss $MAVEN_REPO
RUN chown jboss:jboss $JBOSS_HOME/standalone/configuration/standalone-full-kie-server.xml && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/application-users.properties && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/application-roles.properties && \
chown jboss:jboss $JBOSS_HOME/bin/start_kie-server.sh
#RUN chown jboss:jboss $MAVEN_REPO/settings.xml
RUN chmod +x $JBOSS_HOME/bin/start_kie-server.sh

####### CUSTOM JBOSS USER ############
# Switchback to jboss user
USER jboss

####### RUNNING KIE-SERVER ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_kie-server.sh"]