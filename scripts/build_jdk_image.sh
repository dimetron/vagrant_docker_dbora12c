#echo "Update all packages" && yum update  -y
export DOCKER_TMPDIR=/vagrant/tmp
rm -rf $DOCKER_TMPDIR 
mkdir  $DOCKER_TMPDIR

#clean old images
rm -rf /vagrant/docker_export/jdk*.tar.xz

#to reduce internal tmp usage after image load we will use external tmp
echo "export DOCKER_TMPDIR=$DOCKER_TMPDIR" >> /etc/sysconfig/docker
echo "export DOCKER_TMPDIR=$DOCKER_TMPDIR" >> /etc/profile.d/temp.sh
service docker restart

#cleanup
echo "--- Cleanup old lcontainers before the build ..."
sudo su -c "docker kill jdk-8"
sudo su -c "docker rm -v $(docker ps -a -q -f status=exited)"
sudo su -c "docker rmi $(docker images --filter "dangling=true" -q --no-trunc)"
echo "---"

echo ">>> Loading base OL7.3 image ..."
docker pull oraclelinux:7.3

echo "@@@ Building Java8 base image ..."
cp /etc/yum.conf /vagrant/docker/jdk-8u121/
sudo docker build --no-cache -t="oracle/jdk-8-base" /vagrant/docker/jdk-8u121/

echo "@@@ Running Java8 container ..."
sudo docker run   --privileged -h jdk-8 --name jdk-8 -t -d oracle/jdk-8-base /bin/bash

echo "@@@ Compress Layers ..."
sudo su -c "docker export jdk-8  |  docker import - oracle/jdk-8u121"
sudo su -c "docker kill   jdk-8  && docker rm jdk-8 && docker rmi oracle/jdk-8-base"
echo ">> Exporting oracle/java docker images to [docker_export]:"
echo " └─ ...-> oracle/java .  " && sudo  su -c "docker save -o /vagrant/docker_export/jdk-8u121.tar.xz oracle/jdk-8u121"

echo "JDK image complete"
sudo docker ps -a
sudo docker images 
echo " ~~~"

echo "Export complete"
ls -lstr /vagrant/docker_export/
echo " ~~~"

