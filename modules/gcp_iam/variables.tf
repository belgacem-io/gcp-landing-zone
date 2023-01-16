variable "domain" {
  type        = string
  description = "Organization domain"
}
variable "organization_id" {
  description = "The organization id for the associated services"
  type        = string
}

variable "iam_users" {
  type        = map(object({
    given_name  = string
    family_name = string
    email       = string
  }))
  description = "IAM users to import to workspace"
}
variable "iam_groups" {
  type        = map(object({
    name     = string
    email    = string
    members  = list(string)
    managers = list(string)
  }))
  description = "Organization groups to create"
  default     = {}
}

variable "organization_iam_groups" {
  type        = map(object({
    name     = string
    email    = string
    roles    = list(string)
    members  = list(string)
    managers = list(string)
  }))
  description = "Organization groups/roles at organization level"
  default     = {}
}

variable "folder_iam_groups" {
  type        = map(object({
    name     = string
    email    = string
    folders  = list(string)
    roles    = list(string)
    members  = list(string)
    managers = list(string)
  }))
  description = "Organization groups  at folder level"
  default     = {}
}

variable "project_iam_groups" {
  type        = map(object({
    name     = string
    email    = string
    projects = list(string)
    roles    = list(string)
    members  = list(string)
    managers = list(string)
  }))
  description = "Organization groups  at project level"
  default     = {}
}

variable "default_super_admins" {
  type        = list(string)
  description = "Default organization super admins"
}