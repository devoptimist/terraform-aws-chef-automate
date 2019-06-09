# Important
This module creates a chef automate server.
Currently only supports RHEL 7 compatible images.

## Usage

```hcl

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.64.0"

  name = "chef-automate-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["eu-west-2a"]
  public_subnets = ["10.0.1.0/24"]
  map_public_ip_on_launch = true
  tags = "${var.tags}"
}

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "2.17.0"

  name        = "chef-automate-security-group"
  description = "security group to enable ssh"
  vpc_id      = "${module.vpc.vpc_id}"
  ingress_rules       = ["ssh-tcp","https-443-tcp"]
  egress_rules        = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

data "aws_ami" "chef_automate_image" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-7.6_HVM_GA-20190128-x86_64-0-Hourly2-GP2"]
  }
}

<<<<<<< HEAD
module "chef_automate" {
  source                      = "devoptimist/chef-automate/aws"
  version                     = "0.1.0"
  name                        = "chef-automate" 
=======
module "chef_server" {
  source                      = "devoptimist/chef-server/aws"
  version                     = "0.0.7"
  name                        = "chef-server" 
>>>>>>> dfae90c6ac14db5c970e0bb55a876ea5cb36e852
  chef_user                   = "mike"
  chef_pass                   = "P@55w0rd1"
  chef_org                    = "org1"
  chef_automate_version       = "12.19.44"
  instance_count              = 1
  ami                         = "${module.chef_automate_image.ami_id}"
  instance_type               = "t2.medium"
  key_name                    = "my_aws_key"
  vpc_security_group_ids      = ["${module.sg.this_security_group_id}"]
  subnet_ids                  = ["${module.vpc.public_subnets}"]
  root_disk_size              = 40
  tags                        = "${var.tags}"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
|name|The name to give the chef automate instnace Name tag|string||yes|
|instance_count|The number of identical chef automates to create|int|1|no|
|associate_public_ip_address|Should the chef automate server have a public ip|bool|true|no|
|ami|The ami id to create the chef automate from|string||yes|
|instance_type|The aws instance size to create the chef automate from|string|t2.medium|no|
|key_name|The name of aws ssh key to associate with this instance|string||yes|
|vpc_security_group_ids|A list of security group ids to associage with this instance|list||yes|
|subnet_ids|A list of subnet ids to associate with this instance|list||yes|
|root_disk_size|The size (in GB) of the root disk for the chef automate server|string|40|no|
|tags|A map of tags to associate with the instance|map|{}|no|
