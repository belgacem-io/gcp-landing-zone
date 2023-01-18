variable "project_name" {
  description = "The project name of your GCP project"
  type = string
}

variable "vpc_name" {
  description = "The GCP VPC network name for the cluster to be built in."
  type = string
}

variable "subnet_name" {
  description = "The subnet in the VPC for the proxy cluster to be deployed to."
  type = string
}

variable "service_root_name" {
  description = "Root name that all cloud objects will be named with."
  type = string
}

variable "environment_code" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "internal_trusted_cidr_ranges" {
  description = "Your internal CIDR range requiring access to this proxy."
  type = list(string)
}

variable "instance_type" {
  description = "The instance type"
  type = string
  default = "e2-micro"
}

variable "instance_image" {
  description = "The instance image. Must be debian base."
  type = string
  default = "ubuntu-os-cloud/ubuntu-minimal-1804-lts"
}

variable "autoscaling_max" {
  description = "The maximum cluster size of the squid managed instance group."
  type = number
  default = 3
}
variable "autoscaling_min" {
  description = "The minimum cluster size of the squid managed instance group."
  type = number
  default = 1
}
variable "autoscaling_cpu_target" {
  description = "CPU target to create a new instance."
  type = number
  default = 75
}