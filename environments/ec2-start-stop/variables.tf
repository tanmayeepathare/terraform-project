variable "aws_region" {
  default = "ap-south-1"
}

variable "project_name" {
  default = "ec2-scheduler"
}


variable "ami_id" {
  type = string 
  default = "ami-07a00cf47dbbc844c"
}

variable "instance_type" {
  type = string 
  default = "t3.micro"
}

variable "key_name" {
  type = string 
  default = "doc-keypair"
}



variable "instance_name" {
  default = "ec2_start_stop"
}

variable "environment" {
  default = "dev"
  
}