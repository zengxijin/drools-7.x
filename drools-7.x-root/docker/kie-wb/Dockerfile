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
# VFS(workbench projects)
ENV KIE_WB_NIO_GIT /home/projects/git
# artifacts file path
ENV KIE_WB_M2_REPO /home/projects/m2/.m2/repository
# workbench uses when looking for dependencies
ENV KIE_WB_M2_DEPENDENCY /home/dependency/m2/.m2/repository
ENV JBOSS_BIND_ADDRESS 0.0.0.0

ENV JAVA_OPTS -Xms256m -Xmx2048m -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8

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
RUN mkdir -p $KIE_WB_NIO_GIT
RUN chown jboss:jboss $KIE_WB_NIO_GIT
RUN mkdir -p $KIE_WB_M2_REPO
RUN chown jboss:jboss $KIE_WB_M2_REPO
RUN mkdir -p $KIE_WB_M2_DEPENDENCY
RUN chown jboss:jboss $KIE_WB_M2_DEPENDENCY

# Switchback to jboss user
USER jboss
ADD $MATERIALS_PATH/$KIE_CONTEXT_PATH.war $JBOSS_HOME/standalone/deployments/$KIE_CONTEXT_PATH.war

####### RUNNING DROOLS-WB ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_kie-wb.sh"]