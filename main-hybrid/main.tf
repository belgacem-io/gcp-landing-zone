/******************************************
 DNS HUB Outbound Forwarding
*****************************************/

module "dns-forwarding-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 4.2"

  count = var.enable_dns_outbound_forwarding ? 1 : 0

  project_id = var.project_id
  type       = "forwarding"
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name       = "${var.prefix}-fz-glb-dns-hub"
  domain     = "${var.private_domain}."

  private_visibility_config_networks = [
    module.main.network_self_link
  ]
  target_name_server_addresses = var.dns_outbound_server_addresses
}