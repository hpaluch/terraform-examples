# Example plans for HashiCorp Terraform

WARNING!

These scenarios will use AWS resources - so you
may incur some fees (however in case of S3 example they should
be minimal unless you try some stress tests etc.).

# Setup

Tested environment:
```bash
lsb_release -sd
   Ubuntu 18.04.2 LTS
```

Go to Download page https://www.terraform.io/downloads.html
and download appropriate terraform version, in my case:
```bash
cd
curl -O https://releases.hashicorp.com/terraform/0.12.2/terraform_0.12.2_linux_amd64.zip
```

Unpack and install `terraform` binary, in my case:
```bash
unzip  terraform_0.12.2_linux_amd64.zip
sudo cp terraform /usr/local/bin/
```

Verify that binary is really working:
```bash
terraform --version
   Terraform v0.12.2
```

WARNING!

It is strongly recommended that you have installed and
configured AWS CLI. If you have not installed it than issue

```bash
apt-get install awscli
```

And follow these steps to configure credentials: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#cli-quick-configuration


NOTE: For Terrraform you need to copy your your `~/.aws/config`
to `~/aws/credentials` (terraform uses this file as default for some reason).


# Terraform examples

## S3 Static Website with logging

Example that creates S3 bucket with static Web Site and enables
logging to another S3 bucket.

### Setup

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

No we will validate our configuration using command:
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


# Cleaning up

To remove all resource used by specific project try appropriate sub-directory:
```bash
terraform destroy
```


