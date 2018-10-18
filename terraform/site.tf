provider "aws" {
  shared_credentials_file = "C:\\Users\\Henri\\.aws/credentials"
  profile                 = "default"
  region                  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-hmp"
    key    = "dazzlingdottie/01"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "bucket1" {
  bucket = "dottie-test.com"
  acl = "private"
  policy = "${file("policy-raw.json")}"

  website {
    redirect_all_requests_to = "www.dottie-test.com"
  }
}

resource "aws_s3_bucket" "bucket2" {
  bucket = "www.dottie-test.com"
  acl = "private"
  policy = "${file("policy-www.json")}"

  website {
    index_document = "index.html"
  }

}

resource "aws_cloudfront_origin_access_identity" "test" {
  comment = "Some comment"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.bucket2.bucket_regional_domain_name}"
    origin_id   = "${aws_s3_bucket.bucket2.bucket_regional_domain_name}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.test.id}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  aliases = ["dottie-test.com", "www.dottie-test.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.bucket2.bucket_regional_domain_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}
