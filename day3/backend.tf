terraform {
  backend "s3" {
    bucket = "backend-tf-day3"
    key    = "compute/day3/terraform.tfstate"
    region = "ap-south-1"
  }
}