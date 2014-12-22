#!/bin/sh

# Script to start Vagrant
# Using OSX default provider is parallels

echo "Checking Docker dependencies ..."

FILE=oraclelinux-6.6.tar.xz
if [ -f $FILE ]
 then
   echo "File   [$FILE] already exists. - OK"
 else
   echo "File   [$FILE] will be downloaded"
   	wget http://public-yum.oracle.com/docker-images/OracleLinux/OL6/oraclelinux-6.6.tar.xz
fi

#set platform specific parameters
if [[ `uname` == 'Darwin' ]]; 
	then
		VAGRANT_DEFAULT_PROVIDER=parallels
		VAGRANT_PLUGIN=vagrant-parallels
	else
		VAGRANT_DEFAULT_PROVIDER=virtualbox	
		VAGRANT_PLUGIN=vagrant-vbguest
fi

#test if required plugin is installed
if cat  ~/.vagrant.d/plugins.json | grep -q $VAGRANT_PLUGIN
then	
	echo "Plugin [$VAGRANT_PLUGIN] already installed - OK"
else
	echo "Plugin [$VAGRANT_PLUGIN] will be installed"
	vagrant plugin install $VAGRANT_PLUGIN
fi			

echo "Using  [$VAGRANT_DEFAULT_PROVIDER] vagrant provider"

vagrant up
vagrant ssh