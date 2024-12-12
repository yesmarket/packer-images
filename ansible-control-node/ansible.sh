#!/bin/bash

#install Ansible
sudo add-apt-repository universe
sudo apt-get -y upgrade
sudo apt-get -y update
sudo apt -y install python3-pip keychain
sudo pip3 install ansible --no-warn-script-location

#install gnome desktop
sudo apt-get install ubuntu-gnome-desktop -y

#install xrdp
sudo apt-get install xrdp -y
sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config

#install VSCode
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install -y code
code --install-extension redhat.ansible
