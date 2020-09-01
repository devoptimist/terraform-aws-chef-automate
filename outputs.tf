output "automate_ip" {
  value = module.automate.public_ip_address
}

output "vpc_subnets" {
  value = module.automate.vpc_subnets_cidrs
}

output "vpc_cidr" {
  value = module.automate.vpc_cidr
}

output "nat_cidrs" {
  value = module.automate.nat_cidrs
}
