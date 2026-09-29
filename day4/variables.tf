variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The EC2 instance type to use."
  type        = string
}

variable "server_port" {
  description = "The port number the server listens on."
  type        = number
  default     = 8080
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "db_password" {
  description = "The database password."
  type        = string
  sensitive   = true
}