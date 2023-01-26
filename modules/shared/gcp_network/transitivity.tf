data "google_compute_subnetwork" "private_svc_connect_subnet" {

  for_each = var.mode == "hub" ? toset(var.private_svc_connect_subnets.*.subnet_name) : toset([])

  name      = each.value
  project   = var.project_id
  region    = var.default_region

  depends_on = [
    module.main
  ]
}

/******************************************
  Squid Proxy.
 *****************************************/
module "transitivity_gateway" {
  source = "../squid_proxy"

  count = var.mode == "hub" ? 1 :  0

  environment_code             = var.environment_code
  project_id                   = var.project_id
  default_region               = var.default_region
  internal_trusted_cidr_ranges = var.internal_trusted_cidr_ranges
  name                         = "${var.environment_code}-transit-gwt"
  subnet_name                  = var.private_subnets[0].subnet_name
  vpc_name                     = module.main.network_name
  network_internet_egress_tag  = "egress-internet"
}
/******************************************
  Private Google APIs DNS Zone & records.
 *****************************************/
module "private_service_connect" {
  source                     = "terraform-google-modules/network/google//modules/private-service-connect"
  version                                = "~> 5.2"

  count   = var.mode == "hub" && var.private_svc_connect_ip !=null ? 1 : 0

  forwarding_rule_name         = "privategoogleapi"
  private_service_connect_name = "${var.environment_code}-gip-psconnect"
  project_id                   = var.project_id
  network_self_link            = module.main.network_self_link
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
  nat_subnets              = [for subnet in data.google_compute_subnetwork.private_svc_connect_subnet : subnet.id]
  target_service           = module.transitivity_gateway.0.ilb_id
}