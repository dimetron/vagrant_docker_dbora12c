#!/bin/sh

echo "Checking Docker dependencies ..."


FILE=oraclelinux-6.6.tar.xz
if [ -f $FILE ]
 then
   echo "File $FILE exists. - OK"
 else
   	wget http://public-yum.oracle.com/docker-images/OracleLinux/OL6/oraclelinux-6.6.tar.xz
fi

if cat  ~/.vagrant.d/plugins.json | grep -q vagrant-parallels
then	
   echo "vagrant plugin already installed - OK"
 else
	vagrant plugin install vagrant-parallels
fi

vagrant up --provider parallels
vagrant ssh