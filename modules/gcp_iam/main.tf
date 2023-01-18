## Create users
resource "googleworkspace_user" "users" {

  for_each = var.iam_users

  primary_email = each.value.email
  password      = "34819d7beeabb9260a5c854bc85b3e44"
  hash_function = "MD5"

  name {
    family_name = each.value.family_name
    given_name  = each.value.given_name
  }

  lifecycle {
    ignore_changes = [
      posix_accounts,
      ssh_public_keys,
      ssh_public_keys,
      languages,
      last_login_time
    ]
  }
}

#Create default groups
module "organization_iam_groups" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.4"

  for_each = var.iam_groups

  id           = each.value.email
  display_name = each.value.name
  description  = each.value.name
  domain       = var.domain
  owners       = var.default_super_admins
  members      = each.value.members
  managers     = each.value.managers

}


module "organization_iam_groups_bindings" {
  source        = "terraform-google-modules/iam/google//modules/organizations_iam"
  version = "~> 7.4"

  organizations = [var.organization_id]
  mode          = "authoritative"

  bindings = local.organization_iam_groups_bindings
}

module "folders_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  for_each = local.folder_iam_groups_bindings

  folders = [each.key]
  bindings = each.value
}

module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.4"

  for_each = local.project_iam_groups_bindings

  projects = [each.key]
  bindings = each.value
}