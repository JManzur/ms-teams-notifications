data "http" "myip" {
  url = "https://ifconfig.co/"
}

resource "aws_security_group" "demo" {
  name        = "demo-sg"
  description = "SSH"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH Form User IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    description      = "Allow Internet Out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "demo-sg" }
}
