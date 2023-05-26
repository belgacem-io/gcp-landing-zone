variable "environment_code" {
  type = string
}
variable "prefix" {
  type        = string
  description = "Prefix applied to service to all resources."
}
variable "org_nethub_vpc_self_link" {
  type        = string
  description = "Organization hub network VPC self link"
}

variable "org_nethub_project_id" {
  type        = string
  description = "Organization hub network project id"
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

variable "domain" {
  type        = string
  description = "The DNS name of peering managed zone, for instance 'example.com.'. Must end with a period."
}

variable "private_subnet_ranges" {
  type = list(string)
}

variable "data_subnet_ranges" {
  type = list(string)
}

variable "reserved_subnets" {
  type = map(object({
    purpose = string
    role    = string
    range   = string
  }))
  description = "The list of reserved subnet for appliances like SVC and proxies."
  default     = {}
}

variable "private_svc_connect_ip" {
  type        = string
  description = "The internal IP to be used for the private service connect. Required for hub mode"
}

variable "business_project_subnets" {
  description = "Default subnets for Organization network hub."
  type        = list(object({
    project_name                  = string
    environment_code              = string
    private_subnet_ranges         = list(string)
    data_subnet_ranges            = list(string)
    private_subnet_k8s_2nd_ranges = list(string)
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