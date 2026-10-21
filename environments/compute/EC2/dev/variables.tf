variable "instance_ami_id" {
  type = string
  
}

variable "instance_type" {
  type = string

}

# variable "subnet_id" {
#   type = string


# }
variable "environment" {
  type = string
  default = "dev"
}


variable "associate_public_ip_address" {
  type = bool
  default = true
}
variable "aws_region" {
  
}