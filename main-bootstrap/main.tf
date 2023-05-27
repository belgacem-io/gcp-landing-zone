module "bootstrap" {
  source  = "../modules/gcp_bootstrap"

  org_id                         = var.gcp_organization_id
  prefix                         = "${var.gcp_organization_prefix}-prod"
  billing_account                = var.gcp_billing_account
  parent_folder                  = var.gcp_parent_container_id
  project_id                     = var.gcp_bootstrap_project_id
  folder_id                      = var.gcp_parent_container_id
  group_org_admins               = var.gcp_group_org_admins
  group_billing_admins           = var.gcp_group_org_billing_admins
  default_region                 = var.gcp_default_region
  iac_service_account_email      = var.gcp_terraform_sa_email
  grant_billing_user             = false
}