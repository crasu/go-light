# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y linux-image-extra-virtual  
    sudo apt-get install -y python-pip
    pip install esptool
    pip install nodemcu-uploader
    echo "cd /vagrant" >> ~/.bashrc
  SHELL

  config.vm.provider "virtualbox" do |vb|
  vb.customize ["modifyvm", :id, "--usb", "on"]
  vb.customize ["modifyvm", :id, "--usbehci", "on"]
  vb.customize ["usbfilter", "add", "0",
    "--target", :id,
    "--name", "ESP8266",
    "--vendorid", "0x10c4",
    "--productid", "0xea60"]
  end
end
