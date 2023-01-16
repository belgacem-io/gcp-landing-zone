/***********************************************
  Organization permissions for Terraform.
 ***********************************************/

resource "google_organization_iam_member" "tf_sa_org_perms" {
  for_each = toset(var.gcp_terraform_sa_org_iam_permissions)

  org_id = var.gcp_organization_id
  role   = each.value
  member = "serviceAccount:${var.gcp_terraform_sa_email}"
}

resource "google_billing_account_iam_member" "tf_billing_user" {
  billing_account_id = var.gcp_billing_account
  role               = "roles/billing.user"
  member             = "serviceAccount:${var.gcp_terraform_sa_email}"
}

resource "google_billing_account_iam_member" "tf_billing_admin" {
  billing_account_id = var.gcp_billing_account
  role               = "roles/billing.admin"
  member             = "serviceAccount:${var.gcp_terraform_sa_email}"
}

/***********************************************
  IAM - Impersonation permissions to run terraform
  as org admin.
 ***********************************************/

resource "google_service_account_iam_member" "org_admin_sa_impersonate_permissions" {
  service_account_id = var.gcp_terraform_sa_id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "group:${var.gcp_group_org_admins}"
}

resource "google_organization_iam_member" "org_admin_serviceusage_consumer" {

  org_id = var.gcp_organization_id
  role   = "roles/serviceusage.serviceUsageConsumer"
  member = "group:${var.gcp_group_org_admins}"
}