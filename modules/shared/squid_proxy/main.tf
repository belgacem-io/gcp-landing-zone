/******************************************
  Create VM Instance Template
*****************************************/

resource "google_service_account" "default" {
  project      = var.project_id
  account_id   = "${var.service_root_name}-svc"
  display_name = "Squid Proxy Service Account"
}

resource "google_compute_instance_template" "squid_server_templ" {
  name_prefix = "${var.service_root_name}-template"
  project     = var.project_id
  region      = var.default_region1
  description = "This template is used to create squid proxy instances."
  tags        = [var.service_root_name, var.network_internet_egress_tag]
  labels      = {
    environment = var.environment_code
  }
  instance_description = "Squid proxy instance."
  machine_type         = var.instance_type
  can_ip_forward       = true
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
  // Create a new boot disk from an image
  disk {
    source_image = var.instance_image
    auto_delete  = true
    boot         = true
  }
  metadata = {
    squid-conf = templatefile("${path.module}/files/squid.conf",{
      trusted_cidr_ranges = var.internal_trusted_cidr_ranges
      safe_ports          = var.authorized_ports
    })
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
  metadata_startup_script = templatefile("${path.module}/files/startup.sh",{
    trusted_cidr_ranges = var.internal_trusted_cidr_ranges
    safe_ports          = var.authorized_ports
  })
  network_interface {
    network            = var.vpc_name
    subnetwork         = var.subnet_name
    subnetwork_project = var.project_id
    #Uncomment the line below to allow a public IP address on each VM.
    #access_config {}
  }
}

/******************************************
  Create Managed Instance Group, Health-Check, and Autoscaler
*****************************************/

resource "google_compute_health_check" "tcp-health-check" {
  name               = "${var.service_root_name}-health-check"
  project            = var.project_id
  timeout_sec        = 1
  check_interval_sec = 5

  tcp_health_check {
    port = "3128"
  }
}

module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 7.9"

  project_id        = var.project_id
  region            = var.default_region1
  hostname          = "mig-${var.service_root_name}"
  instance_template = google_compute_instance_template.squid_server_templ.self_link

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
    google_compute_instance_template.squid_server_templ
  ]
}

/******************************************
  Create Backend Service and Internal Load Balancer
*****************************************/
resource "google_compute_region_backend_service" "default" {
  project               = var.project_id
  region                = var.default_region1
  load_balancing_scheme = "INTERNAL"

  backend {
    group = module.mig.instance_group
  }

  name          = "${var.service_root_name}-backend"
  protocol      = "TCP"
  timeout_sec   = 10
  health_checks = [google_compute_health_check.tcp-health-check.id]
}
resource "google_compute_forwarding_rule" "main_fr" {
  name                  = "${var.service_root_name}-frontend"
  project               = var.project_id
  region                = var.default_region1
  network               = var.vpc_name
  subnetwork            = var.subnet_name
  backend_service       = google_compute_region_backend_service.default.self_link
  load_balancing_scheme = "INTERNAL"
  ports                 = var.authorized_ports
}

/******************************************
  Routes & Firewall Rules
*****************************************/

resource "google_compute_firewall" "default_allow" {
  name          = "allow-${var.service_root_name}"
  project       = var.project_id
  network       = var.vpc_name
  #130.211.0.0/22 and 35.191.0.0/16 are CIDR ranges for GCP IAP services.
  source_ranges = flatten(["130.211.0.0/22", "35.191.0.0/16", var.internal_trusted_cidr_ranges])
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = var.authorized_ports
  }
  source_tags = [var.service_root_name]
}