output "automate_ip" {
  value = module.automate_base.public_ip
}

output "ingest_token" {
  value = module.automate_install.token
}
