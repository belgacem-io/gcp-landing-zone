# TCP Proxy load balancer DNS record
resource "google_dns_record_set" "apps" {
  project      = var.network_project_id
  # DNS Zone name where record should be created
  managed_zone = var.dns_zone_name

  # DNS record
  name = format("*.%s.%s.", var.cluster_name, var.dns_zone)
  type = "A"
  ttl  = 300

  # IPv4 address of apiserver TCP Proxy load balancer
  rrdatas = [module.gke.endpoint]

  lifecycle {
    ignore_changes = [
      rrdatas
    ]
  }
}