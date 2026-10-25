module "dynmodb_module" {
  source = "../dynamodb_module"

  write_capacity = var.write_capacity
  name = var.name
  attribute_name = var.attribute_name
  dynamodb_table_name = var.dynamodb_table_name
  attribute_type = var.attribute_type
  aws_region = var.aws_region
  environment = var.environment
  hash_key = var.hash_key
  range_key = var.range_key
  billing_mode = var.billing_mode
  read_capacity = var.read_capacity
range_attribute_name = var.range_attribute_name

range_attribute_type = var.range_attribute_type


}