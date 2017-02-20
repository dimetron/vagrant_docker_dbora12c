#!/bin/sh

export DOCKER_TMPDIR=/vagrant/tmp
rm -rf $DOCKER_TMPDIR 
mkdir  $DOCKER_TMPDIR

#clean old images
rm -rf /vagrant/docker_export/*.tar.xz

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

chmod +x /vagrant/scripts/*.sh

/vagrant/scripts/build_jdk_image.sh
/vagrant/scripts/build_weblogic_image.sh
/vagrant/scripts/build_db_image.sh

echo "==========================================="
docker images
echo "==========================================="