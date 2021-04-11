#!/bin/bash

apt update
apt-get update -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"

sudo apt update

curl https://get.docker.com | sudo bash

sudo usermod -aG docker $(whoami)

sudo apt update

docker swarm join --token $Token $IPLink:2377