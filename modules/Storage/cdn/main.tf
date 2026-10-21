############################################################
# Origin Access Control
############################################################

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.bucket_name}-oac"
  description                       = "OAC for ${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

############################################################
# CloudFront Distribution
############################################################

resource "aws_cloudfront_distribution" "this" {

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.environment} Frontend CDN"
  default_root_object = "index.html"

  aliases = var.aliases

  origin {

    domain_name = var.bucket_regional_domain_name
    origin_id   = "frontend-s3"

    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  default_cache_behavior {

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    target_origin_id = "frontend-s3"

    viewer_protocol_policy = "redirect-to-https"

    compress = true

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

  }

  restrictions {

    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {

    acm_certificate_arn = var.acm_certificate_arn

    ssl_support_method = "sni-only"

    minimum_protocol_version = "TLSv1.2_2021"
  }

  custom_error_response {

    error_code = 403

    response_code = 200

    response_page_path = "/index.html"
  }

  custom_error_response {

    error_code = 404

    response_code = 200

    response_page_path = "/index.html"
  }

  price_class = var.price_class

  tags = merge(
    {
      Environment = var.environment
      Name        = "frontend-cloudfront"
    },
    var.tags
  )
}

############################################################
# S3 Bucket Policy
############################################################

data "aws_iam_policy_document" "this" {

  statement {

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${var.bucket_arn}/*"
    ]

    principals {

      type = "Service"

      identifiers = [
        "cloudfront.amazonaws.com"
      ]
    }

    condition {

      test = "StringEquals"

      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.this.arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {

  bucket = var.bucket_name

  policy = data.aws_iam_policy_document.this.json
}