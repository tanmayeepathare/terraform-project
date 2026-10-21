
variable "project_name" {
  description = "Name of our static website hosting project"
  type        = string
  default     = "tanmayee-portfolio"
}

variable "aws_region" {
  description = "AWS region for our project"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "website_directory" {
  description = "Local directory containing website files"
  type        = string
  default     = "website"
}

variable "domain_name" {
  description = "Custom domain for the portfolio website"
  type        = string
  default     = "tanmayee.qd.je"
}
