/******************************************
  Project creation
*****************************************/

module "organization_observability" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 14.1"
  random_project_id           = true
  create_project_sa           = false
  default_service_account     = "delete"
  name                    = var.infra_observability_project.name
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  folder_id               = google_folder.infra.id
  activate_apis           = ["logging.googleapis.com", "monitoring.googleapis.com"]

  budget_alert_pubsub_topic   = var.budget_alert_pubsub_topic
  budget_alert_spent_percents = var.budget_alert_spent_percents
  budget_amount               = var.infra_observability_project.budget.amount

  labels = {
    environment_code = "prod"
    application_name = var.infra_observability_project.name
  }

}

/******************************************
  Logs
*****************************************/
locals {
  main_logs_filter = <<EOF
    logName: /logs/cloudaudit.googleapis.com%2Factivity OR
    logName: /logs/cloudaudit.googleapis.com%2Fsystem_event OR
    logName: /logs/cloudaudit.googleapis.com%2Fdata_access OR
    logName: /logs/compute.googleapis.com%2Fvpc_flows OR
    logName: /logs/compute.googleapis.com%2Ffirewall OR
    logName: /logs/cloudaudit.googleapis.com%2Faccess_transparency
EOF
  all_logs_filter  = ""
}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

/******************************************
  Send logs to BigQuery
*****************************************/

module "log_export_to_biqquery" {
  count = var.enable_log_export_to_biqquery ? 1 : 0

  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.4"
  destination_uri        = module.bigquery_destination.0.destination_uri
  filter                 = local.main_logs_filter
  log_sink_name          = "sk-c-logging-bq"
  parent_resource_id     = split("/",var.parent_id )[1]
  parent_resource_type   = startswith("organisations",var.parent_id) ? "organisation" : "folder"
  include_children       = true
  unique_writer_identity = true
  bigquery_options = {
    use_partitioned_tables = true
  }
}

module "bigquery_destination" {
  count = var.enable_log_export_to_biqquery ? 1 : 0

  source                     = "terraform-google-modules/log-export/google//modules/bigquery"
  version                    = "~> 7.4"
  project_id                 = module.organization_observability.project_id
  dataset_name               = "audit_logs"
  log_sink_writer_identity   = module.log_export_to_biqquery.0.writer_identity
  expiration_days            = var.audit_logs_table_expiration_days
  delete_contents_on_destroy = var.audit_logs_table_delete_contents_on_destroy
}


/******************************************
  Send logs to Storage
*****************************************/

module "storage_destination" {
  count = var.enable_log_export_to_cs ? 1 : 0

  source                      = "terraform-google-modules/log-export/google//modules/storage"
  version                     = "~> 7.4"
  project_id                  = module.organization_observability.project_id
  storage_bucket_name         = "bkt-${module.organization_observability.project_id}-org-logs-${random_string.suffix.result}"
  log_sink_writer_identity    = module.log_export_to_storage.0.writer_identity
  uniform_bucket_level_access = true
  location                    = var.log_export_storage_location
  retention_policy            = var.log_export_storage_retention_policy
  force_destroy               = var.log_export_storage_force_destroy
  versioning                  = var.log_export_storage_versioning
  lifecycle_rules             = var.log_export_storage_lifecycle_rules
}

module "log_export_to_storage" {
  count = var.enable_log_export_to_cs ? 1 : 0

  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.4"
  destination_uri        = module.storage_destination.0.destination_uri
  filter                 = ""
  log_sink_name          = "sk-c-logging-bkt"
  parent_resource_id     = split("/",var.parent_id )[1]
  parent_resource_type   = startswith("organizations",var.parent_id) ? "organization" : "folder"
  include_children       = true
  unique_writer_identity = true
}

/******************************************
  Billing logs (Export configured manually)
*****************************************/

resource "google_bigquery_dataset" "billing_dataset" {
  count = var.enable_log_export_to_biqquery ? 1 : 0

  dataset_id    = "billing_data"
  project       = module.organization_observability.project_id
  friendly_name = "GCP Billing Data"
  location      = var.default_region
}

/******************************************
  Metrics
*****************************************/
resource "google_monitoring_group" "europe" {
  display_name = "Europe metrics"
  project      = module.organization_observability.project_id
  filter       = "resource.labels.zone = starts_with('europe-')"
}