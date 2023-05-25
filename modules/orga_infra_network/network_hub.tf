locals {
  nethub_project_id  = try(data.google_projects.org_nethub.projects[0].project_id, null)
}

/******************************************
  Base Network VPC
*****************************************/

module "nethub" {
  source = "../gcp_network"

  project_id                    = local.nethub_project_id
  environment_code              = "prod"
  prefix                        = var.prefix
  bgp_asn_subnet                = var.enable_partner_interconnect ? "16550" : "64514"
  default_region                = var.default_region
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

  public_subnets              = var.public_subnet_ranges
  private_subnets             = var.private_subnet_ranges
  data_subnets                = var.data_subnet_ranges
  reserved_subnets            = var.reserved_subnets
  private_svc_connect_ip      = var.private_svc_connect_ip

  secondary_ranges = {}

  allow_egress_ranges           = var.trusted_egress_ranges
  allow_ingress_ranges          = var.trusted_ingress_ranges
  internal_trusted_cidr_ranges  = var.trusted_private_ranges
}