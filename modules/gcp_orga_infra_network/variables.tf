variable "parent_id" {
  type = string
  description = "Can be either an organisation or a folder. Format : organizations/1235 or folders/12562."
}

variable "organization_id" {
  type = string
  description = "The domain of the current organization. Can be different from the organization name. exp:  company.com, cloud.company.com"
}

variable "terraform_sa_email" {
  description = "Service account email of the account to impersonate to run Terraform."
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
  type        = string
}
variable "infra_folder_name" {
  type = string
  default = "Infrastructure"
  description = "Folder witch will contains all infra projects"
}

variable "network_hub_project_name" {
  type = string
  description = "Project witch will contains all dns configs"
}


variable "default_region1" {
  type        = string
  description = "First subnet region for DNS Hub network."
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

variable "domain" {
  type        = string
  description = "The DNS name of forwarding managed zone, for instance 'example.com'. Must end with a period."
}

variable "bgp_asn_dns" {
  type        = number
  description = "BGP Autonomous System Number (ASN)."
  default     = 64667
}

variable "enable_dns_proxy_advertising" {
  type        = bool
  description = "Enables routers to advertise DNS proxy range 35.199.192.0/19."
  default = false
}

variable "enable_orga_network_hub_windows_activation" {
  type        = bool
  description = "Enable Windows license activation for Windows workloads in Base Hub"
  default     = false
}

variable "enable_orga_network_hub_dns_inbound_forwarding" {
  type        = bool
  description = "Toggle inbound query forwarding for Base Hub VPC DNS."
  default     = true
}

variable "enable_orga_network_hub_dns_logging" {
  type        = bool
  description = "Toggle DNS logging for Base Hub VPC DNS."
  default     = true
}
variable "enable_orga_network_hub_firewall_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls in Base Hub VPC."
  default     = true
}

variable "enable_orga_network_hub_optional_fw_rules" {
  type        = bool
  description = "Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges in Hub VPC."
  default     = true
}

variable "enable_orga_network_hub_nat" {
  type        = bool
  description = "Toggle creation of NAT cloud router in Hub."
  default     = true
}

variable "orga_network_hub_nat_bgp_asn" {
  type        = number
  description = "BGP ASN for first NAT cloud routes in Base Hub."
  default     = 64514
}

variable "orga_network_hub_nat_num_addresses_region1" {
  type        = number
  description = "Number of external IPs to reserve for first Cloud NAT in Base Hub."
  default     = 2
}

variable "orga_network_hub_nat_num_addresses_region2" {
  type        = number
  description = "Number of external IPs to reserve for first Cloud NAT in Base Hub."
  default     = 2
}

variable "enable_partner_interconnect" {
  description = "Enable Partner Interconnect in the environment."
  type        = bool
  default     = false
}

variable "gcp_labels" {
  type        = map(string)
  description = "Map of tags"
}

variable "orga_network_hub_subnets" {
  description = "Default subnets for Organization network hub."
  type        = object({
    public_subnet_ranges = list(string)
    private_subnet_ranges  = list(string)
    data_subnet_ranges =  list(string)
  })
}