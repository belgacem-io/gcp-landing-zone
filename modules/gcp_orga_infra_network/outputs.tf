output "vpc_name" {
  value = module.nethub.network_name
}

output "private_subnets_names" {
  value = [for subnet in module.nethub.subnets_names : subnet if length(regexall(".*private.*", subnet)) > 0 ]
}

output "vpc_subnetwork_self_links" {
  value = module.nethub.subnets_self_links
}

output "vpc_network_self_links" {
  value = module.nethub.network_self_link
}

output "vpc_svc_private_subnetwork_self_links" {
  value = flatten([ for self_link in module.nethub.subnets_self_links:
    self_link if length(regexall(".*/${var.nethub_project_name}-[0-9]+-${var.default_region1}", self_link)) > 0
  ])
}

output "vpc_svc_data_subnetwork_self_links" {
  value = flatten([ for self_link in module.nethub.subnets_self_links:
    self_link if length(regexall(".*/${var.nethub_project_name}-[0-9]+-${var.default_region1}", self_link)) > 0
  ])
}

output "network_internet_egress_tag" {
  value       = module.nethub.network_internet_egress_tag
  description = "Network tags for VMs with internet access."
}