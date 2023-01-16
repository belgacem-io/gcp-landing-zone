variable "organization_id" {
  type = string
  description = "The name of the current organization."
}

variable "terraform_sa_email" {
  description = "Service account email of the account to impersonate to run Terraform."
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
  type        = string
}


variable "gcp_labels" {
  type        = map(string)
  description = "Map of tags"
}

variable "infra_folder_name" {
  type = string
  description = "Folder witch will contains all infra projects"
}


variable "infra_security_project" {
  type = object({
    name = string
    folder = string
    budget = object({
      amount = number,
      time_unit = string,
      email_addresses_to_notify = list(string)
    })
  })
}

variable "infra_observability_project" {
  type = object({
    name = string
    folder = string
    budget = object({
      amount = number,
      time_unit = string,
      alert_pubsub_topic = string
      email_addresses_to_notify = list(string)
    })
  })
}

variable "infra_networking_hub_project" {
  type = object({
    name = string
    folder = string
    budget = object({
      amount = number,
      time_unit = string,
      email_addresses_to_notify = list(string)
    })
  })
}

variable "scc_notification_name" {
  description = "Name of the Security Command Center Notification. It must be unique in the organization. Run `gcloud scc notifications describe <scc_notification_name> --organization=org_id` to check if it already exists."
  type        = string
  default = "org-scc-notify"
}

variable "scc_notification_filter" {
  description = "Filter used to create the Security Command Center Notification, you can see more details on how to create filters in https://cloud.google.com/security-command-center/docs/how-to-api-filter-notifications#create-filter"
  type        = string
  default     = "state = \"ACTIVE\""
}

variable "enable_sa_key_creation_deny_policy" {
  description = "Deny service account key creation at the organization level."
  type        = bool
  default     = false
}

variable "enable_os_login_policy" {
  description = "Enable OS Login Organization Policy."
  type        = bool
  default     = false
}

variable "enable_domains_sharing_restriction_policy" {
  description = "Enable domains sharing restriction Organization Policy."
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

variable "enable_scc_notification" {
  description = "Enable Security Control Center notifications."
  type        = bool
  default     = false
}

variable "log_export_storage_location" {
  description = "The location of the storage bucket used to export logs."
  type        = string
  default     = "EU"
}

variable "log_export_storage_force_destroy" {
  description = "(Optional) If set to true, delete all contents when destroying the resource; otherwise, destroying the resource will fail if contents are present."
  type        = bool
  default     = false
}

variable "log_export_storage_versioning" {
  description = "(Optional) Toggles bucket versioning, ability to retain a non-current object version when the live object version gets replaced or deleted."
  type        = bool
  default     = false
}

variable "org_audit_data_admins" {
  description = "Google Workspace or Cloud Identity group that have access to audit logs."
  type        = string
}

variable "org_billing_data_viewers" {
  description = "Google Workspace or Cloud Identity group that have access to billing data set."
  type        = string
}

variable "org_viewers" {
  description = "G Suite or Cloud Identity group that have the ability to view resource information across the Google Cloud organization."
  type        = string

}
variable "org_audit_viewers" {
  description = "Members are part of an audit team and view audit logs in the logging project."
  type        = string
}
variable "org_security_reviewers" {
  description = "G Suite or Cloud Identity group that members are part of the security team responsible for reviewing cloud security."
  type        = string
}
variable "org_scc_admins" {
  description = "G Suite or Cloud Identity group that can administer Security Command Center."
  type        = string
}

variable "org_org_admins" {
  description = "Identity that has organization administrator permissions."
  type        = string
}

variable "org_billing_admins" {
  description = "Identity that has billing administrator permissions"
  type        = string
}
variable "org_network_viewers" {
  description = "G Suite or Cloud Identity group that members are part of the networking team and review network configurations"
  type        = string
}

variable "log_export_storage_lifecycle_rules" {
  description = "Bucket lifecycle rules"
  type        = any
  default     = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age        = 365
        with_state = "ANY"
      }
    },
    {
      action = {
        type = "SetStorageClass"
        storage_class = "ARCHIVE"
      }
      condition = {
        age        = 30
        with_state = "ANY"
      }
    }
  ]
}

variable "log_export_storage_retention_policy" {
  description = "Configuration of the bucket's data retention policy for how long objects in the bucket should be retained."
  type = object({
    is_locked             = bool
    retention_period_days = number
  })
  default = null
}

variable "budget_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded"
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "budget_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}`"
  type        = string
}

variable "audit_logs_table_expiration_days" {
  description = "Period before tables expire for all audit logs in milliseconds. Default is 30 days."
  type        = number
  default     = 30
}

variable "audit_logs_table_delete_contents_on_destroy" {
  description = "(Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = false
}

variable "default_region" {
  description = "Default region for BigQuery resources."
  type        = string
}