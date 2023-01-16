module "business_project" {
  source                                   = "../shared/gcp_single_project"
  org_id                                   = var.org_id
  billing_account                          = var.billing_account
  folder_id                                = var.parent_folder_id
  environment_code                         = var.environment_code
  alert_spent_percents                     = var.alert_spent_percents
  alert_pubsub_topic                       = var.alert_pubsub_topic
  budget_amount                            = var.budget_amount
  activate_apis                            = var.activate_apis
  env_network_hub_project_id               = var.env_network_hub_project_id
  env_network_hub_vpc_subnetwork_self_link = var.env_network_hub_vpc_subnetwork_self_link
  project_name                             = var.project_name
  monitoring_project_id                    = var.monitoring_project_id
}