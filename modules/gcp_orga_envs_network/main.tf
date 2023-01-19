locals {

  bgp_asn_number                          = var.enable_partner_interconnect ? "16550" : "64514"

  # Primary subnets for common services
  primary_env_net_hub_private_subnets = [
    for subnet in var.env_net_hub_private_subnet_ranges : {
      subnet_name           = "${ var.environment_code }-${var.env_nethub_project_name}-private-${index(var.env_net_hub_private_subnet_ranges , subnet)}-${var.default_region1}"
      subnet_ip             = subnet
      subnet_region         = var.default_region1
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "${ var.environment_code }/${var.env_nethub_project_name}/${var.default_region1}"
    }
  ]

  primary_env_net_hub_data_subnets = [
    for subnet in var.env_net_hub_data_subnet_ranges : {
      subnet_name           = "${ var.environment_code }-${var.env_nethub_project_name}-data-${index(var.env_net_hub_data_subnet_ranges , subnet)}-${var.default_region1}"
      subnet_ip             = subnet
      subnet_region         = var.default_region1
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "${ var.environment_code }/${var.env_nethub_project_name}/${var.default_region1}"
    }
  ]

  primary_env_net_hub_subnets = concat(local.primary_env_net_hub_private_subnets,local.primary_env_net_hub_data_subnets)

  ## Primary subnets for business projects
  primary_business_project_private_subnets = flatten([
        for prj in var.business_project_subnets : [
          for subnet in prj.private_subnet_ranges:
          {
            subnet_name           = "${ prj.environment_code }-${ prj.project_name }-private-${index(prj.private_subnet_ranges , subnet)}-${var.default_region1}"
            subnet_ip             = subnet
            subnet_region         = var.default_region1
            subnet_private_access = "true"
            subnet_flow_logs      = var.subnetworks_enable_logging
            description           = "${ prj.environment_code }/${ prj.project_name }/${var.default_region1}"
          } if var.environment_code == prj.environment_code
        ]
      ])
  primary_business_project_data_subnets = flatten([
        for prj in var.business_project_subnets : [
          for subnet in prj.data_subnet_ranges:
          {
            subnet_name           = "${ prj.environment_code }-${ prj.project_name }-data-${index(prj.data_subnet_ranges , subnet)}-${var.default_region1}"
            subnet_ip             = subnet
            subnet_region         = var.default_region1
            subnet_private_access = "true"
            subnet_flow_logs      = var.subnetworks_enable_logging
            description           = "${ prj.environment_code }/${ prj.project_name }/${var.default_region1}"
          } if var.environment_code == prj.environment_code
        ]
      ])
  primary_business_project_subnets = concat(local.primary_business_project_private_subnets,local.primary_business_project_data_subnets)


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
  source                        = "../shared/gcp_network_hub"
  project_id                    = var.env_net_hub_project_id
  environment_code              = var.environment_code
  org_id                        = var.org_id
  default_region1               = var.default_region1
  domain                        = "${var.domain}."
  bgp_asn_subnet                = local.bgp_asn_number
  windows_activation_enabled    = var.windows_activation_enabled
  dns_enable_inbound_forwarding = var.dns_enable_inbound_forwarding
  dns_enable_logging            = var.dns_enable_logging
  firewall_enable_logging       = var.firewall_enable_logging
  optional_fw_rules_enabled     = var.optional_fw_rules_enabled
  nat_enabled                   = var.nat_enabled
  nat_bgp_asn                   = var.nat_bgp_asn
  nat_num_addresses_region1     = var.nat_num_addresses_region1
  nat_num_addresses             = var.nat_num_addresses
  mode                          = "hub"

  subnets                  = concat(local.primary_business_project_subnets,local.primary_env_net_hub_subnets)

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
  for_each = toset(var.env_net_hub_private_svc_subnet_ranges)

  name          = "${var.org_nethub_vpc_name}-private-access"
  project       = var.env_net_hub_project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = element(split("/", each.value), 0)
  prefix_length = element(split("/", each.value), 1)
  network       = module.env_nethub.network_self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  for_each = toset(var.env_net_hub_private_svc_subnet_ranges)

  network                 = module.env_nethub.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access_address[each.key].name]

}