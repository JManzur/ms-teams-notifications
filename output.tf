output "ec2_public_ip_ssh" {
  value       = module.ec2.ec2_public_ip_ssh
  description = "The full SSH you need to run to connect to the instance"
}