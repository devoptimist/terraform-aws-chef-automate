locals {
  ui = [
    for i in module.automate_base.public_ip :
      "https://${i}"
  ]
  connection_string = [
    for i in module.automate_base.public_ip :
      "ssh -i ${var.automate_ssh_user_private_key} ${module.automate_base.ssh_user}@${i}"
  ]
}
output "ssh_command" {
  value = local.connection_string
}

output "ingest_token" {
  value = module.automate_install.token
}

output "UI" {
  value = local.ui
}
