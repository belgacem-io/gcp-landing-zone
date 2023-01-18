
module "project" {
  source                      = "terraform-google-modules/project-factory/google"
  version                     = "~> 11.1"

  random_project_id           = true
  create_project_sa           = false
  default_service_account     = "delete"
  activate_apis               = distinct(concat(var.activate_apis, ["billingbudgets.googleapis.com"]))
  name                        = var.project_name
  org_id                      = var.org_id
  billing_account             = var.billing_account
  folder_id                   = var.folder_id

  svpc_host_project_id = var.env_network_hub_project_id
  shared_vpc_subnets   = var.env_network_hub_vpc_subnetwork_self_link

  vpc_service_control_attach_enabled = var.vpc_service_control_attach_enabled
  vpc_service_control_perimeter_name = var.vpc_service_control_perimeter_name

  labels = {
    environment_code       = var.environment_code
    application_name  = var.project_name
  }
  budget_alert_pubsub_topic   = var.alert_pubsub_topic
  budget_alert_spent_percents = var.alert_spent_percents
  budget_amount               = var.budget_amount
}

/******************************************
  Metrics
*****************************************/

resource "google_monitoring_monitored_project" "primary" {
  provider      = google-beta
  metrics_scope = "locations/global/metricsScopes/${var.monitoring_project_id}"
  name          = "locations/global/metricsScopes/${var.monitoring_project_id}/projects/${module.project.project_id}"
}