# 1. Reference your existing Route 53 Hosted Zone
data "aws_route53_zone" "primary" {
  name         = var.hosted_zone_name
  private_zone = false
}


resource "aws_route53_record" "alb_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.dns_name_to_access_alb
  type    = "A" # Use "AAAA" instead if you need IPv6 dual-stack routing

  alias {
    name                   = data.terraform_remote_state.alb_backend.outputs.alb_dns_name
    zone_id                = data.terraform_remote_state.alb_backend.outputs.alb_zone_id
    evaluate_target_health = true
  }
}