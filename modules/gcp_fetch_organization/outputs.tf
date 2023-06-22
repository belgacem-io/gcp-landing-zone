output "folders_by_env_code" {
  value = local.folders_by_env_code
}

output "netenv_projects_by_env_code" {
  value = local.nethubs_by_env_code
}

output "netenv_networks_by_env_code" {
  value = data.google_compute_network.netenv
}

output "projects_by_name" {
  value = local.projects_by_name
}