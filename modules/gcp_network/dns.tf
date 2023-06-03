/******************************************
  Default HUB DNS Policy
 *****************************************/

resource "google_dns_policy" "default_policy" {
  count = var.mode == "hub" ? 1 : 0

  project                   = var.project_id
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name                      = "${var.prefix}-dp-glb-${var.network_name}-hub-default-policy"
  enable_inbound_forwarding = var.enable_dns_inbound_forwarding
  enable_logging            = var.enable_dns_logging
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
  name                      = "${var.prefix}-dp-glb-${var.network_name}-spoke-default-policy"
  enable_inbound_forwarding = var.enable_dns_inbound_forwarding
  enable_logging            = var.enable_dns_logging
  networks {
    network_url = module.main.network_self_link
  }
}


/******************************************
  Private Google APIs DNS Zone & records.
 *****************************************/
module "private_service_connect" {
  source  = "terraform-google-modules/network/google//modules/private-service-connect"
  version = "~> 5.2"

  count = var.mode == "hub" && var.private_svc_connect_ip !=null ? 1 : 0

  forwarding_rule_name         = "privategoogleapi"
  private_service_connect_name = "${var.environment_code}-pscip--${var.network_name}"
  project_id                   = var.project_id
  network_self_link            = module.main.network_self_link
  private_service_connect_ip   = var.private_svc_connect_ip
  forwarding_rule_target       = "all-apis"
}

/******************************************
  Private Google APIs DNS Zone & records.
 *****************************************/

module "dns-private-zone" {
  count = var.mode == "hub" ? 1 : 0

  source        = "terraform-google-modules/cloud-dns/google"
  version       = "~> 4.2"
  project_id    = var.project_id
  type          = "private"
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name          = "${var.prefix}-pvz-glb-${var.network_name}-${var.mode}"
  domain        = "${var.private_domain}."
  force_destroy = true

  private_visibility_config_networks = [
    module.main.network_self_link
  ]

  recordsets = var.enable_secure_web_proxy ? [
    {
      name    = "proxy"
      type    = "A"
      ttl     = 300
      records = [
        module.secure_web_proxy.0.gateway_ip_address,
      ]
    }
  ] : []

  depends_on = [
    module.secure_web_proxy
  ]
}

/******************************************
 DNS Spoke peering
*****************************************/
module "dns-peering-zone-hub2spoke" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 4.2"

  for_each = ( var.mode == "spoke" && var.enable_dns_peering ) ? var.infra_nethub_networks_self_links : {}

  project_id = var.project_id
  type       = "peering"
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name       = "${var.prefix}-pz-glb-${var.network_name}-peering-hub2spoke-${each.key}"
  domain     = "${var.private_domain}."

  private_visibility_config_networks = [
    module.main.network_self_link
  ]
  target_network = each.value
}