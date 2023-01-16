/******************************************
  Create projects
*****************************************/

module "infra_projects" {
  source = "../modules/gcp_orga_infra_projects"

  terraform_sa_email           = var.gcp_terraform_sa_email
  billing_account              = var.gcp_billing_account
  organization_id              = var.gcp_organization_id
  infra_security_project       = var.gcp_infra_projects.security
  infra_observability_project  = var.gcp_infra_projects.observability
  infra_networking_hub_project = var.gcp_infra_projects.networking_hub
  domains_to_allow             = [
    var.gcp_organization_name
  ]
  enable_scc_notification      = true
  infra_folder_name            = var.gcp_infra_folder_name
  org_audit_data_admins        = var.gcp_group_org_security_admins
  org_audit_viewers            = var.gcp_group_org_security_reviewers
  org_billing_admins           = var.gcp_group_org_billing_admins
  org_billing_data_viewers     = var.gcp_group_org_billing_admins
  org_network_viewers          = var.gcp_group_org_network_viewers
  org_org_admins               = var.gcp_group_org_admins
  org_viewers                  = var.gcp_group_org_viewers
  org_scc_admins               = var.gcp_group_org_security_admins
  org_security_reviewers       = var.gcp_group_org_security_reviewers
  default_region               = var.gcp_default_region1
  budget_alert_pubsub_topic    = var.gcp_infra_projects.observability.budget.alert_pubsub_topic

  gcp_labels = var.gcp_labels
}

module "infra_networks" {
  source = "../modules/gcp_orga_infra_network"

  domain                   = var.gcp_organization_name
  organization_id          = var.gcp_organization_id
  terraform_sa_email       = var.gcp_terraform_sa_email
  billing_account          = var.gcp_billing_account
  network_hub_project_name = var.gcp_infra_projects.networking_hub.name
  default_region1          = var.gcp_default_region1
  default_region2          = var.gcp_default_region2
  orga_network_hub_subnets = var.gcp_infra_projects.networking_hub.network.cidr_blocks

  gcp_labels = var.gcp_labels
}