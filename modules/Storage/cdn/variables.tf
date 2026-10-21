variable "bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}

variable "bucket_regional_domain_name" {
  description = "Regional Domain Name of S3 Bucket"
  type        = string
}

variable "bucket_arn" {
  description = "ARN of S3 Bucket"
  type        = string
}

variable "aliases" {
  description = "CloudFront Aliases"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM Certificate ARN (Must be in us-east-1)"
  type        = string
}

variable "price_class" {
  default = "PriceClass_100"
}

variable "environment" {
  default = "dev"
}

variable "tags" {
  type    = map(string)
  default = {}
}
variable "aws_region" {
  description = "AWS Region"
  
}