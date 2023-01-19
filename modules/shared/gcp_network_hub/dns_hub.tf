/******************************************
  Default DNS Policy
 *****************************************/

resource "google_dns_policy" "default_policy" {
  count   = var.mode == "hub" ? 1 : 0

  project                   = var.project_id
  name                      = "dp-dns-hub-default-policy"
  enable_inbound_forwarding = true
  enable_logging            = var.dns_enable_logging
  networks {
    network_url = module.main.network_self_link
  }
}

/******************************************
 DNS Forwarding
*****************************************/

module "dns-forwarding-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 4.2"

  count   = ( var.mode == "hub"  && var.target_name_server_addresses != null ) ? 1 : 0

  project_id = var.project_id
  type       = "forwarding"
  name       = "fz-dns-hub"
  domain     = var.domain

  private_visibility_config_networks = [
    module.main.network_self_link
  ]
  target_name_server_addresses = var.target_name_server_addresses
}

/*********************************************************
  Routers to advertise DNS proxy range "35.199.192.0/19"
*********************************************************/

module "dns_hub_region1_router1" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 4.0"

  count   = var.mode == "hub" ? 1 : 0

  name    = "cr-c-dns-hub-${var.default_region1}-cr1"
  project = var.project_id
  network = module.main.network_name
  region  = var.default_region1
  bgp = {
    asn                  = var.bgp_asn_dns
    advertised_ip_ranges = [{ range = "35.199.192.0/19" }]
  }
}

module "dns_hub_region1_router2" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 4.0"

  count   = var.mode == "hub" ? 1 : 0

  name    = "cr-c-dns-hub-${var.default_region1}-cr2"
  project = var.project_id
  network = module.main.network_name
  region  = var.default_region1
  bgp = {
    asn                  = var.bgp_asn_dns
    advertised_ip_ranges = [{ range = "35.199.192.0/19" }]
  }
}