#!/bin/sh

# Script to start Vagrant with Docker and Oracle
# Using OSX default provider is parallels
# 
# author Dmytro Rashko - dimetron@me.com  aka. @dimetron
# 
# version 1.0   -- 23.12.2014
# version 1.0   -- 10.01.2015 Docker setup moved inside packer


#URLS
DOCKER_OL6="http://public-yum.oracle.com/docker-images/OracleLinux/OL6/"
ORACLE_DB_ENT="http://download.oracle.com/otn/linux/oracle12c/121020/"

#docker oracle image and oracle DB 12c ent locations
t1="oraclelinux-6.6.tar.xz"
t2="linuxamd64_12102_database_1of2.zip"
t3="linuxamd64_12102_database_2of2.zip"

echo ""
echo "Checking Required dependencies ..."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"  
echo ""

#
# This function require 3 parameter 
# 	1 - FILE variable name {t1,t2,t3 ...}
# 	2 - URL 
# 	3 - MANUAL flag YES / NO
# 	
# It checks if file already exists and set var t1, t2, t3 return 0 if file found
# 
function download_once() {
 VAR=f$1
 eval FILE=\${$1}
 
 CURL=$2
 MANUAL=$3

 echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"  
 echo "Checking : $FILE"
 
 #download file only once
 if [ -f "downloads/$FILE" ];
 then
	echo "[OK] - File [$FILE] in the [downloads] directory"
	RES=0
 else
 	echo "[KO] - File [$FILE] not found in the [downloads] directory"
 	if [ $MANUAL = 'YES' ];
 	then
    	echo "File cannot be downloaded by script"
		echo "Manual download required:"
 		echo "http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html"
		RES=1
 	else 
    	echo "Downloading $CURL ..."
		curl -L -b "oraclelicense=accept-dbindex-cookie" $CURL  -o $FILE
		RES=$?
	fi 
 fi
 echo ""
 eval "$VAR=$RES"
}
  

if [ ! -f "docker_export/oracle12c_db.tar.xz" ]; then
		
#test all required files downloaded   
download_once t1 "$DOCKER_OL6/$t1" "NO"
download_once t2 "$ORACLE_DB_ENT/$t2" "YES"
download_once t3 "$ORACLE_DB_ENT/$t3" "YES"

	if [ $ft1 -ne 0 ] || [ $ft2 -ne 0 ] || [ $ft3 -ne 0 ]; then
	 echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"  
	 echo "!!!  Please download required files and place to the directory  !!! "
	 echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"  
	 exit -1
	fi

	if [ -d "database" ]; 
		then	
			echo "Oracle install files already extracted"
			#rm -rf database
		else
			echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"   	
			echo "Extracting oracle DB files ..."	
			unzip -q "downloads/$t2"
			unzip -q "downloads/$t3"
			echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" 	
	fi
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

#test if proxyconf plugin is installed
if cat  ~/.vagrant.d/plugins.json | grep -q vagrant-proxyconf
then	
	echo "Plugin [vagrant-proxyconf] already installed - OK"
else
	echo "Plugin [vagrant-proxyconf] will be installed"
	vagrant plugin install vagrant-proxyconf
fi	

echo "Using  [$VAGRANT_DEFAULT_PROVIDER] vagrant provider"

#Firts time VM will create all images and then only reuse those
if [ ! -f "docker_export/oracle12c_db.tar.xz" ]; then
	say "Starting Build"	
	#To start again remove old VM and Box
	vagrant destroy -f
	vagrant box remove Docker-OL6-$VAGRANT_DEFAULT_PROVIDER
	vagrant up
	
	say "First Build is finished. Running cleanup"
	vagrant destroy -f
	#cleanup
	if [ -d "database" ]; then	
		echo "Cleanup oracle installation ..."
		rm -rf database
	fi
fi

echo "Booting VM ..." && say "Booting VM."
vagrant up

echo "Starting SSH ..." && say "Your VM is ready to use."	
vagrant ssh