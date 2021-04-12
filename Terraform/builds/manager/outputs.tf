output "system_public-ip" {
  value = "http://${module.ec2_manager.system_public-ip[0]}\nssh -i \"~/.ssh/AccessKey\" ubuntu@ec2-${module.ec2_manager.system_public-ip[0]}.eu-west-1.compute.amazonaws.com\nls ~ Once ao appears\naws configure ~ Enter your details one last time"
}