/******************************************
  Allow squid proxy to access to internet
 *****************************************/
resource "google_compute_firewall" "allow_squid_to_internet" {

  #[prefix]-[resource]-[location]-[description]-[suffix]
  name                    = "${var.prefix}-fw-glb-allow-squid-to-internet"
  description             = "VPC Transit Gateway to internet firewall"
  project                 = var.project_id
  network                 = var.network_name
  priority                = 100
  direction               = "EGRESS"
  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = module.service_account.emails_list

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }

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


}

resource "google_compute_route" "allow_squid_to_internet" {

  project          = var.project_id
  network          = var.network_name
  priority         = 100
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name             = "${var.prefix}-rt-glb-allow-squid-to-internet"
  description      = "Transit Gateway to internet route"
  tags             = var.network_tags
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
}

/******************************************
  Allow traffic between Squid and all trusted VPCs
 *****************************************/
resource "google_compute_firewall" "allow_trusted_vpc_to_squid" {
  #[prefix]-[project]-[env]-[resource]-[location]-[description]-[suffix]
  name                    = "${var.prefix}-fw-glb-allow-trusted-vpc-to-squid"
  network                 = var.network_name
  project                 = var.project_id
  direction               = "INGRESS"
  priority                = 1000
  source_ranges           = var.source_trusted_cidr_ranges
  target_service_accounts = module.service_account.emails_list

  allow {
    protocol = "all"
  }

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
}

resource "google_compute_firewall" "allow_squid_to_trusted_vpc" {
  #[prefix]-[project]-[env]-[resource]-[location]-[description]-[suffix]
  name      = "${var.prefix}-fw-glb-allow-squid-to-trusted-vpc"
  network   = var.network_name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 1000
  destination_ranges      = var.source_trusted_cidr_ranges
  target_service_accounts = module.service_account.emails_list

  allow {
    protocol = "all"
  }

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

}

/******************************************
  IAP Configuration
 *****************************************/

resource "google_project_iam_member" "os_login_bindings" {
  for_each = toset(var.authorized_members)
  project  = var.project_id
  role     = "roles/compute.osLogin"
  member   = each.key
}

module "iap_tunneling" {
  source  = "terraform-google-modules/bastion-host/google//modules/iap-tunneling"
  version = "~> 5.1"

  #[prefix]-[resource]-[location]-[description]-[suffix]
  fw_name_allow_ssh_from_iap = "${var.prefix}-iap-glb-allow-squid-iap"
  project                    = var.project_id
  network                    = var.network_name
  service_accounts           = module.service_account.emails_list
  instances                  = []
  members                    = var.authorized_members
}