variable "project_id" {
  type        = string
  description = "VPC Project ID"
}

variable "regions" {
  type        = set(string)
  description = "Regions to deploy the transitivity appliances"
}

variable "vpc_name" {
  type        = string
  description = "Label to identify the VPC associated with shared VPC that will use the Interconnect."
}

variable "gw_subnets" {
  description = "Subnets in {REGION => SUBNET} format."
  type        = map(string)
}

variable "regional_aggregates" {
  description = "Aggregate ranges for each region in {REGION => [AGGREGATE_CIDR,] } format."
  type        = map(list(string))
}

variable "firewall_enable_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls."
  default     = true
}

variable "health_check_enable_log" {
  type        = bool
  description = "Toggle logging for health checks."
  default     = false
}
