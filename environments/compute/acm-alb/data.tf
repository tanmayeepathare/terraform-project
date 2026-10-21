data "terraform_remote_state" "dns_backend" {
  backend = "s3"

  config = {
    bucket = "tanmayee-terraform-state-2026"
    key    = "global/dns/tanmayee/terraform.tfstate"
    region = "ap-south-1"
  }
}