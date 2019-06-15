# outputs.tf - variables print on output

output "s3_website_url" {
  value = "http://${aws_s3_bucket.website_bucket.id}.s3-website-${aws_s3_bucket.website_bucket.region}.amazonaws.com"
}

output "s3_log_bucket" {
  value = "${aws_s3_bucket.log_bucket.id}"
}

