#!/bin/sh

# fix locale warning
echo LANG=en_US.utf-8 >> /etc/environment
echo LC_ALL=en_US.utf-8 >> /etc/environment

# confirm
echo "#--------- Linux Version --------"
cat /etc/oracle-release
uname -a
echo "---------------------------------"

#update certificates
wget --no-check-certificate -O /etc/pki/tls/certs/ca-bundle.crt https://curl.haxx.se/ca/cacert.pem

#provision Docker settings add user vagrant to docker group
echo "Install docker  :: git htop tmux zsh"
rpm -iUvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y yum-utils mc zsh git tmux htop

sudo yum-config-manager --add-repo https://docs.docker.com/engine/installation/linux/repo_files/centos/docker.repo
sudo yum makecache fast
sudo yum -y install docker-engine


echo "Install OhmyZSH"
su - vagrant -c "git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh"
su - vagrant -c "cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc"
su - vagrant -c "sed -i 's/robbyrussell/norm/g' .zshrc"
su - vagrant -c "sed -i 's/git/git docker npm sbt tmux yum/g' .zshrc"
chsh vagrant -s /bin/zsh
echo "----------------------------------------------"
echo "Installing docker "
echo "----------------------------------------------"

cd /tmp

service docker stop
rm -rf /var/run/docker.pid

sed -i /sdb/d /etc/fstab
mkfs.xfs -f /dev/sdb
echo "/dev/sdb /var/lib/docker xfs 	defaults 0 	0" >> /etc/fstab
#mount -a

echo "Disable Selinux / Set docker service parameters"
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
echo "other_args=\"-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock\"" > /etc/sysconfig/docker
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