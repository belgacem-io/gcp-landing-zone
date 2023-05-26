/******************************************
  Org Network Hub
*****************************************/

data "google_projects" "infra_nethub" {
  filter = "parent.id:${split("/", data.google_active_folder.infra.name)[1]} labels.application_name=${var.gcp_infra_projects.nethub.name} lifecycleState=ACTIVE"
}

data "google_projects" "infra_monitoring" {
  filter = "parent.id:${split("/", data.google_active_folder.infra.name)[1]} labels.application_name=${var.gcp_infra_projects.observability.name} lifecycleState=ACTIVE"
}

data "google_compute_network" "infra_nethub" {
  name    = "vpc-prod-shared-hub"
  project = data.google_projects.infra_nethub.projects[0].project_id
}

data "google_active_folder" "infra" {
  display_name = var.gcp_infra_projects.folder
  parent       = var.gcp_parent_container_id
}

locals {
  business_project_subnets = flatten([
    for key, env in var.gcp_organization_environments : [
      for project in var.gcp_business_projects : merge(project, {
        environment_key               = key
        project_name                  = project.name
        private_subnet_ranges         = project.network.cidr_blocks.private_subnet_ranges
        data_subnet_ranges            = project.network.cidr_blocks.data_subnet_ranges
        private_subnet_k8s_2nd_ranges = project.network.cidr_blocks.private_subnet_k8s_2nd_ranges
      }) if project.environment_code == env.environment_code
    ]
  ])
}
/******************************************
  Create projects
*****************************************/

module "netenv_projects" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.1"

  for_each = var.gcp_organization_environments

  random_project_id       = true
  create_project_sa       = false
  default_service_account = "delete"

  #[prefix]-[env]
  name            = "${each.value.name}-${each.value.environment_code}"
  org_id          = var.gcp_organization_id
  billing_account = var.gcp_billing_account
  folder_id       = google_folder.environments[each.key].id
  activate_apis   = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "servicenetworking.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "billingbudgets.googleapis.com"
  ]

  labels = {
    environment_code = each.value.environment_code
    application_name = each.value.name
  }
  budget_alert_pubsub_topic   = var.gcp_infra_projects.observability.budget.alert_pubsub_topic
  budget_alert_spent_percents = var.gcp_alert_spent_percents
  budget_amount               = 100
}

module "netenv_networks" {
  source = "../modules/gcp_env_network"

  for_each = var.gcp_organization_environments

  default_region             = var.gcp_default_region
  domain                     = "${ each.value.environment_code }.${var.gcp_organization_domain}"
  prefix                     = var.gcp_organization_prefix
  environment_code           = each.value.environment_code
  org_id                     = var.gcp_organization_id
  project_id                 = module.netenv_projects[each.key].project_id
  network_name               = each.value.network.name
  private_subnet_ranges      = each.value.network.cidr_blocks.private_subnet_ranges
  data_subnet_ranges         = each.value.network.cidr_blocks.data_subnet_ranges
  private_svc_connect_ranges = each.value.network.cidr_blocks.private_svc_subnet_ranges
  project_name               = each.value.name
  private_svc_connect_ip     = each.value.network.cidr_blocks.private_svc_connect_ip
  infra_nethub_project_id      = data.google_projects.infra_nethub.projects[0].project_id
  infra_nethub_vpc_self_link   = data.google_compute_network.infra_nethub.self_link
  trusted_egress_ranges      = var.trusted_egress_ranges
  trusted_ingress_ranges     = var.trusted_ingress_ranges
  trusted_private_ranges     = var.trusted_private_ranges
  business_project_subnets   = [
    for subnet in local.business_project_subnets :  subnet if subnet.environment_key == each.key
  ]


  depends_on = [
    data.google_projects.infra_monitoring,
    data.google_projects.infra_nethub,
    module.netenv_projects
  ]
}

module "netenv_bastions" {
  source = "../modules/gcp_bastion_host"

  for_each = var.gcp_organization_environments

  prefix             = var.gcp_organization_prefix
  environment_code   = each.value.environment_code
  instance_name      = "${each.value.environment_code}-bastion"
  project_id         = module.netenv_projects[each.key].project_id
  authorized_members = ["group:${each.value.environment_code}-env-nethub-devops@belgacem.io"]
  region             = var.gcp_default_region
  network_self_link  = module.netenv_networks[each.key].network_self_links
  subnet_self_link   = module.netenv_networks[each.key].subnetwork_self_links[0]

  depends_on = [
    module.netenv_networks
  ]
}