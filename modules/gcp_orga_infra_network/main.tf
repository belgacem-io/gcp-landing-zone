data "google_active_folder" "infra" {
  display_name = var.infra_folder_name
  parent       = "organizations/${var.organization_id}"
}
