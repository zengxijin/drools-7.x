# Drools Rule Engine
在docker主机上，需要创建几个映射目录，
主要用于保存Kie Drools Workbench的开发项目资源和Kie Server的container包。

脚本如下：
```bash
mkdir -p /home/docker-files/workbench/git
mkdir -p /home/docker-files/workbench/jars
mkdir -p /home/docker-files/server/m2repo
chmod 777 /home/docker-files/workbench/git && chmod 777 /home/docker-files/workbench/jars && chmod 777 /home/docker-files/server/m2repo
```