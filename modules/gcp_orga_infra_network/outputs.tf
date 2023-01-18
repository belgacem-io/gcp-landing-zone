output "org_nethub_vpc_name" {
  value = module.nethub.network_name
}

output "org_nethub_private_subnets_names" {
  value = [for subnet in module.nethub.subnets_names : subnet if length(regexall(".*private.*", subnet)) > 0 ]
}