data "aws_availability_zones" "available" {}

resource "random_id" "hash" {
  byte_length = 4
}

module "ami" {
  source  = "srb3/ami/aws"
  version = "0.0.1"
  os_name = var.automate_os_name
}

locals {
  prefix         = var.automate_name_prefix != null ? var.automate_name_prefix : random_id.hash.hex
  create_vpc     = var.automate_create ? var.automate_vpc_id == null ? true : false : false
  create_sg      = var.automate_create ? var.automate_security_group_ids == null ? true : false :false
  instance_count = var.automate_create ? 1 : 0
  vpc_name       = "${local.prefix}-${var.automate_vpc_name}"
  sec_grp_name   = "${local.prefix}-${var.automate_security_group_name}"
  vm_name        = "${local.prefix}-${var.automate_vm_name}"
  ami_id         = var.automate_ami_id != null ? var.automate_ami_id : module.ami.id
  user           = var.automate_ssh_user != null ? var.automate_ssh_user : module.ami.user
  sec_grp_ids    = var.automate_security_group_ids != null ? var.automate_security_group_ids : [module.automate_security_group.id]
  vpc_id         = var.automate_vpc_id != null ? var.automate_vpc_id : module.automate_vpc.vpc_id
  subnet_ids     = var.automate_subnet_ids != null ? var.automate_subnet_ids : module.automate_vpc.public_subnets
  azs            = length(var.automate_azs) > 0 ? var.automate_azs : [
                                           data.aws_availability_zones.available.names[0],
                                           data.aws_availability_zones.available.names[1]
                                         ]
  rbd            = var.automate_root_block_device != null ? var.automate_root_block_device : [
                                           { volume_type = "gp2", volume_size = "40" }
                                         ]
  ebd            = var.automate_ebs_block_device != null ? var.automate_ebs_block_device : []
  cidr           = var.automate_cidrs != null ? var.automate_cidrs : ["0.0.0.0/0"]
  iwcb           = length(var.automate_security_group_ingress_with_cidr_blocks) > 0 ? var.automate_security_group_ingress_with_cidr_blocks : [
    { rule = "ssh-tcp", cidr_blocks = join(",",local.cidr) },
    { rule = "http-80-tcp", cidr_blocks = join(",",local.cidr) },
    { rule = "https-443-tcp", cidr_blocks = join(",",local.cidr) }
  ]
  ewcb           = length(var.automate_security_group_egress_with_cidr_blocks) > 0 ? var.automate_security_group_egress_with_cidr_blocks : [
    { rule = "all-all", cidr_blocks = "0.0.0.0/0" }
  ]
}

resource "aws_eip" "automate" {
  vpc = true
}

module "automate_vpc" {
  source             = "srb3/vpc/aws"
  version            = "0.0.3"
  create_vpc         = local.create_vpc
  name               = local.vpc_name
  cidr               = var.automate_cidr
  azs                = local.azs
  private_subnets    = var.automate_private_subnets
  public_subnets     = var.automate_public_subnets
  enable_nat_gateway = var.automate_enable_nat_gateway
  tags               = var.tags
}

module "automate_security_group" {
  source                   = "srb3/security-group/aws"
  version                  = "0.0.1"
  create                   = local.create_sg
  name                     = local.sec_grp_name
  description              = var.automate_security_group_description
  vpc_id                   = local.vpc_id
  ingress_with_cidr_blocks = local.iwcb
  ingress_cidr_blocks      = var.automate_security_group_ingress_cidr_blocks
  egress_with_cidr_blocks  = local.ewcb
  egress_cidr_blocks       = var.automate_security_group_egress_cidr_blocks
  tags                     = var.tags
}

module "automate_instance" {
  source                      = "srb3/vm/aws"
  version                     = "0.0.1"
  name                        = local.vm_name
  ami                         = local.ami_id
  instance_count              = local.instance_count
  instance_type               = var.automate_instance_type
  key_name                    = var.automate_key_name
  security_group_ids          = local.sec_grp_ids
  subnet_ids                  = local.subnet_ids
  root_block_device           = local.rbd
  ebs_block_device            = local.ebd
  associate_public_ip_address = var.automate_associate_public_ip_address
  tags                        = var.tags
}

module "automate_install" {
  source                      = "srb3/chef-automate/linux"
  version                     = "0.0.33"
  ips                         = flatten(module.automate_instance.public_ip)
  instance_count              = local.instance_count
  ssh_user_name               = local.user
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
  ips                         = flatten(module.automate_instance.public_ip)
  instance_count              = local.instance_count
  user_name                   = local.user
  user_private_key            = var.automate_ssh_user_private_key
  enabled_profiles            = var.automate_enabled_profiles
  automate_module             = jsonencode(module.automate_install)
}
