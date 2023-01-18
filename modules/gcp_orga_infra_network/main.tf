
locals {
  org_nethub_project_id = data.google_projects.org_nethub.projects[0].project_id
}

/******************************************
  DNS Hub Project
*****************************************/
data "google_active_folder" "infra" {
  display_name = var.infra_folder_name
  parent       = var.parent_id
}

data "google_projects" "org_nethub" {
  filter = "parent.id:${split("/", data.google_active_folder.infra.name)[1]} labels.application_name=${var.nethub_project_name} lifecycleState=ACTIVE"
}


