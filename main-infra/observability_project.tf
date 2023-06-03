/******************************************
  Project creation
*****************************************/

module "observability_project" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 14.1"
  random_project_id       = true
  create_project_sa       = false
  default_service_account = "delete"
  name                    = var.gcp_infra_projects.observability.name
  org_id                  = var.gcp_org_id
  billing_account         = var.gcp_billing_account
  folder_id               = google_folder.infra.id
  activate_apis           = ["logging.googleapis.com", "monitoring.googleapis.com"]

  budget_alert_pubsub_topic   = var.gcp_infra_projects.observability.budget.alert_pubsub_topic
  budget_alert_spent_percents = var.budget_alert_spent_percents
  budget_amount               = var.gcp_infra_projects.observability.budget.amount

  labels = merge(var.gcp_labels,{
    environment_code = "prod"
    project_role = "observability"
    application_name = var.gcp_infra_projects.observability.name
  })
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
  #[prefix]-[resource]-[location]-[description]-[suffix]
  log_sink_name          = "${var.gcp_org_name}-prod-bq-${var.gcp_default_region}-orglogs"
  parent_resource_id     = split("/", var.gcp_parent_container_id )[1]
  parent_resource_type   = startswith("organisations", var.gcp_parent_container_id) ? "organisation" : "folder"
  include_children       = true
  unique_writer_identity = true
  bigquery_options       = {
    use_partitioned_tables = true
  }
}

module "bigquery_destination" {
  count = var.enable_log_export_to_biqquery ? 1 : 0

  source                     = "terraform-google-modules/log-export/google//modules/bigquery"
  version                    = "~> 7.4"
  project_id                 = module.observability_project.project_id
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
  project_id                  = module.observability_project.project_id
  #[prefix]-[resource]-[location]-[description]-[suffix]
  storage_bucket_name         = "${var.gcp_org_name}-prod-bkt-${lower(var.log_export_storage_location)}-orglogs-${random_string.suffix.result}"
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
  #[prefix]-[resource]-[location]-[description]-[suffix]
  log_sink_name          = "${var.gcp_org_name}-prod-sk-glb-orglogs"
  parent_resource_id     = split("/", var.gcp_parent_container_id )[1]
  parent_resource_type   = startswith("organizations", var.gcp_parent_container_id) ? "organization" : "folder"
  include_children       = true
  unique_writer_identity = true
}

/******************************************
  Billing logs (Export configured manually)
*****************************************/

resource "google_bigquery_dataset" "billing_dataset" {
  count = var.enable_log_export_to_biqquery ? 1 : 0

  dataset_id    = "billing_data"
  project       = module.observability_project.project_id
  friendly_name = "GCP Billing Data"
  location      = var.gcp_default_region
}

/******************************************
  Metrics
*****************************************/
resource "google_monitoring_group" "europe" {
  display_name = "Europe metrics"
  project      = module.observability_project.project_id
  filter       = "resource.labels.zone = starts_with('europe-')"
}