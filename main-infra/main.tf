resource "google_folder" "infra" {
  display_name = var.gcp_infra_projects.folder
  parent       = var.gcp_parent_container_id
}
