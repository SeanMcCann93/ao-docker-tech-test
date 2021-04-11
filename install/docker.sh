#!/bin/bash

# Get token for repository access
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"

# Update apt repository
sudo apt update

# Install Docker
curl https://get.docker.com | sudo bash

# Set Docker as a main command
sudo usermod -aG docker $(whoami)

# Update files after install
sudo apt update

# Confirm Successful Installation
docker --version

# To enable this on local system...
# service docker start

# Note: If your system is running WSL1 then you will not be able to start this system.
#       Follow steps online to enable this feature and configure your virtual machine.