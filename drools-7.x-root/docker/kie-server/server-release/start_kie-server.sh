#!/usr/bin/env bash

# Start Wildfly with the given arguments.
echo "Running KIE Execution Server on Wildfly..."
exec ./standalone.sh -b $JBOSS_BIND_ADDRESS \
-c standalone-full-kie-server.xml \
$KIE_ARGUMENTS

exit $?