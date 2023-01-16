<!-- BEGIN_TF_DOCS -->
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider_google) | >= 3.77 |
| <a name="provider_random"></a> [random](#provider_random) | n/a |

#### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bigquery_destination"></a> [bigquery_destination](#module_bigquery_destination) | terraform-google-modules/log-export/google//modules/bigquery | ~> 7.3.0 |
| <a name="module_log_export_to_biqquery"></a> [log_export_to_biqquery](#module_log_export_to_biqquery) | terraform-google-modules/log-export/google | ~> 7.3.0 |
| <a name="module_log_export_to_storage"></a> [log_export_to_storage](#module_log_export_to_storage) | terraform-google-modules/log-export/google | ~> 7.3 |
| <a name="module_org_cloudsql_external_ip_access"></a> [org_cloudsql_external_ip_access](#module_org_cloudsql_external_ip_access) | terraform-google-modules/org-policy/google | ~> 5.0 |
| <a name="module_org_compute_disable_guest_attributes_access"></a> [org_compute_disable_guest_attributes_access](#module_org_compute_disable_guest_attributes_access) | terraform-google-modules/org-policy/google | ~> 5.0 |
| <a name="module_org_disable_automatic_iam_grants_on_default_service_accounts"></a> [org_disable_automatic_iam_grants_on_default_service_accounts](#module_org_disable_automatic_iam_grants_on_default_service_accounts) | terraform-google-modules/org-policy/google | ~> 5.0 |
| <a name="module_org_disable_nested_virtualization"></a> [org_disable_nested_virtualization](#module_org_disable_nested_virtualization) | terraform-google-modules/org-policy/google | ~> 5.0 |
| <a name="module_org_disable_sa_key_creation"></a> [org_disable_sa_key_creation](#module_org_disable_sa_key_creation) | terraform-google-modules/org-policy/google | ~> 5.0 |
| <a name="module_org_disable_serial_port_access"></a> [org_disable_serial_port_access](#module_org_disable_serial_port_access) | terraform-google-modules/org-policy/google | ~> 5.0 |
| <a name="module_org_domain_restricted_sharing"></a> [org_domain_restricted_sharing](#module_org_domain_restricted_sharing) | terraform-google-modules/org-policy/google//modules/domain_restricted_sharing | ~> 5.0 |
| <a name="module_org_enforce_bucket_level_access"></a> [org_enforce_bucket_level_access](#module_org_enforce_bucket_level_access) | terraform-google-modules/org-policy/google | ~> 5.0 |
| <a name="module_org_shared_require_os_login"></a> [org_shared_require_os_login](#module_org_shared_require_os_login) | terraform-google-modules/org-policy/google | ~> 5.0 |
| <a name="module_org_shared_vpc_lien_removal"></a> [org_shared_vpc_lien_removal](#module_org_shared_vpc_lien_removal) | terraform-google-modules/org-policy/google | ~> 5.0 |
| <a name="module_org_skip_default_network"></a> [org_skip_default_network](#module_org_skip_default_network) | terraform-google-modules/org-policy/google | ~> 5.0 |
| <a name="module_org_vm_external_ip_access"></a> [org_vm_external_ip_access](#module_org_vm_external_ip_access) | terraform-google-modules/org-policy/google | ~> 5.0 |
| <a name="module_organization_networking_hub"></a> [organization_networking_hub](#module_organization_networking_hub) | terraform-google-modules/project-factory/google | ~> 11.1 |
| <a name="module_organization_observability"></a> [organization_observability](#module_organization_observability) | terraform-google-modules/project-factory/google | ~> 11.1 |
| <a name="module_organization_security"></a> [organization_security](#module_organization_security) | terraform-google-modules/project-factory/google | ~> 11.1 |
| <a name="module_storage_destination"></a> [storage_destination](#module_storage_destination) | terraform-google-modules/log-export/google//modules/storage | ~> 7.3 |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account"></a> [billing_account](#input_billing_account) | The ID of the billing account to associate this project with | `string` | n/a | yes |
| <a name="input_budget_alert_pubsub_topic"></a> [budget_alert_pubsub_topic](#input_budget_alert_pubsub_topic) | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` | `string` | n/a | yes |
| <a name="input_default_region"></a> [default_region](#input_default_region) | Default region for BigQuery resources. | `string` | n/a | yes |
| <a name="input_domains_to_allow"></a> [domains_to_allow](#input_domains_to_allow) | The list of domains to allow users from in IAM. Used by Domain Restricted Sharing Organization Policy. Must include the domain of the organization you are deploying the foundation. To add other domains you must also grant access to these domains to the terraform service account used in the deploy. | `list(string)` | n/a | yes |
| <a name="input_gcp_labels"></a> [gcp_labels](#input_gcp_labels) | Map of tags | `map(string)` | n/a | yes |
| <a name="input_infra_folder_name"></a> [infra_folder_name](#input_infra_folder_name) | Folder witch will contains all infra projects | `string` | n/a | yes |
| <a name="input_infra_networking_hub_project"></a> [infra_networking_hub_project](#input_infra_networking_hub_project) | n/a | <pre>object({<br>    name = string<br>    folder = string<br>    budget = object({<br>      amount = number,<br>      time_unit = string,<br>      email_addresses_to_notify = list(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_infra_observability_project"></a> [infra_observability_project](#input_infra_observability_project) | n/a | <pre>object({<br>    name = string<br>    folder = string<br>    budget = object({<br>      amount = number,<br>      time_unit = string,<br>      alert_pubsub_topic = string<br>      email_addresses_to_notify = list(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_infra_security_project"></a> [infra_security_project](#input_infra_security_project) | n/a | <pre>object({<br>    name = string<br>    folder = string<br>    budget = object({<br>      amount = number,<br>      time_unit = string,<br>      email_addresses_to_notify = list(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_org_audit_data_admins"></a> [org_audit_data_admins](#input_org_audit_data_admins) | Google Workspace or Cloud Identity group that have access to audit logs. | `string` | n/a | yes |
| <a name="input_org_audit_viewers"></a> [org_audit_viewers](#input_org_audit_viewers) | Members are part of an audit team and view audit logs in the logging project. | `string` | n/a | yes |
| <a name="input_org_billing_admins"></a> [org_billing_admins](#input_org_billing_admins) | Identity that has billing administrator permissions | `string` | n/a | yes |
| <a name="input_org_billing_data_viewers"></a> [org_billing_data_viewers](#input_org_billing_data_viewers) | Google Workspace or Cloud Identity group that have access to billing data set. | `string` | n/a | yes |
| <a name="input_org_network_viewers"></a> [org_network_viewers](#input_org_network_viewers) | G Suite or Cloud Identity group that members are part of the networking team and review network configurations | `string` | n/a | yes |
| <a name="input_org_org_admins"></a> [org_org_admins](#input_org_org_admins) | Identity that has organization administrator permissions. | `string` | n/a | yes |
| <a name="input_org_scc_admins"></a> [org_scc_admins](#input_org_scc_admins) | G Suite or Cloud Identity group that can administer Security Command Center. | `string` | n/a | yes |
| <a name="input_org_security_reviewers"></a> [org_security_reviewers](#input_org_security_reviewers) | G Suite or Cloud Identity group that members are part of the security team responsible for reviewing cloud security. | `string` | n/a | yes |
| <a name="input_org_viewers"></a> [org_viewers](#input_org_viewers) | G Suite or Cloud Identity group that have the ability to view resource information across the Google Cloud organization. | `string` | n/a | yes |
| <a name="input_organization_id"></a> [organization_id](#input_organization_id) | The name of the current organization. | `string` | n/a | yes |
| <a name="input_terraform_sa_email"></a> [terraform_sa_email](#input_terraform_sa_email) | Service account email of the account to impersonate to run Terraform. | `string` | n/a | yes |
| <a name="input_audit_logs_table_delete_contents_on_destroy"></a> [audit_logs_table_delete_contents_on_destroy](#input_audit_logs_table_delete_contents_on_destroy) | (Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present. | `bool` | `false` | no |
| <a name="input_audit_logs_table_expiration_days"></a> [audit_logs_table_expiration_days](#input_audit_logs_table_expiration_days) | Period before tables expire for all audit logs in milliseconds. Default is 30 days. | `number` | `30` | no |
| <a name="input_budget_alert_spent_percents"></a> [budget_alert_spent_percents](#input_budget_alert_spent_percents) | A list of percentages of the budget to alert on when threshold is exceeded | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> | no |
| <a name="input_create_access_context_manager_access_policy"></a> [create_access_context_manager_access_policy](#input_create_access_context_manager_access_policy) | Whether to create access context manager access policy | `bool` | `false` | no |
| <a name="input_enable_domains_sharing_restriction_policy"></a> [enable_domains_sharing_restriction_policy](#input_enable_domains_sharing_restriction_policy) | Enable domains sharing restriction Organization Policy. | `bool` | `false` | no |
| <a name="input_enable_os_login_policy"></a> [enable_os_login_policy](#input_enable_os_login_policy) | Enable OS Login Organization Policy. | `bool` | `false` | no |
| <a name="input_enable_sa_key_creation_deny_policy"></a> [enable_sa_key_creation_deny_policy](#input_enable_sa_key_creation_deny_policy) | Deny service account key creation at the organization level. | `bool` | `false` | no |
| <a name="input_enable_scc_notification"></a> [enable_scc_notification](#input_enable_scc_notification) | Enable Security Control Center notifications. | `bool` | `false` | no |
| <a name="input_log_export_storage_force_destroy"></a> [log_export_storage_force_destroy](#input_log_export_storage_force_destroy) | (Optional) If set to true, delete all contents when destroying the resource; otherwise, destroying the resource will fail if contents are present. | `bool` | `false` | no |
| <a name="input_log_export_storage_lifecycle_rules"></a> [log_export_storage_lifecycle_rules](#input_log_export_storage_lifecycle_rules) | Bucket lifecycle rules | `any` | <pre>[<br>  {<br>    "action": {<br>      "type": "Delete"<br>    },<br>    "condition": {<br>      "age": 365,<br>      "with_state": "ANY"<br>    }<br>  },<br>  {<br>    "action": {<br>      "storage_class": "ARCHIVE",<br>      "type": "SetStorageClass"<br>    },<br>    "condition": {<br>      "age": 30,<br>      "with_state": "ANY"<br>    }<br>  }<br>]</pre> | no |
| <a name="input_log_export_storage_location"></a> [log_export_storage_location](#input_log_export_storage_location) | The location of the storage bucket used to export logs. | `string` | `"EU"` | no |
| <a name="input_log_export_storage_retention_policy"></a> [log_export_storage_retention_policy](#input_log_export_storage_retention_policy) | Configuration of the bucket's data retention policy for how long objects in the bucket should be retained. | <pre>object({<br>    is_locked             = bool<br>    retention_period_days = number<br>  })</pre> | `null` | no |
| <a name="input_log_export_storage_versioning"></a> [log_export_storage_versioning](#input_log_export_storage_versioning) | (Optional) Toggles bucket versioning, ability to retain a non-current object version when the live object version gets replaced or deleted. | `bool` | `false` | no |
| <a name="input_scc_notification_filter"></a> [scc_notification_filter](#input_scc_notification_filter) | Filter used to create the Security Command Center Notification, you can see more details on how to create filters in https://cloud.google.com/security-command-center/docs/how-to-api-filter-notifications#create-filter | `string` | `"state = \"ACTIVE\""` | no |
| <a name="input_scc_notification_name"></a> [scc_notification_name](#input_scc_notification_name) | Name of the Security Command Center Notification. It must be unique in the organization. Run `gcloud scc notifications describe <scc_notification_name> --organization=org_id` to check if it already exists. | `string` | `"org-scc-notify"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_org_network_hub_project_id"></a> [org_network_hub_project_id](#output_org_network_hub_project_id) | n/a |
<!-- END_TF_DOCS -->