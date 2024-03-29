<!-- BEGIN_TF_DOCS -->
## Purpose

The purpose of this stage is to set up the common folder used to house projects that contain shared resources such as DNS Hub, Interconnect, Security Command Center notification, org level secrets, network hub and org level logging. This will create the following folder and project structure:
   ```text
   example-organization
     └── xx-infra (folder)
        ├── xx-logging-prod
        ├── xx-security-prod
        └── xx-nethub-prod
   ```

### Logging
This project is organization wide billing, applications and infra logs. The logs are collected into BigQuery datasets which you can then use for general querying, dashboarding, and reporting. Logs are also exported to Pub/Sub, a Cloud Storage bucket, and a log bucket.
### Nethub
This project is designed to serve as the hub for both the networks and DNS within the organization. It essentially contains two types of networks.
1. **DMZ Network**: Also known as the 'demilitarized zone' network, the DMZ network hosts internet-facing appliances. This includes tools like NAT (Network Address Translation), routers, and HTTP Proxies. DMZ network acts as a buffer zone between the public internet and the internal network of your organization, enhancing security by limiting exposure to potential threats from the internet.
2. **Internal Hub Network**: unlike the DMZ, the internal hub network is designed primarily for intra-organizational connectivity. It facilitates secure and efficient communication within your organization. Additionally, it can also be linked to on-premise infrastructure via VPN (Virtual Private Network) or Interconnect, enabling seamless integration between cloud-based and on-premise resources.

