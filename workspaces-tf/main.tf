provider "aws" {
  region = "ap-south-1"
}

locals {
  instance_name = "${terraform.workspace}-instance"
}

resource "aws_instance" "workspce-demo" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair

  tags = {
    Name = local.instance_name
  }
}