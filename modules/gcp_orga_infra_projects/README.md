<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | The ID of the billing account to associate this project with | `string` | n/a | yes |
| <a name="input_budget_alert_pubsub_topic"></a> [budget\_alert\_pubsub\_topic](#input\_budget\_alert\_pubsub\_topic) | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` | `string` | n/a | yes |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region for BigQuery resources. | `string` | n/a | yes |
| <a name="input_domains_to_allow"></a> [domains\_to\_allow](#input\_domains\_to\_allow) | The list of domains to allow users from in IAM. Used by Domain Restricted Sharing Organization Policy. Must include the domain of the organization you are deploying the foundation. To add other domains you must also grant access to these domains to the terraform service account used in the deploy. | `list(string)` | n/a | yes |
| <a name="input_gcp_labels"></a> [gcp\_labels](#input\_gcp\_labels) | Map of tags | `map(string)` | n/a | yes |
| <a name="input_infra_folder_name"></a> [infra\_folder\_name](#input\_infra\_folder\_name) | Folder witch will contains all infra projects | `string` | n/a | yes |
| <a name="input_infra_nethub_project"></a> [infra\_nethub\_project](#input\_infra\_nethub\_project) | n/a | <pre>object({<br>    name = string<br>    budget = object({<br>      amount = number,<br>      time_unit = string,<br>      email_addresses_to_notify = list(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_infra_observability_project"></a> [infra\_observability\_project](#input\_infra\_observability\_project) | n/a | <pre>object({<br>    name = string<br>    budget = object({<br>      amount = number,<br>      time_unit = string,<br>      alert_pubsub_topic = string<br>      email_addresses_to_notify = list(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_infra_security_project"></a> [infra\_security\_project](#input\_infra\_security\_project) | n/a | <pre>object({<br>    name = string<br>    budget = object({<br>      amount = number,<br>      time_unit = string,<br>      email_addresses_to_notify = list(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_org_audit_data_admins"></a> [org\_audit\_data\_admins](#input\_org\_audit\_data\_admins) | Google Workspace or Cloud Identity group that have access to audit logs. | `string` | n/a | yes |
| <a name="input_org_audit_viewers"></a> [org\_audit\_viewers](#input\_org\_audit\_viewers) | Members are part of an audit team and view audit logs in the logging project. | `string` | n/a | yes |
| <a name="input_org_billing_admins"></a> [org\_billing\_admins](#input\_org\_billing\_admins) | Identity that has billing administrator permissions | `string` | n/a | yes |
| <a name="input_org_billing_data_viewers"></a> [org\_billing\_data\_viewers](#input\_org\_billing\_data\_viewers) | Google Workspace or Cloud Identity group that have access to billing data set. | `string` | n/a | yes |
| <a name="input_org_network_viewers"></a> [org\_network\_viewers](#input\_org\_network\_viewers) | G Suite or Cloud Identity group that members are part of the networking team and review network configurations | `string` | n/a | yes |
| <a name="input_org_org_admins"></a> [org\_org\_admins](#input\_org\_org\_admins) | Identity that has organization administrator permissions. | `string` | n/a | yes |
| <a name="input_org_scc_admins"></a> [org\_scc\_admins](#input\_org\_scc\_admins) | G Suite or Cloud Identity group that can administer Security Command Center. | `string` | n/a | yes |
| <a name="input_org_security_reviewers"></a> [org\_security\_reviewers](#input\_org\_security\_reviewers) | G Suite or Cloud Identity group that members are part of the security team responsible for reviewing cloud security. | `string` | n/a | yes |
| <a name="input_org_viewers"></a> [org\_viewers](#input\_org\_viewers) | G Suite or Cloud Identity group that have the ability to view resource information across the Google Cloud organization. | `string` | n/a | yes |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The ID of the current organization. | `string` | n/a | yes |
| <a name="input_parent_id"></a> [parent\_id](#input\_parent\_id) | Can be either an organisation or a folder. Format : organizations/1235 or folders/12562. | `string` | n/a | yes |
| <a name="input_terraform_sa_email"></a> [terraform\_sa\_email](#input\_terraform\_sa\_email) | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_audit_logs_table_delete_contents_on_destroy"></a> [audit\_logs\_table\_delete\_contents\_on\_destroy](#input\_audit\_logs\_table\_delete\_contents\_on\_destroy) | (Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present. | `bool` | `false` | no |
| <a name="input_audit_logs_table_expiration_days"></a> [audit\_logs\_table\_expiration\_days](#input\_audit\_logs\_table\_expiration\_days) | Period before tables expire for all audit logs in milliseconds. Default is 30 days. | `number` | `30` | no |
| <a name="input_budget_alert_spent_percents"></a> [budget\_alert\_spent\_percents](#input\_budget\_alert\_spent\_percents) | A list of percentages of the budget to alert on when threshold is exceeded | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> | no |
| <a name="input_enable_log_export_to_biqquery"></a> [enable\_log\_export\_to\_biqquery](#input\_enable\_log\_export\_to\_biqquery) | Enable log export to bigquery | `bool` | `false` | no |
| <a name="input_enable_log_export_to_cs"></a> [enable\_log\_export\_to\_cs](#input\_enable\_log\_export\_to\_cs) | Enable log export to bigquery | `bool` | `true` | no |
| <a name="input_enable_scc_notification"></a> [enable\_scc\_notification](#input\_enable\_scc\_notification) | Enable Security Control Center notifications. | `bool` | `false` | no |
| <a name="input_log_export_storage_force_destroy"></a> [log\_export\_storage\_force\_destroy](#input\_log\_export\_storage\_force\_destroy) | (Optional) If set to true, delete all contents when destroying the resource; otherwise, destroying the resource will fail if contents are present. | `bool` | `false` | no |
| <a name="input_log_export_storage_lifecycle_rules"></a> [log\_export\_storage\_lifecycle\_rules](#input\_log\_export\_storage\_lifecycle\_rules) | Bucket lifecycle rules | `any` | <pre>[<br>  {<br>    "action": {<br>      "type": "Delete"<br>    },<br>    "condition": {<br>      "age": 365,<br>      "with_state": "ANY"<br>    }<br>  },<br>  {<br>    "action": {<br>      "storage_class": "ARCHIVE",<br>      "type": "SetStorageClass"<br>    },<br>    "condition": {<br>      "age": 30,<br>      "with_state": "ANY"<br>    }<br>  }<br>]</pre> | no |
| <a name="input_log_export_storage_location"></a> [log\_export\_storage\_location](#input\_log\_export\_storage\_location) | The location of the storage bucket used to export logs. | `string` | `"EU"` | no |
| <a name="input_log_export_storage_retention_policy"></a> [log\_export\_storage\_retention\_policy](#input\_log\_export\_storage\_retention\_policy) | Configuration of the bucket's data retention policy for how long objects in the bucket should be retained. | <pre>object({<br>    is_locked             = bool<br>    retention_period_days = number<br>  })</pre> | `null` | no |
| <a name="input_log_export_storage_versioning"></a> [log\_export\_storage\_versioning](#input\_log\_export\_storage\_versioning) | (Optional) Toggles bucket versioning, ability to retain a non-current object version when the live object version gets replaced or deleted. | `bool` | `false` | no |
| <a name="input_scc_notification_filter"></a> [scc\_notification\_filter](#input\_scc\_notification\_filter) | Filter used to create the Security Command Center Notification, you can see more details on how to create filters in https://cloud.google.com/security-command-center/docs/how-to-api-filter-notifications#create-filter | `string` | `"state = \"ACTIVE\""` | no |
| <a name="input_scc_notification_name"></a> [scc\_notification\_name](#input\_scc\_notification\_name) | Name of the Security Command Center Notification. It must be unique in the organization. Run `gcloud scc notifications describe <scc_notification_name> --organization=org_id` to check if it already exists. | `string` | `"org-scc-notify"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_org_nethub_project_id"></a> [org\_nethub\_project\_id](#output\_org\_nethub\_project\_id) | n/a |
<!-- END_TF_DOCS -->