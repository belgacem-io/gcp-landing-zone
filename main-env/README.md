<!-- BEGIN_TF_DOCS -->
## Purpose

Sets up development, non-production, and production environments within the Google Cloud organization that you've
created.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_billing_account"></a> [gcp\_billing\_account](#input\_gcp\_billing\_account) | The ID of the billing account to associate this project with | `string` | n/a | yes |
| <a name="input_gcp_default_region"></a> [gcp\_default\_region](#input\_gcp\_default\_region) | Default region for resources. | `string` | n/a | yes |
| <a name="input_gcp_infra_projects"></a> [gcp\_infra\_projects](#input\_gcp\_infra\_projects) | n/a | <pre>object({<br>    folder   = string<br>    security = object({<br>      name   = string<br>      budget = object({<br>        amount                    = number,<br>        time_unit                 = string,<br>        email_addresses_to_notify = list(string)<br>      })<br>    })<br>    observability = object({<br>      name   = string<br>      budget = object({<br>        amount                    = number,<br>        time_unit                 = string,<br>        alert_pubsub_topic        = string<br>        email_addresses_to_notify = list(string)<br>      })<br>    })<br>    nethub = object({<br>      name   = string<br>      budget = object({<br>        amount                    = number,<br>        time_unit                 = string,<br>        email_addresses_to_notify = list(string)<br>      })<br>      networks = object({<br>        dmz = object({<br>          name        = string<br>          cidr_blocks = object({<br>            public_subnet_ranges          = list(string)<br>            private_subnet_ranges         = list(string)<br>            data_subnet_ranges            = list(string)<br>          })<br>        })<br>        corp = object({<br>          name        = string<br>          cidr_blocks = object({<br>            private_subnet_ranges         = list(string)<br>            data_subnet_ranges            = list(string)<br>            private_svc_connect_ip        = string<br>          })<br>        })<br>      })<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_gcp_labels"></a> [gcp\_labels](#input\_gcp\_labels) | Map of labels | `map(string)` | n/a | yes |
| <a name="input_gcp_org_id"></a> [gcp\_org\_id](#input\_gcp\_org\_id) | The organization id for the associated services | `string` | n/a | yes |
| <a name="input_gcp_org_name"></a> [gcp\_org\_name](#input\_gcp\_org\_name) | The organization name, will be used for resources naming. | `string` | n/a | yes |
| <a name="input_gcp_org_private_domain"></a> [gcp\_org\_private\_domain](#input\_gcp\_org\_private\_domain) | The private domain of the current organization. Can be different from the organization name. exp:  company.local, cloud.company.local | `string` | n/a | yes |
| <a name="input_gcp_org_public_domain"></a> [gcp\_org\_public\_domain](#input\_gcp\_org\_public\_domain) | The public domain of the current organization. Can be different from the organization name. exp:  company.com, cloud.company.com | `string` | n/a | yes |
| <a name="input_gcp_parent_container_id"></a> [gcp\_parent\_container\_id](#input\_gcp\_parent\_container\_id) | Can be either an organisation or a folder. Format : organizations/1235 or folders/12562. | `string` | n/a | yes |
| <a name="input_gcp_terraform_sa_email"></a> [gcp\_terraform\_sa\_email](#input\_gcp\_terraform\_sa\_email) | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_trusted_egress_ranges"></a> [trusted\_egress\_ranges](#input\_trusted\_egress\_ranges) | List of network ranges to which all egress traffic will be allowed | `list(string)` | n/a | yes |
| <a name="input_trusted_ingress_ranges"></a> [trusted\_ingress\_ranges](#input\_trusted\_ingress\_ranges) | List of network ranges from which all ingress traffic will be allowed | `list(string)` | n/a | yes |
| <a name="input_trusted_private_ranges"></a> [trusted\_private\_ranges](#input\_trusted\_private\_ranges) | List of network ranges from which internal traffic will be allowed | `list(string)` | n/a | yes |
| <a name="input_gcp_alert_spent_percents"></a> [gcp\_alert\_spent\_percents](#input\_gcp\_alert\_spent\_percents) | A list of percentages of the budget to alert on when threshold is exceeded | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> | no |
| <a name="input_gcp_business_projects"></a> [gcp\_business\_projects](#input\_gcp\_business\_projects) | The set of projects to create. Defaults to an empty list. | <pre>list(object({<br>    name             = string,<br>    department       = string,<br>    environment_code = string,<br>    budget           = object({<br>      amount                    = number,<br>      time_unit                 = string,<br>      email_addresses_to_notify = list(string)<br>    })<br>    network = object({<br>      cidr_blocks = object({<br>        private_subnet_ranges         = list(string)<br>        data_subnet_ranges            = list(string)<br>      })<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_gcp_org_environments"></a> [gcp\_org\_environments](#input\_gcp\_org\_environments) | The tree of organizational folders to construct. Defaults to an empty tree. | <pre>map(object({<br>    environment_code = string,<br>    name             = string<br>    network          = object({<br>      name        = string,<br>      cidr_blocks = object({<br>        private_subnet_ranges = list(string)<br>        data_subnet_ranges    = list(string)<br>      })<br>    })<br>    children = list(object({<br>      name     = string,<br>      children = list(object({<br>        name = string<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->