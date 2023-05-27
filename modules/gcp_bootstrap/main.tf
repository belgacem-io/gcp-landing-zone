/**
 * Copyright 2019 Google LLC
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

locals {
  impersonation_apis         = distinct(concat(var.activate_apis, ["serviceusage.googleapis.com", "iamcredentials.googleapis.com"]))
  activate_apis              = var.sa_enable_impersonation == true ? local.impersonation_apis : var.activate_apis
  org_project_creators_tf_sa = ["serviceAccount:${var.iac_service_account_email}"]
  org_project_creators       = distinct(concat(var.org_project_creators, local.org_project_creators_tf_sa, ["group:${var.group_org_admins}"]))
  is_organization            = var.parent_folder == "" ? true : false
  parent_id                  = var.parent_folder == "" ? var.org_id : split("/", var.parent_folder)[1]
  seed_org_depends_on        = try(google_folder_iam_member.tmp_project_creator[0].etag, "") != "" ? var.org_id : google_organization_iam_member.tmp_project_creator[0].org_id
}

resource "random_id" "suffix" {
  byte_length = 2
}

/*************************************************
  Make sure group_org_admins has projectCreator.
*************************************************/

resource "google_organization_iam_member" "tmp_project_creator" {
  count = local.is_organization ? 1 : 0

  org_id = local.parent_id
  role   = "roles/resourcemanager.projectCreator"
  member = "group:${var.group_org_admins}"
}

resource "google_folder_iam_member" "tmp_project_creator" {
  count = local.is_organization ? 0 : 1

  folder = local.parent_id
  role   = "roles/resourcemanager.projectCreator"
  member = "group:${var.group_org_admins}"
}

/******************************************
  Protect IAC Project
******************************************

module "enable_cross_project_service_account_usage" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.1"

  project_id  = var.project_id
  policy_for  = "project"
  policy_type = "boolean"
  enforce     = "false"
  constraint  = "constraints/iam.disableCrossProjectServiceAccountUsage"
}
*/

/***********************************************
  GCS Bucket - Terraform State
 ***********************************************/
data "google_storage_project_service_account" "gcs_account" {
  project = var.project_id
}

module "kms" {
  count   = var.encrypt_gcs_bucket_tfstate ? 1 : 0
  source  = "terraform-google-modules/kms/google"
  version = "~> 2.1"

  project_id           = var.project_id
  location             = var.default_region
  #[prefix]-[resource]-[location]-[description]-[suffix]
  keyring              = "${var.prefix}-keyring-${var.default_region}"
  #[prefix]-[resource]-[location]-[description]-[suffix]
  keys                 = ["${var.prefix}-key-${var.default_region}"]
  key_rotation_period  = var.key_rotation_period
  key_protection_level = var.key_protection_level
  set_decrypters_for   = ["${var.prefix}-key-${var.default_region}"]
  set_encrypters_for   = ["${var.prefix}-key-${var.default_region}"]
  decrypters = [
    "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}",
  ]
  encrypters = [
    "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}",
  ]
  prevent_destroy = var.kms_prevent_destroy
}

resource "google_storage_bucket" "org_terraform_state" {
  project                     = var.project_id
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name                        = "${var.prefix}-bkt-${var.default_region}-tfstate-${random_id.suffix.hex}"
  location                    = var.default_region
  labels                      = var.storage_bucket_labels
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }

  dynamic "encryption" {
    for_each = var.encrypt_gcs_bucket_tfstate ? ["encryption"] : []
    content {
      default_kms_key_name = module.kms[0].keys["${var.prefix}-key-${var.default_region}"]
    }
  }
}

/***********************************************
  Authorative permissions at org. Required to
  remove default org wide permissions
  granting billing account and project creation.
 ***********************************************/

resource "google_organization_iam_binding" "billing_creator" {
  count = local.is_organization ? 1 : 0

  org_id = var.org_id
  role   = "roles/billing.creator"
  members = [
    "group:${var.group_billing_admins}",
  ]
}

resource "google_organization_iam_binding" "project_creator" {
  count = local.is_organization ? 1 : 0

  org_id  = local.parent_id
  role    = "roles/resourcemanager.projectCreator"
  members = local.org_project_creators
}

resource "google_folder_iam_binding" "project_creator" {
  count = local.is_organization ? 0 : 1

  folder  = local.parent_id
  role    = "roles/resourcemanager.projectCreator"
  members = local.org_project_creators
}

/***********************************************
  Organization permissions for org admins.
 ***********************************************/

resource "google_organization_iam_member" "org_admins_group" {
  for_each = local.is_organization ? toset(var.org_admins_org_iam_permissions) : toset([])

  org_id = var.org_id
  role   = each.value
  member = "group:${var.group_org_admins}"
}

/***********************************************
  Organization permissions for Terraform.
 ***********************************************/

resource "google_organization_iam_member" "tf_sa_org_perms" {
  for_each = local.is_organization ? toset(var.sa_org_iam_permissions) : toset([])

  org_id = var.org_id
  role   = each.value
  member = "serviceAccount:${var.iac_service_account_email}"
}

resource "google_billing_account_iam_member" "tf_billing_user" {
  count = var.grant_billing_user ? 1 : 0

  billing_account_id = var.billing_account
  role               = "roles/billing.user"
  member             = "serviceAccount:${var.iac_service_account_email}"
}

resource "google_storage_bucket_iam_member" "org_terraform_state_iam" {

  bucket = google_storage_bucket.org_terraform_state.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${var.iac_service_account_email}"
}

/***********************************************
  IAM - Impersonation permissions to run terraform
  as org admin.
 ***********************************************/

resource "google_service_account_iam_member" "org_admin_sa_user" {
  count = var.sa_enable_impersonation  ? 1 : 0

  service_account_id = var.iac_service_account_email
  role               = "roles/iam.serviceAccountUser"
  member             = "group:${var.group_org_admins}"
}

resource "google_service_account_iam_member" "org_admin_sa_impersonate_permissions" {
  count = var.sa_enable_impersonation ? 1 : 0

  service_account_id = var.iac_service_account_email
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "group:${var.group_org_admins}"
}

resource "google_organization_iam_member" "org_admin_serviceusage_consumer" {
  count = var.sa_enable_impersonation && local.is_organization ? 1 : 0

  org_id = local.parent_id
  role   = "roles/serviceusage.serviceUsageConsumer"
  member = "group:${var.group_org_admins}"
}

resource "google_folder_iam_member" "org_admin_service_account_user" {
  count = var.sa_enable_impersonation && !local.is_organization ? 1 : 0

  folder = local.parent_id
  role   = "roles/iam.serviceAccountUser"
  member = "group:${var.group_org_admins}"
}

resource "google_folder_iam_member" "org_admin_serviceusage_consumer" {
  count = var.sa_enable_impersonation && !local.is_organization ? 1 : 0

  folder = local.parent_id
  role   = "roles/serviceusage.serviceUsageConsumer"
  member = "group:${var.group_org_admins}"
}

resource "google_storage_bucket_iam_member" "orgadmins_state_iam" {
  count = var.sa_enable_impersonation ? 1 : 0

  bucket = google_storage_bucket.org_terraform_state.name
  role   = "roles/storage.admin"
  member = "group:${var.group_org_admins}"
}