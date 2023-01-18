locals {
  nethub_project_id = try(data.google_projects.org_nethub.projects[0].project_id, null)
  org_public_subnets            = [
    for subnet in var.orga_nethub_subnets.public_subnet_ranges : {
      subnet_name           = "org-network-hub-public-${index(var.orga_nethub_subnets.public_subnet_ranges,subnet )}-${var.default_region1}"
      subnet_ip             = subnet
      subnet_region         = var.default_region1
      subnet_private_access = "false"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "prod/org-network-hub/${var.default_region1}"
    }
  ]

  org_private_subnets            = [
    for subnet in var.orga_nethub_subnets.private_subnet_ranges : {
      subnet_name           = "org-network-hub-private-${index(var.orga_nethub_subnets.private_subnet_ranges,subnet )}-${var.default_region1}"
      subnet_ip             = subnet
      subnet_region         = var.default_region1
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "prod/org-network-hub/${var.default_region1}"
    }
  ]
  org_data_subnets            = [
    for subnet in var.orga_nethub_subnets.data_subnet_ranges : {
      subnet_name           = "org-network-hub-data-${index(var.orga_nethub_subnets.data_subnet_ranges,subnet )}-${var.default_region1}"
      subnet_ip             = subnet
      subnet_region         = var.default_region1
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "prod/org-network-hub/${var.default_region1}"
    }
  ]

  org_subnets = concat(local.org_public_subnets,local.org_private_subnets,local.org_data_subnets)
}

/******************************************
  Base Network VPC
*****************************************/

module "nethub" {
  source = "../shared/gcp_network_hub"

  project_id                    = local.nethub_project_id
  environment_code              = "prod"
  org_id                        = var.organization_id
  bgp_asn_subnet                = var.enable_partner_interconnect ? "16550" : "64514"
  default_region1               = var.default_region1
  domain                        = var.domain
  windows_activation_enabled    = var.enable_orga_nethub_windows_activation
  dns_enable_inbound_forwarding = var.enable_orga_nethub_dns_inbound_forwarding
  dns_enable_logging            = var.enable_orga_nethub_dns_logging
  firewall_enable_logging       = var.enable_orga_nethub_firewall_logging
  optional_fw_rules_enabled     = var.enable_orga_nethub_optional_fw_rules
  allow_all_egress_ranges       = ["0.0.0.0/0"]
  allow_all_ingress_ranges      = ["0.0.0.0/0"]
  nat_enabled                   = var.enable_orga_nethub_nat
  nat_bgp_asn                   = var.orga_nethub_nat_bgp_asn
  nat_num_addresses_region1     = var.orga_nethub_nat_num_addresses_region1
  mode                          = "hub"

  subnets          = local.org_subnets
  secondary_ranges = {}
}