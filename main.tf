locals {
  bootstrap  = templatefile("${path.module}/templates/bootstrap.sh", {
    create_system_user         = var.create_system_user,
    system_user_name           = var.system_user_name,
    system_user_pass           = var.system_user_pass,
    system_user_public_ssh_key = var.system_user_public_ssh_key
  })
  first_boot = templatefile("${path.module}/templates/first_boot.json", {
    channel              = var.chef_automate_channel,
    version              = var.chef_automate_version,
    config               = var.chef_automate_config,
    accept_license       = var.chef_automate_accept_license,
    creds_json_path      = var.chef_automate_json_credentials_path,
    dc_token             = var.chef_automate_data_collector_token,
    fqdn                 = var.chef_automate_hostname,
    admin_password       = var.chef_automate_admin_password
  })
}

module "chef_automate" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "2.0.0"
  name                        = var.name
  instance_count              = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  monitoring                  = true
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  root_block_device = [{
    volume_type = "gp2"
    volume_size = var.root_disk_size
  }]
  tags                        = var.tags
  user_data                   = local.bootstrap

}

resource "null_resource" "chef_run" {

  connection {
    user        = var.system_user_name
    password    = var.system_user_pass
    host        = module.chef_automate.public_ip[0]
  }

  provisioner "file" {
    source      = "${path.module}/files/Policyfile.rb"
    destination = "${var.tmp_path}/Policyfile.rb"
  }

  provisioner "file" {
    content     = local.first_boot
    destination = "${var.tmp_path}/first-boot.json"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -LO https://www.chef.io/chef/install.sh && sudo bash ./install.sh -P ${var.chef_bootstrap_product} -v ${var.chef_bootstrap_version}",
      "chef install ${var.tmp_path}/Policyfile.rb",
      "chef export ${var.tmp_path}/Policyfile.rb . -a",
      "mv chef_automate_wrapper-*.tgz ${var.tmp_path}/cookbooks.tgz",
      "sudo chef-solo --recipe-url ${var.tmp_path}/cookbooks.tgz -j ${var.tmp_path}/first-boot.json --chef-license accept"
    ]
  }
  depends_on = ["module.chef_automate"]
}

data "external" "a2_secrets" {
  program = ["bash", "${path.module}/files/data_source.sh"]
  depends_on = ["null_resource.chef_run"]

  query = {
    ssh_user        = "${var.system_user_name}"
    ssh_key         = "${var.system_user_private_ssh_key}"
    ssh_pass        = "${var.system_user_pass}"
    automate_ip     = "${module.chef_automate.public_ip[0]}"
    data_script     = "${var.data_script}"
  }
}
