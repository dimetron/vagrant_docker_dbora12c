#!/bin/sh

# fix locale warning
echo LANG=en_US.utf-8 >> /etc/environment
echo LC_ALL=en_US.utf-8 >> /etc/environment

# install Oracle Database prereq packages
echo "Install Oracle Database prereq packages"
yum install -y oracle-rdbms-server-12cR1-preinstall


echo "Install Oracle UEK"
# install UEK kernel
yum install -y elfutils-libs
yum update -y --enablerepo=ol6_UEKR3_latest
yum install -y kernel-uek-devel --enablerepo=ol6_UEKR3_latest
grubby --set-default=/boot/vmlinuz-3.8*

# confirm
cat /etc/oracle-release

#extras
echo "Install git htop tmux zsh"
yum install -y mc zsh git tmux htop
su - vagrant -c "curl -L http://install.ohmyz.sh | sh"

#set default schell as ZSH
chsh vagrant -s /bin/zsh
su - vagrant -c "sed -i 's/git/git docker npm sbt tmux yum/g' .zshrc"

#provision Docker settings
echo "Disable Selinux / Set docker service parameters"
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
service docker stop
echo "other_args =-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock" > /etc/sysconfig/docker
service docker start
#add user vagrant to docker group
usermod -a -G docker vagrant

cd /vagrant
docker load -i oraclelinux-6.6.tar.xz
sudo docker build -t="drashko/oracle12c" docker/oracle-c12/
