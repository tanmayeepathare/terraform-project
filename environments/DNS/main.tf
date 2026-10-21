module "dns_module" {
  source = "../../modules/DNS"
  domain_name = var.domain_name
  aws_region = var.aws_region
}