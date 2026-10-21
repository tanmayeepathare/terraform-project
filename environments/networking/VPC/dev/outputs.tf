output "vpc_id" {
  value = module.vpc_module.vpc_id
}

output "public_subnet_01_id" {
  value = module.vpc_module.public_subnet_01_id
}

output "private_subnet_01_id" {
  value = module.vpc_module.private_subnet_01_id
}