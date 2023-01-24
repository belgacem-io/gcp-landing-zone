/******************************************
  Routes to internet
 *****************************************/

resource "google_compute_route" "internet_routes" {
  project           = var.project_id
  network           = var.vpc_name
  name              = "rt-${var.name}-internet"
  description       = "${var.name} route for internet"
  tags              = [var.name]
  dest_range        = "0.0.0.0/0"
  next_hop_gateway  = "default-internet-gateway"
}


/******************************************
  Mandatory firewall rules
 *****************************************/

resource "google_compute_route" "routes" {
  for_each = toset(var.internal_trusted_cidr_ranges)

  project      = var.project_id
  network      = var.vpc_name
  name         = "rt-${var.name}-${replace(replace(each.value, "/", "-"), ".", "-")}"
  description  = "${var.name} route for ${each.value}"
  dest_range   = each.value
  next_hop_ilb = module.squid_proxy_ilbs.forwarding_rule
}

resource "google_compute_firewall" "allow_ingress" {
  name      = "fw-allow-${var.name}-ingress"
  network   = var.vpc_name
  project   = var.project_id
  direction = "INGRESS"
  priority  = 1000

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

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
  name      = "fw-allow-${var.name}-egress"
  network   = var.vpc_name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 1000

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

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
