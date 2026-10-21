data "terraform_remote_state" "acm_backend" {
  backend = "s3"

  config = {

    bucket = "terraform-remote-backend-july-batch-fctp-v3" # this must be your s3 bucket name
    key    = "security/fctp/acm-alb/terraform.tfstate"
    region = "ap-south-1"

  }
}

######################################################
#### vpc_backend
#####################################################

data "terraform_remote_state" "vpc_backend" {
  backend = "s3"

  config = {

    bucket = "terraform-remote-backend-july-batch-fctp-v3" # this must be your s3 bucket name
    key    = "network/fctp/dev/vpc/terraform.tfstate"
    region = "ap-south-1"

  }
}


###################################################
#######   acm alb backend 
###################################################

data "terraform_remote_state" "tg_backend" {
  backend = "s3"

  config = {

    bucket = "terraform-remote-backend-july-batch-fctp-v3" # this must be your s3 bucket name
    key    = "compute/fctp/dev/tg/terraform.tfstate"
    region = "ap-south-1"

  }
}

###################################################
#######    alb backend 
###################################################

data "terraform_remote_state" "alb_backend" {
  backend = "s3"

  config = {

    bucket = "terraform-remote-backend-july-batch-fctp-v3" # this must be your s3 bucket name
    key    = "compute/fctp/dev/alb/terraform.tfstate"
    region = "ap-south-1"

  }
}