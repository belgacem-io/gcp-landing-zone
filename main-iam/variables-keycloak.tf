variable "keycloak_url" {
  description = "keycloak instance url"
  type        = string
}

variable "keycloak_realm" {
  description = "keycloak realm name"
  type        = string
}

variable "keycloak_client_id" {
  description = "keycloak client id"
  type        = string
}

variable "keycloak_ldap_bind_dn" {
  description = "Ldap admin DN"
  type        = string
}

variable "keycloak_ldap_bind_credential" {
  description = "Ldap admin credential"
  type        = string
}

variable "keycloak_ldap_users_dn" {
  description = "Ldap users DN"
  type        = string
}

variable "keycloak_ldap_server_url" {
  description = "Ldap server URL"
  type        = string
}

variable "keycloak_ldap_roles_mapper_dn" {
  description = "Ldap roles mapper DN"
  type        = string
}

variable "keycloak_ldap_roles_mapper_filter" {
  description = "Ldap roles mapper filter"
  type        = string
}

variable "keycloak_ldap_roles_mapper_name" {
  description = "Ldap roles mapper name"
  type        = string
}