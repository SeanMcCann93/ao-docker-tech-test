output "system_public-ip" {
  value = aws_instance.ec2_instance.*.public_ip
}