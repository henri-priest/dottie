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
  bucket = "dottie-test"
}

resource "aws_s3_bucket" "bucket2" {
  bucket = "www.dottie-test"

  policy = "${file("policy.json")}"

  website {
    index_document = "index.html"
  }

}

resource "aws_s3_bucket_object" "index" {
  key        = "index.html"
  bucket     = "${aws_s3_bucket.bucket2.id}"
  source     = "../s3_static/index.html"
}
