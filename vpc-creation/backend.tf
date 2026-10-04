terraform {
  backend "s3" {
    bucket         = "tanmayee-vpc-creation-tf"
    key            = "networking/vpc/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "vpc-tf-db"
  }
}