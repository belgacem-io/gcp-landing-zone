variable "gcp_org_id" {
  description = "The organization id for the associated services"
  type        = string
}

variable "gcp_parent_container_id" {
  type        = string
  description = "Can be either an organisation or a folder. Format : organizations/1235 or folders/12562."
}

variable "gcp_org_name" {
  description = "The organization name, will be used for resources naming."
  type        = string
}

variable "gcp_org_public_domain" {
  type        = string
  description = "The public domain of the current organization. Can be different from the organization name. exp:  company.com, cloud.company.com"
}

variable "gcp_org_private_domain" {
  type        = string
  description = "The private domain of the current organization. Can be different from the organization name. exp:  company.local, cloud.company.local"
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

variable "gcp_default_region" {
  description = "Default region for resources."
  type        = string
}

variable "gcp_default_region_azs" {
  description = "Default availability zones for region 1."
  type        = list(string)
}

variable "gcp_org_environments" {
  type = map(object({
    environment_code = string,
    name             = string
    network          = object({
      name        = string,
      cidr_blocks = object({
        private_subnet_ranges = list(string)
        data_subnet_ranges    = list(string)
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
      })
    })
  }))
  default     = []
  description = "The set of projects to create. Defaults to an empty list."
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
      networks = object({
        dmz = object({
          name        = string
          cidr_blocks = object({
            public_subnet_ranges          = list(string)
            private_subnet_ranges         = list(string)
            data_subnet_ranges            = list(string)
          })
        })
        corp = object({
          name        = string
          cidr_blocks = object({
            private_subnet_ranges         = list(string)
            data_subnet_ranges            = list(string)
            private_svc_connect_ip        = string
          })
        })
      })
    })
  })
}

variable "gcp_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded"
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
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

variable "gcp_labels" {
  type        = map(string)
  description = "Map of labels"
}