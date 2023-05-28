/******************************************
  Metrics
*****************************************/

resource "google_monitoring_monitored_project" "netenv_projects" {
  provider = google-beta

  for_each = var.gcp_org_environments

  metrics_scope = "locations/global/metricsScopes/${data.google_projects.infra_observability.projects[0].project_id}"
  name          = "locations/global/metricsScopes/${data.google_projects.infra_observability.projects[0].project_id}/projects/${module.netenv_projects[each.key].project_id}"
}