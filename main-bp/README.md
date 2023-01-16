<!-- BEGIN_TF_DOCS -->
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_google.impersonate"></a> [google.impersonate](#provider_google.impersonate) | >= 4.10 |

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_business_project"></a> [business_project](#module_business_project) | ../modules/gcp_orga_business_project | n/a |
| <a name="module_fetch"></a> [fetch](#module_fetch) | ../modules/shared/gcp_fetch_organization | n/a |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_billing_account"></a> [gcp_billing_account](#input_gcp_billing_account) | The ID of the billing account to associate this project with | `string` | n/a | yes |
| <a name="input_gcp_default_region1"></a> [gcp_default_region1](#input_gcp_default_region1) | Default region for resources. | `string` | n/a | yes |
| <a name="input_gcp_default_region1_azs"></a> [gcp_default_region1_azs](#input_gcp_default_region1_azs) | Default availability zones for region 1. | `list(string)` | n/a | yes |
| <a name="input_gcp_default_region2"></a> [gcp_default_region2](#input_gcp_default_region2) | Default region for resources. | `string` | n/a | yes |
| <a name="input_gcp_default_region2_azs"></a> [gcp_default_region2_azs](#input_gcp_default_region2_azs) | Default availability zones for region 2. | `list(string)` | n/a | yes |
| <a name="input_gcp_group_org_admins"></a> [gcp_group_org_admins](#input_gcp_group_org_admins) | Google Group for GCP Organization Administrators | `string` | n/a | yes |
| <a name="input_gcp_group_org_billing_admins"></a> [gcp_group_org_billing_admins](#input_gcp_group_org_billing_admins) | Google Group for GCP Organization Billing Administrators | `string` | n/a | yes |
| <a name="input_gcp_group_org_network_admins"></a> [gcp_group_org_network_admins](#input_gcp_group_org_network_admins) | Google Group for GCP Organization Network Administrators | `string` | n/a | yes |
| <a name="input_gcp_group_org_network_viewers"></a> [gcp_group_org_network_viewers](#input_gcp_group_org_network_viewers) | Google Group for GCP Organization Network Read only users | `string` | n/a | yes |
| <a name="input_gcp_group_org_security_admins"></a> [gcp_group_org_security_admins](#input_gcp_group_org_security_admins) | Google Group for GCP Organization Security Administrators | `string` | n/a | yes |
| <a name="input_gcp_group_org_security_reviewers"></a> [gcp_group_org_security_reviewers](#input_gcp_group_org_security_reviewers) | Google Group for GCP Organization Security reviewer | `string` | n/a | yes |
| <a name="input_gcp_group_org_viewers"></a> [gcp_group_org_viewers](#input_gcp_group_org_viewers) | Google Group for GCP Organization read only users | `string` | n/a | yes |
| <a name="input_gcp_infra_projects"></a> [gcp_infra_projects](#input_gcp_infra_projects) | n/a | <pre>object({<br>    security       = object({<br>      name   = string<br>      folder = string<br>      budget = object({<br>        amount                    = number,<br>        time_unit                 = string,<br>        email_addresses_to_notify = list(string)<br>      })<br>    })<br>    observability  = object({<br>      name   = string<br>      folder = string<br>      budget = object({<br>        amount                    = number,<br>        time_unit                 = string,<br>        alert_pubsub_topic        = string<br>        email_addresses_to_notify = list(string)<br>      })<br>    })<br>    networking_hub = object({<br>      name    = string<br>      folder  = string<br>      budget  = object({<br>        amount                    = number,<br>        time_unit                 = string,<br>        email_addresses_to_notify = list(string)<br>      })<br>      network = object({<br>        name        = string,<br>        cidr_blocks = object({<br>          region1_primary_ranges = list(string)<br>          region2_primary_ranges = list(string)<br>        })<br>      })<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_gcp_labels"></a> [gcp_labels](#input_gcp_labels) | Map of tags | `map(string)` | n/a | yes |
| <a name="input_gcp_organization_id"></a> [gcp_organization_id](#input_gcp_organization_id) | The organization id for the associated services | `string` | n/a | yes |
| <a name="input_gcp_organization_name"></a> [gcp_organization_name](#input_gcp_organization_name) | The name of the current organization. | `string` | n/a | yes |
| <a name="input_gcp_terraform_sa_email"></a> [gcp_terraform_sa_email](#input_gcp_terraform_sa_email) | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_gcp_terraform_sa_id"></a> [gcp_terraform_sa_id](#input_gcp_terraform_sa_id) | Service account id of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_gcp_business_projects"></a> [gcp_business_projects](#input_gcp_business_projects) | The set of projects to create. Defaults to an empty list. | <pre>list(object({<br>    name             = string,<br>    department       = string,<br>    environment_code = string,<br>    budget           = object({<br>      amount                    = number,<br>      time_unit                 = string,<br>      email_addresses_to_notify = list(string)<br>    })<br>    network          = object({<br>      cidr_blocks = object({<br>        region1_primary_ranges = list(string)<br>        region2_primary_ranges = list(string)<br>      })<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_gcp_infra_folder_name"></a> [gcp_infra_folder_name](#input_gcp_infra_folder_name) | Folder witch will contains all infra projects | `string` | `"Infrastructure"` | no |
| <a name="input_gcp_organization_environments"></a> [gcp_organization_environments](#input_gcp_organization_environments) | The tree of organizational folders to construct. Defaults to an empty tree. | <pre>map(object({<br>    environment_code = string,<br>    network          = object({<br>      prefix      = string,<br>      cidr_blocks = object({<br>        region1_primary_ranges = list(string)<br>        region2_primary_ranges = list(string)<br>      })<br>    })<br>    children         = list(object({<br>      name     = string,<br>      children = list(object({<br>        name = string<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_gcp_terraform_sa_org_iam_permissions"></a> [gcp_terraform_sa_org_iam_permissions](#input_gcp_terraform_sa_org_iam_permissions) | List of permissions granted to Terraform service account across the GCP organization. | `list(string)` | <pre>[<br>  "roles/billing.user",<br>  "roles/compute.networkAdmin",<br>  "roles/compute.xpnAdmin",<br>  "roles/iam.securityAdmin",<br>  "roles/iam.serviceAccountAdmin",<br>  "roles/logging.configWriter",<br>  "roles/orgpolicy.policyAdmin",<br>  "roles/resourcemanager.folderAdmin",<br>  "roles/resourcemanager.organizationViewer"<br>]</pre> | no |

#### Outputs

No outputs.
<!-- END_TF_DOCS -->