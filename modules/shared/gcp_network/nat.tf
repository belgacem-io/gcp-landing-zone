/******************************************
  NAT Cloud Router & NAT config
 *****************************************/

resource "google_compute_router" "nat_router_region1" {
  count   = var.nat_enabled ? 1 : 0

  name    = "cr-${var.network_name}-${var.default_region}-nat-router"
  project = var.project_id
  region  = var.default_region
  network = module.main.network_self_link

  bgp {
    asn = var.nat_bgp_asn
  }
}

resource "google_compute_address" "nat_external_addresses_region1" {
  count   = var.nat_enabled ? var.nat_num_addresses_region1 : 0

  project = var.project_id
  name    = "ca-${var.network_name}-${var.default_region}-${count.index}"
  region  = var.default_region
}

resource "google_compute_router_nat" "egress_nat_region1" {
  count                              = var.nat_enabled ? 1 : 0

  name                               = "rn-${var.network_name}-${var.default_region}-egress"
  project                            = var.project_id
  router                             = google_compute_router.nat_router_region1.0.name
  region                             = var.default_region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat_external_addresses_region1.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}
