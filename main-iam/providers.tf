locals {
  tf_sa = var.gcp_terraform_sa_email
}

provider "google" {
  alias = "impersonate"

  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_service_account_access_token" "default" {
  provider               = google.impersonate
  target_service_account = local.tf_sa
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "600s"
}

/******************************************
  Provider credential configuration
 *****************************************/
provider "google" {
  access_token = data.google_service_account_access_token.default.access_token
}

provider "google-beta" {
  user_project_override = true
  access_token = data.google_service_account_access_token.default.access_token
}

provider "googleworkspace" {
  customer_id  = var.gcp_workspace_customer_id
  impersonated_user_email = var.gcp_terraform_sa_email
}