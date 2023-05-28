output "gateway_id" {
  value = module.proxy_ilbs.forwarding_rule
}

output "gateway_ip_address" {
  value = module.proxy_ilbs.ip_address
}