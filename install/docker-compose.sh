#!/bin/bash

# Install any updates
sudo apt update

# Install Prerequisites
sh curl.sh
sh jq.sh

# Assign the Variable "version" the latest docker-compose Version
version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name')

# Get the latest version
sudo curl -L "https://github.com/docker/compose/releases/download/${version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make 'docker-compose' Executable
sudo chmod +x /usr/local/bin/docker-compose

# Confirm Docker Compose is Installed
docker-compose --version