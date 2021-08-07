# Example plans for HashiCorp Terraform

WARNING!

These scenarios will use AWS resources - so you
may incur some fees (however in case of S3 example they should
be minimal unless you try some stress tests etc.).

# Setup

Update - latest tested environment:
```bash
# openSUSE LEAP 15.2
sudo zypper in lsb-release

lsb_release -d
Description:	openSUSE Leap 15.2
```

Original Tested environment:
```bash
lsb_release -sd
   Ubuntu 18.04.2 LTS
```

## Setup - openSUSE LEAP 15.2

For `openSUSE LEAP 15.2` just run:
```bash
sudo zypper in aws-cli terraform
```

## Setup - Ubuntu 18.04 LTS

For Ubuntu 18.04 do this:

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

# Setup (continued)

And follow these steps to configure credentials: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#cli-quick-configuration


NOTE: For Terrraform you need to copy your your `~/.aws/config`
to `~/aws/credentials` (terraform uses this file as default for some reason).


# Terraform examples

Here is list of examples:

* [S3 Static Website with logging](s3-website-w-logging)


# Cleaning up

To remove all resource used by specific project try appropriate sub-directory:
```bash
terraform destroy
```


