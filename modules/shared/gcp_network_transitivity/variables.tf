variable "project_id" {
  type        = string
  description = "Project ID for Private Shared VPC."
}

variable "prefix" {
  type        = string
  description = "Prefix applied to service to all resources."
}

variable "network_name" {
  type        = string
  description = "The network name."
}
variable "subnetwork_name" {
  type        = string
  description = "The subnetwork name."
}

variable "environment_code" {
  type        = string
  description = "A short form of the folder level resources (environment) within the Google Cloud organization."
}

variable "default_region" {
  type        = string
  description = "Default region 1 for subnets and Cloud Routers"
}

variable "internal_trusted_cidr_ranges" {
  description = "Internal trusted ip ranges. Must be set to private ip ranges"
  type        = list(string)
}

variable "enable_inter_vpc_gateway" {
  description = "If enabled, an internal transit gateway will be created and traffic can flow between VPCs"
  type        = bool
}

variable "enable_internet_gateway" {
  description = "If enabled, a transparent gateway will be created and traffic can flow from VPCs to internet."
  type        = bool
}

variable "org_private_ca" {
  type        = object({
    cert = string
    key  = string
  })
  default     = null
  description = "The Organization CertificateAuthority's certificate. Required in squid mode"
}