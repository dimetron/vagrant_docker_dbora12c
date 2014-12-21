#!/bin/sh

# fix locale warning
echo LANG=en_US.utf-8 >> /etc/environment
echo LC_ALL=en_US.utf-8 >> /etc/environment

# install Oracle Database prereq packages
#echo "Install Oracle Database prereq packages"
#yum install -y oracle-rdbms-server-12cR1-preinstall

echo "Install Oracle UEK"
# install UEK kernel
yum install -y elfutils-libs kernel-uek-devel 
grubby --set-default=/boot/vmlinuz-3.8*

# confirm
cat /etc/oracle-release

#extras
echo "Install git htop tmux zsh"
yum install -y mc zsh git tmux htop

su - vagrant -c "git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh"
su - vagrant -c "cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc"
su - vagrant -c "sed -i 's/robbyrussell/norm/g' .zshrc"
su - vagrant -c "sed -i 's/git/git docker npm sbt tmux yum/g' .zshrc"
chsh vagrant -s /bin/zsh

#provision Docker settings add user vagrant to docker group
echo "Disable Selinux / Set docker service parameters"
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
service docker stop
echo "other_args=\"-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock\"" > /etc/sysconfig/docker
service docker start
usermod -a -G docker vagrant

echo "Docker Info"
docker version

cd /vagrant
docker load -i oraclelinux-6.6.tar.xz
sudo docker build -t="oracle/oracle12c" docker/oracle-c12/
