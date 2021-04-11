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
  name_tag    = "AO-Subnet"
  network_tag = "AO"
}

module "subnet_private" {
  source  = "./../../tools/SUBNET"
  availability_zone = data.aws_availability_zones.available.names[0]
  v4_cidr = "126.157.20.0/24"
  pub_ip  = true
  vpc_id  = module.vpc.id

  # @@@ TAGS @@@
  name_tag    = "AO-Subnet"
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
  user_data      = templatefile("./../../tools/boot_scripts/boot-manager.sh", {})

  # @@@ TAGS @@@
  name_tag = "AO-Manager"
  network_tag = "AO"
}