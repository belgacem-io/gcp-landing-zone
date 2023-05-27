variable "gcp_organization_id" {
  description = "The organization id for the associated services"
  type        = string
}

variable "gcp_organization_name" {
  description = "The organization name, will be used for resources naming."
  type        = string
}

variable "gcp_parent_container_id" {
  type        = string
  description = "Can be either an organisation or a folder. Format : organizations/1235 or folders/12562."
}

variable "gcp_organization_domain" {
  type        = string
  description = "The domain of the current organization. Can be different from the organization name. exp:  company.com, cloud.company.com"
}


variable "gcp_billing_account" {
  description = "The ID of the billing account to associate this project with"
  type        = string
}


variable "gcp_terraform_sa_email" {
  description = "Service account email of the account to impersonate to run Terraform."
  type        = string
}

variable "gcp_terraform_sa_id" {
  description = "Service account id of the account to impersonate to run Terraform."
  type        = string
}

variable "gcp_group_org_admins" {
  description = "Google Group for GCP Organization Administrators"
  type        = string
  default     = null
}
variable "gcp_group_org_viewers" {
  description = "Google Group for GCP Organization read only users"
  type        = string
  default     = null
}
variable "gcp_group_org_security_admins" {
  description = "Google Group for GCP Organization Security Administrators"
  type        = string
  default     = null
}

variable "gcp_group_org_security_reviewers" {
  description = "Google Group for GCP Organization Security reviewer"
  type        = string
  default     = null
}

variable "gcp_group_org_billing_admins" {
  description = "Google Group for GCP Organization Billing Administrators"
  type        = string
  default     = null
}

variable "gcp_group_org_billing_viewers" {
  description = "Google Group for GCP Organization Billing viewers"
  type        = string
  default     = null
}

variable "gcp_group_org_network_admins" {
  description = "Google Group for GCP Organization Network Administrators"
  type        = string
  default     = null
}

variable "gcp_group_org_network_viewers" {
  description = "Google Group for GCP Organization Network Read only users"
  type        = string
  default     = null
}

variable "gcp_default_region" {
  description = "Default region for resources."
  type        = string
}

variable "gcp_default_region_azs" {
  description = "Default availability zones for region 1."
  type        = list(string)
}

variable "gcp_organization_environments" {
  type = map(object({
    environment_code = string,
    name             = string
    network          = object({
      name        = string,
      cidr_blocks = object({
        private_subnet_ranges     = list(string)
        data_subnet_ranges        = list(string)
        reserved_subnets          = map(object({
          purpose = string
          role    = string
          range   = string
        }))
        private_svc_connect_ip    = string
      })
    })
    children = list(object({
      name     = string,
      children = list(object({
        name = string
      }))
    }))
  }))
  default     = {}
  description = "The tree of organizational folders to construct. Defaults to an empty tree."
}

variable "gcp_business_projects" {
  type = list(object({
    name             = string,
    department       = string,
    environment_code = string,
    budget           = object({
      amount                    = number,
      time_unit                 = string,
      email_addresses_to_notify = list(string)
    })
    network = object({
      cidr_blocks = object({
        private_subnet_ranges         = list(string)
        data_subnet_ranges            = list(string)
        reserved_subnets      = map(object({
          purpose = string
          role    = string
          range   = string
        }))
      })
    })
  }))
  default     = []
  description = "The set of projects to create. Defaults to an empty list."
}

variable "gcp_labels" {
  type        = map(string)
  description = "Map of tags"
}

variable "gcp_infra_projects" {
  type = object({
    folder   = string
    security = object({
      name   = string
      budget = object({
        amount                    = number,
        time_unit                 = string,
        email_addresses_to_notify = list(string)
      })
    })
    observability = object({
      name   = string
      budget = object({
        amount                    = number,
        time_unit                 = string,
        alert_pubsub_topic        = string
        email_addresses_to_notify = list(string)
      })
    })
    nethub = object({
      name   = string
      budget = object({
        amount                    = number,
        time_unit                 = string,
        email_addresses_to_notify = list(string)
      })
      network = object({
        name        = string,
        cidr_blocks = object({
          public_subnet_ranges      = list(string)
          private_subnet_ranges     = list(string)
          data_subnet_ranges        = list(string)
          reserved_subnets          = map(object({
            purpose = string
            role    = string
            range   = string
          }))
          private_svc_connect_ip    = string
        })
      })
    })
  })
}

variable "trusted_egress_ranges" {
  type        = list(string)
  description = "List of network ranges to which all egress traffic will be allowed"
}

variable "trusted_ingress_ranges" {
  type        = list(string)
  description = "List of network ranges from which all ingress traffic will be allowed"
}

variable "trusted_private_ranges" {
  type        = list(string)
  description = "List of network ranges from which internal traffic will be allowed"
}

variable "enable_log_export_to_biqquery" {
  description = "Enable log export to bigquery"
  type        = bool
  default     = false
}

variable "enable_log_export_to_cs" {
  description = "Enable log export to bigquery"
  type        = bool
  default     = true
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
        type          = "SetStorageClass"
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
  type        = object({
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

variable "scc_notification_name" {
  description = "Name of the Security Command Center Notification. It must be unique in the organization. Run `gcloud scc notifications describe <scc_notification_name> --organization=org_id` to check if it already exists."
  type        = string
  default     = "org-scc-notify"
}

variable "scc_notification_filter" {
  description = "Filter used to create the Security Command Center Notification, you can see more details on how to create filters in https://cloud.google.com/security-command-center/docs/how-to-api-filter-notifications#create-filter"
  type        = string
  default     = "state = \"ACTIVE\""
}

variable "enable_partner_interconnect" {
  description = "Enable Partner Interconnect in the environment."
  type        = bool
  default     = false
}
