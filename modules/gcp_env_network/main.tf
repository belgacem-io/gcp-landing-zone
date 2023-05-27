locals {

  # Primary subnets for common services
  primary_netenv_private_subnets = [
    for subnet in var.private_subnet_ranges : {
      #[prefix]-[resource]-[location]-[description]-[suffix]
      subnet_suffix  = "private-${index(var.private_subnet_ranges , subnet)}"
      subnet_range   = subnet
    }
  ]

  primary_netenv_data_subnets = [
    for subnet in var.data_subnet_ranges : {
      #[prefix]-[resource]-[location]-[description]-[suffix]
      subnet_suffix  = "data-${index(var.data_subnet_ranges , subnet)}"
      subnet_range   = subnet
    }
  ]

  ## Primary subnets for business projects
  primary_business_project_private_subnets = flatten([
    for prj in var.business_project_subnets : [
      for subnet in prj.private_subnet_ranges :
      {
        #[prefix]-[resource]-[location]-[description]-[suffix]
        subnet_suffix  = "private-${prj.project_name}-${index(prj.private_subnet_ranges , subnet)}"
        subnet_range   = subnet
        project_name   = prj.project_name
      } if var.environment_code == prj.environment_code
    ]
  ])
  primary_business_project_data_subnets = flatten([
    for prj in var.business_project_subnets : [
      for subnet in prj.data_subnet_ranges :
      {
        #[prefix]-[resource]-[location]-[description]-[suffix]
        subnet_suffix  = "data-${prj.project_name}-${index(prj.data_subnet_ranges , subnet)}"
        subnet_range   = subnet
        project_name   = prj.project_name
      } if var.environment_code == prj.environment_code
    ]
  ])

}
/******************************************
 Env Network hub shared VPC
*****************************************/

module "netenv" {
  source                        = "../gcp_network"

  project_id                    = var.project_id
  environment_code              = var.environment_code
  prefix                        = var.prefix
  default_region                = var.default_region
  infra_nethub_network_self_link    = var.infra_nethub_network_self_link
  infra_nethub_project_id       = var.infra_nethub_project_id
  domain                        = "${var.domain}."
  bgp_asn_subnet                = "64514"
  enable_optional_fw_rules      = false
  nat_enabled                   = false
  network_name                  = var.network_name

  mode = "spoke"

  public_subnets              = []
  private_subnets             = concat(local.primary_netenv_private_subnets, local.primary_business_project_private_subnets)
  data_subnets                = concat(local.primary_netenv_data_subnets, local.primary_business_project_data_subnets)
  reserved_subnets            = var.reserved_subnets
  secondary_ranges            = {}

  allow_egress_ranges           = var.trusted_egress_ranges
  allow_ingress_ranges          = var.trusted_ingress_ranges
  internal_trusted_cidr_ranges  = var.trusted_private_ranges
}