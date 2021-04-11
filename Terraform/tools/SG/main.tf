resource "aws_security_group" "sg" {
  name        = var.name_tag
  description = var.sg_description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    iterator = port
    for_each = var.in_port
    content {
      description = var.port_desc[port.value]
      from_port   = port.value
      to_port     = port.value
      protocol    = var.in_protocol
      cidr_blocks = [var.in_cidr]
    }
  }

  egress {
    from_port   = var.out_port
    to_port     = var.out_port
    protocol    = var.out_protocol
    cidr_blocks = [var.out_cidr]
  }

  tags = {
    Name = var.name_tag
    Network = var.network_tag
  }
}