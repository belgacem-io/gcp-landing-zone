/******************************************
  Mandatory firewall rules
 *****************************************/

resource "google_compute_firewall" "deny_all_egress" {
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name      = "${var.prefix}-fw-glb-deny-all-egress"
  network   = module.main.network_name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 65535

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

  deny {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
}


resource "google_compute_firewall" "allow_private_api_egress" {
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name      = "${var.prefix}-fw-glb-allow-private-google-api-egress"
  network   = module.main.network_name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 65534

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
    protocol = "tcp"
    ports    = ["443"]
  }

  destination_ranges = [local.private_googleapis_cidr]

  target_tags = ["allow-google-apis"]
}

/******************************************
  Configured firewall rules
 *****************************************/
resource "google_compute_firewall" "allow_limited_egress" {
  count = var.allow_egress_ranges != null ? 1 : 0

  #[prefix]-[resource]-[location]-[description]-[suffix]
  name      = "${var.prefix}-fw-glb-allow-limited-egress"
  network   = module.main.network_name
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

  destination_ranges = var.allow_egress_ranges
}

resource "google_compute_firewall" "allow_limited_ingress" {
  count = var.allow_ingress_ranges != null ? 1 : 0

  #[prefix]-[resource]-[location]-[description]-[suffix]
  name      = "${var.prefix}-fw-glb-allow-limited-ingress"
  network   = module.main.network_name
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

  source_ranges = var.allow_ingress_ranges
}

/******************************************
  Optional firewall rules
 *****************************************/

// Allow SSH via IAP when using the allow-iap-ssh tag for Linux workloads.
resource "google_compute_firewall" "allow_iap_ssh" {
  count = var.optional_fw_rules_enabled ? 1 : 0

  #[prefix]-[resource]-[location]-[description]-[suffix]
  name    = "${var.prefix}-fw-glb-allow-iap-ssh"
  network = module.main.network_name
  project = var.project_id

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

  // Cloud IAP's TCP forwarding netblock
  source_ranges = concat(data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4)

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["allow-iap-ssh"]
}

// Allow RDP via IAP when using the allow-iap-rdp tag for Windows workloads.
resource "google_compute_firewall" "allow_iap_rdp" {
  count = var.optional_fw_rules_enabled ? 1 : 0

  #[prefix]-[resource]-[location]-[description]-[suffix]
  name    = "${var.prefix}-fw-glb-allow-iap-rdp"
  network = module.main.network_name
  project = var.project_id

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

  // Cloud IAP's TCP forwarding netblock
  source_ranges = concat(data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4)

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  target_tags = ["allow-iap-rdp"]
}

// Allow access to kms.windows.googlecloud.com for Windows license activation
resource "google_compute_firewall" "allow_windows_activation" {
  count = var.windows_activation_enabled ? 1 : 0

  #[prefix]-[resource]-[location]-[description]-[suffix]
  name      = "${var.prefix}-fw-glb-allow-windows-activation"
  network   = module.main.network_name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 0

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
    protocol = "tcp"
    ports    = ["1688"]
  }

  destination_ranges = ["35.190.247.13/32"]

  target_tags = ["allow-win-activation"]
}

// Allow traffic for Internal & Global load balancing health check and load balancing IP ranges.
resource "google_compute_firewall" "allow_lb" {
  count = var.optional_fw_rules_enabled ? 1 : 0

  #[prefix]-[resource]-[location]-[description]-[suffix]
  name    = "${var.prefix}-fw-glb-allow-lb-health"
  network = module.main.network_name
  project = var.project_id

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

  source_ranges = concat(data.google_netblock_ip_ranges.health_checkers.cidr_blocks_ipv4, data.google_netblock_ip_ranges.legacy_health_checkers.cidr_blocks_ipv4)

  // Allow common app ports by default.
  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]
  }

  target_tags = ["allow-lb"]
}