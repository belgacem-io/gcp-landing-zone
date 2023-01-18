/******************************************
  Firewall Rules
*****************************************/

resource "google_compute_firewall" "default_allow" {
  name          = "allow-${var.service_root_name}"
  network       = var.vpc_name
  #130.211.0.0/22 and 35.191.0.0/16 are CIDR ranges for GCP IAP services.
  source_ranges = flatten(["130.211.0.0/22", "35.191.0.0/16", var.internal_trusted_cidr_ranges])
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["3128"]
  }
  source_tags = [var.service_root_name]
}

/******************************************
  Create VM Instance Template
*****************************************/

resource "google_service_account" "default" {
  account_id   = "${var.service_root_name}-svc"
  display_name = "Squid Proxy Service Account"
}

resource "google_compute_instance_template" "squid_server_templ" {
  name        = "${var.service_root_name}-template"
  description = "This template is used to create squid proxy instances."
  tags        = ["squid-proxy"]
  labels      = {
    environment = var.environment_code
  }
  instance_description = "Squid proxy instance."
  machine_type         = var.instance_type
  can_ip_forward       = false
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
    squid-conf = file("${path.module}/files/squid.conf")
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
  metadata_startup_script = file("${path.module}/files/startup.sh")
  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name
    #Uncomment the line below to allow a public IP address on each VM.
    #access_config {}
  }
}

/******************************************
  Create Managed Instance Group, Health-Check, and Autoscaler
*****************************************/

resource "google_compute_health_check" "tcp-health-check" {
  name = "${var.service_root_name}-health-check"

  timeout_sec        = 1
  check_interval_sec = 5

  tcp_health_check {
    port = "3128"
  }
}
resource "google_compute_instance_group_manager" "squid_igm" {
  name = "${var.service_root_name}-igm"

  base_instance_name = var.service_root_name

  named_port {
    name = "proxy-port"
    port = "3128"
  }

  version {
    instance_template = google_compute_instance_template.squid_server_templ.id
  }

  target_size = 2

  auto_healing_policies {
    health_check      = google_compute_health_check.tcp-health-check.id
    initial_delay_sec = 200
  }

}
resource "google_compute_autoscaler" "autoscaler" {
  name   = "${var.service_root_name}-autoscaler"
  target = google_compute_instance_group_manager.squid_igm.id

  autoscaling_policy {
    max_replicas    = var.autoscaling_max
    min_replicas    = var.autoscaling_min
    cooldown_period = 60

    cpu_utilization {
      target = var.autoscaling_cpu_target
    }
  }
}

/******************************************
  Create Backend Service and Internal Load Balancer
*****************************************/
resource "google_compute_region_backend_service" "default" {
  load_balancing_scheme = "INTERNAL"

  backend {
    group = google_compute_instance_group_manager.squid_igm.instance_group
  }

  name          = "${var.service_root_name}-backend"
  protocol      = "TCP"
  timeout_sec   = 10
  health_checks = [google_compute_health_check.tcp-health-check.id]
}
resource "google_compute_forwarding_rule" "main_fr" {
  name                  = "${var.service_root_name}-frontend"
  network               = var.vpc_name
  subnetwork            = var.subnet_name
  backend_service       = google_compute_region_backend_service.default.self_link
  load_balancing_scheme = "INTERNAL"
  ports                 = ["3128"]
}

