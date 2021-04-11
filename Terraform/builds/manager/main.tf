# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@ Prerequesits ~ START @@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# Any requirments needed for this applicatin to run exists in here.

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
  key_name   = "AccessKey"
  public_key = file("~/.ssh/AccessKey.pub")
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@ Create Virtual Priv Network @@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "vpc" {
  source  = "./../../tools/VPC"
  v4_cidr = "126.157.0.0/16"
  hostname = true

  # @@@ TAGS @@@
  name_tag = "AO-Cloud"
  network_tag = "AO"
}

module "igw" {
  source = "./../../tools/IGW"
  vpc_id = module.vpc.id

  # @@@ TAGS @@@
  name_tag    = "AO-Network_Gate"
  network_tag = "AO"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "subnet_public" {
  source  = "./../../tools/SUBNET"
  availability_zone = data.aws_availability_zones.available.names[0]
  v4_cidr = "126.157.10.0/24"
  pub_ip  = true
  vpc_id  = module.vpc.id

  # @@@ TAGS @@@
  name_tag    = "AO-Subnet-Pub"
  network_tag = "AO"
}

module "subnet_private" {
  source  = "./../../tools/SUBNET"
  availability_zone = data.aws_availability_zones.available.names[0]
  v4_cidr = "126.157.20.0/24"
  pub_ip  = true
  vpc_id  = module.vpc.id

  # @@@ TAGS @@@
  name_tag    = "AO-Subnet-Sub"
  network_tag = "AO"
}

module "public_routes" {
  source  = "./../../tools/ROUTES"
  vpc_id  = module.vpc.id
  v4_cidr = "0.0.0.0/0"
  igw_id  = module.igw.id

  # @@@ TAGS @@@
  name_tag    = "AO-Routes"
  network_tag = "AO"
}

module "public_routes_association" {
  source    = "./../../tools/ROUTES/ASSOCIATION"
  table_id  = module.public_routes.id
  subnet_id = module.subnet_public.id
}

# iam user

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@ Create Security Group @@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "sg" {
  source         = "./../../tools/SG"
  sg_description = "This Security Group is created to allow various port access to an instance."
  vpc_id         = module.vpc.id
  port_desc      = {
    22 = "Open-SSH-Access"
    80 = "Open-HTTP-Access"
    3200 = "Open-Nginx-3200"
    }
  in_port        = [22, 80, 3200]
  in_cidr        = "0.0.0.0/0"
  out_port       = 0
  out_protocol   = "-1"
  in_protocol    = "tcp"
  out_cidr       = "0.0.0.0/0"

  # @@@ TAGS @@@
  name_tag = "AO-port_access"
  network_tag = "AO"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@ Create EC2 Instance @@@@@@@
# @@@@@@@       Manager       @@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "ec2_manager" {
  source         = "./../../tools/EC2"
  instance_count = "1"
  ami_code       = "ami-08bac620dc84221eb" # Ubuntu 20.04
  type_code      = "t2.micro"            # 1 x CPU + 1 x RAM
  pem_key        = "AccessKey"
  subnet         = module.subnet_public.id
  vpc_sg         = [module.sg.id]
  pub_ip         = true
  lock           = var.locked
  user_data      = <<-EOF
  #!/bin/bash
  sudo su ubuntu
  ssh-keygen -f /home/ubuntu/.ssh/ManagerAccessKey -N "" -C "ubuntu"
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
  cd Terraform/builds/worker/ && terraform init
  terraform apply -var locked="false" -var aws_location="eu-west-1" -var Token=$(docker swarm join-token -q worker) -var IPLink=$(hostname -i) -auto-approve
  cd ./../../..
  docker stack deploy --compose-file docker-compose.yml AO_Stack
  EOF

  # @@@ TAGS @@@
  name_tag = "AO-Manager"
  network_tag = "AO"
}