/******************************************
  Mandatory firewall rules
 *****************************************/
resource "google_compute_firewall" "allow_ingress" {
  #[prefix]-[project]-[env]-[resource]-[location]-[description]-[suffix]
  name      = "${var.prefix}-fw-glb-allow-${var.name}-ingress"
  network   = var.vpc_name
  project   = var.project_id
  direction = "INGRESS"
  priority  = 1000

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [
      {
        metadata = "INCLUDE_ALL_METADATA"
      }
    ] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  allow {
    protocol = "all"
  }

  source_ranges           = var.internal_trusted_cidr_ranges
  target_service_accounts = module.squid_proxy_service_account.emails_list
}

resource "google_compute_firewall" "allow_egress" {
  #[prefix]-[project]-[env]-[resource]-[location]-[description]-[suffix]
  name      = "${var.prefix}-fw-glb-allow-${var.name}-egress"
  network   = var.vpc_name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 1000

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [
      {
        metadata = "INCLUDE_ALL_METADATA"
      }
    ] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  allow {
    protocol = "all"
  }

  destination_ranges      = var.internal_trusted_cidr_ranges
  target_service_accounts = module.squid_proxy_service_account.emails_list
}
