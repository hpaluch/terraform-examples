# s3-website-w-logging/main.tf - creates two S3 buckets in Amazon AWS:
# - one with static website
# - another one for logging

# use defaults from environment
provider aws {
  region = var.aws_region
}

# Private bucket to store logs
# from https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#enable-logging
resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket_name
  region = var.aws_region
  acl    = "log-delivery-write"

  tags = {
    "rule" = "log"
  }

}

# bucket to store static WebSite
# from: https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#static-website-hosting
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.website_bucket_name
  region = var.aws_region
  acl    = "public-read"

  website {
    index_document = "index.html"
  }

  logging {
    target_bucket = "${aws_s3_bucket.log_bucket.id}"
    target_prefix = "log/"
  }

  tags = {
    "rule" = "web"
  }
}

# single bucket object - file index.html
resource "aws_s3_bucket_object" "object" {
  bucket       = "${aws_s3_bucket.website_bucket.id}"
  acl          = "public-read"
  key          = "index.html"
  content_type = "text/html"
  source       = "./files/index.html"

  tags = {
    "rule" = "web"
  }
}


