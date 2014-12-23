# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
 
  config.vm.box = "Docker-OL6-#{ENV['VAGRANT_DEFAULT_PROVIDER']}" 
  config.vm.box_url="bento/builds/#{ENV['VAGRANT_DEFAULT_PROVIDER']}/opscode_oracle-6.6_base.box"

  config.vm.hostname = "docker-vm"
  
  #PARALLELS PROVIDE SETTINGS
  config.vm.provider "parallels" do |v|
    v.name = "Docker-VM"
    v.optimize_power_consumption = false
    #v.update_guest_tools = true
    v.memory = 2560
    v.cpus = 2  
 end

  #VIRTUAL BOX PROVIDER SETTINGS
  config.vm.provider "virtualbox" do |v|
   v.name = "Docker-VM"
   v.gui = false
   v.memory = "2560"
   v.cpus = "2"   
   
  end
 
  # Oracle and Docker port forwarding
  config.vm.network "forwarded_port", guest: 1521, host: 1521
  config.vm.network "forwarded_port", guest: 4243, host: 4243
  
  # run setup.sh
  config.vm.provision "shell", path: "scripts/provision.sh"
   
end