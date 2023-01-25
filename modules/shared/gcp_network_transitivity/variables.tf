variable "project_id" {
  type        = string
  description = "VPC Project ID"
}
variable "mode" {
  type        = string
  description = "Network deployment mode, should be set to `hub` or `spoke`."
}

variable "environment_code" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "default_region" {
  type        = string
  description = "Default region 1 for subnets and Cloud Routers"
}


variable "network_self_link" {
  description = "The GCP VPC network link for the cluster to be built in."
  type        = string
}

variable "network_name" {
  description = "The GCP VPC network name for the cluster to be built in."
  type        = string
}

variable "subnet_name" {
  description = "The subnet in the VPC for the proxy cluster to be deployed to."
  type        = string
}
variable "internal_trusted_cidr_ranges" {
  description = "Internal trusted ip ranges. Must be set to private ip ranges"
  type = list(string)
  default = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]
}

variable "private_svc_connect_ip" {
  description = "The internal IP to be used for the private service connect. Required for hub mode"
  type        = string
  default = null
}

variable "private_svc_connect_subnets_ids" {
  type        = list(string)
  description = "The list of subnets where service Private Service Connect will be published."
}
