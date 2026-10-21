############################################################
# S3
############################################################

module "frontend_bucket" {

  source = "../../../../modules/Storage/S3"


  bucket_name = var.bucket_name

  environment = var.environment

}

############################################################
# CloudFront
############################################################

module "cloudfront" {

  source = "../../../../modules/Storage/cdn"
  aws_region =  var.aws_region
  bucket_name = module.frontend_bucket.bucket_name

  bucket_arn = module.frontend_bucket.bucket_arn

  bucket_regional_domain_name = module.frontend_bucket.bucket_regional_domain_name

  aliases = [

    var.frontend_domain

  ]

  acm_certificate_arn = data.terraform_remote_state.acm_global.outputs.certificate_arn

  environment = var.environment
  

}

############################################################
# Route53
############################################################

resource "aws_route53_record" "frontend" {

  zone_id = data.terraform_remote_state.dns.outputs.hosted_zone_id

  name = var.frontend_domain

  type = "A"

  alias {

    name = module.cloudfront.distribution_domain_name

    zone_id = module.cloudfront.hosted_zone_id

    evaluate_target_health = false

  }

}