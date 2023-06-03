/***************************************************************
  VPC Peering Configuration
 **************************************************************/

module "peering" {
  source  = "terraform-google-modules/network/google//modules/network-peering"
  version = "~> 5.2"

  for_each = var.mode == "spoke" ? var.infra_nethub_networks : {}

  prefix                    = "${var.prefix}-np-glb-${var.network_name}-${each.key}"
  local_network             = module.main.network_self_link
  peer_network              = each.value.self_link
  export_peer_custom_routes = true

  depends_on = [
    module.main
  ]
}
