terraform {
  backend "s3" {
    bucket = "tanmayee-vpcpeering-tf-2026" # this must be your s3 bucket name
    key    = "networking/fctp/dev/vpc-peering/demo/terraform.tfstate"
    region = "ap-south-1"
  }
}
