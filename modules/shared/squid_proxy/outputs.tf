output "squid_proxy_ilb_ip" {
  value       = google_compute_forwarding_rule.main_fr.ip_address
  description = "The target for the internal load balancer."
}
