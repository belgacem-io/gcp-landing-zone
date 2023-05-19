output "projects" {
  value = values(data.google_project.projects)
}

output "projects_by_name" {
  value = local.projects_by_name
}

output "projects_by_id" {
  value = data.google_project.projects
}

output "folders" {
  value = local.folders
}

output "folders_by_id" {
  value = {for folder in local.folders : folder.name => folder}
}

output "folders_by_name" {
  value = {
    for folder in local.folders :
    folder.name => [for fld in local.folders : fld if fld.display_name == folder.display_name]
  }
}
output "folders_by_env_code" {
  value = local.folders_by_env_code
}

output "org_nethub_project" {
  value = local.projects_by_name["orga-network-hub"]
}

output "nethubs_by_env_code" {
  value = local.nethubs_by_env_code
}

output "nethubs_shared_vpc_by_env_code" {
  value = data.google_compute_network.nethub_vpc
}
output "nethubs_subnets_by_env_code" {
  value = local.nethubs_subnets_by_env_code
}

output "shared_subnets_by_project_and_region" {
  value = local.shared_subnets_by_project_and_region
}
