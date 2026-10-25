variable "aws_region" {
  type = string
}


variable "name" {
  type = string
}

variable "billing_mode" {
  type = string
}


variable "read_capacity" {
  type = string
}
variable "write_capacity" {
  type = string
}
variable "hash_key" {
  type = string
}
variable "range_key" {
  type = string
}
variable "attribute_name" {
  type = string
}

variable "attribute_type" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "range_attribute_name" {
  description = "DynamoDB sort key attribute name"
  type        = string
}

variable "range_attribute_type" {
  description = "DynamoDB sort key attribute type"
  type        = string
}