provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "web_server" {
  ami           = "ami-01a00762f46d584a1"
  instance_type = var.instance_type

  tags = {
    Name        = "web-server-${var.environment}"
    Environment = var.environment
  }
}