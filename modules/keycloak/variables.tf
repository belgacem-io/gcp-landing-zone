variable "keycloak_url" {
  description = "keycloak instance url"
  type = string
}

variable "keycloak_realm" {
  description = "keycloak realm name"
  type = string
}

variable "keycloak_client_id" {
  description = "keycloak client id"
  type = string
}

variable "keycloak_ldap_bind_dn" {
  description = "Ldap admin DN"
  type = string
}

variable "keycloak_ldap_bind_credential" {
  description = "Ldap admin credential"
  type = string
}

variable "keycloak_ldap_users_dn" {
  description = "Ldap users DN"
  type = string
}

variable "keycloak_ldap_roles_mapper_dn" {
  description = "Ldap roles mapper DN"
  type = string
}

variable "keycloak_ldap_roles_mapper_filter" {
  description = "Ldap roles mapper filter"
  type = string
}

variable "keycloak_ldap_roles_mapper_name" {
  description = "Ldap roles mapper name"
  type = string
}

variable "keycloak_ldap_server_url" {
  description = "Ldap server URL"
  type = string
}

variable "keycloak_ou_groups" {
  type = map(object({
    name = string,
    parent = string
  }))
  default = {}
  description = "The map of groups to create. Defaults to an empty map."
}

variable "keycloak_account_groups" {
  type = map(object({
    name = string,
    parent = string
  }))
  default = {}
  description = "The map of groups to create. Defaults to an empty map."
}

variable "keycloak_roles" {
  type = map(object({
    name = string,
    group = string,
    account_id = string
    account_name = string
  }))
  default = {}
  description = "The map of roles to create. Defaults to an empty dict."
}


variable "ldap_server_name" {
  description = "LDAP server name"
  type = string
}