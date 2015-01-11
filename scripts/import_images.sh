#!/bin/sh

echo "Update all packages" && yum update  -y
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

echo "Installation complete"
echo "...................."
sudo docker images

echo "Starting Images"
echo "...................."
sudo docker run  --privileged -h db12c --name database -p 1521:1521 -t -d  oracle/database /bin/bash
sudo docker run  --privileged -h crm92 --name weblogic -p 8001:8001 -p 8002:8002 -t -d oracle/weblogic /bin/bash
sudo docker ps -a

sudo docker exec -i database /bin/bash  /etc/init.d/dbstart
sudo docker exec -i weblogic java -version

echo "alias db_container_init='sudo docker run  --privileged -h db12c --name database -p 1521:1521 -t -d  oracle/database /bin/bash'" >> .zshrc
echo "alias wl_container_init='sudo docker run  --privileged -h crm92 --name weblogic -p 8001:8001 -p 8002:8002 -t -d oracle/weblogic /bin/bash'" >> .zshrc

echo "alias db_shell='sudo docker exec -i -t database /bin/bash'" >> .zshrc
echo "alias wl_shell='sudo docker exec -i -t weblogic /bin/bash'" >> .zshrc

echo "alias db_start='sudo docker exec -i database /bin/bash  /etc/init.d/dbstart'"   >> .zshrc
echo "alias db_stop='sudo  docker exec -i database /etc/init.d/dbstart stop'"         >> .zshrc
echo "alias db_ping='sudo  docker exec -i database su - oracle -c \"tnsping db12c\"'" >> .zshrc

echo "alias db_container_start='sudo docker start  database && db_start'"  >> .zshrc
echo "alias wl_container_start='sudo docker start  weblogic'"              >> .zshrc
echo "alias db_container_stop='db_stop && sudo docker stop  database'"     >> .zshrc
echo "alias wl_container_stop='sudo docker stop  weblogic'"                >> .zshrc

echo "Following aliases available:"
echo "--------------------------------------------------"
echo "db_ping       - tnsping database"
echo "db_stop       - Stops Database inside the image"
echo "db_start      - Start Database inside the image"
echo ""
echo "db_shell      - shell into database container"
echo "wl_shell      - shell into weblogic container"
echo "--------------------------------------------------"