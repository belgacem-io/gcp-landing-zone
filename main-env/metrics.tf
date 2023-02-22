/******************************************
  Metrics
*****************************************/

resource "google_monitoring_monitored_project" "nethub_projects" {
  provider = google-beta

  for_each = var.gcp_organization_environments

  metrics_scope = "locations/global/metricsScopes/${data.google_projects.org_monitoring.projects[0].project_id}"
  name          = "locations/global/metricsScopes/${data.google_projects.org_monitoring.projects[0].project_id}/projects/${module.env_nethub_projects[each.key].project_id}"
}