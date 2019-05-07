#!/usr/bin/env bash

KIE_SERVER_ID=kie-server-$HOSTNAME
# Start Wildfly with the given arguments.
echo "Running KIE Execution Server on Wildfly..."
exec ./standalone.sh -b $JBOSS_BIND_ADDRESS \
-c standalone-full-kie-server.xml \
-Dorg.kie.server.id=$KIE_SERVER_ID \
$KIE_ARGUMENTS

exit $?