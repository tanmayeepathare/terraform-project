data "terraform_remote_state" "vpc_backend" {
  backend = "s3"

  config = {

    bucket = "terraform-remote-backend-july-batch-fctp-v3" # this must be your s3 bucket name
    key    = "network/fctp/dev/vpc/terraform.tfstate"
    region = "ap-south-1"

  }
}
