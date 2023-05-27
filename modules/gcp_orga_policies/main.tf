locals {
  parent_id = split("/", var.resource_id)[1]
}
/******************************************
  Compute org policies
*******************************************/

module "org_disable_nested_virtualization" {

  count = var.disable_nested_virtualization_policy ? 1 : 0

  source         = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version        = "~> 5.2.2"
  policy_root    = var.resource_type
  policy_root_id = local.parent_id
  policy_type    = "boolean"
  rules          = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
  constraint     = "constraints/compute.disableNestedVirtualization"
}

module "org_disable_serial_port_access" {

  count = var.disable_serial_port_access_policy ? 1 : 0

  source         = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version        = "~> 5.2.2"
  policy_root    = var.resource_type
  policy_root_id = local.parent_id
  policy_type    = "boolean"
  rules          = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
  constraint     = "constraints/compute.disableSerialPortAccess"
}


module "org_compute_disable_guest_attributes_access" {
  count = var.disable_guest_attributes_access_policy ? 1 : 0

  source         = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version        = "~> 5.2.2"
  policy_root    = var.resource_type
  policy_root_id = local.parent_id
  policy_type    = "boolean"
  rules          = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
  constraint      = "constraints/compute.disableGuestAttributesAccess"
}

module "org_vm_external_ip_access" {
  count = var.vm_external_ip_access_policy !=null ? 1 : 0

  source         = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version        = "~> 5.2.2"
  policy_root    = var.resource_type
  policy_root_id = local.parent_id
  policy_type    = "list"
  rules          = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
  constraint      = "constraints/compute.vmExternalIpAccess"
}

module "org_skip_default_network" {
  count = var.skip_default_network_policy ? 1 : 0

  source         = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version        = "~> 5.2.2"
  policy_root    = var.resource_type
  policy_root_id = local.parent_id
  policy_type    = "boolean"
  rules          = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
  constraint      = "constraints/compute.skipDefaultNetworkCreation"
}

module "org_shared_vpc_lien_removal" {
  count = var.shared_vpc_lien_removal_policy ? 1 : 0

  source         = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version        = "~> 5.2.2"
  policy_root    = var.resource_type
  policy_root_id = local.parent_id
  policy_type    = "boolean"
  rules          = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
  constraint      = "constraints/compute.restrictXpnProjectLienRemoval"
}

module "org_require_os_login" {

  count = var.enable_os_login_policy ? 1 : 0

  source         = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version        = "~> 5.2.2"
  policy_root    = var.resource_type
  policy_root_id = local.parent_id
  policy_type    = "boolean"
  rules          = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
  constraint      = "constraints/compute.requireOsLogin"
}

/******************************************
  Cloud SQL
*******************************************/

module "org_cloudsql_external_ip_access" {

  count = var.enable_cloudsql_external_ip_access_policy ? 1 : 0

  source         = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version        = "~> 5.2.2"
  policy_root    = var.resource_type
  policy_root_id = local.parent_id
  policy_type    = "boolean"
  rules          = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
  constraint      = "constraints/sql.restrictPublicIp"
}

/******************************************
  IAM
*******************************************/

module "org_domain_restricted_sharing" {
  count = var.enable_domains_sharing_restriction_policy ? 1 : 0

  source           = "terraform-google-modules/org-policy/google//modules/domain_restricted_sharing"
  version          = "~> 5.0"
  organization_id  = var.resource_type == "organization" ? var.resource_id : null
  folder_id        = var.resource_type == "folder" ? var.resource_id : null
  project_id       = var.resource_type == "project" ? var.resource_id : null
  policy_for       = var.resource_type
  domains_to_allow = var.domains_to_allow
}

module "org_disable_sa_key_creation" {
  count = var.enable_sa_key_creation_deny_policy ? 1 : 0

  source         = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version        = "~> 5.2.2"
  policy_root    = var.resource_type
  policy_root_id = local.parent_id
  policy_type    = "boolean"
  rules          = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
  constraint      = "constraints/iam.disableServiceAccountKeyCreation"
}

module "org_disable_automatic_iam_grants_on_default_service_accounts" {
  count = var.disable_automatic_iam_grants_on_default_service_accounts_policy ? 1 : 0

  source         = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version        = "~> 5.2.2"
  policy_root    = var.resource_type
  policy_root_id = local.parent_id
  policy_type    = "boolean"
  rules          = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
  constraint      = "constraints/iam.automaticIamGrantsForDefaultServiceAccounts"
}

/******************************************
  Storage
*******************************************/

module "org_enforce_bucket_level_access" {
  count = var.enforce_bucket_level_access_policy ? 1 : 0

  source         = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version        = "~> 5.2.2"
  policy_root    = var.resource_type
  policy_root_id = local.parent_id
  policy_type    = "boolean"
  rules          = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
  constraint      = "constraints/storage.uniformBucketLevelAccess"
}

/******************************************
  Access Context Manager Policy
*******************************************/

resource "google_access_context_manager_access_policy" "access_policy" {
  count  = var.create_access_context_manager_access_policy ? 1 : 0
  parent = var.resource_id
  title  = "default policy"
}