
terraform {
  backend "s3" {
    bucket = "tanmayee-terraform-state-2026"
    key    = "global/dns/tanmayee/terraform.tfstate"
    region = "ap-south-1"
  }
}
