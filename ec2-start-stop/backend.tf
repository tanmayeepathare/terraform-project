
terraform {
  backend "s3" {
    bucket = "tanmayee-terraform-state-2026-2026"
    key    = "ec2/scheduler/dns/tanmayee/terraform.tfstate"
    region = "ap-south-1"
  }
}
