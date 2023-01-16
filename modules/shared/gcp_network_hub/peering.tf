/***************************************************************
  VPC Peering Configuration
 **************************************************************/

module "peering" {
  source                    = "terraform-google-modules/network/google//modules/network-peering"
  version                   = "~> 4.1"
  count                     = var.mode == "spoke" ? 1 : 0
  prefix                    = "np"
  local_network             = module.main.network_self_link
  peer_network              = data.google_compute_network.org_network_hub_vpc[0].self_link
  export_peer_custom_routes = true
}

/***************************************************************
  Configure Service Networking for Cloud SQL & future services.
 **************************************************************/

resource "google_compute_global_address" "private_service_access_address" {
  count         = var.private_service_cidr != null ? 1 : 0
  name          = "ga-${local.vpc_name}-vpc-peering-internal"
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = element(split("/", var.private_service_cidr), 0)
  prefix_length = element(split("/", var.private_service_cidr), 1)
  network       = module.main.network_self_link

  depends_on = [module.peering]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count                   = var.private_service_cidr != null ? 1 : 0
  network                 = module.main.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access_address[0].name]

  depends_on = [module.peering]
}
