# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.box = "bento/ubuntu-22.04"
  
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |vb|
        vb.memory   = "2048"
        vb.cpus     =  2
  end

  config.vm.provision "shell", inline: <<-SHELL
      sudo wget https://apt.puppet.com/puppet7-release-jammy.deb
      sudo dpkg -i puppet7-release-jammy.deb
      sudo apt-get update
      sudo apt-get install -y puppet-agent
  SHELL

  config.vm.provision "puppet" do |puppet|
      puppet.options           = "--verbose"
      puppet.module_path       = "modules"
      puppet.manifests_path    = "manifests"
      puppet.manifest_file     = "default.pp"
      puppet.hiera_config_path = "hiera.yaml"
  end
end
