#!/bin/sh

CONTAINER_NAME="kie-server"
IMAGE_NAME="zengxijin/kie-server-7.12.final"
IMAGE_TAG="latest"

# -c | --container-name:    The name for the created container.
#                           If not specified, defaults to "kie-server-showcase"
# -h | --help;              Show the script usage
#
function usage
{
     echo "usage: start.sh [ [-c <container_name> ] ] [-h]]"
}

while [ "$1" != "" ]; do
    case $1 in
        -c | --container-name ) shift
                                CONTAINER_NAME=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# kie server id is set in docker -Dorg.kie.server.id=$KIE_SERVER_ID
# KIE_SERVER_ID=kie01
KIE_SERVER_USER=kieserver
KIE_SERVER_PWD=bkjk@123
KIE_SERVER_LOCATION=http://192.168.56.101:8080/kie-server/services/rest/server

KIE_WB=http://192.168.56.101:8081/kie-wb
KIE_SERVER_CONTROLLER=$KIE_WB/rest/controller
KIE_SERVER_CONTROLLER_USER=kieadmin
KIE_SERVER_CONTROLLER_PWD=bkjk@123


SERVER_ARGUMENTS=" -Dorg.kie.server.user=$KIE_SERVER_USER -Dorg.kie.server.pwd=$KIE_SERVER_PWD -Dorg.kie.server.location=$KIE_SERVER_LOCATION "
echo "Using '$KIE_SERVER_LOCATION' as KIE server location"

WORKBENCH_ARGUMENTS=" -Dorg.kie.server.controller=$KIE_SERVER_CONTROLLER -Dorg.kie.server.controller.user=$KIE_SERVER_CONTROLLER_USER "
WORKBENCH_ARGUMENTS=" $WORKBENCH_ARGUMENTS -Dorg.kie.server.controller.pwd=$KIE_SERVER_CONTROLLER_PWD -Dorg.appformer.m2repo.url=$KIE_WB/maven2 "
WORKBENCH_ARGUMENTS=" $WORKBENCH_ARGUMENTS -Dkie.maven.settings.custom=/home/artifacts/.m2/settings.xml "

ARGUMENTS=" $SERVER_ARGUMENTS $WORKBENCH_ARGUMENTS "

docker run -e KIE_ARGUMENTS="$ARGUMENTS" -p 8080:8080 -p 8001:8001 -v /home/docker-files/server/m2repo:/home/artifacts/.m2 -d --name $CONTAINER_NAME $IMAGE_NAME:$IMAGE_TAG