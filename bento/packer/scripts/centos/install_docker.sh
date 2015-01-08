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

echo "Install OhmyZSH"
su - vagrant -c "git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh"
su - vagrant -c "cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc"
su - vagrant -c "sed -i 's/robbyrussell/norm/g' .zshrc"
su - vagrant -c "sed -i 's/git/git docker npm sbt tmux yum/g' .zshrc"
chsh vagrant -s /bin/zsh
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