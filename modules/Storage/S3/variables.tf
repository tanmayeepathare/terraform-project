variable "aws_region" {
  default = "ap-south-1"
}

variable "bucket_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "tags" {
  type    = map(string)
  default = {}
}