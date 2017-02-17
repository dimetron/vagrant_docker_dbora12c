# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
 
  config.vm.box = "Docker-OL7.3-#{ENV['VAGRANT_DEFAULT_PROVIDER']}" 
  config.vm.box_url="bento/builds/oracle-7.3.#{ENV['VAGRANT_DEFAULT_PROVIDER']}.box"
  
  config.vm.hostname = "docker-vm"
  
  #PARALLELS PROVIDE SETTINGS
  config.vm.provider "parallels" do |v|
    v.name = "Docker-VM"
    v.optimize_power_consumption = false
    #v.update_guest_tools = true
    v.memory = 512
    v.cpus = 2  
 end

  #VIRTUAL BOX PROVIDER SETTINGS
  config.vm.provider "virtualbox" do |v|
   v.name = "Docker-VM"
   v.gui = false
   v.memory = "512M"
   v.cpus = "2"   
  end
   
  #use proxy for local RPM cache
  #config.proxy.http     = "http://127.0.0.1:8080"
  #config.proxy.https    = "http://127.0.0.1:8080"
  #config.proxy.no_proxy = "localhost,127.0.0.1"

  # Oracle and Docker port forwarding
  config.vm.network "forwarded_port", guest: 1521, host: 1521
  config.vm.network "forwarded_port", guest: 8001, host: 8001
  config.vm.network "forwarded_port", guest: 8002, host: 8002 
  config.vm.network "forwarded_port", guest: 4243, host: 4243
  
  # run setup.sh
  config.vm.provision "shell", path: "scripts/provision.sh"
   
end