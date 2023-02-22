/******************************************
  Create folders
*****************************************/

locals {
  departments = flatten([
    for key, env in var.gcp_organization_environments : [
      for bu in env.children : {
        name             = bu.name
        parent           = key
        environment_code = env.environment_code
      }
    ]
  ])
  departments_map = {
    for bu in local.departments : "${bu.environment_code}-${bu.name}" => bu
  }

  business_projects = flatten([
    for key, env in var.gcp_organization_environments : [
      for project in var.gcp_business_projects : project if project.environment_code == env.environment_code
    ]
  ])

  business_projects_map = {
    for project in local.business_projects : "${project.environment_code}-${project.name}" => project
    if lookup(local.departments_map, "${project.environment_code}-${project.department}", null) !=  null
  }
}