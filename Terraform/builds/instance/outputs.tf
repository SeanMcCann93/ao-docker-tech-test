output "system_public-ip" {
  value = "http://${module.ec2_machine.system_public-ip[0]}"
}