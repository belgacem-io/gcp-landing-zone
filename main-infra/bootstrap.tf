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

/***********************************************
  IAM - Impersonation permissions to run terraform
  as org admin.
 ***********************************************/

resource "google_service_account_iam_member" "org_admin_sa_impersonate_permissions" {
  count = var.gcp_group_org_admins !=null ? 1: 0

  service_account_id = var.gcp_terraform_sa_id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "group:${var.gcp_group_org_admins}"
}

resource "google_organization_iam_member" "org_admin_serviceusage_consumer" {
  count  = startswith(var.gcp_parent_container_id, "organizations") && var.gcp_group_org_admins !=null ? 1 : 0

  org_id = split("/",var.gcp_parent_container_id)[1]
  role   = "roles/serviceusage.serviceUsageConsumer"
  member = "group:${var.gcp_group_org_admins}"
}

resource "google_folder_iam_member" "org_admin_serviceusage_consumer" {

  count  = startswith(var.gcp_parent_container_id, "folders") && var.gcp_group_org_admins !=null ? 1 : 0

  folder = split("/",var.gcp_parent_container_id)[1]
  role   = "roles/serviceusage.serviceUsageConsumer"
  member = "group:${var.gcp_group_org_admins}"
}