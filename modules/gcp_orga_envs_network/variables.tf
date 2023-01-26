variable "environment_code" {
  type = string
}

variable "org_nethub_vpc_self_link" {
  type = string
  description = "Organization hub network VPC self link"
}

variable "org_nethub_project_id" {
  type = string
  description = "Organization hub network project id"
}
variable "project_id" {
  type = string
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

variable "private_svc_connect_ranges" {
  type        = list(string)
  description = "CIDR range for private service networking. Used for Cloud SQL and other managed services."
}

variable "private_svc_connect_ip" {
  type        = string
  description = "The internal IP to be used for the private service connect. Required for hub mode"
}

variable "business_project_subnets" {
  description = "Default subnets for Organization network hub."
  type        = list(object({
    project_name = string
    environment_code = string
    private_subnet_ranges  = list(string)
    data_subnet_ranges =  list(string)
    private_subnet_k8s_2nd_ranges = list(string)
  }))
}

variable "network_name" {
  type        = string
  description = "The network name."
}