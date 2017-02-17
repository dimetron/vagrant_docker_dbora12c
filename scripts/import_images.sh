#!/bin/sh

#echo "Update all packages" && yum update  -y

#to reduce internal tmp usage after image load we will use external tmp
export DOCKER_TMPDIR=/vagrant/tmp && rm -rf $DOCKER_TMPDIR  && mkdir $DOCKER_TMPDIR
echo "export DOCKER_TMPDIR=$DOCKER_TMPDIR" >> /etc/sysconfig/docker
echo "export DOCKER_TMPDIR=$DOCKER_TMPDIR" >> /etc/profile.d/temp.sh
service docker restart

echo "Loading base JDK image"
sudo  su -c "docker load -i /vagrant/docker_export/jdk-8u121.tar.xz"

echo "Loading base Weblogic image"
sudo  su -c "docker load -i /vagrant/docker_export/weblogic12.tar.xz"

echo "Loading 8GB Oracle image ..."
echo "This may take some time :)"
sudo  su -c "docker load -i /vagrant/docker_export/oracle12c.tar.xz"
sudo docker images

echo "Starting Images"
echo "...................."

sudo docker run  --privileged --restart=always -h db12c --name database -v /opt/oracle/product -p 1521:1521 -t -d   oracle/database /bin/bash
sudo docker run  --privileged --restart=always -h crm92 --name weblogic --volumes-from database -p 8001:8001 -p 8002:8002  -t -d oracle/weblogic /bin/bash

sudo docker exec -i database /bin/bash  /etc/init.d/dbstart
sudo docker exec -i weblogic java -version
echo "...................."
sudo docker ps -a

echo ". /vagrant/scripts/aliases.sh" >> .zshrc

echo "Installation complete"
echo "...................."


