/******************************************
  Squid Proxy.
 *****************************************/
module "transitivity_gateway" {
  source = "../squid_proxy"

  count = var.mode == "hub" ? 1 :  0

  environment_code             = var.environment_code
  project_id                   = var.project_id
  default_region              = var.default_region
  internal_trusted_cidr_ranges = var.internal_trusted_cidr_ranges
  name                         = "${var.environment_code}-transit-gwt"
  subnet_name                  = var.subnet_name
  vpc_name                     = var.network_name
  network_internet_egress_tag  = "egress-internet"
}
/******************************************
  Private Google APIs DNS Zone & records.
 *****************************************/
module "private_service_connect" {
  source                     = "terraform-google-modules/network/google//modules/private-service-connect"
  version                                = "~> 5.2"

  count   = var.mode == "hub" ? 1 : 0

  forwarding_rule_name         = "privategoogleapi"
  private_service_connect_name = "${var.environment_code}-gip-psconnect"
  project_id                   = var.project_id
  network_self_link            = var.network_self_link
  private_service_connect_ip   = var.private_svc_connect_ip
  forwarding_rule_target       = "all-apis"
}

/*
 * Service connect
 */

resource "google_compute_service_attachment" "svc_attachment" {
  count = var.mode == "hub" ? 1 :  0

  name        = "${var.environment_code}-transit-gwt"
  region      = var.default_region
  project     = var.project_id
  description = "Transit gateway service attachment"

  enable_proxy_protocol    = false
  connection_preference    = "ACCEPT_AUTOMATIC"
  nat_subnets              = var.private_svc_connect_subnets_ids
  target_service           = module.transitivity_gateway.0.ilb_id
}