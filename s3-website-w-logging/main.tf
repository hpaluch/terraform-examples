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

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"

    tags = {
      "rule"      = "log"
      "autoclean" = "true"
    }

    # delete logs older than 60 days - avoid growing forgotten
    # bucket to "infinity"...
    expiration {
      days = 60
    }
  }

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

  # this policy ensures that all uploaded files are PUBLIC
  # see: https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteAccessPermissionsReqd.html
  # NOTE: Terraform does not allow self-references, hence
  #       using ${var.website_bucket_name}
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
	"Sid":"PublicReadGetObject",
        "Effect":"Allow",
	  "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.website_bucket_name}/*"
      ]
    }
  ]
}
  POLICY


  tags = {
    "rule" = "web"
  }
}

# single bucket object - file index.html
resource "aws_s3_bucket_object" "object" {
  bucket = "${aws_s3_bucket.website_bucket.id}"
  acl = "public-read"
  key = "index.html"
  content_type = "text/html"
  source = "./files/index.html"

  tags = {
    "rule" = "web"
  }
}


