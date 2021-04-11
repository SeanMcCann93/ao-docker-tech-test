variable "aws_location" {
  description = "AWS region."
}

variable "locked" {
  description = "This is made to enable termination protection to maintain access to your nodes that are an extention of this bridge."
}

variable "Token" {
  description = "This is the JOIN token to the Docker Swarm manager."
}

variable "IPLink" {
  description = "This is the IP for the Docker Swarm manager."
}