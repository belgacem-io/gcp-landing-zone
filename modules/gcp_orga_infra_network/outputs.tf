output "org_network_hub_vpc_name" {
  value = module.network_hub.network_name
}

output "org_network_hub_private_subnets_names" {
  value = [for subnet in module.network_hub.subnets_names : subnet if length(regexall(".*private.*", subnet)) > 0 ]
}