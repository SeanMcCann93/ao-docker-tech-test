#!/bin/bash

sudo su ubuntu
ssh-keygen -f /home/ubuntu/.ssh/AccessKey -N "" -C "ubuntu"
apt update
apt-get update -y
cd /home/ubuntu/
sudo su ubuntu
git clone https://github.com/SeanSnake93/ao-docker-tech-test
cd ./ao-docker-tech-test
git checkout containerize
sh ./install/terra.sh
sudo apt install awscli -y
cd Teraaform/builds/worker/ && terraform init
#terraform apply -var locked="false" -var aws_location="eu-west-1" -var Token="$JOIN" -auto-approve
cd ./../../..
sh ./install/docker.sh
docker swarm init
JOIN=$(docker swarm join-token -q worker)




# ssh -i "~/.ssh/AccessKey" ubuntu@ec2-34-243-231-236.eu-west-1.compute.amazonaws.com