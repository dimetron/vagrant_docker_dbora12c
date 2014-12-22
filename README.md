This is repository with scripts to build Vagrant virtual images and install Oracle Database 12c

Scripts are tested on OSX using Parallels and Virtualbox vagrant providers

Original Docker file and script based on work done by Yasushi YAMAZAKI https://github.com/yasushiyy/vagrant-docker-oracle12c
However VM boxes built by http://packer.io/ Oracle Linux 6.6  as well as official oracle 6.6 Docker images  
http://public-yum.oracle.com/docker-images/

VirtualBox 4.3.20 - Parallels Version 10.1.1 (28614)

Docker started with flags:

     -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock -s btrfs


Changelog
-------------------------------------------------
21.12.2014 - Inintial version fixes
22.12.2014 - Fully automated install script for oracle 
22.12.2014 - Added separate btrfs partition for Docker, optimization


Installation
-------------------------------------------------

0. __Install Vagrant__
    
    Download and install version for your platform.
        
        https://www.vagrantup.com/downloads.html

    Default virtualizaton provider is Virtualbox

        https://www.virtualbox.org

1. __Install packer check requirements for your builder at:__

    http://www.packer.io/docs/builders/parallels.html
    http://www.packer.io/docs/builders/virtualbox.html

2. __Get latest set of packer scripts__

    git clone https://github.com/opscode/bento.git

3. __Build VM images__  

build for all platforms: 

    cd bento/packer/
    packer build oracle-6.6-x86_64.json

Or only specify builder type:

    packer build -only=virtualbox-iso oracle-6.6-x86_64.json
    packer build -only=parallels-iso oracle-6.6-x86_64.json


Using Docker VM
-------------------------------------------------

__Install Database in the container__

Download the database binary (12.1.0.2.0) from below.  Unzip to the subdirectory name "database".

http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html

* linuxamd64_12c_database_1of2.zip
* linuxamd64_12c_database_2of2.zip

To start VM use vagrant

    $vagrant up


Below steps are already part of Vagrant provision script

Building Container with Oracle Database installed
-------------------------------------------------

__1. Start Docker VM and Download OL6.6 Docker image__

```    
    $vagrant ssh
    cd /vagrant
    wget http://public-yum.oracle.com/docker-images/OracleLinux/OL6/oraclelinux-6.6.tar.xz
```

__2. Build Container__

```    
    sudo docker build -t="oracle/oracle12c" /vagrant/docker/oracle-c12/
```


__3. This is will run automatic installation of software and create database :__

```
sudo docker run --privileged -h db12c -p 1521:1521 -t -i -v /vagrant:/vagrant oracle/oracle12c /bin/bash /vagrant/scripts/install_oracle.sh
```

__4. Save our installation as a new image__
```
sudo docker ps -l
sudo docker commit `docker ps --no-trunc -aq` oracle/database

#remove build container
docker rm `docker ps --no-trunc -aq`

sudo docker images

```


Using Database container in detached mode
-------------------------------------------------

```
#list of all containers running
docker ps -a

#to start image in detached mode
sudo docker run --privileged -h db12c -p 1521:1521 -t -d oracle/database /bin/bash

#check running processes
sudo docker exec -i `docker ps --no-trunc -aq` ps -ef

#start db
sudo docker exec -i `docker ps --no-trunc -aq` /bin/bash  /etc/init.d/dbstart

#stop db
sudo docker exec -i `docker ps --no-trunc -aq` /etc/init.d/dbstart stop

#shell
sudo docker exec -i -t `docker ps --no-trunc -aq` /bin/bash

#kill container
docker kill `docker ps --no-trunc -aq`

#remove container
docker rm `docker ps --no-trunc -aq`

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
