#!/bin/sh

#echo "Update all packages"
#yum update  -y

echo "Installing oracle"
sudo docker load -i /vagrant/oraclelinux-6.6.tar.xz
service docker restart

sudo docker build -t="oracle/oracle12c" /vagrant/docker/oracle-c12/
sudo docker run --privileged -h db12c -p 1521:1521 -v /vagrant:/vagrant oracle/oracle12c /bin/bash /vagrant/scripts/install_oracle.sh

echo "Saving oracle/database container changes ... "
sudo docker commit `docker ps --no-trunc -aq` oracle/database

echo "Cleanup build container"
docker rm `docker ps --no-trunc -aq`

echo "Installation complete"
sudo docker ps -a
sudo docker images

