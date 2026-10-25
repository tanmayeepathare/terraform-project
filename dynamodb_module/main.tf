
#############################################################
# DynamoDB Table
#############################################################

resource "aws_dynamodb_table" "basic_dynamodb_table" {
  name           = var.name
  billing_mode   = var.billing_mode

  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity

  # Primary key configuration
  hash_key  = var.hash_key
  range_key = var.range_key

  # Partition key attribute
  attribute {
    name = var.attribute_name
    type = var.attribute_type
  }

  # Sort key attribute
  attribute {
    name = var.range_attribute_name
    type = var.range_attribute_type
  }

  # Resource tags
  tags = {
    Name        = var.dynamodb_table_name
    environment = var.environment
  }
}