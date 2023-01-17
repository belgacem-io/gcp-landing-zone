locals {

  parent_id                               = "organizations/${var.org_id}"
  bgp_asn_number                          = var.enable_partner_interconnect ? "16550" : "64514"

  # Primary subnets for common services
  primary_common_services_subnets_region1 = [
    for subnet in var.common_services_subnet_region1_ranges : {
      subnet_name           = "${ var.environment_code }-common-services-${index(var.common_services_subnet_region1_ranges , subnet)}-${var.default_region1}"
      subnet_ip             = subnet
      subnet_region         = var.default_region1
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "${ var.environment_code }/common-services/${var.default_region1}"
    }
  ]

  primary_common_services_subnets_region2 = [
    for subnet in var.common_services_subnet_region2_ranges : {
      subnet_name           = "${ var.environment_code }-common-services-${index(var.common_services_subnet_region2_ranges , subnet)}-${var.default_region2}"
      subnet_ip             = subnet
      subnet_region         = var.default_region2
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "${ var.environment_code }/common-services/${var.default_region2}"
    }
  ]

  primary_common_services_subnets = concat(local.primary_common_services_subnets_region1,local.primary_common_services_subnets_region2)

  ## Primary subnets for business projects
  primary_business_project_subnets_region1 = flatten([
        for prj in var.business_project_subnets : [
          for subnet in prj.private_subnet_ranges:
          {
            subnet_name           = "${ prj.environment_code }-${ prj.project_name }-${index(prj.private_subnet_ranges , subnet)}-${var.default_region1}"
            subnet_ip             = subnet
            subnet_region         = var.default_region1
            subnet_private_access = "true"
            subnet_flow_logs      = var.subnetworks_enable_logging
            description           = "${ prj.environment_code }/${ prj.project_name }/${var.default_region1}"
          }
        ]
      ])
  primary_business_project_subnets_region2 = flatten([
        for prj in var.business_project_subnets : [
          for subnet in prj.data_subnet_ranges:
          {
            subnet_name           = "${ prj.environment_code }-${ prj.project_name }-${index(prj.data_subnet_ranges , subnet)}-${var.default_region2}"
            subnet_ip             = subnet
            subnet_region         = var.default_region2
            subnet_private_access = "true"
            subnet_flow_logs      = var.subnetworks_enable_logging
            description           = "${ prj.environment_code }/${ prj.project_name }/${var.default_region2}"
          }
        ]
      ])
  primary_business_project_subnets = concat(local.primary_business_project_subnets_region1,local.primary_business_project_subnets_region2)


  ## Secondary subnets for business projects
  secondary_business_project_subnets_region1 = flatten([
      for prj in var.business_project_subnets : [
        for subnet in prj.region1_secondary_ranges:
        {
          # All secondary ranges are associated with the first subnet
          subnet_name           = "${ prj.environment_code }-${ prj.project_name }-0-${var.default_region1}"
          range_name            = "${ prj.environment_code }-${ prj.project_name }-0-${var.default_region1}-secondary-${index(prj.region1_secondary_ranges , subnet)}"
          ip_cidr_range         = subnet
        }
      ]
      ])
  secondary_business_project_subnets_region2 = flatten([
      for prj in var.business_project_subnets : [
        for subnet in prj.region2_secondary_ranges:
        {
          # All secondary ranges are associated with the first subnet
          subnet_name           = "${ prj.environment_code }-${ prj.project_name }-0-${var.default_region2}"
          range_name            = "${ prj.environment_code }-${ prj.project_name }-0-${var.default_region2}-secondary-${index(prj.region2_secondary_ranges , subnet)}"
          ip_cidr_range         = subnet
        }
      ]
      ])

  secondary_business_project_subnets = concat(local.secondary_business_project_subnets_region1,local.secondary_business_project_subnets_region2)

}
/******************************************
 Env Network hub shared VPC
*****************************************/

module "env_network_hub" {
  source                        = "../shared/gcp_network_hub"
  project_id                    = var.env_network_hub_project_id
  environment_code              = var.environment_code
  org_id                        = var.org_id
  default_region1               = var.default_region1
  default_region2               = var.default_region2
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
  nat_num_addresses_region2     = var.nat_num_addresses_region2
  nat_num_addresses             = var.nat_num_addresses
  mode                          = "spoke"
  org_network_hub_vpc_name      = var.org_network_hub_vpc_name
  org_network_hub_project_id    = var.org_network_hub_project_id

  subnets                  = concat(local.primary_business_project_subnets,local.primary_common_services_subnets)

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
  count         = var.private_service_cidr != null ? 1 : 0

  name          = "${var.org_network_hub_vpc_name}-private-access"
  project       = var.env_network_hub_project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = element(split("/", var.private_service_cidr), 0)
  prefix_length = element(split("/", var.private_service_cidr), 1)
  network       = module.env_network_hub.network_self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count                   = var.private_service_cidr != null ? 1 : 0
  network                 = module.env_network_hub.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access_address[0].name]

}