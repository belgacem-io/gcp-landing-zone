/******************************************
  VPC Transit Gateway.
 *****************************************/
module "vpc_tgw" {
  source = "../gcp_linux_tgw"

  environment_code                = var.environment_code
  project_id                      = var.project_id
  default_region                  = var.default_region
  prefix                          = var.prefix
  source_trusted_cidr_ranges      = var.internal_trusted_cidr_ranges
  destination_trusted_cidr_ranges = var.internal_trusted_cidr_ranges
  subnetwork_name                 = local.private_subnets[0].subnet_name
  network_name                    = var.network_name

  depends_on = [
    module.main
  ]
}

/******************************************
  Transitivity Routes
 *****************************************/

resource "google_compute_route" "inter_vpc_routes" {
  for_each = toset(var.internal_trusted_cidr_ranges)

  project      = var.project_id
  network      = var.network_name
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name         = "${var.prefix}-rt-glb-tgw-for-${replace(replace(each.value, "/", "-"), ".", "-")}"
  description  = "Inter VPCs route through TGW for range ${each.value}"
  dest_range   = each.value
  next_hop_ilb = module.vpc_tgw.0.ilb_id

  depends_on = [
    module.vpc_tgw
  ]
}