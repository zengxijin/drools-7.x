#!/bin/sh
# author: xijin.zeng
# 2019-5-8

# running sample:
# bash server_start.sh \
# -c kie01 \
# -ip 192.168.56.101 \
# -port 8234 \
# -wb_ip 192.168.56.101 \
# -wb_port 8123

IMAGE_NAME="zengxijin/kie-server-7.12.final"
IMAGE_TAG="latest"

# default container name
CONTAINER_NAME="kie-server"
# default workbench ip or host for kie-server to connect
WB_IP=127.0.0.1
# default workbench port
WB_PORT=8123
# default kie server port
PORT=8234
# default kie server IP
IP=127.0.0.1

function usage
{
     echo "usage: server_start.sh [ [-c <container_name> ] [-port <server_port>] [-ip <server_ip>] [-wb_ip <workbench host_ip>] [-wb_port <workbench port>]] [-h]]"
}

while [ "$1" != "" ]; do
    case $1 in
        -c | --container-name ) shift
                                CONTAINER_NAME=$1
                                ;;
        -ip | --ip )            shift
                                IP=$1
                                ;;
        -port | --port )        shift
                                PORT=$1
                                ;;
        -wb_ip | --wb_ip )      shift
                                WB_IP=$1
                                ;;
        -wb_port | --wb_port )  shift
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

# kie server id is set in docker -Dorg.kie.server.id=$KIE_SERVER_ID
# KIE_SERVER_ID=kie01
KIE_SERVER_USER=kieserver
KIE_SERVER_PWD=bkjk@123
KIE_SERVER_LOCATION=http://$IP:$PORT/kie-server/services/rest/server

KIE_WB=http://$WB_IP:$WB_PORT/kie-wb
KIE_SERVER_CONTROLLER=$KIE_WB/rest/controller
KIE_SERVER_CONTROLLER_USER=kieadmin
KIE_SERVER_CONTROLLER_PWD=bkjk@123

echo "using $KIE_SERVER_LOCATION for kie server"
echo "using $KIE_SERVER_CONTROLLER for kie workbench controller"

SERVER_ARGUMENTS=" -Dorg.kie.server.id=kie-server -Dorg.kie.server.user=$KIE_SERVER_USER -Dorg.kie.server.pwd=$KIE_SERVER_PWD -Dorg.kie.server.location=$KIE_SERVER_LOCATION "
echo "Using '$KIE_SERVER_LOCATION' as KIE server location"

WORKBENCH_ARGUMENTS=" -Dorg.kie.server.controller=$KIE_SERVER_CONTROLLER -Dorg.kie.server.controller.user=$KIE_SERVER_CONTROLLER_USER "
WORKBENCH_ARGUMENTS=" $WORKBENCH_ARGUMENTS -Dorg.kie.server.controller.pwd=$KIE_SERVER_CONTROLLER_PWD -Dorg.appformer.m2repo.url=$KIE_WB/maven2 "
WORKBENCH_ARGUMENTS=" $WORKBENCH_ARGUMENTS -Dkie.maven.settings.custom=/home/artifacts/.m2/settings.xml "

ARGUMENTS=" $SERVER_ARGUMENTS $WORKBENCH_ARGUMENTS "

MAP_PATH=/home/docker-files/server/$CONTAINER_NAME/m2repo

mkdir -p $MAP_PATH
chmod 777 $MAP_PATH
# it's important for kie server to load artifacts from workbench maven repository of installed projects
SETTINGS_STR="
<settings>
    <localRepository>/home/artifacts/.m2/repository</localRepository>
    <proxies>
    </proxies>
    <servers>
        <server>
            <id>kie-workbench</id>
            <username>kieadmin</username>
            <password>bkjk@123</password>
            <configuration>
                <wagonProvider>httpclient</wagonProvider>
                <httpConfiguration>
                    <all>
                        <usePreemptive>true</usePreemptive>
                    </all>
                </httpConfiguration>
            </configuration>
        </server>
    </servers>
    <mirrors>
    </mirrors>
    <profiles>
        <profile>
            <id>kie</id>
            <properties>
            </properties>
            <repositories>
                <repository>
                    <id>jboss-public-repository-group</id>
                    <name>JBoss Public Maven Repository Group</name>
                    <url>https://repository.jboss.org/nexus/content/groups/public-jboss/</url>
                    <layout>default</layout>
                    <releases>
                        <enabled>true</enabled>
                        <updatePolicy>never</updatePolicy>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                        <updatePolicy>always</updatePolicy>
                    </snapshots>
                </repository>
                <repository>
                    <id>kie-workbench</id>
                    <name>JBoss BRMS Guvnor M2 Repository</name>
                    <url>http://$WB_IP:$WB_PORT/kie-wb/maven2</url>
                    <layout>default</layout>
                    <releases>
                        <enabled>true</enabled>
                        <updatePolicy>always</updatePolicy>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                        <updatePolicy>always</updatePolicy>
                    </snapshots>
                </repository>
            </repositories>
            <pluginRepositories>
                <pluginRepository>
                    <id>jboss-public-repository-group</id>
                    <name>JBoss Public Maven Repository Group</name>
                    <url>https://repository.jboss.org/nexus/content/groups/public-jboss/</url>
                    <layout>default</layout>
                    <releases>
                        <enabled>true</enabled>
                        <updatePolicy>never</updatePolicy>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                        <updatePolicy>never</updatePolicy>
                    </snapshots>
                </pluginRepository>
            </pluginRepositories>
        </profile>
    </profiles>
    <activeProfiles>
        <activeProfile>kie</activeProfile>
    </activeProfiles>
</settings>
"
echo $SETTINGS_STR

rm -rf $MAP_PATH/settings.xml
echo $SETTINGS_STR > $MAP_PATH/settings.xml
echo "writing content to file /home/artifacts/.m2/settings.xml"

docker run \
-e KIE_ARGUMENTS="$ARGUMENTS" \
-p $PORT:8080 \
-p ::8001 \
-v $MAP_PATH:/home/artifacts/.m2 \
-d \
--name $CONTAINER_NAME $IMAGE_NAME:$IMAGE_TAG

# print log, Control+C to skip printing logs
run_id=$(docker ps | grep $CONTAINER_NAME | awk '{print $1}' | tr -d '",')
echo "container id: $run_id"
echo "start to printing the log..."
docker logs -f $run_id
