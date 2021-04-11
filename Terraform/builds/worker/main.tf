# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@ Prerequesits ~ START @@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@ Prerequesits ~ END @@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

provider "aws" {
  # version                 = "~> 2.8"
  region                  = var.aws_location
  shared_credentials_file = "./../../../../.aws/credentials"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@ Key Pair for machine Access @@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

resource "aws_key_pair" "key_pair" {
  key_name   = "ManagerAccessKey"
  public_key = file("/home/ubuntu/.ssh/ManagerAccessKey.pub")
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@ Create Virtual Priv Network @@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

data "aws_subnet" "subnet_public" {
  filter {
    name   = "tag:Name"
    values = ["AO-Subnet-Pub"]
  }
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@ Create Security Group @@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

data "aws_security_group" "sg" {
  filter {
    name   = "tag:Name"
    values = ["AO-port_access"]
  }
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@ Create EC2 Instance @@@@@@@
# @@@@@@@       Manager       @@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "ec2_worker" {
  source         = "./../../tools/EC2"
  instance_count = "1"
  ami_code       = "ami-08bac620dc84221eb" # Ubuntu 20.04
  type_code      = "t2.micro"            # 1 x CPU + 1 x RAM
  pem_key        = "ManagerAccessKey"
  subnet         = data.aws_subnet.subnet_public.id # Task ~ get the Subnet group with Name Tag "PetClinic_Subnet"
  vpc_sg         = [data.aws_security_group.sg.id] # Task ~ get the Security group with Name Tag "multi_port_access"
  pub_ip         = true
  lock           = var.locked
  user_data      = << EOF
  #!/bin/bash
  
  apt update

  apt-get update -y
  
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
  
  apt update
  
  curl https://get.docker.com | sudo bash
  
  usermod -aG docker $(whoami)
  
  apt update
  
  docker swarm join --token ${var.Token} ${var.IPLink}:2377
  
  EOF

  # @@@ TAGS @@@
  name_tag = "AO-Worker"
  network_tag = "AO"
}