
terraform {
  backend "s3" {
    bucket = "tanmayee-terraform-state-2026"
    key    = "security/fctp/acm-alb/terraform.tfstate"
    region = "ap-south-1"
  }
}
