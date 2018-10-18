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

resource "aws_s3_bucket" "bucket" {
  bucket = "dottie-test"
  acl    = "private"

  tags {
    Name        = "Dottie"
    Environment = "Dev"
  }
}

