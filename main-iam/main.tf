# Doc : https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs

# Pre requisites : source .env to set
#   export KEYCLOAK_CLIENT_SECRET=UUID \
#   export KEYCLOAK_CLIENT_TIMEOUT=5 \
# Realm cloud-public created with 1 client terraform,
#      on Service account tab : realm managment -> add realm admin

# Configure the Keycloak Provider
provider "keycloak" {
  client_id = var.keycloak_client_id
  url       = var.keycloak_url
  realm     = var.keycloak_realm
}

module "keycloak" {
  source = "../modules/keycloak"

  keycloak_url                      = var.keycloak_url
  keycloak_realm                    = var.keycloak_realm
  keycloak_client_id                = var.keycloak_client_id
  keycloak_ldap_server_url          = var.keycloak_ldap_server_url
  keycloak_ldap_bind_dn             = var.keycloak_ldap_bind_dn
  keycloak_ldap_users_dn            = var.keycloak_ldap_users_dn
  keycloak_ldap_bind_credential     = var.keycloak_ldap_bind_credential
  keycloak_ldap_roles_mapper_dn     = var.keycloak_ldap_roles_mapper_dn
  keycloak_ldap_roles_mapper_filter = var.keycloak_ldap_roles_mapper_filter
  keycloak_ldap_roles_mapper_name   = var.keycloak_ldap_roles_mapper_name
}

locals {

  users = distinct(concat(flatten(values(var.gcp_iam_groups).*.managers), flatten(values(var.gcp_iam_groups).*.members)))
}
// use the keycloak_user data source to grab users
data "keycloak_user" "users" {
  for_each = toset(local.users)

  realm_id = module.keycloak.realm.id
  username = each.value
}

locals {
  gcp_iam_groups = {for key,group in var.gcp_iam_groups : key => merge(group,{
    email       = "${ group.name }@${var.gcp_organization_name}"
    members    = formatlist("%s@${var.gcp_organization_name}", group.members)
    managers   = formatlist("%s@${var.gcp_organization_name}", group.managers)
  })
  }

}
module "gcp_iam" {
  source = "../modules/gcp_iam"

  domain                  = var.gcp_organization_name
  organization_id         = var.gcp_organization_id
  default_super_admins    = [
    "hassene.belgacem@belgacem.io",
    var.gcp_terraform_sa_email
  ]
  iam_users               = {
  for user in local.users : user =>{
    given_name  = data.keycloak_user.users[user].first_name
    family_name = data.keycloak_user.users[user].last_name
    email       = "${user}@${var.gcp_organization_name}"
  }
  }
  iam_groups              = local.gcp_iam_groups
  organization_iam_groups = {for k, v in local.gcp_iam_groups : k => v if v.folders ==null && v.projects ==null}
  folder_iam_groups       = {for k, v in local.gcp_iam_groups : k => v if v.folders !=null}
  project_iam_groups      = {for k, v in local.gcp_iam_groups : k => v if v.projects !=null}
}
#