### Security
This project, overseen by your organization's security teams, forms the foundation for centralized audit logs and security alerts at the organization level. This secure hub will feature a Pub/Sub topic and subscription, along with a Security Command Center notification set up to broadcast all new findings to the established topic. Furthermore, it serves as a home for the Secret Manager, where your organization can safely store and share secrets.

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
| <a name="input_gcp_parent_container_id"></a> [gcp\_parent\_container\_id](#input\_gcp\_parent\_container\_id) | Can be either an organization or a folder. Format : organizations/1235 or folders/12562. | `string` | n/a | yes |
| <a name="input_gcp_terraform_sa_email"></a> [gcp\_terraform\_sa\_email](#input\_gcp\_terraform\_sa\_email) | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_trusted_egress_ranges"></a> [trusted\_egress\_ranges](#input\_trusted\_egress\_ranges) | List of network ranges to which all egress traffic will be allowed | `list(string)` | n/a | yes |
| <a name="input_trusted_ingress_ranges"></a> [trusted\_ingress\_ranges](#input\_trusted\_ingress\_ranges) | List of network ranges from which all ingress traffic will be allowed | `list(string)` | n/a | yes |
| <a name="input_trusted_private_ranges"></a> [trusted\_private\_ranges](#input\_trusted\_private\_ranges) | List of network ranges from which internal traffic will be allowed | `list(string)` | n/a | yes |
| <a name="input_audit_logs_table_delete_contents_on_destroy"></a> [audit\_logs\_table\_delete\_contents\_on\_destroy](#input\_audit\_logs\_table\_delete\_contents\_on\_destroy) | (Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present. | `bool` | `false` | no |
| <a name="input_audit_logs_table_expiration_days"></a> [audit\_logs\_table\_expiration\_days](#input\_audit\_logs\_table\_expiration\_days) | Period before tables expire for all audit logs in milliseconds. Default is 30 days. | `number` | `30` | no |
| <a name="input_budget_alert_spent_percents"></a> [budget\_alert\_spent\_percents](#input\_budget\_alert\_spent\_percents) | A list of percentages of the budget to alert on when threshold is exceeded | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> | no |
| <a name="input_enable_log_export_to_biqquery"></a> [enable\_log\_export\_to\_biqquery](#input\_enable\_log\_export\_to\_biqquery) | Enable log export to bigquery | `bool` | `false` | no |
| <a name="input_enable_log_export_to_cs"></a> [enable\_log\_export\_to\_cs](#input\_enable\_log\_export\_to\_cs) | Enable log export to bigquery | `bool` | `true` | no |
| <a name="input_enable_scc_notification"></a> [enable\_scc\_notification](#input\_enable\_scc\_notification) | Enable Security Control Center notifications. | `bool` | `false` | no |
| <a name="input_gcp_business_projects"></a> [gcp\_business\_projects](#input\_gcp\_business\_projects) | The set of projects to create. Defaults to an empty list. | <pre>list(object({<br>    name             = string,<br>    department       = string,<br>    environment_code = string,<br>    budget           = object({<br>      amount                    = number,<br>      time_unit                 = string,<br>      email_addresses_to_notify = list(string)<br>    })<br>    network = object({<br>      cidr_blocks = object({<br>        private_subnet_ranges         = list(string)<br>        data_subnet_ranges            = list(string)<br>      })<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_gcp_group_org_admins"></a> [gcp\_group\_org\_admins](#input\_gcp\_group\_org\_admins) | Google Group for GCP Organization Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_billing_admins"></a> [gcp\_group\_org\_billing\_admins](#input\_gcp\_group\_org\_billing\_admins) | Google Group for GCP Organization Billing Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_billing_viewers"></a> [gcp\_group\_org\_billing\_viewers](#input\_gcp\_group\_org\_billing\_viewers) | Google Group for GCP Organization Billing viewers | `string` | `null` | no |
| <a name="input_gcp_group_org_network_admins"></a> [gcp\_group\_org\_network\_admins](#input\_gcp\_group\_org\_network\_admins) | Google Group for GCP Organization Network Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_network_viewers"></a> [gcp\_group\_org\_network\_viewers](#input\_gcp\_group\_org\_network\_viewers) | Google Group for GCP Organization Network Read only users | `string` | `null` | no |
| <a name="input_gcp_group_org_security_admins"></a> [gcp\_group\_org\_security\_admins](#input\_gcp\_group\_org\_security\_admins) | Google Group for GCP Organization Security Administrators | `string` | `null` | no |
| <a name="input_gcp_group_org_security_reviewers"></a> [gcp\_group\_org\_security\_reviewers](#input\_gcp\_group\_org\_security\_reviewers) | Google Group for GCP Organization Security reviewer | `string` | `null` | no |
| <a name="input_gcp_group_org_viewers"></a> [gcp\_group\_org\_viewers](#input\_gcp\_group\_org\_viewers) | Google Group for GCP Organization read only users | `string` | `null` | no |
| <a name="input_gcp_org_environments"></a> [gcp\_org\_environments](#input\_gcp\_org\_environments) | The tree of organizational folders to construct. Defaults to an empty tree. | <pre>map(object({<br>    environment_code = string,<br>    name             = string<br>    network          = object({<br>      name        = string,<br>      cidr_blocks = object({<br>        private_subnet_ranges     = list(string)<br>        data_subnet_ranges        = list(string)<br>      })<br>    })<br>    children = list(object({<br>      name     = string,<br>      children = list(object({<br>        name = string<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_log_export_storage_force_destroy"></a> [log\_export\_storage\_force\_destroy](#input\_log\_export\_storage\_force\_destroy) | (Optional) If set to true, delete all contents when destroying the resource; otherwise, destroying the resource will fail if contents are present. | `bool` | `true` | no |
| <a name="input_log_export_storage_lifecycle_rules"></a> [log\_export\_storage\_lifecycle\_rules](#input\_log\_export\_storage\_lifecycle\_rules) | Bucket lifecycle rules | `any` | <pre>[<br>  {<br>    "action": {<br>      "type": "Delete"<br>    },<br>    "condition": {<br>      "age": 365,<br>      "with_state": "ANY"<br>    }<br>  },<br>  {<br>    "action": {<br>      "storage_class": "ARCHIVE",<br>      "type": "SetStorageClass"<br>    },<br>    "condition": {<br>      "age": 30,<br>      "with_state": "ANY"<br>    }<br>  }<br>]</pre> | no |
| <a name="input_log_export_storage_location"></a> [log\_export\_storage\_location](#input\_log\_export\_storage\_location) | The location of the storage bucket used to export logs. | `string` | `"EU"` | no |
| <a name="input_log_export_storage_retention_policy"></a> [log\_export\_storage\_retention\_policy](#input\_log\_export\_storage\_retention\_policy) | Configuration of the bucket's data retention policy for how long objects in the bucket should be retained. | <pre>object({<br>    is_locked             = bool<br>    retention_period_days = number<br>  })</pre> | `null` | no |
| <a name="input_log_export_storage_versioning"></a> [log\_export\_storage\_versioning](#input\_log\_export\_storage\_versioning) | (Optional) Toggles bucket versioning, ability to retain a non-current object version when the live object version gets replaced or deleted. | `bool` | `false` | no |
| <a name="input_scc_notification_filter"></a> [scc\_notification\_filter](#input\_scc\_notification\_filter) | Filter used to create the Security Command Center Notification, you can see more details on how to create filters in https://cloud.google.com/security-command-center/docs/how-to-api-filter-notifications#create-filter | `string` | `"state = \"ACTIVE\""` | no |
| <a name="input_scc_notification_name"></a> [scc\_notification\_name](#input\_scc\_notification\_name) | Name of the Security Command Center Notification. It must be unique in the organization. Run `gcloud scc notifications describe <scc_notification_name> --organization=org_id` to check if it already exists. | `string` | `"org-scc-notify"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_infra_nethub_project_id"></a> [infra\_nethub\_project\_id](#output\_infra\_nethub\_project\_id) | n/a |
<!-- END_TF_DOCS -->