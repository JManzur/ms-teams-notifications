output "instance_id" {
  value = aws_instance.demo.id
}

output "ec2_public_ip_ssh" {
  value       = "sudo ssh -i ~/.ssh/${var.ssh_key_name}.pem ec2-user@${aws_instance.demo.public_ip}"
  description = "The full SSH you need to run to connect to the instance"
}