locals {

  # Primary subnets for common services
  primary_env_nethub_private_subnets = [
    for subnet in var.private_subnet_ranges : {
      subnet_name           = "${ var.environment_code }-${var.project_name}-private-${index(var.private_subnet_ranges , subnet)}-${var.default_region}"
      subnet_ip             = subnet
      project_name          = var.project_name
    }
  ]

  primary_env_nethub_data_subnets = [
    for subnet in var.data_subnet_ranges : {
      subnet_name           = "${ var.environment_code }-${var.project_name}-data-${index(var.data_subnet_ranges , subnet)}-${var.default_region}"
      subnet_ip             = subnet
      project_name          = var.project_name
    }
  ]

  primary_env_nethub_private_svc_connect_subnets            = [
    for subnet_range in var.private_svc_connect_ranges : {
      subnet_name           = "${ var.environment_code }-${var.project_name}-svcconnect-${index(var.private_svc_connect_ranges,subnet_range )}-${var.default_region}"
      subnet_ip             = subnet_range
      project_name          = var.project_name
    }
  ]


  ## Primary subnets for business projects
  primary_business_project_private_subnets = flatten([
        for prj in var.business_project_subnets : [
          for subnet in prj.private_subnet_ranges:
          {
            subnet_name           = "${ prj.environment_code }-${ prj.project_name }-private-${index(prj.private_subnet_ranges , subnet)}-${var.default_region}"
            subnet_ip             = subnet
            project_name          = prj.project_name
          } if var.environment_code == prj.environment_code
        ]
      ])
  primary_business_project_data_subnets = flatten([
        for prj in var.business_project_subnets : [
          for subnet in prj.data_subnet_ranges:
          {
            subnet_name           = "${ prj.environment_code }-${ prj.project_name }-data-${index(prj.data_subnet_ranges , subnet)}-${var.default_region}"
            subnet_ip             = subnet
            project_name          = prj.project_name
          } if var.environment_code == prj.environment_code
        ]
      ])


  ## Secondary subnets for business projects
  k8s_business_project_2nd_subnets = flatten([
      for prj in var.business_project_subnets : [
        for subnet in prj.private_subnet_k8s_2nd_ranges:
        {
          # All secondary ranges are associated with the first subnet
          subnet_name           = "${ prj.environment_code }-${ prj.project_name }-k8s-0-${var.default_region}"
          range_name            = "${ prj.environment_code }-${ prj.project_name }-k8s-0-${var.default_region}-${index(prj.private_subnet_k8s_2nd_ranges , subnet)}"
          ip_cidr_range         = subnet
        }if var.environment_code == prj.environment_code
      ]
      ])

  secondary_business_project_subnets = concat(local.k8s_business_project_2nd_subnets)

}
/******************************************
 Env Network hub shared VPC
*****************************************/

module "env_nethub" {
  source                        = "../shared/gcp_network"
  project_id                    = var.project_id
  environment_code              = var.environment_code
  org_id                        = var.org_id
  default_region                = var.default_region
  org_nethub_vpc_self_link      = var.org_nethub_vpc_self_link
  org_nethub_project_id         = var.org_nethub_project_id
  domain                        = "${var.domain}."
  bgp_asn_subnet                = "64514"
  windows_activation_enabled    = false
  dns_enable_inbound_forwarding = false
  dns_enable_logging            = false
  firewall_enable_logging       = false
  optional_fw_rules_enabled     = false
  nat_enabled                   = false

  mode                          = "spoke"

  public_subnets                = []
  private_subnets               = concat(local.primary_env_nethub_private_subnets,local.primary_business_project_private_subnets)
  data_subnets                  = concat(local.primary_env_nethub_data_subnets,local.primary_business_project_data_subnets)
  private_svc_connect_subnets   = local.primary_env_nethub_private_svc_connect_subnets
  secondary_ranges = {
    for subnet_name in distinct(local.secondary_business_project_subnets.*.subnet_name) :
          subnet_name => [ for s_range in local.secondary_business_project_subnets : s_range if s_range.subnet_name == subnet_name ]
  }

  # FIXME Security issue
  allow_all_egress_ranges       = ["0.0.0.0/0"]
  allow_all_ingress_ranges      = ["0.0.0.0/0"]
}