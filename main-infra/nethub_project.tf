/******************************************
  Project creation
*****************************************/

module "nethub_project" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 14.1"
  random_project_id       = true
  create_project_sa       = false
  default_service_account = "delete"
  name                    = var.gcp_infra_projects.nethub.name
  org_id                  = var.gcp_organization_id
  billing_account         = var.gcp_billing_account
  folder_id               = google_folder.infra.id
  activate_apis           = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "servicenetworking.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "billingbudgets.googleapis.com"
  ]
  budget_alert_pubsub_topic   = var.gcp_infra_projects.observability.budget.alert_pubsub_topic
  budget_alert_spent_percents = var.budget_alert_spent_percents
  budget_amount               = var.gcp_infra_projects.nethub.budget.amount

  labels = {
    environment_code = "prod"
    application_name = var.gcp_infra_projects.nethub.name
  }
}

