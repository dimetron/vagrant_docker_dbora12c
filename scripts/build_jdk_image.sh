#!/bin/sh

echo ">>> Loading base OL7.3 image ..."
docker pull oraclelinux:7.3

echo "@@@ Building Java8 base image ..."
cp /etc/yum.conf /vagrant/docker/jdk-8u121/
sudo docker build --no-cache -t="oracle/jdk-8-base" /vagrant/docker/jdk-8u121/

echo "@@@ Running Java8 container ..."
sudo docker run   --privileged -h jdk-8 --name jdk-8 -t -d oracle/jdk-8-base /bin/bash

echo "@@@ Compress Layers ..."
sudo su -c "docker export jdk-8  |  docker import - oracle/jdk-8u121"
sudo su -c "docker kill   jdk-8  && docker rm jdk-8 && docker rmi oracle/jdk-8-base"
echo ">> Exporting oracle/java docker images to [docker_export]:"
echo " └─ ...-> oracle/java .  " && sudo  su -c "docker save -o /vagrant/docker_export/jdk-8u121.tar.xz oracle/jdk-8u121"

echo "JDK image complete"
sudo docker ps -a
sudo docker images 
echo " ~~~"

echo "Export complete"
ls -lstr /vagrant/docker_export/
echo " ~~~"

