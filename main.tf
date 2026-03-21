provider "aws" {
  region = "us-east-1"
}

# Free-tier Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Allow only HTTP
resource "aws_security_group" "web_sg" {
  name = "minimal-web-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Single free-tier EC2 instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<EOF
#!/bin/bash
echo "hello world" > /var/www/html/index.html
yum install -y httpd
systemctl enable httpd
systemctl start httpd
EOF
}

output "url" {
  value = "http://${aws_instance.web.public_ip}"
}
