/******************************************
  Default DNS Policy
 *****************************************/

resource "google_dns_policy" "default_spoke_policy" {
  count   = var.mode == "spoke" ? 1 : 0

  project                   = var.project_id
  name                      = "dp-${var.environment_code}-network-hub-default-policy"
  enable_inbound_forwarding = var.dns_enable_inbound_forwarding
  enable_logging            = var.dns_enable_logging
  networks {
    network_url = module.main.network_self_link
  }
}

/******************************************
  Private Google APIs DNS Zone & records.
 *****************************************/

module "private_googleapis" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 4.2"

  count   = var.mode == "spoke" ? 1 : 0

  project_id  = var.project_id
  type        = "private"
  name        = "dz-${var.environment_code}-network-hub-apis"
  domain      = "googleapis.com."
  description = "Private DNS zone to configure private.googleapis.com"

  private_visibility_config_networks = [
    module.main.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["private.googleapis.com."]
    },
    {
      name    = "private"
      type    = "A"
      ttl     = 300
      records = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
    },
  ]
}

/******************************************
  Private GCR DNS Zone & records.
 *****************************************/

module "base_gcr" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 4.2"

  count   = var.mode == "spoke" ? 1 : 0

  project_id  = var.project_id
  type        = "private"
  name        = "dz-${var.environment_code}-network-hub-gcr"
  domain      = "gcr.io."
  description = "Private DNS zone to configure gcr.io"

  private_visibility_config_networks = [
    module.main.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["gcr.io."]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
    },
  ]
}

/***********************************************
  Private Artifact Registry DNS Zone & records.
 ***********************************************/

module "base_pkg_dev" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 4.2"

  count   = var.mode == "spoke" ? 1 : 0

  project_id  = var.project_id
  type        = "private"
  name        = "dz-${var.environment_code}-network-hub-pkg-dev"
  domain      = "pkg.dev."
  description = "Private DNS zone to configure pkg.dev"

  private_visibility_config_networks = [
    module.main.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["pkg.dev."]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
    },
  ]
}

/******************************************
 Creates public DNS zone
*****************************************/

locals {
  zone_name = replace(substr(var.domain,0,length(var.domain) - 1 ),".","-")
}

data "google_dns_managed_zone" "org_dns_zone" {
  count   = var.mode == "spoke" ? 1 : 0

  name    = "fz-dns-hub"
  project = var.org_nethub_project_id
}

resource "google_dns_record_set" "spoke_ns_record" {
  count   = var.mode == "spoke" ? 1 : 0

  project = var.org_nethub_project_id
  name = var.domain
  type = "NS"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.org_dns_zone.0.name

  rrdatas = module.public_zone.0.name_servers
}

module "public_zone" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 4.2"

  count   = var.mode == "spoke" ? 1 : 0

  project_id  = var.project_id
  type        = "public"
  name        = local.zone_name
  domain      = var.domain
  description = "Public DNS zone."

  private_visibility_config_networks = [
    module.main.network_self_link
  ]
  target_network = data.google_compute_network.org_nethub_vpc[0].self_link
}
