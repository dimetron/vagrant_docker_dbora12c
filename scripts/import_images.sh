#!/bin/sh

#echo "Update all packages" && yum update  -y

#to reduce internal tmp usage after image load we will use external tmp
export DOCKER_TMPDIR=/vagrant/tmp && rm -rf $DOCKER_TMPDIR  && mkdir $DOCKER_TMPDIR
echo "export DOCKER_TMPDIR=$DOCKER_TMPDIR" >> /etc/sysconfig/docker
echo "export DOCKER_TMPDIR=$DOCKER_TMPDIR" >> /etc/profile.d/temp.sh
service docker restart

echo "Loading base Weblogic image"
sudo  su -c "docker load -i /vagrant/docker_export/weblogic12.tar.xz"

echo "Loading 8GB Oracle image ..."
echo "This may take some time :)"
sudo  su -c "docker load -i /vagrant/docker_export/oracle12c_db.tar.xz"
sudo docker images

echo "Starting Images"
echo "...................."
sudo docker run  --privileged -h db12c --name database -p 1521:1521 -t -d  oracle/database /bin/bash
sudo docker run  --privileged -h crm92 --name weblogic -p 8001:8001 -p 8002:8002 -t -d oracle/weblogic /bin/bash
sudo docker ps -a

sudo docker exec -i database /bin/bash  /etc/init.d/dbstart
sudo docker exec -i weblogic java -version

user_aliases="
alias db_container_init='sudo docker run  --privileged -h db12c --name database -p 1521:1521 -t -d  oracle/database /bin/bash'
alias wl_container_init='sudo docker run  --privileged -h crm92 --name weblogic -p 8001:8001 -p 8002:8002 -t -d oracle/weblogic /bin/bash'

alias db_shell='sudo docker exec -i -t database /bin/bash'
alias wl_shell='sudo docker exec -i -t weblogic /bin/bash'

alias db_start='sudo docker exec -i database /bin/bash  /etc/init.d/dbstart'
alias db_stop='sudo  docker exec -i database /etc/init.d/dbstart stop'
alias db_ping='sudo  docker exec -i database su - oracle -c \"tnsping db12c\"'

alias db_container_start='sudo docker start  database && db_start'
alias wl_container_start='sudo docker start  weblogic'
alias db_container_stop='db_stop && sudo docker stop  database'
alias wl_container_stop='sudo docker stop  weblogic'       
"
welcome='
# Welcome message for login shells
if [[ $SHLVL -eq 1 ]] ; then
    echo
    print -P "\e[1;32m Welcome to: \e[1;34m%m"
    print -P "\e[1;32m Running: \e[1;34m`uname -srm`\e[1;32m on \e[1;34m%l"
    print -P "\e[1;32m It is:\e[1;34m %D{%r} \e[1;32m on \e[1;34m%D{%A %b %f %G}"
    echo
    echo "Following aliases available:"
    echo "--------------------------------------------------"
	echo "db_container_init"
	echo "db_container_start"
	echo "db_container_stop"
	echo ""
	echo "db_ping       - tnsping database"
	echo "db_stop       - Stops Database inside the image"
	echo "db_start      - Start Database inside the image"
	echo ""
	echo "db_shell      - shell into database container"
	echo "wl_shell      - shell into weblogic container"	
	echo "--------------------------------------------------"
fi
'

echo $user_aliases >> .zshrc
echo $welcome  	   >> .zshrc

echo "Installation complete"
echo "...................."


