output "ilb_id" {
  value = module.ilbs.forwarding_rule
}

output "proxy_service_accounts" {
  value = google_service_account.sa.email
}