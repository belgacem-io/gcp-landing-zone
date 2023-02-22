module "squid_proxy_service_account" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.2"

  project_id    = var.project_id
  names         = [var.name]
  project_roles = [
    "${var.project_id}=>roles/logging.logWriter",
    "${var.project_id}=>roles/monitoring.metricWriter",
  ]
}

module "squid_proxy_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 7.3"

  project_id         = var.project_id
  region             = var.default_region
  can_ip_forward     = true
  disk_size_gb       = 10
  name_prefix        = var.name
  network            = var.vpc_name
  subnetwork         = var.subnet_name
  subnetwork_project = var.project_id
  machine_type       = var.instance_type
  service_account    = {
    email  = module.squid_proxy_service_account.emails_list[0]
    scopes = ["cloud-platform"]
  }
  metadata = {
    squid-conf = templatefile("${path.module}/files/squid.conf", {
      trusted_cidr_ranges = var.internal_trusted_cidr_ranges
      safe_ports          = var.authorized_ports
    })
    startup-script = templatefile("${path.module}/files/startup.sh", {
      trusted_cidr_ranges = var.internal_trusted_cidr_ranges
      safe_ports          = var.authorized_ports
    })
  }
  source_image_family  = split("/", var.instance_image)[1]
  source_image_project = split("/", var.instance_image)[0]

  tags = [var.network_internet_egress_tag, var.name]

  depends_on = [
    module.squid_proxy_service_account
  ]
}

module "squid_proxy_migs" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 7.3"
  project_id        = var.project_id
  region            = var.default_region
  target_size       = var.min_replicas
  hostname          = var.name
  instance_template = module.squid_proxy_template.self_link
  update_policy     = var.update_policy

  /* autoscaler */
  autoscaling_enabled          = var.autoscaling_enabled
  max_replicas                 = var.max_replicas
  min_replicas                 = var.min_replicas
  cooldown_period              = var.cooldown_period
  autoscaling_cpu              = var.autoscaling_cpu
  autoscaling_metric           = var.autoscaling_metric
  autoscaling_lb               = var.autoscaling_lb
  autoscaling_scale_in_control = var.autoscaling_scale_in_control

  depends_on = [
    module.squid_proxy_template
  ]
}

module "squid_proxy_ilbs" {
  source  = "GoogleCloudPlatform/lb-internal/google"
  version = "~> 5.0"

  project                 = var.project_id
  region                  = var.default_region
  name                    = var.name
  ports                   = null
  all_ports               = true
  global_access           = true
  network                 = var.vpc_name
  subnetwork              = var.subnet_name
  target_service_accounts = module.squid_proxy_service_account.emails_list
  source_tags             = null
  target_tags             = null
  create_backend_firewall = false
  backends                = [
    { group = module.squid_proxy_migs.instance_group, description = "" },
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
  depends_on = [
    module.squid_proxy_migs
  ]
}