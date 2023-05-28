/******************************************
  Fetch data
*****************************************/

module "fetch" {
  source                    = "../modules/gcp_fetch_organization"
  organization_name         = var.gcp_org_name
  default_region            = var.gcp_default_region
  parent_container_id       = var.gcp_parent_container_id
  infra_nethub_network_name = var.gcp_infra_projects.nethub.network.name
}

/******************************************
  Create business projects
*****************************************/

module "business_project" {

  for_each = local.business_projects_map

  source                  = "../modules/gcp_single_project"
  billing_account         = var.gcp_billing_account
  environment_code        = each.value.environment_code
  org_id                  = var.gcp_org_id
  #[prefix]-[env]
  project_name            = "${var.gcp_org_name}-${each.value.name}-${each.value.environment_code}"
  folder_id               = module.fetch.folders_by_env_code[each.value.environment_code][each.value.department].name
  netenv_project_id       = module.fetch.netenv_projects_by_env_code[each.value.environment_code].project_id
  netenv_subnet_self_link = [
    for self_link in module.fetch.netenv_networks_by_env_code[each.value.environment_code].subnetworks_self_links :
    self_link if length(regexall("${each.value.environment_code}-${each.value.name}-.*", self_link)) > 0
  ]
  activate_apis = [
    "iam.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "networkmanagement.googleapis.com",
    "artifactregistry.googleapis.com",
    "sqladmin.googleapis.com"
  ]
  monitoring_project_id = module.fetch.projects_by_name[var.gcp_infra_projects.observability.name].project_id

  depends_on = [
    module.fetch
  ]
}