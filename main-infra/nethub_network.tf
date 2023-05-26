/******************************************
  Base Network VPC
*****************************************/

module "nethub_network" {
  source = "../modules/gcp_network"

  project_id                    = module.nethub_project.project_id
  environment_code              = "prod"
  prefix                        = "${var.gcp_organization_prefix}-prod"
  bgp_asn_subnet                = var.enable_partner_interconnect ? "16550" : "64514"
  default_region                = var.gcp_default_region
  domain                        = var.gcp_organization_domain
  nat_enabled                   = true
  network_name                  = var.gcp_infra_projects.nethub.network.name
  mode                          = "hub"

  public_subnets = [
    for range in var.gcp_infra_projects.nethub.network.cidr_blocks.public_subnet_ranges : {
      subnet_suffix = "public", subnet_range = range
    }
  ]
  private_subnets = [
    for range in var.gcp_infra_projects.nethub.network.cidr_blocks.private_subnet_ranges :{
      subnet_suffix = "private", subnet_range = range
    }
  ]
  data_subnets = [
    for range in var.gcp_infra_projects.nethub.network.cidr_blocks.data_subnet_ranges : {
      subnet_suffix = "data", subnet_range = range
    }
  ]
  reserved_subnets       = var.gcp_infra_projects.nethub.network.cidr_blocks.reserved_subnets
  private_svc_connect_ip = var.gcp_infra_projects.nethub.network.cidr_blocks.private_svc_connect_ip

  secondary_ranges = {}

  allow_egress_ranges          = var.trusted_egress_ranges
  allow_ingress_ranges         = var.trusted_ingress_ranges
  internal_trusted_cidr_ranges = var.trusted_private_ranges

  depends_on = [
    module.nethub_project
  ]
}