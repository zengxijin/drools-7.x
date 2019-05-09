#!/bin/sh

mkdir -p /home/docker-files/workbench/git
mkdir -p /home/docker-files/workbench/jars
mkdir -p /home/docker-files/server/m2repo
chmod 777 /home/docker-files/workbench/git && chmod 777 /home/docker-files/workbench/jars && chmod 777 /home/docker-files/server/m2repo

IP=$1
PORT=$2
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
                    <url>http://$IP:$PORT/kie-wb/maven2</url>
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
echo $SETTINGS_STR > /home/artifacts/.m2/settings.xml
echo "writing content to file /home/artifacts/.m2/settings.xml"