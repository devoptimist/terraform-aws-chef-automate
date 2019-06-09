output "automate_ip" {
  value = module.chef_automate.public_ip[0]
}

output "automate_ssh_user" {
  value = var.system_user_name
}

output "automate_ssh_pass" {
  value = var.system_user_pass
}

output "automate_admin_user" {
  value = data.external.a2_secrets.result["username"]
}

output "automate_admin_password" {
  value = data.external.a2_secrets.result["password"]
}

output "automate_token" {
  value = data.external.a2_secrets.result["token"]
}

output "automate_url" {
  value = data.external.a2_secrets.result["url"]
}
