locals {

  # Primary subnets for common services
  primary_env_nethub_private_subnets = [
    for subnet in var.private_subnet_ranges : {
      #[prefix]-[resource]-[location]-[description]-[suffix]
      subnet_suffix  = "private-${index(var.private_subnet_ranges , subnet)}"
      subnet_range   = subnet
    }
  ]

  primary_env_nethub_data_subnets = [
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
        subnet_suffix  = "${var.prefix}-sub-${var.default_region}-private-${index(prj.private_subnet_ranges , subnet)}"
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
        subnet_suffix  = "${var.prefix}-sub-${var.default_region}-data-${index(prj.data_subnet_ranges , subnet)}"
        subnet_range   = subnet
        project_name   = prj.project_name
      } if var.environment_code == prj.environment_code
    ]
  ])


  ## Secondary subnets for business projects
  k8s_business_project_2nd_subnets = flatten([
    for prj in var.business_project_subnets : [
      for subnet in prj.private_subnet_k8s_2nd_ranges :
      {
        # All secondary ranges are associated with the first subnet
        #[prefix]-[resource]-[location]-[description]-[suffix]
        subnet_name   = "${ var.prefix }-sub-${var.default_region}-k8s-0"
        range_name    = "${ var.prefix }-subr-${var.default_region}-k8s-0-${index(prj.private_subnet_k8s_2nd_ranges , subnet)}"
        ip_cidr_range = subnet
      }if var.environment_code == prj.environment_code
    ]
  ])

  secondary_business_project_subnets = concat(local.k8s_business_project_2nd_subnets)

}
/******************************************
 Env Network hub shared VPC
*****************************************/

module "env_nethub" {
  source                        = "../gcp_network"

  project_id                    = var.project_id
  environment_code              = var.environment_code
  prefix                        = var.prefix
  default_region                = var.default_region
  org_nethub_vpc_self_link      = var.infra_nethub_vpc_self_link
  org_nethub_project_id         = var.infra_nethub_project_id
  domain                        = "${var.domain}."
  bgp_asn_subnet                = "64514"
  windows_activation_enabled    = false
  dns_enable_inbound_forwarding = false
  dns_enable_logging            = false
  firewall_enable_logging       = false
  optional_fw_rules_enabled     = false
  nat_enabled                   = false
  network_name                  = var.network_name

  mode = "spoke"

  public_subnets              = []
  private_subnets             = concat(local.primary_env_nethub_private_subnets, local.primary_business_project_private_subnets)
  data_subnets                = concat(local.primary_env_nethub_data_subnets, local.primary_business_project_data_subnets)
  reserved_subnets            = var.reserved_subnets
  secondary_ranges            = {
    for subnet_name in distinct(local.secondary_business_project_subnets.*.subnet_name) :
    subnet_name =>
    [for s_range in local.secondary_business_project_subnets : s_range if s_range.subnet_name == subnet_name]
  }

  allow_egress_ranges           = var.trusted_egress_ranges
  allow_ingress_ranges          = var.trusted_ingress_ranges
  internal_trusted_cidr_ranges  = var.trusted_private_ranges
}