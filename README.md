This is repository with scripts to build Vagrant virtual images and install Oracle Database 12c

Original Docker file and script based on work done by Yasushi YAMAZAKI https://github.com/yasushiyy/vagrant-docker-oracle12c
However VM boxes built by http://packer.io/ Oracle Linux 6.6  as well as official oracle 6.6 Docker images  
http://public-yum.oracle.com/docker-images/

Installation
=============

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
=================

To start VM use vagrant

    $vagrant up


Building Container with Oracle Database installed
=========================

__Start Docker VM and Download OL6.6 Docker image__

```    
    $vagrant ssh
    cd /vagrant
    wget http://public-yum.oracle.com/docker-images/OracleLinux/OL6/oraclelinux-6.6.tar.xz
```

__Build Container__

```    
    sudo docker build -t="oracle/oracle12c" docker/oracle-c12/
```

__Connect to the container__

```
    sudo docker run --privileged -h db12c -p 11521:1521 -t -i -v /vagrant:/vagrant oracle/oracle12c /bin/bash
```


__Install Database in the container__

Download the database binary (12.1.0.2.0) from below.  Unzip to the subdirectory name "database".

http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html

* linuxamd64_12c_database_1of2.zip
* linuxamd64_12c_database_2of2.zip

This is manual step after connecting to container:

All commands inside container below begin as: [<user>@db12c ~]$ 

```
sudo docker run --privileged -h db12c -p 1521:1521 -t -i -v /vagrant:/vagrant oracle/oracle12c /bin/bash

[root@db12c ~]$ su - oracle
[oracle@db12c ~]$ /vagrant/database/runInstaller -silent -showProgress -ignorePrereq -responseFile /vagrant/docker/oracle-c12/db_install.rsp
[oracle@db12c ~]$ exit

[root@db12c ~]$ /opt/oraInventory/orainstRoot.sh
[root@db12c ~]$ /opt/oracle/product/12.1.0.2/dbhome_1/root.sh

[root@db12c ~] su - oracle
[oracle@db12c ~]$ netca -silent -responseFile $ORACLE_HOME/assistants/netca/netca.rsp
[oracle@db12c ~]$ dbca -silent -createDatabase -responseFile /vagrant/docker/oracle-c12/dbca.rsp
[oracle@db12c ~]$ exit

[root@db12c ~]$ cp /vagrant/docker/oracle-c12/dbstart /etc/init.d/
[root@db12c ~]$ chkconfig dbstart on
[root@db12c ~]$ chmod +x /etc/init.d/dbstart
[root@db12c ~]$ service dbstart start
[root@db12c ~]$ service dbstart stop

[root@db12c ~]$ vi /etc/oratab
db12c:/opt/oracle/product/12.1.0.2/dbhome_1:Y

ORACLE_HOME_LISTNER  ??? TODO fix

```

__Test connection__
```
sqlplus system/oracle@localhost:1521/db12c

SQL> select count(1) from user_tables;

  COUNT(1)
----------
       178

SQL> show parameter inmemory

SQL> exit

```

__Save our changes__
```
sudo docker ps -l

sudo docker commit `docker ps --no-trunc -aq` oracle/oracle12c

sudo docker images

```


The last step is for regular use of our database container

__Using Database container in detached mode__
```
#list of all containers running
docker ps -a

#to start image in detached mode
sudo docker run --privileged -h db12c -p 1521:1521 -t -d oracle/oracle12c /bin/bash

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

