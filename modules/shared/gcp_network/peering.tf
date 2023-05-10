/***************************************************************
  VPC Peering Configuration
 **************************************************************/

module "peering" {
  source  = "terraform-google-modules/network/google//modules/network-peering"
  version = "~> 5.2"

  count                     = var.mode == "spoke" ? 1 : 0
  prefix                    = "${var.prefix}-np-glb"
  local_network             = module.main.network_self_link
  peer_network              = var.org_nethub_vpc_self_link
  export_peer_custom_routes = true
}
