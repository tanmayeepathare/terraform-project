terraform {
  backend "s3" {
    bucket = "terraform-dynamo-db-2026"
    key = "projects/dynamodb-table/alb/terraform.tfstate"
    region = "ap-south-1"
  }

}