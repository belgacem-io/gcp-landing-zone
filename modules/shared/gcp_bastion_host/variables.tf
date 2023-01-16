variable "members" {
  description = "List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email}"
  type        = list(string)
}

variable "project_id" {
  type = string
  description = "Project ID where to set up the instance and IAP tunneling"
}

variable "instance_name" {
  type = string
  description = "Name of the example VM instance to create and allow SSH from IAP."
}

variable "region" {
  type = string
  description = "Region to create the subnet and example VM."
}

variable "zone" {
  type = string
  description = "Zone of the example VM instance to create and allow SSH from IAP."
}

variable "network_self_link" {
  type = string
  description = "Network where to install the bastion host"
}

variable "subnet_self_link" {
  type = string
  description = "Subnet where to install the bastion host"
}

variable "host_project" {
  description = "The network host project ID."
  default     = ""
}