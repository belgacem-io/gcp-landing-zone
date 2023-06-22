/******************************************
  VPC Transit Gateway.
 *****************************************/
module "vpc_tgw" {
  source = "../gcp_linux_tgw"

  count = (var.mode == "hub" && var.enable_transitive_network) ? 1 : 0

  environment_code                = var.environment_code
  project_id                      = var.project_id
  default_region                  = var.default_region
  prefix                          = var.prefix
  source_trusted_cidr_ranges      = var.internal_trusted_cidr_ranges
  destination_trusted_cidr_ranges = var.internal_trusted_cidr_ranges
  subnetwork_name                 = local.private_subnets[0].subnet_name
  network_name                    = local.network_name

  labels = var.labels

  depends_on = [
    module.main
  ]
}

/******************************************
  Transitivity Routes
 *****************************************/

resource "google_compute_route" "inter_vpc_routes" {
  for_each = (var.mode == "hub" && var.enable_transitive_network) ? toset(var.internal_trusted_cidr_ranges) : toset([])

  project      = var.project_id
  network      = local.network_name
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name         = "${var.prefix}-rt-glb-${var.network_name}-tgw-for-${replace(replace(each.value, "/", "-"), ".", "-")}"
  description  = "Inter VPCs route through TGW for range ${each.value}"
  dest_range   = each.value
  next_hop_ilb = module.vpc_tgw.0.gateway_id

  depends_on = [
    module.vpc_tgw
  ]
}

/******************************************
  Secure web proxy.
 *****************************************/
module "secure_web_proxy" {
  source = "../gcp_squid_proxy"

  count = (var.mode == "hub" && var.enable_secure_web_proxy) ? 1 : 0

  environment_code                = var.environment_code
  project_id                      = var.project_id
  default_region                  = var.default_region
  prefix                          = var.prefix
  source_trusted_cidr_ranges      = var.internal_trusted_cidr_ranges
  subnetwork_name                 = local.private_subnets[0].subnet_name
  network_name                    = module.main.network_name

  labels = var.labels

  depends_on = [
    module.main
  ]
}
