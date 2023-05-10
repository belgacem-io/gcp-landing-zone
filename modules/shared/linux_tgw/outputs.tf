output "ilb_id" {
  value = module.ilbs.forwarding_rule
}

output "proxy_service_accounts" {
  value = module.service_account.emails_list
}