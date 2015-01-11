#!/bin/sh

if [ -f "/vagrant/docker_export/oracle12c_db.tar.xz" ];
then
	echo "------------------------------------------"
	echo "Second run ..."	
	echo "Images will be loaded into VM."
	echo "------------------------------------------"

	. /vagrant/scripts/import_images.sh
else
    echo "------------------------------------------"
	echo "First run ..."	
	echo "VM will build all images and then restart."
	echo "------------------------------------------"

	. /vagrant/scripts/create_images.sh	
fi
