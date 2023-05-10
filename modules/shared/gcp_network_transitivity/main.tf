/******************************************
  Internet Transit Gateway Proxy.
 *****************************************/
module "transparent_squid" {
  source = "../squid_proxy"

  count = var.enable_internet_gateway ? 1 : 0

  environment_code                = var.environment_code
  project_id                      = var.project_id
  default_region                  = var.default_region
  prefix                          = var.prefix
  source_trusted_cidr_ranges      = var.internal_trusted_cidr_ranges
  subnetwork_name                 = var.subnetwork_name
  network_name                    = var.network_name
  private_ca                      = var.org_private_ca
}

/******************************************
  VPC Transit Gateway.
 *****************************************/
module "vpc_tgw" {
  source = "../linux_tgw"

  count = var.enable_inter_vpc_gateway ? 1 : 0

  environment_code                = var.environment_code
  project_id                      = var.project_id
  default_region                  = var.default_region
  prefix                          = var.prefix
  source_trusted_cidr_ranges      = var.internal_trusted_cidr_ranges
  destination_trusted_cidr_ranges = var.internal_trusted_cidr_ranges
  subnetwork_name                 = var.subnetwork_name
  network_name                    = var.network_name
}

/******************************************
  Transitivity Routes
 *****************************************/

resource "google_compute_route" "inter_vpc_routes" {
  for_each = var.enable_inter_vpc_gateway ? toset(var.internal_trusted_cidr_ranges) : toset([])

  project      = var.project_id
  network      = var.network_name
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name         = "${var.prefix}-rt-glb-tgw-for-${replace(replace(each.value, "/", "-"), ".", "-")}"
  description  = "Inter VPCs route through TGW for range ${each.value}"
  dest_range   = each.value
  next_hop_ilb = module.vpc_tgw.0.ilb_id
}

resource "google_compute_route" "internet_route" {
  count = var.enable_internet_gateway ? 1 : 0

  project      = var.project_id
  network      = var.network_name
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name         = "${var.prefix}-rt-glb-squid-internet"
  description  = "Internet route through Squid Gateway"
  dest_range   = "0.0.0.0/0"
  next_hop_ilb = module.transparent_squid.0.ilb_id
}