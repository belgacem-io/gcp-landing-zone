/******************************************
  Project creation
*****************************************/

module "organization_security" {
  source                      = "terraform-google-modules/project-factory/google"
  version                     = "~> 11.1"
  random_project_id           = "true"
  default_service_account     = "deprivilege"
  name                        = var.infra_security_project.name
  org_id                      = var.organization_id
  billing_account             = var.billing_account
  folder_id                   = google_folder.infra.folder_id
  activate_apis               = ["logging.googleapis.com", "bigquery.googleapis.com", "billingbudgets.googleapis.com"]
  budget_alert_pubsub_topic   = var.budget_alert_pubsub_topic
  budget_alert_spent_percents = var.budget_alert_spent_percents
  budget_amount               = var.infra_security_project.budget.amount

  labels = {
    environment_code       = "prod"
    application_name  = var.infra_security_project.name
  }

}

/******************************************
  SCC Notification
*****************************************/

resource "google_pubsub_topic" "scc_notification_topic" {
  name    = "top-scc-notification"
  project = module.organization_security.project_id
}

resource "google_pubsub_subscription" "scc_notification_subscription" {
  name    = "sub-scc-notification"
  topic   = google_pubsub_topic.scc_notification_topic.name
  project = module.organization_security.project_id
}

resource "google_scc_notification_config" "scc_notification_config" {
  count = var.enable_scc_notification ? 1 : 0

  config_id    = var.scc_notification_name
  organization = var.organization_id
  description  = "SCC Notification for all active findings"
  pubsub_topic = google_pubsub_topic.scc_notification_topic.id

  streaming_config {
    filter = var.scc_notification_filter
  }
}