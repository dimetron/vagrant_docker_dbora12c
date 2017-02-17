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
sudo su -c "docker kill database"
sudo su -c "docker rm -v $(docker ps -a -q -f status=exited)"
sudo su -c "docker rmi $(docker images --filter "dangling=true" -q --no-trunc)"
echo "---"

echo "@@@ Building OracleDB12c image ..."
cp /etc/yum.conf /vagrant/docker/oracle-c12/
sudo docker build --no-cache -t="oracle/oracle12c" /vagrant/docker/oracle-c12/
sudo docker run   --privileged -h db12c --name database -p 1521:1521 -v /vagrant:/vagrant oracle/oracle12c /bin/bash /vagrant/scripts/install_oracle.sh
sudo su -c "docker export database |  docker import - oracle/database"
sudo su -c "docker kill   database && docker rm database && docker rmi oracle/oracle12c"
echo ">> Exporting oracle/database images to [docker_export]:"
echo " └─ ...-> oracle/database .. " && sudo  su -c "docker save -o /vagrant/docker_export/oracle12c_db.tar.xz oracle/database"

echo "Installation complete"
sudo docker ps -a
sudo docker images 
echo " ~~~"

echo "Export complete"
ls -lstr /vagrant/docker_export/
echo " ~~~"
