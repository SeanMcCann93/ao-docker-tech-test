#!/bin/bash

sudo su ubuntu
ssh-keygen -f /home/ubuntu/.ssh/AccessKey -N "" -C "ubuntu"
apt update
apt-get update -y
cd /home/ubuntu/
apt install awscli -y
git clone https://github.com/SeanSnake93/ao-docker-tech-test
cd ./ao-docker-tech-test
git checkout containerize
cd ./install
sh terra.sh
sh docker.sh
sh docker-compose.sh
cd ./..
docker swarm init
JOIN=$(docker swarm join-token -q worker)
LINK=$(hostname -i)
cd Terraform/builds/worker/ && terraform init
terraform apply -var locked="false" -var aws_location="eu-west-1" -var Token="$JOIN" -var IPLink="$LINK" -auto-approve
cd ./../../..