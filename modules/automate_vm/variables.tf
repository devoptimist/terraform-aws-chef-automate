########### general settings #####################

variable "automate_name_prefix" {
  description = "A string to preprend to the names given to resources that are created by this module"
  type        = string
  default     = null
}

variable "automate_cidrs" {
  description = "A list of CIDR's to allow access to the chef autoamte instance from"
  type        = list(string)
}

variable "automate_create" {
  description = "A boolean to dictate if we create an instance of chef automate"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of key / value pairs to apply to the resources created by this module that accept tags"
  type        = map(string)
}

########### automate vpc settings ################

variable "automate_vpc_id" {
  description = "The id of an aws vpc to use for our chef automate instnace"
  type        = string
  default     = null
}

variable "automate_vpc_name" {
  description = "The name to give the vpc that will be associated with our chef automate instance"
  type        = string
  default     = "automate-vpc"
}

variable "automate_cidr" {
  description = "The CIDR block for the VPC that will be used by the automate instance"
  type        = string
  default     = "10.0.0.0/16"
}

variable "automate_azs" {
  description = "A list of availability zones names or ids in the region, This is consumed by the vpc module"
  type        = list(string)
  default     = [] 
}

variable "automate_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "automate_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "automate_enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

########### automate security group settings #####

variable "automate_security_group_name" {
  description = "The name to give the security group that will be associated with our chef automate instance"
  type        = string
  default     = "automate-sg"
}

variable "automate_security_group_description" {
  description = "The description to give the security group that will be associated with our chef automate instance"
  type        = string
  default     = "An omnidemo managed automate security group"
}

variable "automate_security_group_ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "automate_security_group_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "automate_security_group_egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "automate_security_group_egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

########### automate vm settings #################

variable "automate_vm_name" {
  description = "The name to give the automate virtual machine"
  type        = string
  default     = "automate-vm"
}

variable "automate_ami_id" {
  description = "The id of an ami to use for chef automate. if not used then the automate_os_name value is used to get the latest named image id"
  type        = string
  default     = null
}

variable "automate_os_name" {
  description = "The name of the OS to use for the chef autoamte deployment, ignored if automate_ami is used"
  type        = string
  default     = "centos-7"
}

variable "automate_ssh_user" {
  description = "The user name of the ami's default ssh user e.g. ec-user"
  type        = string
  default     = null
}

variable "automate_instance_type" {
  description = "The instance type to use for deploying chef autoamte"
  type        = string
  default     = "t3.medium"
}

variable "automate_key_name" {
  description = "The name of the aws ssh key pair to use with the chef automate instance"
  type        = string
}

variable "automate_security_group_ids" {
  description = "The id of a security group to associate with chef automate, if null then a default security group is created"
  type        = list(string)
  default     = null
}

variable "automate_subnet_ids" {
  description = "A list of ids of subnets to associate with chef automate, if null that a default subnet is created"
  type        = list(string)
  default     = null
}

variable "automate_root_block_device" {
  description = "Customize details about the root block device of the instance"
  type        = list(map(string))
  default     = null
}

variable "automate_ebs_block_device" {
  description = "Additional EBS block devices to attach to the instanc"
  type        = list(map(string))
  default     = null
}

variable "automate_associate_public_ip_address" {
  description = "If true, the chef automate instance will have associated public IP address"
  type        = bool
  default     = true
}

########### automate install settings ###########

variable "automate_ssh_user_private_key" {
  description = "The ssh private key path for access to the chef automate vm"
  type        = string
}

variable "automate_products" {
  description = "A list of products to install: automate,chef,builder"
  type        = list(string)
  default     = ["automate"]
}

variable "automate_config" {
  description = "Any other config to pass to chef automate"
  type        = string
  default     = ""
}

variable "automate_ingest_token" {
  description = "The string token to use for chef automate's admin token"
  type        = string
  default     = "admintoken1234"
}

variable "automate_admin_password" {
  description = "The admin password for chef automate"
  type        = string
  default     = ""
}

variable "automate_license" {
  description = "The chef automate license"
  type        = string
  default     = ""
}

variable "automate_hostname_method" {
  description = "The method to use for setting the hostname."
  type        = string
  default     = "cloud"
}

########### automate populate settings ##########

variable "automate_enabled_profiles" {
  description = "A list of profiles to enable from the automate profile market place"
  type        = list(map(string))
  default     = []
}
