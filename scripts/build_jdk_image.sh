#!/bin/sh

#sync with proxy settungs etc
cp /etc/yum.conf /vagrant/docker/jdk-8u121/

echo "@@@ Building Java8 base image ..."
sudo su -c "docker build --squash --rm --no-cache --memory 1G -t=oracle/jdk-8u121 /vagrant/docker/jdk-8u121/"

echo "=>> Exporting oracle/jdk-8u121 to [docker_export] ..."
sudo su -c "docker save -o /vagrant/docker_export/jdk-8u121.tar.xz oracle/jdk-8u121"

echo "Export complete"
ls -lstr /vagrant/docker_export/
echo " ~~~"