#!/bin/sh

#fix for docker filesystem issues
echo "********** install docker on second drive *********"

cd /tmp

service docker stop

#make btrfs -> /dev/sdb
mkfs.btrfs -f /dev/sdb
echo "/dev/sdb1 /var/lib/docker btrfs defaults 0 0" >> /etc/fstab
mount -a
btrfs filesystem show /var/lib/docker

curl -O --location https://get.docker.io/builds/Linux/x86_64/docker-latest
chmod a+x docker-latest
mv -f docker-latest /usr/bin/docker

echo "Disable Selinux / Set docker service parameters"
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
echo "other_args=\"-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock -s btrfs\"" > /etc/sysconfig/docker
usermod -a -G docker vagrant

chkconfig docker on
service docker start

echo "Docker Info"
docker info

echo "***************************************************"
