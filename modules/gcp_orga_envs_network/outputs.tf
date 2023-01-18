output "vpc_name" {
  value = module.env_nethub.network_name
}

output "vpc_subnetwork_self_links" {
  value = module.env_nethub.subnets_self_links
}

output "vpc_network_self_links" {
  value = module.env_nethub.network_self_link
}

output "vpc_svc_private_subnetwork_self_links" {
  value = flatten([ for self_link in module.env_nethub.subnets_self_links:
    self_link if length(regexall(".*/${var.environment_code}-svc-private-[0-9]+-${var.default_region1}", self_link)) > 0
    ])
}

output "vpc_svc_data_subnetwork_self_links" {
  value = flatten([ for self_link in module.env_nethub.subnets_self_links:
    self_link if length(regexall(".*/${var.environment_code}-svc-data-[0-9]+-${var.default_region1}", self_link)) > 0
  ])
}