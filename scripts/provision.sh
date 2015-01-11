#!/bin/sh

#echo "Update all packages" && yum update  -y
export DOCKER_TMPDIR=/vagrant/tmp
rm -rf $DOCKER_TMPDIR 
mkdir  $DOCKER_TMPDIR

#clean old images
rm -rf /vagrant/docker_export/*.tar.xz

#to reduce internal tmp usage after image load we will use external tmp
echo "export DOCKER_TMPDIR=$DOCKER_TMPDIR" >> /etc/sysconfig/docker
echo "export DOCKER_TMPDIR=$DOCKER_TMPDIR" >> /etc/profile.d/temp.sh
service docker restart

echo ">>> Loading base OL6.6 image ..."
sudo  su -c "docker load -i /vagrant/downloads/oraclelinux-6.6.tar.xz"

echo "@@@ Building Java7 image ..."
cp /etc/yum.conf /vagrant/docker/java-7u71/
sudo docker build --no-cache -t="oracle/java-7u71" /vagrant/docker/java-7u71/
sudo docker run   --privileged -h jdk7h --name java -t -d oracle/java-7u71 /bin/bash
sudo su -c "docker export java |  docker import - oracle/java"
sudo su -c "docker kill   java && docker rm java && docker rmi oracle/java-7u71"
echo ">> Exporting oracle/java docker images to [docker_export]:"
echo " └─ ...-> oracle/java .  " && sudo  su -c "docker save -o /vagrant/docker_export/java-7u71.tar.xz oracle/java"

echo "@@@ Building Weblogic image ..."
cp /etc/yum.conf /vagrant/docker/weblogic-12/
sudo docker build --no-cache -t="oracle/weblogic12" /vagrant/docker/weblogic-12/
sudo docker run   --privileged -h crm92 --name weblogic  -p 8001:8001 -p 8002:8002 -t -d oracle/weblogic12 /bin/bash
sudo su -c "docker export weblogic |  docker import - oracle/weblogic"
sudo su -c "docker kill   weblogic && docker rm weblogic && docker rmi oracle/weblogic12"
echo ">> Exporting oracle/weblogic images to [docker_export]:"
echo " └─ ...-> oracle/weblogic .. " && sudo  su -c "docker save -o /vagrant/docker_export/weblogic12.tar.xz oracle/weblogic"


echo "@@@ Building OracleDB12c image ..."
cp /etc/yum.conf /vagrant/docker/oracle-c12/
sudo docker build --no-cache -t="oracle/oracle12c" /vagrant/docker/oracle-c12/
sudo docker run   --privileged -h db12c --name database -p 1521:1521 -v /vagrant:/vagrant oracle/oracle12c /bin/bash /vagrant/scripts/install_oracle.sh
sudo su -c "docker export database |  docker import - oracle/database"
sudo su -c "docker kill   database && docker rm database && docker rmi oracle/oracle12c"
echo ">> Exporting oracle/database images to [docker_export]:"
echo " └─ ...-> oracle/database .. " && sudo  su -c "docker save -o /vagrant/docker_export/oracle12c_db.tar oracle/database"

echo "Installation complete"
sudo docker ps -a
sudo docker images 
echo " ~~~"

echo "Export complete"
ls -lstr /vagrant/docker_export/
echo " ~~~"