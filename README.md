Oracle Linux 7 + Weblogic 12 + Oracle 12c DB Docker builder
=============================================

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/dimetron/vagrant_docker_dbora12c?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

This is repository with scripts to build docker images for Oracle Database 12c, Weblogic 12 and JDK
Optimized to use ```/tmp``` folder as ```/vagrant/tmp``` for speed and less VM resource usage.

Vagrant box i susing separate partition for docker which gives option for a separate backup and can be reformatted
```/dev/sdb  40G  9.9G   31G  25% /var/lib/docker```

**Stage1** - all doker images created and  exported into ```./docker_export```
**Stage2** - VM box recreated and images loaded from ```./docker_export```

```
    oraclelinux         7.3                 e703afa7f696        225 MB
    oracle/jdk-8u121    latest              9ffe8fd8a1dc        619 MB      jdk-8u121.tar.xz
    oracle/weblogic12   latest              470aa1d5a6a4        1.46 GB     weblogic12.tar.xz
    oracle/database     latest              056a2be38e91        5.83 GB     oracle12c.tar.xz
```

(https://hub.docker.com/_/oraclelinux/)
(https://github.com/oracle/docker-images)


Changelog
-------------------------------------------------
- 21.12.2014 - Inintial version fixes 
- 22.12.2014 - Fully automated install script for oracle 
- 22.12.2014 - Added separate btrfs partition for Docker storage
- 11.01.2015 - VM image tmp folders optimizations Docker installation moved to packer stage.
- 12.01.2015 - Added JDK 7u71 and Weblogic 12.1.3 Docker files to the provision 
- 19.02.2017 - Updated to the latest Docker 1.13 Oracle Linux 7 and Java 8

Installation
-------------------------------------------------

0. __Install Required Tools__
    
- _Vagrant_
 Download and install version for your platform.
 https://www.vagrantup.com/downloads.html

- _Virtualbox_
 It's default virtualizaton provider, 
 https://www.virtualbox.org

- _Parallels_
 In case you use Parallels you need to download also SDK:
 http://www.parallels.com/eu/products/desktop/download/

_Packer_
 http://www.packer.io/docs/installation.html

or with homebrew ->

    $ brew tap homebrew/binary
    $ brew install packer


Building base VM images  
-------------------------------------------------
Build for all platforms: 

    cd bento/packer/
    packer build oracle-6.6-x86_64.json

Or only specify builder type:

    packer build -only=virtualbox-iso oracle-6.6-x86_64.json
    packer build -only=parallels-iso oracle-6.6-x86_64.json


Install Database in the container
-------------------------------------------------

1. __Download the database binary (12.1.0.2.0) from below.__  
2. __Most of the steps already automated by vm_start.sh script__

http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html

* linuxamd64_12c_database_1of2.zip
* linuxamd64_12c_database_2of2.zip

_Below steps are already part of Vagrant provision script_

Build Process
-------------------------------------------------
vm_start.sh will detect if it is first run and create all docker container images at first run.
After that it will destroy the VM and load create images from tar.xz files 
This allows to save VM disk space and keep Docker VM small


Using Database container in detached mode
-------------------------------------------------

Keep in mind docker need one main process to run detached.
I use /bin/bash for that purpose. This allows to connect to existing container later on.

```
#list of all containers running
docker ps -a

#to start images in detached mode - with container name  [database] or [weblogic]
sudo docker run --privileged -h db12c --name database -p 1521:1521 -t -d oracle/database /bin/bash
sudo docker run --privileged -h weblogic --name weblogic  -p 8001:8001 -p 8002:8002 -t -d oracle/weblogic12c /bin/bash

#execute simple command
sudo docker exec -i weblogic java -version

#connect to existing running container shell
sudo docker exec -ti  database /bin/bash

#check running processes
sudo docker exec -i database ps -ef

#start db
sudo docker exec -i database /bin/bash  /etc/init.d/dbstart

#stop db
sudo docker exec -i database /etc/init.d/dbstart stop

#kill container
docker kill database

#remove container
docker rm database

```

__Test connection__
```
su - oracle

sqlplus system/oracle@localhost:1521/db12c

SQL> select count(1) from user_tables;

  COUNT(1)
----------
       178

SQL> show parameter inmemory

SQL> exit
```
