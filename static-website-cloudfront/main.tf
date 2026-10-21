
# Generate a unique suffix for the S3 bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Existing website bucket — keep the same bucket name
resource "aws_s3_bucket" "website" {
  bucket = "${var.project_name}-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = var.project_name
    Environment = var.environment
    Project     = "Static Website Hosting"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Configure S3 static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

# Allow public access to website files
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# Allow visitors to read website files
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadWebsiteFiles"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

# Upload website files to S3
resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}/${var.website_directory}", "**")

  bucket = aws_s3_bucket.website.id
  key    = each.value
  source = "${path.module}/${var.website_directory}/${each.value}"
  etag   = filemd5("${path.module}/${var.website_directory}/${each.value}")

  content_type = (
    endswith(each.value, ".html") ? "text/html" :
    endswith(each.value, ".css") ? "text/css" :
    endswith(each.value, ".js") ? "application/javascript" :
    endswith(each.value, ".png") ? "image/png" :
    endswith(each.value, ".jpg") || endswith(each.value, ".jpeg") ? "image/jpeg" :
    endswith(each.value, ".svg") ? "image/svg+xml" :
    "application/octet-stream"
  )
}
