variable "environment_code" {
  type = string
}

variable "org_network_hub_vpc_name" {
  type = string
  description = "Organization hub network VPC name"
}

variable "org_network_hub_project_id" {
  type = string
  description = "Organization hub network project id"
}
variable "env_network_hub_project_id" {
  type = string
  description = "Environment hub network project id"
}

variable "org_id" {
  type        = string
  description = "Organization ID"
}

variable "terraform_service_account" {
  type        = string
  description = "Service account email of the account to impersonate to run Terraform."
}

variable "default_region1" {
  type        = string
  description = "First subnet region. The shared vpc modules only configures two regions."
}

variable "domain" {
  type        = string
  description = "The DNS name of peering managed zone, for instance 'example.com.'. Must end with a period."
}

variable "dns_enable_logging" {
  type        = bool
  description = "Toggle DNS logging for VPC DNS."
  default     = true
}

variable "subnetworks_enable_logging" {
  type        = bool
  description = "Toggle subnetworks flow logging for VPC Subnetworks."
  default     = true
}

variable "firewall_enable_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls."
  default     = true
}

variable "dns_enable_inbound_forwarding" {
  type        = bool
  description = "Toggle inbound query forwarding for VPC DNS."
  default     = true
}

variable "windows_activation_enabled" {
  type        = bool
  description = "Enable Windows license activation for Windows workloads."
  default     = false
}

variable "nat_enabled" {
  type        = bool
  description = "Toggle creation of NAT cloud router."
  default     = true
}

variable "nat_bgp_asn" {
  type        = number
  description = "BGP ASN for first NAT cloud routes."
  default     = 64514
}

variable "nat_num_addresses_region1" {
  type        = number
  description = "Number of external IPs to reserve for first Cloud NAT."
  default     = 2
}

variable "nat_num_addresses_region2" {
  type        = number
  description = "Number of external IPs to reserve for second Cloud NAT."
  default     = 2
}

variable "nat_num_addresses" {
  type        = number
  description = "Number of external IPs to reserve for Cloud NAT."
  default     = 2
}

variable "optional_fw_rules_enabled" {
  type        = bool
  description = "Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges."
  default     = true
}

variable "enable_partner_interconnect" {
  description = "Enable Partner Interconnect in the environment."
  type        = bool
  default     = false
}

variable "preactivate_partner_interconnect" {
  description = "Preactivate Partner Interconnect VLAN attachment in the environment."
  type        = bool
  default     = false
}

variable "enable_hub_and_spoke_transitivity" {
  description = "Enable transitivity via gateway VMs on Hub-and-Spoke architecture."
  type        = bool
  default     = false
}

variable "csvc_private_subnet_ranges" {
  type = list(string)
}

variable "csvc_data_subnet_ranges" {
  type = list(string)
}

variable "private_service_cidr" {
  type        = string
  description = "CIDR range for private service networking. Used for Cloud SQL and other managed services."
}

variable "business_project_subnets" {
  description = "Default subnets for Organization network hub."
  type        = list(object({
    project_name = string
    environment_code = string
    private_subnet_ranges  = list(string)
    data_subnet_ranges =  list(string)
    k8s_secondary_ranges = list(string)
  }))
}