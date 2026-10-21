terraform {
  backend "s3" {

    bucket = "load-balancer-tf-26" # this must be your s3 bucket name
    key    = "network/fctp/dev/vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}
