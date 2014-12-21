#!/bin/bash -eux
# These were only needed for building VMware/Virtualbox extensions:
yum -y remove gcc cpp kernel-devel kernel-headers perl

## upgrade to latest release
yum upgrade -y

## install Docker
rpm -iUvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum update -y

yum install -y docker-io

curl -O --location https://get.docker.io/builds/Linux/x86_64/docker-latest
chmod a+x docker-latest
mv -f docker-latest /usr/bin/docker
echo "other_args =-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock" > /etc/sysconfig/docker

service docker start
chkconfig docker on

yum -y clean all

rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?
rm -f /tmp/chef*rpm

# clean up redhat interface persistence
rm -f /etc/udev/rules.d/70-persistent-net.rules
if [ -r /etc/sysconfig/network-scripts/ifcfg-eth0 ]; then
  sed -i 's/^HWADDR.*$//' /etc/sysconfig/network-scripts/ifcfg-eth0
  sed -i 's/^UUID.*$//' /etc/sysconfig/network-scripts/ifcfg-eth0
fi
