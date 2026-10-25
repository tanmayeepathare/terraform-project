terraform {
  backend "s3" {
    bucket = "terraform-workspaces-2026"
    key = "workspaces/ec2/terraform.tfstate"
    region = "ap-south-1"
  }

}