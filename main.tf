provider "aws" {
  shared_credentials_file = var.aws_creds_file
  profile                 = var.aws_profile
  region                  = var.aws_region
}

provider "external" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

locals {
  instance_count = var.automate_create ? 1 : 0
  ami_id         = var.automate_ami_id != null ? var.automate_ami_id : null
  ssh_user       = var.automate_ami_id != null ? var.automate_ssh_user != null ? var.automate_ssh_user : "root" : module.automate_base.ssh_user
}

module "automate_base" {
  source                      = "srb3/base/aws"
  version                     = "0.0.1"
  vm_key_name                 = var.automate_key_name
  vm_instance_type            = var.automate_instance_type
  security_group_access_cidrs = var.automate_cidrs
  vm_ami_id                   = local.ami_id
  vm_os_name                  = var.automate_os_name
  base_create                 = var.automate_create
}

module "automate_install" {
  source                      = "srb3/chef-automate/linux"
  version                     = "0.0.33"
  ips                         = module.automate_base.public_ip
  instance_count              = local.instance_count
  ssh_user_name               = local.ssh_user
  ssh_user_private_key        = var.automate_ssh_user_private_key
  products                    = var.automate_products
  config                      = var.automate_config
  admin_password              = var.automate_admin_password
  ingest_token                = var.automate_ingest_token
  hostname_method             = var.automate_hostname_method
  chef_automate_license       = var.automate_license
}

module "automate_populate" {
  source                      = "srb3/chef-automate-populate/linux"
  version                     = "0.0.16"
  ips                         = module.automate_instance.public_ip
  instance_count              = local.instance_count
  ssh_user_name               = local.ssh_user
  user_private_key            = var.automate_ssh_user_private_key
  enabled_profiles            = var.automate_enabled_profiles
  automate_module             = jsonencode(module.automate_install)
}
