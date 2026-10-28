
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "load-balancer-tf-26-26"
    key    = "network/fctp/dev/vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}
