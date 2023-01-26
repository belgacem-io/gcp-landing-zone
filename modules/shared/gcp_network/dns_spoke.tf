/******************************************
  Default DNS Policy
 *****************************************/
resource "google_dns_policy" "default_spoke_policy" {
  count   = var.mode == "spoke" ? 1 : 0

  project                   = var.project_id
  name                      = "dp-${var.environment_code}-network-spoke-default-policy"
  enable_inbound_forwarding = var.dns_enable_inbound_forwarding
  enable_logging            = var.dns_enable_logging
  networks {
    network_url = module.main.network_self_link
  }
}
