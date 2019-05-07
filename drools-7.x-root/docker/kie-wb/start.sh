#!/bin/sh

# -c | --container-name:    The name for the created container.
#                           If not specified, defaults to "drools-workbench-showcase"
# -h | --help;              Show the script usage
#

CONTAINER_NAME="kie-wb"
IMAGE_NAME="zengxijin/kie-wb-7.12.final"
IMAGE_TAG="latest"


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

# Check if container is already started
if [ -f docker.pid ]; then
    echo "Container already started"
    container_id=$(cat docker.pid)
    echo "Stopping container $container_id..."
    docker stop $container_id
    rm -f docker.pid
fi

KIE_SERVER_USER=kieserver
KIE_SERVER_PWD=bkjk@123
SERVER_ARGUMENTS=" -Dorg.kie.server.user=$KIE_SERVER_USER -Dorg.kie.server.pwd=$KIE_SERVER_PWD "
ARGUMENTS=" $SERVER_ARGUMENTS "

# Start the jboss docker container
echo "Starting $CONTAINER_NAME docker container using:"
echo "** Container name: $CONTAINER_NAME"
image_drools_workbench=$(docker run -e KIE_ARGUMENTS="$ARGUMENTS" -v /home/docker-files/workbench/jars:/home/projects/m2/.m2 -v /home/docker-files/workbench/git:/home/projects/git -p 8081:8080 -d --name $CONTAINER_NAME $IMAGE_NAME:$IMAGE_TAG)
ip_drools_workbench=$(docker inspect $image_drools_workbench | grep \"IPAddress\" | awk '{print $2}' | tr -d '",')
echo $image_drools_workbench > docker.pid

# End
echo ""
echo "Server starting in $ip_drools_workbench"
echo "You can access the server root context in http://$ip_drools_workbench:8081"
echo "Kie Drools Workbench is running at http://$ip_drools_workbench:8081/kie-wb"

exit 0