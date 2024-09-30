#!/bin/bash
sudo apt-get update
# sudo apt -y install pipx
# pipx install --include-deps ansible
sudo apt -y install python3-pip
sudo pip3 install ansible --no-warn-script-location
