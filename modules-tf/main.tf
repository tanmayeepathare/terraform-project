provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"
  description = "Allow HTTP inbound traffic"

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

module "nginx_ubuntu" {
  source            = "./modules/nginx_ubuntu"
  ami_id            = var.ubuntu_ami
  instance_type     = "t3.micro"
  key_name          = var.key_name
  subnet_id         = var.subnet_id
  security_group_id = aws_security_group.web_sg.id
}

module "httpd_amazon" {
  source            = "./modules/httpd_amazon"
  ami_id            = var.amazon_ami
  instance_type     = "t3.micro"
  key_name          = var.key_name
  subnet_id         = var.subnet_id
  security_group_id = aws_security_group.web_sg.id
}
output "nginx_ip" {
  value = module.nginx_ubuntu.nginx_public_ip
}

output "httpd_ip" {
  value = module.httpd_amazon.httpd_public_ip
}