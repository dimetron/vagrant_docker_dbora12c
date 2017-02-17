#!/usr/bin/env bash

vagrant box remove Docker-OL7.3-parallels
vagrant plugin install vagrant-parallels
vagrant plugin install vagrant-proxyconf

rm -rf /Users/drashko/Projects/Amdocs/bento/oracle-7.3-x86_64-2.vdi

export http_proxy="http://192.168.1.100:8080"
export https_proxy="https://192.168.1.100:8080"

#packer build oracle-7.3-x86_64.json
#packer build -only=virtualbox-iso oracle-7.3-x86_64.json
packer build -only=parallels-iso oracle-7.3-x86_64.json




