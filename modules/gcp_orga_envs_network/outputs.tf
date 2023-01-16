output "vpc_name" {
  value = module.env_network_hub.network_name
}

output "vpc_subnetwork_self_links" {
  value = module.env_network_hub.subnets_self_links
}

output "vpc_network_self_links" {
  value = module.env_network_hub.network_self_link
}
output "vpc_common_services_subnetwork_self_links" {
  value = flatten(concat([ for self_link in module.env_network_hub.subnets_self_links:
    self_link if length(regexall(".*/${var.environment_code}-common-services-[0-9]+-${var.default_region1}", self_link)) > 0
    ]
    ,[ for self_link in module.env_network_hub.subnets_self_links:
    self_link if length(regexall(".*/${var.environment_code}-common-services-[0-9]+-${var.default_region2}", self_link)) > 0
    ]))
}

output "vpc_common_services_subnetwork_self_links_by_region" {
  value = {
    (var.default_region1) = [ for self_link in module.env_network_hub.subnets_self_links:
          self_link if length(regexall(".*/${var.environment_code}-common-services-[0-9]+-${var.default_region1}", self_link)) > 0
    ]
    (var.default_region2) = [ for self_link in module.env_network_hub.subnets_self_links:
    self_link if length(regexall(".*/${var.environment_code}-common-services-[0-9]+-${var.default_region2}", self_link)) > 0
    ]
  }
}