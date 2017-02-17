#!/bin/sh

echo "@@@ Building OracleDB12c image ..."
cp /etc/yum.conf /vagrant/docker/oracle-c12/
sudo docker build --no-cache -t="oracle/oracle12c" /vagrant/docker/oracle-c12/
sudo docker run   --privileged -h db12c --name database -p 1521:1521 -v /vagrant:/vagrant oracle/oracle12c /bin/bash /vagrant/scripts/install_oracle.sh
sudo su -c "docker export database |  docker import - oracle/database"
sudo su -c "docker kill   database && docker rm database && docker rmi oracle/oracle12c"
echo ">> Exporting oracle/database images to [docker_export]:"
echo " └─ ...-> oracle/database .. " && sudo  su -c "docker save -o /vagrant/docker_export/oracle12c.tar.xz oracle/database"

echo "Installation complete"
sudo docker ps -a
sudo docker images 
echo " ~~~"

echo "Export complete"
ls -lstr /vagrant/docker_export/
echo " ~~~"
