
locals {
  org_network_hub_project_id = data.google_projects.org_network_hub.projects[0].project_id
}

/******************************************
  DNS Hub Project
*****************************************/
data "google_active_folder" "infra" {
  display_name = var.infra_folder_name
  parent       = var.parent_id
}

data "google_projects" "org_network_hub" {
  filter = "parent.id:${split("/", data.google_active_folder.infra.name)[1]} labels.application_name=${var.network_hub_project_name} lifecycleState=ACTIVE"
}


