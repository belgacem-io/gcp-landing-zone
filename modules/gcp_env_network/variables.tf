variable "environment_code" {
  type = string
}
variable "prefix" {
  type        = string
  description = "Prefix applied to service to all resources."
}

variable "infra_nethub_project_id" {
  type        = string
  description = "Organization hub network project id"
}

variable "infra_nethub_networks" {
  type        = map(object({
    self_link   = string
    has_private_dns = bool
  }))
  description = "Organization hub networks"
}

variable "project_id" {
  type        = string
  description = "Environment hub network project id"
}

variable "org_id" {
  type        = string
  description = "Organization ID"
}

variable "project_name" {
  type        = string
  description = "Subnet prefix for env nethub project"
}

variable "default_region" {
  type        = string
  description = "First subnet region. The shared vpc modules only configures two regions."
}

variable "public_domain" {
  type        = string
  description = "The Public domain of your organization"
}

variable "private_domain" {
  type        = string
  description = "The Private domain of your organization"
}


variable "private_subnet_ranges" {
  type = list(string)
}

variable "data_subnet_ranges" {
  type = list(string)
}

variable "business_project_subnets" {
  description = "Default subnets for Organization network hub."
  type        = list(object({
    project_name                  = string
    environment_code              = string
    private_subnet_ranges         = list(string)
    data_subnet_ranges            = list(string)
  }))
}

variable "network_name" {
  type        = string
  description = "The network name."
}

variable "trusted_egress_ranges" {
  type        = list(string)
  description = "List of network ranges to which all egress traffic will be allowed"
}

variable "trusted_ingress_ranges" {
  type        = list(string)
  description = "List of network ranges from which all ingress traffic will be allowed"
}

variable "trusted_private_ranges" {
  type        = list(string)
  description = "List of network ranges from which internal traffic will be allowed"
}

variable "labels" {
  type        = map(string)
  description = "Map of labels"
}