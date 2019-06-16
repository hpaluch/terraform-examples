# S3 Static Website with logging

Example that creates S3 bucket with static Web Site and enables
logging to another S3 bucket.

Please see [parent README](../../../../terraform-examples) for common
setup instructions

## Setup

Ensure that your CLI user has full S3 access, for example
having this Role in [IAM](https://console.aws.amazon.com/iam/home):
```
arn:aws:iam::aws:policy/AmazonS3FullAccess
```

 For example this command should work:

```bash
aws s3 ls
# no error (output may be empty if you have not yet s3 bucket)
```

To publish static website:
* change working directory:

  ```bash
  cd s3-website-w-logging/
  ```

* copy `terraform.tfvars.example` to `terraform.tfvars`
* edit `terraform.tfvars` - define your own unique bucket names
  and/or change `aws_region` to your preferred region.

For the 1st time initialize terraform using:
```bash
terraform init
# will download used provider in my case
# - Downloading plugin for provider "aws" (terraform-providers/aws) 2.15.0...
# ...
```

Now we will validate our configuration using command:
```bash
terraform validate
# Success! The configuration is valid.
```

The finally you can invoke:
```bash
terraform apply
# confirm yes if it looks reasonable
```
You should see output like:
```
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

s3_log_bucket = your-log-bucket-name
s3_website_url = http://your-website-bucket-name.s3-website-us-east-1.amazonaws.com
```

After you change your `*.tf` files you may ask terraform for plan - what
it will change using command:
```bash
terraform plan
```

If it looks OK you may then use
```bash
terraform apply
```

You may also use again use AWS CLI to see bucket details.
Examples:
```bash
# list all your buckets
aws s3 ls

# list content of specific bucket
aws s3 ls bucket_name
```

NOTE: It will take some time for AWS to write logs in your log bucket
(it done as batch process)

When there is at least one log you can copy all logs using
this single CLI command:
```bash
mkdir -p ~/aws/logs
cd ~/aws/logs
aws s3 sync --dryrun s3://MY-LOG-BUCKET/log/ .
# it it looks reasonable then run:
aws s3 sync  s3://MY-LOG-BUCKET/log/ .
```

# Notes

File `files/image.png` was created using this command (Image Magick):
```bash
convert  -pointsize 16 -font Ubuntu-Mono -fill blue \
         -background lightblue caption:'image' files/image.png
# issue this to list available fonts:
convert -list font
```
There is good introduction on: http://www.imagemagick.org/Usage/text/#pointsize

