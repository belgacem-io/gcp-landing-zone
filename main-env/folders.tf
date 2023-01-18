/******************************************
  Create folders
*****************************************/

locals {
  departments = flatten([
    for key,env in var.gcp_organization_environments : [
          for bu in env.children : {
            name = bu.name
            parent = key
            environment_code = env.environment_code
          }
  ]
  ])
  departments_map = {
    for bu in local.departments : "${bu.environment_code}-${bu.name}" => bu
  }

  business_projects = flatten([
    for key,env in var.gcp_organization_environments : [
          for project in var.gcp_business_projects : merge(project,{
            environment_code = env.environment_code
            environment_key = key
          }) if project.environment_code == env.environment_code
  ]
  ])

  business_projects_map = {
    for project in local.business_projects : "${project.environment_code}-${project.name}" => project  if lookup(local.departments_map, "${project.environment_code}-${project.department}" , null) !=  null
  }
}

resource "google_folder" "environments" {
  for_each = var.gcp_organization_environments

  display_name = "${title( each.value.environment_code )}_Environment"
  parent       = var.gcp_parent_resource_id
}

resource "google_folder" "department" {
  for_each = local.departments_map

  display_name = each.value.name
  parent       = google_folder.environments[each.value.parent].id
}
