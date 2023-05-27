/*
 * Hub & Spoke Peering Transitivity with Gateway VMs
 */
resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = "${var.prefix}-glb-linux-tgw"
  display_name = "Squid Proxy"
}

resource "google_project_iam_member" "member" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ])
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.sa.email}"
}

module "tgw_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 8.0"

  can_ip_forward     = true
  disk_size_gb       = 10
  name_prefix        = "${var.prefix}-tpl-linuxtgwt"
  network            = var.network_name
  project_id         = var.project_id
  region             = var.default_region
  subnetwork         = var.subnetwork_name
  subnetwork_project = var.project_id
  machine_type       = var.instance_type

  service_account = {
    email  = google_service_account.sa.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    user-data = templatefile("${path.module}/files/gw.yaml", {
      source_trusted_ip_ranges      = join(",", var.source_trusted_cidr_ranges),
      destination_trusted_ip_ranges = join(",", var.destination_trusted_cidr_ranges),
    })
    block-project-ssh-keys = "true"
  }

  source_image_family  = split("/", var.instance_image)[1]
  source_image_project = split("/", var.instance_image)[0]

  tags = var.network_tags
}

module "migs" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 8.0"

  project_id                   = var.project_id
  region                       = var.default_region
  #[prefix]-[resource]-[location]-[description]-[suffix]
  hostname                     = "${var.prefix}-mig-${var.default_region}-linuxtgwt"
  instance_template            = module.tgw_template.self_link
  /* autoscaler */
  autoscaling_enabled          = var.autoscaling_enabled
  max_replicas                 = var.max_replicas
  min_replicas                 = var.min_replicas
  cooldown_period              = var.cooldown_period
  autoscaling_cpu              = var.autoscaling_cpu
  autoscaling_metric           = var.autoscaling_metric
  autoscaling_lb               = var.autoscaling_lb
  autoscaling_scale_in_control = var.autoscaling_scale_in_control

  update_policy = var.update_policy
}

module "ilbs" {
  source  = "GoogleCloudPlatform/lb-internal/google"
  version = "~> 5.0"

  region                  = var.default_region
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name                    = "${var.prefix}-ilb-${var.default_region}-linuxtgwt"
  ports                   = null
  all_ports               = true
  global_access           = true
  network                 = var.network_name
  subnetwork              = var.subnetwork_name
  firewall_enable_logging = true
  target_service_accounts = [google_service_account.sa.email]
  source_tags             = null
  target_tags             = null
  create_backend_firewall = false
  backends                = [
    { group = module.migs.instance_group, description = "" },
  ]

  health_check = {
    type                = "tcp"
    check_interval_sec  = 5
    healthy_threshold   = 4
    timeout_sec         = 1
    unhealthy_threshold = 5
    response            = null
    proxy_header        = "NONE"
    port                = 22
    port_name           = null
    request             = null
    request_path        = null
    host                = null
    enable_log          = false
  }
  project = var.project_id
}