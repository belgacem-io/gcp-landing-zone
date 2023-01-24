locals {

  # Primary subnets for common services
  primary_env_nethub_private_subnets = [
    for subnet in var.env_nethub_private_subnet_ranges : {
      subnet_name           = "${ var.environment_code }-${var.env_nethub_project_name}-private-${index(var.env_nethub_private_subnet_ranges , subnet)}-${var.default_region1}"
      subnet_ip             = subnet
      project_name          = var.env_nethub_project_name
    }
  ]

  primary_env_nethub_data_subnets = [
    for subnet in var.env_nethub_data_subnet_ranges : {
      subnet_name           = "${ var.environment_code }-${var.env_nethub_project_name}-data-${index(var.env_nethub_data_subnet_ranges , subnet)}-${var.default_region1}"
      subnet_ip             = subnet
      project_name          = var.env_nethub_project_name
    }
  ]


  ## Primary subnets for business projects
  primary_business_project_private_subnets = flatten([
        for prj in var.business_project_subnets : [
          for subnet in prj.private_subnet_ranges:
          {
            subnet_name           = "${ prj.environment_code }-${ prj.project_name }-private-${index(prj.private_subnet_ranges , subnet)}-${var.default_region1}"
            subnet_ip             = subnet
            project_name          = prj.project_name
          } if var.environment_code == prj.environment_code
        ]
      ])
  primary_business_project_data_subnets = flatten([
        for prj in var.business_project_subnets : [
          for subnet in prj.data_subnet_ranges:
          {
            subnet_name           = "${ prj.environment_code }-${ prj.project_name }-data-${index(prj.data_subnet_ranges , subnet)}-${var.default_region1}"
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
          subnet_name           = "${ prj.environment_code }-${ prj.project_name }-k8s-0-${var.default_region1}"
          range_name            = "${ prj.environment_code }-${ prj.project_name }-k8s-0-${var.default_region1}-${index(prj.private_subnet_k8s_2nd_ranges , subnet)}"
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
  project_id                    = var.env_nethub_project_id
  environment_code              = var.environment_code
  org_id                        = var.org_id
  default_region1               = var.default_region1
  domain                        = "${var.domain}."
  bgp_asn_subnet                = "64514"
  windows_activation_enabled    = false
  dns_enable_inbound_forwarding = false
  dns_enable_logging            = false
  firewall_enable_logging       = false
  optional_fw_rules_enabled     = false
  nat_enabled                   = false

  mode                          = "hub"

  public_subnets                = []
  private_subnets               = concat(local.primary_env_nethub_private_subnets,local.primary_business_project_private_subnets)
  data_subnets                  = concat(local.primary_env_nethub_data_subnets,local.primary_business_project_data_subnets)
  private_service_connect_ip    = var.env_nethub_private_svc_connect_ip

  secondary_ranges = {
    for subnet_name in distinct(local.secondary_business_project_subnets.*.subnet_name) :
          subnet_name => [ for s_range in local.secondary_business_project_subnets : s_range if s_range.subnet_name == subnet_name ]
  }

  # FIXME Security issue
  allow_all_egress_ranges       = ["0.0.0.0/0"]
  allow_all_ingress_ranges      = ["0.0.0.0/0"]
}

/***************************************************************
  Configure Service Networking for Cloud SQL & future services.
 **************************************************************/

resource "google_compute_global_address" "private_service_access_address" {
  for_each = toset(var.env_nethub_private_svc_subnet_ranges)

  name          = "${var.org_nethub_vpc_name}-private-access"
  project       = var.env_nethub_project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = element(split("/", each.value), 0)
  prefix_length = element(split("/", each.value), 1)
  network       = module.env_nethub.network_self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  for_each = toset(var.env_nethub_private_svc_subnet_ranges)

  network                 = module.env_nethub.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access_address[each.key].name]

}