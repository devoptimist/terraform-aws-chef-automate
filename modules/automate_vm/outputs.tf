output "public_ip_address" {
  value = flatten(module.automate_instance.public_ip)
}

output "vpc_subnets_cidrs" {
  value = flatten(module.automate_vpc.public_subnets_cidr_blocks)
}

output "nat_cidrs" {
  value = flatten(module.automate_vpc.nat_public_ips_sr)
}

output "vpc_cidr" {
  value = module.automate_vpc.vpc_cidr_block
}

output "ingest_token" {
  value = module.automate_populate.ingest_token
}
