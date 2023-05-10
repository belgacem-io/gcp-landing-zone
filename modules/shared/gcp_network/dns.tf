/******************************************
  Default HUB DNS Policy
 *****************************************/

resource "google_dns_policy" "default_policy" {
  count = var.mode == "hub" ? 1 : 0

  project                   = var.project_id
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name                      = "${var.prefix}-dp-glb-dns-hub-default-policy"
  enable_inbound_forwarding = var.dns_enable_inbound_forwarding
  enable_logging            = var.dns_enable_logging
  networks {
    network_url = module.main.network_self_link
  }
}

/******************************************
  Default Spoke DNS Policy
 *****************************************/
resource "google_dns_policy" "default_spoke_policy" {
  count = var.mode == "spoke" ? 1 : 0

  project                   = var.project_id
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name                      = "${var.prefix}-dp-glb-network-spoke-default-policy"
  enable_inbound_forwarding = var.dns_enable_inbound_forwarding
  enable_logging            = var.dns_enable_logging
  networks {
    network_url = module.main.network_self_link
  }
}

/******************************************
 DNS HUB Outbound Forwarding
*****************************************/

module "dns-forwarding-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 4.2"

  count = ( var.mode == "hub" && var.dns_enable_outbound_forwarding ) ? 1 : 0

  project_id = var.project_id
  type       = "forwarding"
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name       = "${var.prefix}-fz-glb-dns-hub"
  domain     = var.domain

  private_visibility_config_networks = [
    module.main.network_self_link
  ]
  target_name_server_addresses = var.dns_outbound_server_addresses
}

/******************************************
  Private Google APIs DNS Zone & records.
 *****************************************/
module "private_service_connect" {
  source  = "terraform-google-modules/network/google//modules/private-service-connect"
  version = "~> 5.2"

  count = var.mode == "hub" && var.private_svc_connect_ip !=null ? 1 : 0

  forwarding_rule_name         = "privategoogleapi"
  private_service_connect_name = "${var.environment_code}-gip-psconnect"
  project_id                   = var.project_id
  network_self_link            = module.main.network_self_link
  private_service_connect_ip   = var.private_svc_connect_ip
  forwarding_rule_target       = "all-apis"
}