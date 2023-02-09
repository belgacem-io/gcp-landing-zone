output "vpc_name" {
  value = module.nethub.network_name
}

output "public_subnets_names" {
  value = [for subnet in module.nethub.subnets_names : subnet if length(regexall(".*public.*", subnet)) > 0 ]
}

output "private_subnets_names" {
  value = [for subnet in module.nethub.subnets_names : subnet if length(regexall(".*private.*", subnet)) > 0 ]
}

output "data_subnets_names" {
  value = [for subnet in module.nethub.subnets_names : subnet if length(regexall(".*data.*", subnet)) > 0 ]
}

output "vpc_subnetwork_self_links" {
  value = module.nethub.subnets_self_links
}

output "vpc_network_self_links" {
  value = module.nethub.network_self_link
}