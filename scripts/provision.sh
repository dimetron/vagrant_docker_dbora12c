#!/bin/sh

#echo "Update all packages"
#yum update  -y

export DOCKER_TMPDIR=/vagrant/tmp
rm -rf $DOCKER_TMPDIR 
mkdir $DOCKER_TMPDIR

#clean old images
rm -rf /vagrant/docker_export/oracle12c*.tar.xz

#we need to set proxy properly on docker linux - so we copy it from docker host
cp /etc/yum.conf /vagrant/docker/oracle-c12/

#to reduce internal tmp usage after image load we will use external tmp
echo "export DOCKER_TMPDIR=$DOCKER_TMPDIR" >> /etc/sysconfig/docker

service docker restart

echo "Loading base OL6.6 image"
sudo  su -c "DOCKER_TMPDIR=$DOCKER_TMPDIR && docker load -i /vagrant/downloads/oraclelinux-6.6.tar.xz"

sudo docker build --no-cache -t="oracle/oracle12c" /vagrant/docker/oracle-c12/
sudo docker run --privileged -h db12c -p 1521:1521 -v /vagrant:/vagrant oracle/oracle12c /bin/bash /vagrant/scripts/install_oracle.sh

echo "Saving oracle/database container changes ... "
#also optimized version to remove image history, because we make a base image
#sudo  su -c "DOCKER_TMPDIR=$DOCKER_TMPDIR && docker export `docker ps --no-trunc -aq` | docker import - oracle/database"
sudo  su -c "DOCKER_TMPDIR=$DOCKER_TMPDIR && docker commit `docker ps --no-trunc -aq` oracle/database"

echo "Cleanup build container"
sudo docker rm  `docker ps --no-trunc -aq`
#sudo docker rmi oracle/oracle12c

echo "Installation complete"
sudo docker ps -a
sudo docker images

echo "Export Oracle docker images to [docker_export] :"
sudo  su -c "DOCKER_TMPDIR=$DOCKER_TMPDIR && docker save -o /vagrant/docker_export/oracle12c.tar.xz oracle/oracle12c"
sudo  su -c "DOCKER_TMPDIR=$DOCKER_TMPDIR && docker save -o /vagrant/docker_export/oracle12c_db.tar.xz oracle/database"