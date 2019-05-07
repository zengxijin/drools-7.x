#################################################################################
# Dockerfile that provides the image for JBoss Drools Workbench 7.12.0.Final
#################################################################################

####### BASE ############
FROM jboss/wildfly:11.0.0.Final

####### MAINTAINER ############
MAINTAINER "xijin.zeng" "xjin.zeng@bkjk.com"

####### ENVIRONMENT ############
ENV MATERIALS_PATH wb-release
ENV KIE_CONTEXT_PATH kie-wb
ENV KIE_WB_PROFILE standalone-full-kie-wb
ENV MAVEN_VERSION apache-maven-3.5.2
ENV MAVEN_PATH /home/maven
ENV M2_HOME $MAVEN_PATH/$MAVEN_VERSION
# VFS(workbench projects)
ENV KIE_WB_NIO_GIT /home/projects/git
# artifacts file path
ENV KIE_WB_M2_REPO /home/projects/m2/.m2/repository
# workbench uses when looking for dependencies
#ENV KIE_WB_M2_DEPENDENCY http://localhost:8080/kie-wb/maven2
ENV JBOSS_BIND_ADDRESS 0.0.0.0

ENV JAVA_OPTS -Xms512m -Xmx8192m -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8

####### Drools Workbench CUSTOM CONFIGURATION ############
ADD $MATERIALS_PATH/standalone-full-kie-wb.xml $JBOSS_HOME/standalone/configuration/standalone-full-kie-wb.xml
ADD $MATERIALS_PATH/application-users.properties $JBOSS_HOME/standalone/configuration/application-users.properties
ADD $MATERIALS_PATH/application-roles.properties $JBOSS_HOME/standalone/configuration/application-roles.properties
ADD $MATERIALS_PATH/start_kie-wb.sh $JBOSS_HOME/bin/start_kie-wb.sh

# Added files are chowned to root user, change it to the jboss one.
USER root
RUN chown jboss:jboss $JBOSS_HOME/standalone/configuration/standalone-full-kie-wb.xml && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/application-users.properties && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/application-roles.properties
RUN chmod +x $JBOSS_HOME/bin/start_kie-wb.sh && chown jboss:jboss $JBOSS_HOME/bin/start_kie-wb.sh
RUN mkdir -p $KIE_WB_NIO_GIT && chown jboss:jboss $KIE_WB_NIO_GIT
RUN mkdir -p $KIE_WB_M2_REPO && chown jboss:jboss $KIE_WB_M2_REPO
#RUN mkdir -p $KIE_WB_M2_DEPENDENCY && chown jboss:jboss $KIE_WB_M2_DEPENDENCY
RUN mkdir -p $MAVEN_PATH && chown jboss:jboss $MAVEN_PATH
ADD $MATERIALS_PATH/$MAVEN_VERSION.zip $MAVEN_PATH/$MAVEN_VERSION.zip
RUN unzip $MAVEN_PATH/$MAVEN_VERSION.zip -d $MAVEN_PATH/ && rm -rf $MAVEN_PATH/$MAVEN_VERSION.zip
# Switchback to jboss user
USER jboss
ADD $MATERIALS_PATH/$KIE_CONTEXT_PATH.war $JBOSS_HOME/standalone/deployments/$KIE_CONTEXT_PATH.war

####### RUNNING DROOLS-WB ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_kie-wb.sh"]