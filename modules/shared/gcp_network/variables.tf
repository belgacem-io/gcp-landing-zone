variable "org_id" {
  type        = string
  description = "Organization ID"
}

variable "project_id" {
  type        = string
  description = "Project ID for Private Shared VPC."
}

variable "mode" {
  type        = string
  description = "Network deployment mode, should be set to `hub` or `spoke`."
  default     = null
}

variable "environment_code" {
  type        = string
  description = "A short form of the folder level resources (environment) within the Google Cloud organization."
}

variable "default_region" {
  type        = string
  description = "Default region 1 for subnets and Cloud Routers"
}

variable "nat_enabled" {
  type        = bool
  description = "Toggle creation of NAT cloud router."
  default     = false
}

variable "nat_bgp_asn" {
  type        = number
  description = "BGP ASN for first NAT cloud routes."
  default     = 0
}

variable "nat_num_addresses_region1" {
  type        = number
  description = "Number of external IPs to reserve for first Cloud NAT."
  default     = 2
}

variable "bgp_asn_subnet" {
  type        = number
  description = "BGP ASN for Subnets cloud routers."
}

variable "public_subnets" {
  type        = list(object({
    project_name = string
    subnet_name  = string
    subnet_ip    = string
  }))
  description = "The list of public subnets being created"
  default     = []
}

variable "private_subnets" {
  type        = list(object({
    project_name = string
    subnet_name  = string
    subnet_ip    = string
  }))
  description = "The list of private subnets being created"
  default     = []
}

variable "data_subnets" {
  type        = list(object({
    project_name = string
    subnet_name  = string
    subnet_ip    = string
  }))
  description = "The list of data subnets being created"
  default     = []
}

variable "private_svc_connect_subnets" {
  type        = list(object({
    project_name = string
    subnet_name  = string
    subnet_ip    = string
  }))
  description = "The list of subnets to publish a managed service by using Private Service Connect."
  default     = []
}

variable "private_svc_connect_ip" {
  description = "The internal IP to be used for the private service connect. Required for hub mode"
  type        = string
  default = null
}

variable "secondary_ranges" {
  type        = map(list(object({
    range_name = string,
    ip_cidr_range = string
  })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "dns_enable_inbound_forwarding" {
  type        = bool
  description = "Toggle inbound query forwarding for VPC DNS."
  default     = true
}

variable "dns_enable_logging" {
  type        = bool
  description = "Toggle DNS logging for VPC DNS."
  default     = true
}

variable "firewall_enable_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls."
  default     = true
}

variable "domain" {
  type        = string
  description = "The DNS name of peering managed zone, for instance 'example.com.'"
}

variable "private_service_cidr" {
  type        = string
  description = "CIDR range for private service networking. Used for Cloud SQL and other managed services."
  default     = null
}

variable "windows_activation_enabled" {
  type        = bool
  description = "Enable Windows license activation for Windows workloads."
  default     = false
}

variable "nat_num_addresses" {
  type        = number
  description = "Number of external IPs to reserve for Cloud NAT."
  default     = 2
}

variable "optional_fw_rules_enabled" {
  type        = bool
  description = "Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges."
  default     = false
}

variable "allow_all_egress_ranges" {
  type = list(string)
  description = "List of network ranges to which all egress traffic will be allowed"
  default     = null
}

variable "allow_all_ingress_ranges" {
  type = list(string)
  description = "List of network ranges from which all ingress traffic will be allowed"
  default     = null
}

variable "bgp_asn_dns" {
  type        = number
  description = "BGP Autonomous System Number (ASN)."
  default     = 64667
}

variable "dns_enable_outbound_forwarding" {
  type        = bool
  description = "Toggle outbound query forwarding for VPC DNS. if true dns_outbound_server_addresses must be set"
  default     = false
}

variable "dns_outbound_server_addresses" {
  description = "List of IPv4 address of target name servers for the forwarding zone configuration. See https://cloud.google.com/dns/docs/overview#dns-forwarding-zones for details on target name servers in the context of Cloud DNS forwarding zones."
  type        = list(object({
    ipv4_address    = string,
    forwarding_path = string
  }))
  default = null
}
variable "subnetworks_enable_logging" {
  type        = bool
  description = "Toggle subnetworks flow logging for VPC Subnetworks."
  default     = false
}

variable "network_internet_egress_tag" {
  type = string
  description = "Network tags for VMs with internet access."
  default = "egress-internet"
}

variable "internal_trusted_cidr_ranges" {
  description = "Internal trusted ip ranges. Must be set to private ip ranges"
  type = list(string)
  default = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]
}

variable "org_nethub_project_id" {
  type = string
  default = null
  description = "Organization hub network project. Required en spoke mode"
}

variable "org_nethub_vpc_self_link" {
  type = string
  default = null
  description = "Organization hub network VPC self link. Required en spoke mode"
}