/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/******************************************
  Audit Logs - IAM
*****************************************/

resource "google_organization_iam_audit_config" "org_config" {
  count = var.gcp_group_org_admins !=null ? 1 : 0

  org_id  = var.gcp_organization_id
  service = "allServices"

  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
  audit_log_config {
    log_type = "ADMIN_READ"
  }
}

resource "google_project_iam_member" "audit_log_bq_user" {
  count = var.gcp_group_org_security_admins !=null ? 1 : 0

  project = module.observability_project.project_id
  role    = "roles/bigquery.user"
  member  = "group:${var.gcp_group_org_security_admins}"
}

resource "google_project_iam_member" "audit_log_bq_data_viewer" {
  count = var.gcp_group_org_security_admins !=null ? 1 : 0

  project = module.observability_project.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "group:${var.gcp_group_org_security_admins}"
}

/******************************************
  Billing BigQuery - IAM
*****************************************/

resource "google_project_iam_member" "billing_bq_user" {
  count = var.gcp_group_org_billing_admins !=null ? 1 : 0

  project = module.observability_project.project_id
  role    = "roles/bigquery.user"
  member  = "group:${var.gcp_group_org_billing_admins}"
}

resource "google_project_iam_member" "billing_bq_viewer" {
  count = var.gcp_group_org_billing_admins !=null ? 1 : 0

  project = module.observability_project.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "group:${var.gcp_group_org_billing_admins}"
}

/******************************************
  Billing Cloud Console - IAM
*****************************************/

resource "google_organization_iam_member" "billing_viewer" {
  count = var.gcp_group_org_billing_viewers !=null ? 1 : 0

  org_id = var.gcp_organization_id
  role   = "roles/billing.viewer"
  member = "group:${var.gcp_group_org_billing_viewers}"
}

/******************************************
 Groups permissions according to SFB (Section 6.2 - Users and groups) - IAM
*****************************************/

resource "google_organization_iam_member" "organization_viewer" {
  count = var.gcp_group_org_viewers !=null ? 1 : 0

  org_id = var.gcp_organization_id
  role   = "roles/viewer"
  member = "group:${var.gcp_group_org_viewers}"
}

resource "google_organization_iam_member" "security_reviewer" {
  count = var.gcp_group_org_security_reviewers !=null ? 1 : 0

  org_id = var.gcp_organization_id
  role   = "roles/iam.securityReviewer"
  member = "group:${var.gcp_group_org_security_reviewers}"
}

resource "google_organization_iam_member" "network_viewer" {
  count = var.gcp_group_org_network_viewers !=null ? 1 : 0

  org_id = var.gcp_organization_id
  role   = "roles/compute.networkViewer"
  member = "group:${var.gcp_group_org_network_viewers}"
}

resource "google_project_iam_member" "audit_log_viewer" {
  count = var.gcp_group_org_security_reviewers !=null ? 1 : 0

  project = module.observability_project.project_id
  role    = "roles/logging.viewer"
  member  = "group:${var.gcp_group_org_security_reviewers}"
}

resource "google_project_iam_member" "audit_private_logviewer" {
  count = var.gcp_group_org_security_reviewers !=null ? 1 : 0

  project = module.observability_project.project_id
  role    = "roles/logging.privateLogViewer"
  member  = "group:${var.gcp_group_org_security_reviewers}"
}

resource "google_project_iam_member" "audit_bq_data_viewer" {
  count = var.gcp_group_org_security_reviewers !=null ? 1 : 0

  project = module.observability_project.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "group:${var.gcp_group_org_security_reviewers}"
}

resource "google_project_iam_member" "scc_admin" {
  count = var.gcp_group_org_security_admins !=null ? 1 : 0

  project = module.security_project.project_id
  role    = "roles/securitycenter.adminEditor"
  member  = "group:${var.gcp_group_org_security_admins}"
}


/******************************************
 Privileged accounts permissions according to SFB (Section 6.3 - Privileged identities)
*****************************************/

resource "google_organization_iam_member" "org_admin_user" {
  count = var.gcp_group_org_admins !=null ? 1 : 0

  org_id = var.gcp_organization_id
  role   = "roles/resourcemanager.organizationAdmin"
  member = "group:${var.gcp_group_org_admins}"
}

resource "google_organization_iam_member" "billing_creator_user" {
  count = var.gcp_group_org_billing_admins !=null ? 1 : 0

  org_id = var.gcp_organization_id
  role   = "roles/billing.creator"
  member = "group:${var.gcp_group_org_billing_admins}"
}

resource "google_billing_account_iam_member" "billing_admin_user" {
  count = var.gcp_group_org_billing_admins !=null ? 1 : 0

  billing_account_id = var.gcp_billing_account
  role               = "roles/billing.admin"
  member             = "group:${var.gcp_group_org_billing_admins}"
}