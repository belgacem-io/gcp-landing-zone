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

variable "mode" {
  type        = string
  description = "Network deployment mode, should be set to `hub` or `spoke`."
  default     = null
}

variable "environment_code" {
  type        = string
  description = "A short form of the folder level resources (environment) within the Google Cloud organization."
}

variable "shared_vpc_host" {
  type        = bool
  default     = true
  description = "If the Network will be shared with others projects"
}


variable "default_region" {
  type        = string
  description = "Default region 1 for subnets and Cloud Routers"
}

variable "enable_nat" {
  type        = bool
  description = "Toggle creation of NAT cloud router."
  default     = false
}

variable "nat_bgp_asn" {
  type        = number
  description = "BGP ASN for first NAT cloud routes."
  default     = 64514
}

variable "nat_num_addresses" {
  type        = number
  description = "Number of external IPs to reserve for first Cloud NAT."
  default     = 2
}

variable "public_subnets" {
  type = list(object({
    subnet_suffix = string
    subnet_range  = string
  }))
  description = "The list of public subnets being created"
  default     = []
}

variable "private_subnets" {
  type = list(object({
    subnet_suffix = string
    subnet_range  = string
  }))
  description = "The list of private subnets being created"
  default     = []
}

variable "data_subnets" {
  type = list(object({
    subnet_suffix = string
    subnet_range  = string
  }))
  description = "The list of data subnets being created"
  default     = []
}

variable "private_svc_connect_ip" {
  description = "The internal IP to be used for the private service connect. Required for hub mode"
  type        = string
  default     = null
}

variable "secondary_ranges" {
  type = map(list(object({
    range_name    = string,
    ip_cidr_range = string
  })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "enable_dns_inbound_forwarding" {
  type        = bool
  description = "Toggle inbound query forwarding for VPC DNS."
  default     = true
}

variable "enable_dns_peering" {
  type        = bool
  description = "Toggle inbound query forwarding for VPC DNS."
  default     = true
}

variable "enable_dns_logging" {
  type        = bool
  description = "Toggle DNS logging for VPC DNS."
  default     = false
}

variable "enable_firewall_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls."
  default     = false
}

variable "enable_public_domain" {
  type        = bool
  description = "If true, a public domain zone will be created."
  default = false
}

variable "public_domain" {
  type        = string
  description = "The organization's public domain (DNS), for instance 'example.com.'."
}

variable "enable_private_domain" {
  type        = bool
  description = "If true, a private domain zone will be created."
  default = true
}

variable "private_domain" {
  type        = string
  description = "The organization's private domain (DNS), for instance 'example.com.'."
}

variable "private_service_cidr" {
  type        = string
  description = "CIDR range for private service networking. Used for Cloud SQL and other managed services."
  default     = null
}

variable "enable_windows_activation" {
  type        = bool
  description = "Enable Windows license activation for Windows workloads."
  default     = false
}

variable "enable_optional_fw_rules" {
  type        = bool
  description = "Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges."
  default     = true
}

variable "allow_egress_ranges" {
  type        = list(string)
  description = "List of network ranges to which all egress traffic will be allowed"
  default     = null
}

variable "allow_ingress_ranges" {
  type        = list(string)
  description = "List of network ranges from which all ingress traffic will be allowed"
  default     = null
}

variable "enable_subnetworks_logging" {
  type        = bool
  description = "Toggle subnetworks flow logging for VPC Subnetworks."
  default     = false
}

variable "internal_trusted_cidr_ranges" {
  description = "Internal trusted ip ranges. Must be set to private ip ranges"
  type        = list(string)
}

variable "infra_nethub_project_id" {
  type        = string
  default     = null
  description = "Organization hub network project. Required in spoke mode"
}

variable "infra_nethub_networks" {
  type        = map(object({
    self_link   = string
    has_private_dns = bool
  }))
  default     = {}
  description = "Organization hub networks VPC self links. Required in spoke mode"
}

variable "enable_transitive_network" {
  type        = bool
  default     = true
  description = "In hub mode, if enabled, a transit gateway will be installed."
}

variable "enable_secure_web_proxy" {
  type        = bool
  default     = true
  description = "In hub mode, if enabled, a secure web proxy will be installed."
}

variable "labels" {
  type        = map(string)
  description = "Map of labels"
}