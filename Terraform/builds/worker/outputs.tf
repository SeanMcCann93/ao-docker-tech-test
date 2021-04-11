output "system_public-ip" {
  value = "${module.ec2_worker.system_public-ip[0]} and ${module.ec2_worker.system_public-ip[1]}"
  
}