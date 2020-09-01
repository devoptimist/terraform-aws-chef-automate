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

module "automate" {
  source                        = "./modules/automate_vm"
  automate_create               = var.automate_create
  automate_cidrs                = var.automate_cidrs
  automate_key_name             = var.automate_key_name
  automate_instance_type        = var.automate_instance_type
  automate_ssh_user_private_key = var.automate_ssh_user_private_key
  automate_products             = var.automate_products
  automate_config               = var.automate_config
  automate_ingest_token         = var.automate_ingest_token 
  automate_admin_password       = var.automate_admin_password
  automate_os_name              = var.automate_os_name
  automate_license              = var.automate_license
  automate_enabled_profiles     = var.automate_enabled_profiles
  tags                          = var.tags
}
