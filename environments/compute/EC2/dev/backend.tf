terraform {
  backend "s3" {

    bucket = "terraform-remote-backend-july-batch-fctp-v3" # this must be your s3 bucket name
    key    = "compute/fctp/dev/ec2/terraform.tfstate"
    region = "ap-south-1"
  }
}
