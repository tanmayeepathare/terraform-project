
variable "aws_region" {
  description = "AWS region to deploy the VPC"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["192.168.0.0/27", "192.168.0.32/27", "192.168.0.64/27"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["192.168.0.96/27", "192.168.0.128/27", "192.168.0.160/27"]
}

variable "vpc_tags" {
  default = "vpc-creation-tf"
}

variable "igw_name" {
  default = "space9-igw-tf"
}