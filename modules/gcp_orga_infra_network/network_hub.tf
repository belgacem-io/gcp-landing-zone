locals {
  nethub_project_id = try(data.google_projects.org_nethub.projects[0].project_id, null)
  org_public_subnets            = [
    for subnet_range in var.public_subnet_ranges : {
      subnet_name           = "org-network-hub-public-${index(var.public_subnet_ranges,subnet_range )}-${var.default_region}"
      subnet_ip             = subnet_range
      project_name          = "org-network-hub"
    }
  ]

  org_private_subnets            = [
    for subnet_range in var.private_subnet_ranges : {
      subnet_name           = "org-network-hub-private-${index(var.private_subnet_ranges,subnet_range )}-${var.default_region}"
      subnet_ip             = subnet_range
      project_name          = "org-network-hub"
    }
  ]

  org_private_svc_connect_subnets            = [
    for subnet_range in var.private_svc_connect_ranges : {
      subnet_name           = "org-network-hub-svcconnect-${index(var.private_svc_connect_ranges,subnet_range )}-${var.default_region}"
      subnet_ip             = subnet_range
      project_name          = "org-network-hub"
    }
  ]

  org_data_subnets            = [
    for subnet_range in var.data_subnet_ranges : {
      subnet_name           = "org-network-hub-data-${index(var.data_subnet_ranges,subnet_range )}-${var.default_region}"
      subnet_ip             = subnet_range
      project_name          = "org-network-hub"
    }
  ]
}

/******************************************
  Base Network VPC
*****************************************/

module "nethub" {
  source = "../shared/gcp_network"

  project_id                    = local.nethub_project_id
  environment_code              = "prod"
  org_id                        = var.organization_id
  bgp_asn_subnet                = var.enable_partner_interconnect ? "16550" : "64514"
  default_region               = var.default_region
  domain                        = var.domain
  windows_activation_enabled    = var.enable_windows_activation
  dns_enable_inbound_forwarding = var.enable_dns_inbound_forwarding
  dns_enable_logging            = var.enable_dns_logging
  firewall_enable_logging       = var.enable_firewall_logging
  optional_fw_rules_enabled     = var.enable_optional_fw_rules
  nat_enabled                   = var.enable_nat
  nat_bgp_asn                   = var.nat_bgp_asn
  nat_num_addresses_region1     = var.nat_num_addresses_region1
  network_name                  = var.network_name
  mode                          = "hub"

  public_subnets                = local.org_public_subnets
  private_subnets               = local.org_private_subnets
  data_subnets                  = local.org_data_subnets
  private_svc_connect_subnets   = local.org_private_svc_connect_subnets
  private_svc_connect_ip        = var.private_svc_connect_ip

  secondary_ranges = {}

  # FIXME Security issue
  allow_all_egress_ranges       = ["0.0.0.0/0"]
  allow_all_ingress_ranges      = ["0.0.0.0/0"]
}