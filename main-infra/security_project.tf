/******************************************
  Project creation
*****************************************/

module "security_project" {
  source                      = "terraform-google-modules/project-factory/google"
  version                     = "~> 14.1"
  random_project_id           = true
  create_project_sa           = false
  default_service_account     = "delete"
  name                        = var.gcp_infra_projects.security.name
  org_id                      = var.gcp_org_id
  billing_account             = var.gcp_billing_account
  folder_id                   = google_folder.infra.folder_id
  activate_apis               = ["logging.googleapis.com", 
    "bigquery.googleapis.com",
    "billingbudgets.googleapis.com"]
  budget_alert_pubsub_topic   = var.gcp_infra_projects.observability.budget.alert_pubsub_topic
  budget_alert_spent_percents = var.budget_alert_spent_percents
  budget_amount               = var.gcp_infra_projects.security.budget.amount

  labels = {
    environment_code = "prod"
    project_role = "security"
    application_name = var.gcp_infra_projects.security.name
  }

}

/******************************************
  SCC Notification
*****************************************/

resource "google_pubsub_topic" "scc_notification_topic" {
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name    = "${var.gcp_org_name}-prod-pst-glob-sccnotif"
  project = module.security_project.project_id
}

resource "google_pubsub_subscription" "scc_notification_subscription" {
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name    = "${var.gcp_org_name}-prod-ps-glb-sccnotif"
  topic   = google_pubsub_topic.scc_notification_topic.name
  project = module.security_project.project_id
}

resource "google_scc_notification_config" "scc_notification_config" {
  count = var.enable_scc_notification ? 1 : 0

  config_id    = var.scc_notification_name
  organization = var.gcp_org_id
  description  = "SCC Notification for all active findings"
  pubsub_topic = google_pubsub_topic.scc_notification_topic.id

  streaming_config {
    filter = var.scc_notification_filter
  }
}