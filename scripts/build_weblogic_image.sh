#!/bin/sh

echo "@@@ Building Weblogic image ..."
cp /etc/yum.conf /vagrant/docker/weblogic-12/
sudo docker build --no-cache -t="oracle/weblogic12-base" /vagrant/docker/weblogic-12/

echo "@@@ Running Weblogic container ..."
sudo docker run   --privileged -h weblogic --name weblogic  -p 8001:8001 -p 8002:8002 -t -d oracle/weblogic12-base /bin/bash

echo "@@@ Compress Layers ..."
sudo su -c "docker export weblogic |  docker import - oracle/weblogic12"
sudo su -c "docker kill   weblogic && docker rm weblogic && docker rmi oracle/weblogic12-base"
echo ">> Exporting oracle/weblogic images to [docker_export]:"
echo " └─ ...-> oracle/weblogic12 .. " && sudo  su -c "docker save -o /vagrant/docker_export/weblogic12.tar.xz oracle/weblogic12"

echo "Weblogic image complete"
sudo docker ps -a
sudo docker images 
echo " ~~~"

echo "Export complete"
ls -lstr /vagrant/docker_export/
echo " ~~~"

