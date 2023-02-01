#Grabbing latest Linux 2 AMI
data "aws_ami" "linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "demo" {
  ami                         = data.aws_ami.linux2.id
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_id
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.demo.id]
  associate_public_ip_address = true

  user_data = <<EOF
  #!/bin/bash
  sudo yum update -y
  sudo amazon-linux-extras install epel -y
  sudo yum install stress -y
  sudo yum install htop -y
  EOF

  tags = { Name = "demo-ec2" }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
    tags                  = { Name = "demo-ebs" }
  }
}