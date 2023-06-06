variable "resource_id" {
  type        = string
  description = "Resource id where the policies must be applied"
}

variable "resource_type" {
  type        = string
  description = "Resource type where the policies must be applied. Possible values: organization, folder and project"
}

variable "enable_sa_key_creation_deny_policy" {
  description = "Deny service account key creation at the organization level."
  type        = bool
  default     = false
}

variable "enable_cloudsql_external_ip_access_policy" {
  description = "Enable Cloud SQL external IP Organization Policy."
  type        = bool
  default     = false
}

variable "enable_domains_sharing_restriction_policy" {
  description = "Enable domains sharing restriction Organization Policy."
  type        = bool
  default     = false
}

variable "disable_nested_virtualization_policy" {
  description = "Disable nested virtualization Organization Policy."
  type        = bool
  default     = false
}

variable "disable_automatic_iam_grants_on_default_service_accounts_policy" {
  description = "Disable automatic IAM grants on default service accounts Organization Policy."
  type        = bool
  default     = false
}

variable "enforce_bucket_level_access_policy" {
  description = "Enforce bucket level access Organization Policy."
  type        = bool
  default     = false
}

variable "disable_serial_port_access_policy" {
  description = "Disable serial port access Organization Policy."
  type        = bool
  default     = false
}

variable "disable_guest_attributes_access_policy" {
  description = "Disable guest attributes access Organization Policy."
  type        = bool
  default     = false
}
variable "skip_default_network_policy" {
  description = "Skip default network Organization Policy."
  type        = bool
  default     = false
}

variable "shared_vpc_lien_removal_policy" {
  description = "Shared vpc lien removal Organization Policy."
  type        = bool
  default     = false
}

variable "vm_external_ip_access_policy" {
  description = "vm external ip_access Organization Policy."
  type        = list(string)
  default     = null
}

variable "enable_os_login_policy" {
  description = "Require os login Organization Policy."
  type        = bool
  default     = false
}


variable "create_access_context_manager_access_policy" {
  description = "Whether to create access context manager access policy"
  type        = bool
  default     = false
}

variable "domains_to_allow" {
  description = "The list of domains to allow users from in IAM. Used by Domain Restricted Sharing Organization Policy. Must include the domain of the organization you are deploying the foundation. To add other domains you must also grant access to these domains to the terraform service account used in the deploy."
  type        = list(string)
}

variable "labels" {
  type        = map(string)
  description = "Map of labels"
}