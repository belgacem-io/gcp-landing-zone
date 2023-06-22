/******************************************
  Projects
*****************************************/
data "google_projects" "all" {
  filter = "lifecycleState=ACTIVE"
}

data "google_project" "projects" {
  for_each = toset(data.google_projects.all.projects.*.project_id)

  project_id = each.value
}

/******************************************
  Folders
*****************************************/

data "google_folders" "level1" {
  parent_id = var.parent_container_id
}

data "google_folders" "level2" {
  for_each  = toset(data.google_folders.level1.folders.*.name)
  parent_id = each.value
}


locals {
  folders             = concat(data.google_folders.level1.folders, flatten(values(data.google_folders.level2).*.folders))
  folders_by_env_code = {
    for parent in data.google_folders.level1.folders :
    replace(lower(parent.display_name), "_environment", "") => {
      for folder in data.google_folders.level2[parent.name].folders : folder.display_name => folder
    }
  }
  projects_by_name    = {for k, v in data.google_project.projects : v.name => v}
  nethubs_by_env_code = {
    for k, v in data.google_project.projects :
    v.labels["environment_code"] => v if can(v.labels["environment_code"])
    && can(v.labels["project_role"])
    && try(v.labels["project_role"], "") == "netenv"
  }

}
/******************************************
  Network
*****************************************/

data "google_compute_network" "netenv" {
  for_each = local.nethubs_by_env_code
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name     = "${var.organization_name}-${each.key}-network-${var.default_region}-netenv"
  project  = each.value.project_id

  depends_on = [
    data.google_project.projects
  ]
}
