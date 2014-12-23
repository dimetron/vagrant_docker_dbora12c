#!/bin/sh

#fix for docker filesystem issues

echo "----------------------------------------------"
echo "Installing docker on btrfs -> /var/lib/docker "
echo "----------------------------------------------"


cd /tmp

service docker stop
rm -rf /var/run/docker.pid
sed -i /btrfs/d /etc/fstab

mkfs.btrfs -f /dev/sdb
echo "/dev/sdb /var/lib/docker btrfs 	defaults 	0 	0" >> /etc/fstab
mount -a
btrfs filesystem show 

curl -O --location https://get.docker.io/builds/Linux/x86_64/docker-latest
chmod a+x docker-latest
mv -f docker-latest /usr/bin/docker

echo "Disable Selinux / Set docker service parameters"
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
echo "other_args=\"-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock -s btrfs\"" > /etc/sysconfig/docker
usermod -a -G docker vagrant

chkconfig docker on
service docker start

echo "----------------------------------------------"
echo "Docker info: "
docker info
echo "----------------------------------------------"
echo "Docker Version: "
docker version
echo "----------------------------------------------"
