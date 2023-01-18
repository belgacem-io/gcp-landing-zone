/******************************************
  Fetch data
*****************************************/

module "fetch" {
  source = "../modules/shared/gcp_fetch_organization"

  organization_id = var.gcp_organization_id
}

/******************************************
  Create business projects
*****************************************/
locals {
  authorized_internal_ip_ranges = flatten(concat(values(module.fetch.shared_subnets_by_project_and_region["exp-uc1-kube"]),
  values(module.fetch.shared_subnets_by_project_and_region["exp-sharedsvc"]))).*.ip_cidr_range
}
module "gke" {
  source = "../modules/gcp_gke"

  cluster_name                     = "gke-cluster"
  dns_zone_name                    = "exp-company-cloud"
  dns_zone                         = "exp.${var.gcp_organization_domain}"
  project_id                       = module.fetch.projects_by_name["exp-uc1-kube"].project_id
  region                           = var.gcp_default_region1
  region_azs                       = var.gcp_default_region1_azs
  network_name                     = module.fetch.network_hubs_shared_vpc_by_env_code["exp"].name
  network_self_link                = module.fetch.network_hubs_shared_vpc_by_env_code["exp"].self_link
  network_project_id               = module.fetch.network_hubs_by_env_code["exp"].project_id
  subnetwork_name                  = module.fetch.shared_subnets_by_project_and_region["exp-uc1-kube"]["europe-west4"][0].name
  pods_secondary_ip_range_name     = module.fetch.shared_subnets_by_project_and_region["exp-uc1-kube"]["europe-west4"][0].secondary_ip_range[0].range_name
  services_secondary_ip_range_name = module.fetch.shared_subnets_by_project_and_region["exp-uc1-kube"]["europe-west4"][0].secondary_ip_range[1].range_name
  master_ipv4_cidr_block           = "192.128.0.16/28"
  authorized_subnetwork_ip_ranges  = local.authorized_internal_ip_ranges
  authorized_external_ip_ranges    = var.authorized_external_ip_ranges

}