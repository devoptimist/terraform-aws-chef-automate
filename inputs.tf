variable "name" {
  type    = "string"
}

variable "create_system_user" {
  default = true
}

variable "system_user_name" {
  type    = "string"
  default = "chefuser"
}

variable "system_user_pass" {
  type    = "string"
  default = "P@55w0rd1"
}

variable "system_user_public_ssh_key" {
  type    = "string"
  default = ""
}

variable "system_user_private_ssh_key" {
  type    = "string"
  default = ""
}

variable "data_script" {
  type    = "string"
  default = "/usr/bin/automate.sh"
}

variable "chef_automate_channel" {
  type    = "string"
  default = "current"
}

variable "chef_bootstrap_product" {
  type    = "string"
  default = "chef-workstation"
}

variable "chef_bootstrap_version" {
  type    = "string"
  default = "0.3.2"
}

variable "chef_automate_version" {
  type    = "string"
  default = "latest"
}

variable "chef_automate_config" {
  default = true
}

variable "chef_automate_accept_license" {
  default = true
}

variable "chef_automate_json_credentials_path" {
  type    = "string"
  default = "/tmp/automate-credentials.json"
}

variable "chef_automate_data_collector_token" {
  type    = "string"
  default = ""
}

variable "chef_automate_hostname" {
  type    = "string"
  default = ""
}

variable "chef_automate_admin_password" {
  type    = "string"
  default = ""
}

variable "instance_count" {
  default = 1
}

variable "associate_public_ip_address" {
  default = true
}

variable "ami" {
  type = "string"
}

variable "instance_type" {
  type    = "string"
  default = "t2.medium"
}

variable "key_name" {
  type = "string"
}

variable "vpc_security_group_ids" {
  type = "list"
}

variable "subnet_id" {
  type = "string"
}

variable "root_disk_size" {
  default = 40
}

variable "tags" {
  default = {}
}

variable "tmp_path" {
  default = "/var/tmp"
}
