output "network_name" {
  value       = module.main.network_name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = module.main.network_self_link
  description = "The URI of the VPC being created"
}

output "subnets_names" {
  value       = module.main.subnets_names
  description = "The names of the subnets being created"
}

output "subnets_ids" {
  value       = module.main.subnets_ips
  description = "The IDs of the subnets being created"
}

output "subnets_self_links" {
  value       = module.main.subnets_self_links
  description = "The self-links of subnets being created"
}

output "subnets_secondary_ranges" {
  value       = module.main.subnets_secondary_ranges
  description = "The secondary ranges associated with these subnets"
}

output "net_tag_internet_egress" {
  description = "Network tags for VMs with internet access."
  value       = var.net_tag_internet_egress
}