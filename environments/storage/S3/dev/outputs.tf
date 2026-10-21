output "bucket_name" {
  description = "Frontend S3 bucket name"
  value       = module.frontend_bucket.bucket_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_domain" {
  description = "CloudFront domain name"
  value       = module.cloudfront.distribution_domain_name
}

output "frontend_url" {
  description = "Frontend custom domain"
  value       = "https://${var.frontend_domain}"
}