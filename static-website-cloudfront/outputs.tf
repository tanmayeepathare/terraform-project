
output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting our website"
  value       = aws_s3_bucket.website.bucket
}

output "s3_website_endpoint" {
  description = "S3 static website endpoint"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}
