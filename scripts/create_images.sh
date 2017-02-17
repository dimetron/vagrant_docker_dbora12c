#!/bin/sh


export DOCKER_TMPDIR=/vagrant/tmp
rm -rf $DOCKER_TMPDIR 
mkdir  $DOCKER_TMPDIR

#clean old images
rm -rf /vagrant/docker_export/weblogic*.tar.xz

#to reduce internal tmp usage after image load we will use external tmp
echo "export DOCKER_TMPDIR=$DOCKER_TMPDIR" >> /etc/sysconfig/docker
echo "export DOCKER_TMPDIR=$DOCKER_TMPDIR" >> /etc/profile.d/temp.sh
sudo service docker restart

chmod +x /vagrant/scripts/*.sh

/vagrant/scripts/build_jdk_image.sh
/vagrant/scripts/build_weblogic_image.sh
/vagrant/scripts/build_db_image.sh


echo "Build complete"
docker ps -a
docker images
ls -lstr /vagrant/docker_export/

echo " ~~~"






