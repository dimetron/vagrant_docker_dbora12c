#!/bin/sh

#echo "Update all packages" && yum update  -y

#to reduce internal tmp usage after image load we will use external tmp
#enable experimental features and add DOCKER_TEMP
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo touch /etc/systemd/system/docker.service.d/docker.conf
sudo su -c "cat <<EOT >> /etc/systemd/system/docker.service.d/docker.conf
[Service]
Environment=DOCKER_TMPDIR=/vagrant/tmp
ExecStart=
ExecStart=/usr/bin/dockerd -D --experimental=true
EOT"

sudo systemctl daemon-reload
sudo service docker restart

echo "Loading base JDK image"
sudo  su -c "docker load -i /vagrant/docker_export/jdk-8u121.tar.xz"

echo "Loading base Weblogic image"
sudo  su -c "docker load -i /vagrant/docker_export/weblogic12.tar.xz"

echo "Loading 5GB Oracle image ..."
echo "This may take some time :)"
sudo  su -c "docker load -i /vagrant/docker_export/oracle12c.tar.xz"
sudo docker images

echo "Starting Images"
echo "...................."

sudo docker run  --privileged --restart=always -h db12c --name database -v /vagrant:/vagrant -v /opt/oracle/product -p 1521:1521 -t -d  oracle/database /bin/bash
sudo docker run  --privileged --restart=always -h weblogic --name weblogic --volumes-from database -p 8001:8001 -p 8002:8002  -t -d oracle/weblogic12 /bin/bash

sudo docker exec -i database /bin/bash  /etc/init.d/dbstart
echo "...................."
sudo docker ps -a

echo ". /vagrant/scripts/aliases.sh" >> .zshrc

echo "Installation complete"
echo "...................."


