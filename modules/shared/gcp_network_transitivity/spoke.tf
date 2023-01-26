/******************************************
  Base Network Hub
*****************************************/
data "google_compute_network" "org_nethub_vpc" {
  count   = var.mode == "spoke" ? 1 : 0

  name    = var.org_nethub_vpc_name
  project = var.org_nethub_project_id
}

/***************************************************************
  VPC Peering Configuration
 **************************************************************/

module "peering" {
  source                    = "terraform-google-modules/network/google//modules/network-peering"
  version                   = "~> 5.2"

  count                     = var.mode == "spoke" ? 1 : 0
  prefix                    = "np"
  local_network             = var.network_self_link
  peer_network              = data.google_compute_network.org_nethub_vpc[0].self_link
  export_peer_custom_routes = true
}