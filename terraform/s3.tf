provider "aws" {
  shared_credentials_file = "C:\\Users\\Henri\\.aws/credentials"
  profile                 = "default"
  region                  = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "dottie-test"
  acl    = "private"

  tags {
    Name        = "Dottie"
    Environment = "Dev"
  }
}

