output "gateway_id" {
  value = module.ilbs.forwarding_rule
}

output "gateway_ip_address" {
  value = module.ilbs.ip_address
}