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
  parent       = var.gcp_parent_resource_id
}

/******************************************
  Create projects
*****************************************/

module "network_hub_projects" {
  source                      = "terraform-google-modules/project-factory/google"
  version                     = "~> 14.1"

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
    environment_key                     = key
    project_name                        = project.name
    private_subnet_ranges               =  project.network.cidr_blocks.private_subnet_ranges
    data_subnet_ranges                  = project.network.cidr_blocks.data_subnet_ranges
    private_subnet_k8s_2nd_ranges       = project.network.cidr_blocks.private_subnet_k8s_2nd_ranges
  }) if project.environment_code == env.environment_code
  ]
  ])
}

module "env_networks" {
  source = "../modules/gcp_orga_envs_network"

  for_each = var.gcp_organization_environments

  default_region1                       = var.gcp_default_region1
  domain                                = "${ each.value.environment_code }.${var.gcp_organization_domain}"
  environment_code                      = each.value.environment_code
  org_id                                = var.gcp_organization_id
  terraform_service_account             = var.gcp_terraform_sa_email
  env_net_hub_project_id                = module.network_hub_projects[each.key].project_id
  env_net_hub_private_subnet_ranges     = each.value.network.cidr_blocks.private_subnet_ranges
  env_net_hub_data_subnet_ranges        = each.value.network.cidr_blocks.data_subnet_ranges
  env_net_hub_private_svc_subnet_ranges = each.value.network.cidr_blocks.private_svc_subnet_ranges
  org_network_hub_project_id            = data.google_projects.org_network_hub.projects[0].project_id
  org_network_hub_vpc_name              = data.google_compute_network.org_network_hub.name
  business_project_subnets              = [for subnet in local.business_project_subnets :  subnet if subnet.environment_key == each.key]


  depends_on = [
    data.google_projects.org_monitoring,
    data.google_projects.org_network_hub,
    module.network_hub_projects
  ]
}


module "shared_svc_projects" {
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
  env_network_hub_vpc_subnetwork_self_link = module.env_networks[each.key].vpc_svc_private_subnetwork_self_links
  project_name                             = format("%s-shared-svc", each.value.environment_code)
  monitoring_project_id                    = data.google_projects.org_monitoring.projects[0].project_id

  depends_on = [
    module.network_hub_projects
  ]
}

module "env_bastions" {
  source = "../modules/shared/gcp_bastion_host"

  for_each = var.gcp_organization_environments

  instance_name     = "${each.value.environment_code}-bastion"
  project_id        = module.shared_svc_projects[each.key].project_id
  host_project      = module.network_hub_projects[each.key].project_id
  members           = ["group:${each.value.environment_code}-environment-devops@belgacem.io"]
  region            = var.gcp_default_region1
  zone              = var.gcp_default_region1_azs[0]
  network_self_link = module.env_networks[each.key].vpc_network_self_links
  subnet_self_link  = module.env_networks[each.key].vpc_svc_private_subnetwork_self_links[0]

  depends_on = [
    module.network_hub_projects,
    module.shared_svc_projects
  ]
}