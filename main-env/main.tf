/******************************************
  Data
*****************************************/

data "google_projects" "infra_nethub" {
  filter = "parent.id:${split("/", data.google_active_folder.infra.name)[1]} labels.application_name=${var.gcp_infra_projects.nethub.name} lifecycleState=ACTIVE"
}

data "google_projects" "infra_observability" {
  filter = "parent.id:${split("/", data.google_active_folder.infra.name)[1]} labels.application_name=${var.gcp_infra_projects.observability.name} lifecycleState=ACTIVE"
}

data "google_compute_network" "infra_nethub" {
  for_each = var.gcp_infra_projects.nethub.networks

  name    = "${var.gcp_org_name}-prod-network-${var.gcp_default_region}-${each.key}"
  project = data.google_projects.infra_nethub.projects[0].project_id
}

data "google_active_folder" "infra" {
  display_name = var.gcp_infra_projects.folder
  parent       = var.gcp_parent_container_id
}

locals {
  business_project_subnets = flatten([
    for key, env in var.gcp_org_environments : [
      for project in var.gcp_business_projects : merge(project, {
        environment_key       = key
        project_name          = project.name
        private_subnet_ranges = project.network.cidr_blocks.private_subnet_ranges
        data_subnet_ranges    = project.network.cidr_blocks.data_subnet_ranges
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

  for_each = var.gcp_org_environments

  random_project_id       = true
  create_project_sa       = false
  default_service_account = "delete"

  #[prefix]-[env]
  name            = "${each.value.name}-${each.value.environment_code}"
  org_id          = var.gcp_org_id
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
    project_role     = "netenv"
  }
  budget_alert_pubsub_topic   = var.gcp_infra_projects.observability.budget.alert_pubsub_topic
  budget_alert_spent_percents = var.gcp_alert_spent_percents
  budget_amount               = 100
}

/******************************************
  Create Networks
*****************************************/

module "netenv_networks" {
  source = "../modules/gcp_env_network"

  for_each = var.gcp_org_environments

  default_region                   = var.gcp_default_region
  private_domain                   = var.gcp_org_private_domain
  public_domain                    = var.gcp_org_public_domain
  prefix                           = "${ var.gcp_org_name }-${each.value.environment_code}"
  environment_code                 = each.value.environment_code
  org_id                           = var.gcp_org_id
  project_id                       = module.netenv_projects[each.key].project_id
  network_name                     = each.value.network.name
  private_subnet_ranges            = each.value.network.cidr_blocks.private_subnet_ranges
  data_subnet_ranges               = each.value.network.cidr_blocks.data_subnet_ranges
  project_name                     = each.value.name
  infra_nethub_project_id          = data.google_projects.infra_nethub.projects[0].project_id
  infra_nethub_networks            = {
    for key, net in data.google_compute_network.infra_nethub :
    key => {
        self_link       = net.self_link
        has_private_dns = key == var.gcp_infra_projects.nethub.networks.corp.name
    }
  }
  trusted_egress_ranges    = var.trusted_egress_ranges
  trusted_ingress_ranges   = var.trusted_ingress_ranges
  trusted_private_ranges   = var.trusted_private_ranges
  business_project_subnets = [
    for subnet in local.business_project_subnets :  subnet if subnet.environment_key == each.key
  ]


  depends_on = [
    data.google_projects.infra_observability,
    data.google_projects.infra_nethub,
    module.netenv_projects
  ]
}

/******************************************
  Create Bastions
*****************************************/

module "netenv_bastions" {
  source = "../modules/gcp_bastion_host"

  for_each = var.gcp_org_environments

  prefix             = "${ var.gcp_org_name }-${each.value.environment_code}"
  environment_code   = each.value.environment_code
  instance_name      = "${each.value.environment_code}-bastion"
  project_id         = module.netenv_projects[each.key].project_id
  authorized_members = []
  region             = var.gcp_default_region
  network_self_link  = module.netenv_networks[each.key].network_self_links
  subnet_self_link   = module.netenv_networks[each.key].subnetwork_self_links[0]

  depends_on = [
    module.netenv_networks
  ]
}