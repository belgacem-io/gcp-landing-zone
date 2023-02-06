resource "google_project_service" "enableapi" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "billingbudgets.googleapis.com",
    "iamcredentials.googleapis.com",
    "pubsub.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ])
  project = var.gcp_bootstrap_project_id
  service = each.value
  timeouts {
    create = "30m"
    update = "40m"
  }
  disable_dependent_services = true
}

/***********************************************
  Organization permissions for Terraform.
 ***********************************************/

resource "google_organization_iam_member" "tf_sa_org_perms" {
  for_each = startswith(var.gcp_parent_container_id, "organizations") ? toset(var.gcp_terraform_sa_org_iam_permissions) : toset([])

  org_id = split("/",var.gcp_parent_container_id)[1]
  role   = each.value
  member = "serviceAccount:${var.gcp_terraform_sa_email}"
}

resource "google_folder_iam_member" "tf_sa_org_perms" {
  for_each = startswith(var.gcp_parent_container_id, "folders") ? toset(var.gcp_terraform_sa_org_iam_permissions) : toset([])

  folder = split("/",var.gcp_parent_container_id)[1]
  role   = each.value
  member = "serviceAccount:${var.gcp_terraform_sa_email}"
}