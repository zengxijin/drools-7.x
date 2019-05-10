#!/bin/sh
# author: xijin.zeng
# 2019-5-8

# running sample:
# bash wb_start.sh \
# -c wb01 \
# -port 8123

IMAGE_NAME="zengxijin/kie-wb-7.12.final"
IMAGE_TAG="latest"

# default container name
CONTAINER_NAME="kie-wb"
# default port
WB_PORT=8123

function usage
{
     echo "usage: wb_start.sh [ [-c <container_name> ] [-port <container_port>] ] [-h]]"
}

while [ "$1" != "" ]; do
    case $1 in
        -c | --container-name ) shift
                                CONTAINER_NAME=$1
                                ;;
        -port | --port )        shift
                                WB_PORT=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

echo "using CONTAINER_NAME=$CONTAINER_NAME"
echo "using PORT=$WB_PORT"

KIE_SERVER_USER=kieserver
KIE_SERVER_PWD=bkjk@123
SERVER_ARGUMENTS=" -Dorg.kie.server.user=$KIE_SERVER_USER -Dorg.kie.server.pwd=$KIE_SERVER_PWD "
ARGUMENTS=" $SERVER_ARGUMENTS "

# create host mapping dir for docker running workbench important resources
WB_GIT_PATH=/home/docker-files/workbench/$CONTAINER_NAME/git
WB_JARS_PATH=/home/docker-files/workbench/$CONTAINER_NAME/jars
mkdir -p $WB_GIT_PATH
mkdir -p $WB_JARS_PATH
chmod 777 $WB_GIT_PATH && chmod 777 $WB_JARS_PATH

docker run \
-e KIE_ARGUMENTS="$ARGUMENTS" \
-v $WB_JARS_PATH:/home/projects/m2/.m2 \
-v $WB_GIT_PATH:/home/projects/git \
-p $WB_PORT:8080 \
-d \
--name $CONTAINER_NAME $IMAGE_NAME:$IMAGE_TAG

# print log, Control+C to skip printing logs
run_id=$(docker ps | grep $CONTAINER_NAME | awk '{print $1}' | tr -d '",')
echo "container id: $run_id"
echo "start to printing the log..."
docker logs -f $run_id