/******************************************
  Create projects
*****************************************/

module "infra_projects" {
  source = "../modules/gcp_orga_infra_projects"

  terraform_sa_email           = var.gcp_terraform_sa_email
  billing_account              = var.gcp_billing_account
  parent_id                    = var.gcp_parent_resource_id
  infra_folder_name            = var.gcp_infra_projects.folder
  organization_id              = var.gcp_organization_id
  infra_security_project       = var.gcp_infra_projects.security
  infra_observability_project  = var.gcp_infra_projects.observability
  infra_nethub_project         = var.gcp_infra_projects.nethub
  domains_to_allow             = [
    var.gcp_organization_domain
  ]
  enable_scc_notification   = false
  org_audit_data_admins     = var.gcp_group_org_security_admins
  org_audit_viewers         = var.gcp_group_org_security_reviewers
  org_billing_admins        = var.gcp_group_org_billing_admins
  org_billing_data_viewers  = var.gcp_group_org_billing_admins
  org_network_viewers       = var.gcp_group_org_network_viewers
  org_org_admins            = var.gcp_group_org_admins
  org_viewers               = var.gcp_group_org_viewers
  org_scc_admins            = var.gcp_group_org_security_admins
  org_security_reviewers    = var.gcp_group_org_security_reviewers
  default_region            = var.gcp_default_region1
  budget_alert_pubsub_topic = var.gcp_infra_projects.observability.budget.alert_pubsub_topic

  gcp_labels = var.gcp_labels
}

module "infra_hub_networks" {
  source = "../modules/gcp_orga_infra_network"

  domain                            = var.gcp_organization_domain
  organization_id                   = var.gcp_organization_id
  parent_id                         = var.gcp_parent_resource_id
  terraform_sa_email                = var.gcp_terraform_sa_email
  billing_account                   = var.gcp_billing_account
  nethub_project_name               = var.gcp_infra_projects.nethub.name
  default_region1                   = var.gcp_default_region1
  orga_nethub_subnets               = var.gcp_infra_projects.nethub.network.cidr_blocks
  org_nethub_private_svc_connect_ip = var.gcp_infra_projects.nethub.network.cidr_blocks.private_svc_connect_ip

  gcp_labels = var.gcp_labels

  depends_on = [
    module.infra_projects
  ]
}


module "infra_hub_networks_transit_gw" {
  source = "../modules/shared/gcp_network_transitivity"

  environment_code             = "prod"
  mode                         = "hub"
  project_id                   = module.infra_projects.org_nethub_project_id
  default_region1              = var.gcp_default_region1
  internal_trusted_cidr_ranges = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]
  subnet_name                  = module.infra_hub_networks.private_subnets_names [0]
  vpc_name                     = module.infra_hub_networks.vpc_name
}

module "infra_nethub_bastions" {
  source = "../modules/shared/gcp_bastion_host"

  environment_code   = "prod"
  instance_name      = "prod-bastion"
  project_id         = module.infra_projects.org_nethub_project_id
  authorized_members = ["group:org-nethub-devops@belgacem.io"]
  region             = var.gcp_default_region1
  network_self_link  = module.infra_hub_networks.vpc_network_self_links
  subnet_self_link   = module.infra_hub_networks.vpc_subnetwork_self_links[0]

  depends_on = [
    module.infra_hub_networks
  ]
}