#!/bin/sh

#sync with proxy settungs etc
cp /etc/yum.conf /vagrant/docker/weblogic-12/

echo "@@@ Building Weblogic image ..."
sudo su -c "docker build --squash --rm --no-cache --memory 1G -t=oracle/weblogic12 /vagrant/docker/weblogic-12/"

echo "=>> Exporting oracle/weblogic12 to [docker_export] ..."
sudo su -c "docker save -o /vagrant/docker_export/weblogic12.tar.xz oracle/weblogic12"

echo "Export complete"
ls -lstr /vagrant/docker_export/
echo " ~~~"