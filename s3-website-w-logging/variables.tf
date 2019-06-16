# variables.tf - required variables

variable website_bucket_name {}
variable log_bucket_name {}
variable aws_region {}

variable website_files {
  type    = list(string)
  default = ["index.html", "robots.txt", "image.png"]
}

# NOTE: the order must match website_files !
variable website_mime {
  type    = list(string)
  default = ["text/html", "text/plain", "image/png"]
}

