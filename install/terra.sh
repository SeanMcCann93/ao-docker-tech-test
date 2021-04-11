
#!/bin/bash

# Install Terraform 0.14.6

sudo apt update && sudo apt upgrade -y

# Aquire terraform tools. Latest Version found @ https://www.terraform.io/downloads.html
wget https://releases.hashicorp.com/terraform/0.14.10/terraform_0.14.10_linux_amd64.zip

# Install unzip
sudo apt install unzip -y

# Unzip Terraform Tools
unzip terraform_*_linux_*.zip

# Move file to executable location
sudo mv terraform /usr/local/bin

# Remove the zip file
sudo rm terraform_*_linux_*.zip

# Display the version Installed
#terraform --version