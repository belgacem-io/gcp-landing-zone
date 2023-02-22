/******************************************
  Default DNS Policy
 *****************************************/

resource "google_dns_policy" "default_policy" {
  count = var.mode == "hub" ? 1 : 0

  project                   = var.project_id
  #[prefix]-[project]-[env]-[resource]-[location]-[description]-[suffix]
  name                      = "${var.prefix}-dp-glb-dns-hub-default-policy"
  enable_inbound_forwarding = var.dns_enable_inbound_forwarding
  enable_logging            = var.dns_enable_logging
  networks {
    network_url = module.main.network_self_link
  }
}

/******************************************
 DNS Outbound Forwarding
*****************************************/

module "dns-forwarding-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 4.2"

  count = ( var.mode == "hub" && var.dns_enable_outbound_forwarding ) ? 1 : 0

  project_id = var.project_id
  type       = "forwarding"
  #[prefix]-[project]-[env]-[resource]-[location]-[description]-[suffix]
  name       = "${var.prefix}-fz-glb-dns-hub"
  domain     = var.domain

  private_visibility_config_networks = [
    module.main.network_self_link
  ]
  target_name_server_addresses = var.dns_outbound_server_addresses
}