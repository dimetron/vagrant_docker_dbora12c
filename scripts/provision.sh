#!/bin/sh

# fix locale warning
echo LANG=en_US.utf-8 >> /etc/environment
echo LC_ALL=en_US.utf-8 >> /etc/environment

# confirm
echo "#--------- Linux Version --------"
cat /etc/oracle-release
uname -a
echo "---------------------------------"

#provision Docker settings add user vagrant to docker group
echo "Install docker  :: git htop tmux zsh"
rpm -iUvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install -y docker-io btrfs-progs btrfs-progs-devel mc zsh git tmux htop

chmod +x /vagrant/scripts/install_docker.sh
/vagrant/scripts/install_docker.sh

echo "Install OhmyZSH"
su - vagrant -c "git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh"
su - vagrant -c "cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc"
su - vagrant -c "sed -i 's/robbyrussell/norm/g' .zshrc"
su - vagrant -c "sed -i 's/git/git docker npm sbt tmux yum/g' .zshrc"
chsh vagrant -s /bin/zsh

#echo "Update all packages"
#yum update  -y

echo "Installing oracle"
sudo docker load -i /vagrant/oraclelinux-6.6.tar.xz
service docker restart

sudo docker build -t="oracle/oracle12c" /vagrant/docker/oracle-c12/
sudo docker run --privileged -h db12c -p 1521:1521 -v /vagrant:/vagrant oracle/oracle12c /bin/bash /vagrant/scripts/install_oracle.sh

echo "Saving oracle/database container changes ... "
sudo docker commit `docker ps --no-trunc -aq` oracle/database

echo "Cleanup build container"
docker rm `docker ps --no-trunc -aq`

echo "Installation complete"
sudo docker ps -a
sudo docker images

