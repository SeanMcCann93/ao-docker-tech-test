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
  key_name   = "AccessKey"
  public_key = file("/home/ubuntu/.ssh/AccessKey.pub")
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@ Create Virtual Priv Network @@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

data "aws_subnet" "subnet_public" {
  filter {
    name   = "tag:Name"
    values = ["AO-Subnet"]
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
  pem_key        = "AccessKey"
  subnet         = data.aws_subnet.subnet_public.id # Task ~ get the Subnet group with Name Tag "PetClinic_Subnet"
  vpc_sg         = [data.aws_security_group.sg.id] # Task ~ get the Security group with Name Tag "multi_port_access"
  pub_ip         = true
  lock           = var.locked
  user_data      = templatefile("./../../tools/boot_scripts/boot-worker.sh", {})

  # @@@ TAGS @@@
  name_tag = "AO-Worker"
  network_tag = "AO"
}