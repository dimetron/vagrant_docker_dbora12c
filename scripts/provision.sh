#!/bin/sh

if [ -f "/vagrant/docker_export/oracle12c.tar.xz" ];
then
	echo "------------------------------------------"
	echo "Provisioning for the second run ..."	
	echo "Docker images will be loaded into VM."
	echo "------------------------------------------"

	. /vagrant/scripts/import_images.sh

 	if [ -f "/vagrant/scripts/provision_ext.sh" ];
 	then
		echo "[OK] - running custom installation"
		/vagrant/scripts/provision_ext.sh
 	else

 	fi

else
    echo "------------------------------------------"
	echo "Provisioning for the first run ..."	
	echo "Building Docker images and restart."
	echo "------------------------------------------"

	. /vagrant/scripts/create_images.sh	
fi