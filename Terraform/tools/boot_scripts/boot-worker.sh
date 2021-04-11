#!/bin/bash

apt update
apt-get update -y

docker swarm join --token $Token 192.168.65.3:2377