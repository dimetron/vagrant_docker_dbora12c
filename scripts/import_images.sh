#!/bin/sh

#echo "Update all packages" && yum update  -y

#to reduce internal tmp usage after image load we will use external tmp
export DOCKER_TMPDIR=/vagrant/tmp && rm -rf $DOCKER_TMPDIR  && mkdir $DOCKER_TMPDIR
echo "export DOCKER_TMPDIR=$DOCKER_TMPDIR" >> /etc/sysconfig/docker
echo "export DOCKER_TMPDIR=$DOCKER_TMPDIR" >> /etc/profile.d/temp.sh
service docker restart

echo "Loading base Weblogic image"
sudo  su -c "docker load -i /vagrant/docker_export/weblogic12.tar.xz"

echo "Loading 8GB Oracle image ..."
echo "This may take some time :)"
sudo  su -c "docker load -i /vagrant/docker_export/oracle12c_db.tar.xz"
sudo docker images

echo "Starting Images"
echo "...................."
sudo docker run  --privileged -h db12c --name database -p 1521:1521 -t -d  oracle/database /bin/bash
sudo docker run  --privileged -h crm92 --name weblogic -p 8001:8001 -p 8002:8002 -t -d oracle/weblogic /bin/bash
sudo docker ps -a

sudo docker exec -i database /bin/bash  /etc/init.d/dbstart
sudo docker exec -i weblogic java -version

echo ". /vagrant/scripts/aliases.sh" >> .zshrc

echo "Installation complete"
echo "...................."


