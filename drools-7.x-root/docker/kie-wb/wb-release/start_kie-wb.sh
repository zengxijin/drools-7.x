#!/usr/bin/env bash

# Start Wildfly with the given arguments.
echo "Running Drools Workbench on JBoss Wildfly..."
exec ./standalone.sh -b $JBOSS_BIND_ADDRESS -c $KIE_WB_PROFILE.xml \
-Dorg.kie.demo=false \
-Dorg.kie.example=false \
-Dorg.guvnor.m2repo.dir=$KIE_WB_M2_REPO \
-Dorg.appformer.m2repo.url=$KIE_WB_M2_DEPENDENCY
exit $?