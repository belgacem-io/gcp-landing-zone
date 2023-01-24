/*
 * Hub & Spoke Peering Transitivity with Gateway VMs
 */
module "transitivity_gateway" {
  source = "../squid_proxy"

  count = var.mode == "hub" ? 1 :  0

  environment_code             = var.environment_code
  project_id                   = var.project_id
  default_region1              = var.default_region1
  internal_trusted_cidr_ranges = var.internal_trusted_cidr_ranges
  name                         = "transit-gwt"
  subnet_name                  = var.subnet_name
  vpc_name                     = var.vpc_name
  network_internet_egress_tag  = "egress-internet"
}