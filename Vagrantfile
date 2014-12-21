# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
 
  config.vm.box = "Docker-OL6"
  config.vm.box_url="bento/builds/parallels/opscode_oracle-6.6_chef-provisionerless.box"

  config.vm.hostname = "docker-vm"

  #config.vm.box_download_checksum_type = "sha1"
  #config.vm.box_download_checksum = "55ac491177e6f4a41d18dfd02c6b176fa7ca9ae7"

  #PARALLELS PROVIDE SETTINGS
  config.vm.provider "parallels" do |v|
    v.name = "Docker-VM"
    v.optimize_power_consumption = false
    v.memory = 2048
    v.cpus = 2  
  end

  #VIRTUAL BOX PROVIDER SETTINGS
  config.vm.provider "virtualbox" do |v|
   v.name = "Docker-VM"
   v.gui = false
   v.memory = "2048"
   v.cpus = "2"   
  end
 
  # Oracle port forwarding
  config.vm.network "forwarded_port", guest: 1521, host: 1521

  #Scala activator web
  config.vm.network "forwarded_port", guest: 8888, host: 8888
  config.vm.network "forwarded_port", guest: 9000, host: 9000
  config.vm.network "forwarded_port", guest: 4243, host: 4243
  
  # run setup.sh
  config.vm.provision "shell", path: "scripts/provision.sh"
   
end