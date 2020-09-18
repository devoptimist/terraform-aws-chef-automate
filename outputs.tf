output "automate_ip" {
  value = module.automate_base.public_ip
}

output "ingest_token" {
  value = module.automate_install.token
}

output "public_subnet_ids" {
  description = "A list of public subnet ids associated with this vpc"
  value       = module.automate_base.public_subnet_ids
}

output "sec_grp_ids" {
  description = "A list of security groups associated with this vpc"
  value       = module.automate_base.sec_grp_ids
}

output "vpc_id" {
  description = "A list of security groups associated with this vpc"
  value       = module.automate_base.vpc_id
}
