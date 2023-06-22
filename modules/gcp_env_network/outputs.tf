output "network_name" {
  value = module.netenv.network_name
}

output "subnetwork_self_links" {
  value = module.netenv.subnets_self_links
}

output "network_self_links" {
  value = module.netenv.network_self_link
}