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

variable "default_region1" {
  type        = string
  description = "Default region 1 for subnets and Cloud Routers"
}


variable "vpc_name" {
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

