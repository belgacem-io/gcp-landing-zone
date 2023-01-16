/******************************************
  Org Network Hub
*****************************************/

data "google_projects" "org_network_hub" {
  filter = "parent.id:${split("/", data.google_active_folder.infra.name)[1]} labels.application_name=${var.gcp_infra_projects.networking_hub.name} lifecycleState=ACTIVE"
}

data "google_projects" "org_monitoring" {
  filter = "parent.id:${split("/", data.google_active_folder.infra.name)[1]} labels.application_name=${var.gcp_infra_projects.observability.name} lifecycleState=ACTIVE"
}

data "google_compute_network" "org_network_hub" {
  name    = "vpc-prod-shared-hub"
  project = data.google_projects.org_network_hub.projects[0].project_id
}

data "google_active_folder" "infra" {
  display_name = var.gcp_infra_folder_name
  parent       = "organizations/${var.gcp_organization_id}"
}

/******************************************
  Create projects
*****************************************/

module "network_hub_projects" {
  source                      = "terraform-google-modules/project-factory/google"
  version                     = "~> 10.1"

  for_each = var.gcp_organization_environments

  random_project_id           = "true"
  name                        = format("%s-network-hub", each.value.environment_code)
  org_id                      = var.gcp_organization_id
  billing_account             = var.gcp_billing_account
  folder_id                   = google_folder.environments[each.key].id
  disable_services_on_destroy = false
  activate_apis = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "servicenetworking.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "billingbudgets.googleapis.com"
  ]

  labels = {
    environment_code       = each.value.environment_code
    application_name  = "network-hub"
  }
  budget_alert_pubsub_topic   = var.gcp_infra_projects.observability.budget.alert_pubsub_topic
  budget_alert_spent_percents = var.gcp_alert_spent_percents
  budget_amount               = 100
}



locals {
  business_project_subnets = flatten([
  for key, env in var.gcp_organization_environments : [
  for project in var.gcp_business_projects : merge(project, {
    environment_key          = key
    project_name             = project.name
    region1_primary_ranges   = project.network.cidr_blocks.region1_primary_ranges
    region2_primary_ranges   = project.network.cidr_blocks.region2_primary_ranges
    region1_secondary_ranges = project.network.cidr_blocks.region1_secondary_ranges
    region2_secondary_ranges = project.network.cidr_blocks.region2_secondary_ranges
  }) if project.environment_code == env.environment_code
  ]
  ])
}

module "env_networks" {
  source = "../modules/gcp_orga_envs_network"

  for_each = var.gcp_organization_environments

  default_region1                       = var.gcp_default_region1
  default_region2                       = var.gcp_default_region2
  domain                                = "${ each.value.environment_code }.${var.gcp_organization_name}"
  environment_code                      = each.value.environment_code
  org_id                                = var.gcp_organization_id
  terraform_service_account             = var.gcp_terraform_sa_email
  env_network_hub_project_id            = module.network_hub_projects[each.key].project_id
  org_network_hub_project_id            = data.google_projects.org_network_hub.projects[0].project_id
  org_network_hub_vpc_name              = data.google_compute_network.org_network_hub.name
  business_project_subnets              = [for subnet in local.business_project_subnets :  subnet if subnet.environment_key == each.key]
  common_services_subnet_region1_ranges = each.value.network.cidr_blocks.region1_primary_ranges
  common_services_subnet_region2_ranges = each.value.network.cidr_blocks.region2_primary_ranges
  private_service_cidr                  = each.value.network.cidr_blocks.private_service_range
}


module "shared_services_projects" {
  source = "../modules/shared/gcp_single_project"

  for_each = var.gcp_organization_environments

  org_id               = var.gcp_organization_id
  billing_account      = var.gcp_billing_account
  folder_id            = google_folder.environments[each.key].id
  environment_code     = each.value.environment_code
  alert_spent_percents = var.gcp_alert_spent_percents
  alert_pubsub_topic   = var.gcp_infra_projects.observability.budget.alert_pubsub_topic
  budget_amount        = 100
  activate_apis        = [
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "networkmanagement.googleapis.com",
    "storage-api.googleapis.com",
    "oslogin.googleapis.com",
    "logging.googleapis.com",
    "billingbudgets.googleapis.com",
    "iap.googleapis.com"
  ]

  env_network_hub_project_id               = module.network_hub_projects[each.key].project_id
  env_network_hub_vpc_subnetwork_self_link = module.env_networks[each.key].vpc_common_services_subnetwork_self_links
  project_name                             = format("%s-shared-services", each.value.environment_code)
  monitoring_project_id                    = data.google_projects.org_monitoring.projects[0].project_id

}

module "env_bastions" {
  source = "../modules/shared/gcp_bastion_host"

  for_each = var.gcp_organization_environments

  instance_name     = "${each.value.environment_code}-bastion"
  project_id        = module.shared_services_projects[each.key].project_id
  host_project      = module.network_hub_projects[each.key].project_id
  members           = ["group:${each.value.environment_code}-environment-devops@company.cloud"]
  region            = var.gcp_default_region1
  zone              = var.gcp_default_region1_azs[0]
  network_self_link = module.env_networks[each.key].vpc_network_self_links
  subnet_self_link  = module.env_networks[each.key].vpc_common_services_subnetwork_self_links_by_region[var.gcp_default_region1][0]
}