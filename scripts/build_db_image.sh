#!/bin/sh

#sync with proxy settungs etc
cp /etc/yum.conf /vagrant/docker/oracle-c12/

echo "@@@ Building OracleDB12c image ..."
sudo su -c "docker build --squash --rm --no-cache --memory 1G  -t=oracle/oracle12c /vagrant/docker/oracle-c12/"

# Manual install - /vagrant/scripts/install_oracle.sh
#docker kill database && docker rm database
#sudo docker run  -m 2G --memory-swap 2G --privileged -h db12c --name database -p 1521:1521 -t -d -v /vagrant:/vagrant oracle/oracle12c /bin/bash
#docker exec -ti database /bin/bash

# Automatic - Silent install
sudo docker run  -m 2G --memory-swap 2G --privileged  -h db12c --name database -p 1521:1521 -v /vagrant/tmp:/tmp -v /vagrant:/vagrant oracle/oracle12c /bin/bash /vagrant/scripts/install_oracle.sh

echo "=>> Cleanup and compress image ..."
sudo su -c "docker export database |  docker import - oracle/database"
sudo su -c "docker rm database && docker rmi oracle/oracle12c"

echo ">> Exporting oracle/database  to [docker_export] ..."
sudo  su -c "docker save -o /vagrant/docker_export/oracle12c.tar.xz oracle/database"

#echo "Export complete"
#ls -lstr /vagrant/docker_export/
#echo " ~~~"
